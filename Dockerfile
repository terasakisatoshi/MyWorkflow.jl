FROM julia:1.3.1

RUN apt-get update && \
    apt-get install -y \
    build-essential \
    cmake \
    python3 \
    python3-dev \
    python3-distutils \
    curl \
    ca-certificates

RUN curl -kL https://bootstrap.pypa.io/get-pip.py | python3 && \
    pip3 install \
    jupyter \
    jupytext \
    ipywidgets \
    jupyter-contrib-nbextensions \
    jupyter-nbextensions-configurator

RUN jupyter notebook --generate-config && \
    echo "\
c.ContentsManager.default_jupytext_formats = 'ipynb,jl'\n\
c.NotebookApp.open_browser = False\n\
c.NotebookApp.token = u''\n\
" >> /root/.jupyter/jupyter_notebook_config.py

# prepare to install extension
RUN jupyter contrib nbextension install --user && \
    jupyter nbextensions_configurator enable --user && \
    # enable extensions what you want
    jupyter nbextension enable select_keymap/main && \
    jupyter nbextension enable highlight_selected_word/main && \
    jupyter nbextension enable toggle_all_line_numbers/main && \
    jupyter nbextension enable varInspector/main && \
    jupyter nbextension enable execute_time/ExecuteTime && \
    echo Done

RUN julia -e 'using Pkg; Pkg.add("Revise")'
RUN mkdir -p /root/.julia/config && \
    echo '\
# set environment variables\n\
ENV["PYTHON"]=Sys.which("python3")\n\
ENV["JUPYTER"]=Sys.which("jupyter")\n\
\n\
import Pkg\n\
let\n\
    pkgs = ["Revise","OhMyREPL"]\n\
    for pkg in pkgs\n\
        if Base.find_package(pkg) === nothing\n\
            Pkg.add(pkg)\n\
        end\n\
    end\n\
end\n\
using OhMyREPL \n\
using Revise \n\
' >> /root/.julia/config/startup.jl

# Install Julia Package
RUN julia -E 'using Pkg;\
Pkg.add(["IJulia", "Atom", "Juno", "Plots", "GR", "PyCall"]);\
Pkg.add(PackageSpec(url="https://github.com/KristofferC/PackageCompilerX.jl.git",rev="master"));\
using IJulia, Atom, Juno, PackageCompilerX; # for precompilation\
'

# Switch working directory
WORKDIR /work

COPY ./requirements.txt /work/requirements.txt

RUN pip install -r requirements.txt

COPY ./Project.toml /work/Project.toml

RUN julia --trace-compile="traced.jl" -e 'using OhMyREPL, Revise, Plots, PyCall' && \
    julia -e 'using PackageCompilerX; \
              PackageCompilerX.create_sysimage([:OhMyREPL, :Revise, :Plots, :GR, :PyCall]; precompile_statements_file="traced.jl", replace_default=true)\
             ' && \
    rm traced.jl

# Initialize Julia package using /work/Project.toml
RUN julia --project=/work -e 'using Pkg;\
Pkg.instantiate();\
Pkg.precompile()' && \
# Check Julia version \
julia -e 'using InteractiveUtils; versioninfo()'

# For Jupyter Notebook
EXPOSE 8888
# For Http Server
EXPOSE 8000
