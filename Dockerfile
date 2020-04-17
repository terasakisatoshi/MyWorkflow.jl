FROM julia:1.4.0

RUN apt-get update && \
    apt-get install -y \
    build-essential \
    cmake \
    python3 \
    python3-dev \
    python3-distutils \
    curl \
    ca-certificates \
    git \
    libgconf-2-4 \
    xvfb \
    libgtk-3-0 \
    dvipng \
    texlive-latex-recommended  \
    zip \
    libxt6 libxrender1 libxext6 libgl1-mesa-glx libqt5widgets5 # GR

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
c.NotebookApp.contents_manager_class = 'jupytext.TextFileContentsManager'\n\
c.NotebookApp.open_browser = False\n\
" >> ${HOME}/.jupyter/jupyter_notebook_config.py

# prepare to install extension
RUN jupyter contrib nbextension install --user && \
    jupyter nbextensions_configurator enable --user && \
    # enable extensions what you want
    jupyter nbextension enable select_keymap/main && \
    jupyter nbextension enable highlight_selected_word/main && \
    jupyter nbextension enable toggle_all_line_numbers/main && \
    jupyter nbextension enable varInspector/main && \
    jupyter nbextension enable toc2/main && \
    jupyter nbextension enable equation-numbering/main && \
    jupyter nbextension enable livemdpreview/livemdpreview && \
    jupyter nbextension enable execute_time/ExecuteTime && \
    echo Done


RUN mkdir -p ${HOME}/.julia/config && \
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
enable_autocomplete_brackets(false) \n\
atreplinit() do repl\n\
    try\n\
        @eval using Revise\n\
        @async Revise.wait_steal_repl_backend()\n\
    catch e\n\
        @warn(e.msg)\n\
    end\n\
end\n\
\n\
' >> ${HOME}/.julia/config/startup.jl && cat ${HOME}/.julia/config/startup.jl

# Install Julia Package
RUN julia -E 'using Pkg; \
Pkg.add(["Atom", "Juno"]); \
Pkg.add(["OhMyREPL", "Revise"]); \
Pkg.add(["Plots", "GR", "PyCall", "DataFrames"]); \
Pkg.add("PackageCompiler"); \
Pkg.add(["Documenter", "Literate", "Weave", "Franklin", "NodeJS"]); \
Pkg.add(["Plotly", "PlotlyJS", "ORCA"]); \
Pkg.add(["IJulia", "Interact", "WebIO"]); \
Pkg.precompile() \
'

# suppress warning for related to GR backend
ENV GKSwstype=100
# Do Ahead of Time Compilation using PackageCompiler
# For some technical reason, we switch default user to root then we switch back again
RUN julia --trace-compile="traced.jl" -e '\
    using OhMyREPL, Revise, Plots, PyCall, DataFrames; \
    plot(sin); plot(rand(10),rand(10)) |> display; \
    ' && \
    julia -e 'using PackageCompiler; \
              PackageCompiler.create_sysimage([:OhMyREPL, :Revise, :Plots, :GR, :PyCall, :DataFrames]; precompile_statements_file="traced.jl", replace_default=true) \
             ' && \
    rm traced.jl

COPY ./.statements /tmp

RUN mkdir -p /sysimages && julia -e '\
    using PackageCompiler; PackageCompiler.create_sysimage(\
        [:Plots, :Juno, :Atom], \
        precompile_statements_file="/tmp/atomcompile.jl", \
        sysimage_path="/sysimages/atom.so", \
    ) \
    '

RUN mkdir -p /sysimages && julia -e '\
    using PackageCompiler; PackageCompiler.create_sysimage(\
        [:Plots, :IJulia], \
        precompile_statements_file="/tmp/ijuliacompile.jl", \
        sysimage_path="/sysimages/ijulia.so", \
    ) \
    '

# Install kernel so that `JULIA_PROJECT` should be $JULIA_PROJECT
RUN jupyter nbextension uninstall --user webio/main && \
    jupyter nbextension uninstall --user webio-jupyter-notebook && \
    julia -e '\
              using IJulia, WebIO; \
              WebIO.install_jupyter_nbextension(); \
              envhome="/work"; \
              installkernel("Julia", "--project=$envhome", "-J/sysimages/ijulia.so");\
              ' && \
    echo "Done"


WORKDIR /work
ENV JULIA_PROJECT=/work

COPY ./requirements.txt /work/requirements.txt
RUN pip install -r requirements.txt
COPY ./Project.toml /work/Project.toml

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

