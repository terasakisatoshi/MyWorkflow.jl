FROM julia:1.4.2

ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

USER root

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
    htop \
    libxt6 libxrender1 libxext6 libgl1-mesa-glx libqt5widgets5 # GR && \
    apt-get clean && rm -rf /var/lib/apt/lists/* # clean up

# Switch default user
USER ${NB_USER}
ENV PATH=${HOME}/.local/bin:$PATH

RUN curl -kL https://bootstrap.pypa.io/get-pip.py | python3 && \
    pip3 install \
    jupyter \
    jupyterlab \
    jupytext \
    ipywidgets \
    jupyter-contrib-nbextensions \
    jupyter-nbextensions-configurator \
    jupyterlab_code_formatter autopep8 black \
    numpy \
    sympy==1.5.* \
    pandas \
    matplotlib \
    numba


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

ENV JULIA_PROJECT=${HOME}

# Install Julia Packages
RUN julia -e 'using Pkg; \
Pkg.add([\
    PackageSpec(name="PackageCompiler", version="1.2.1"), \
    PackageSpec(name="Atom", version="0.12.18"), \
    PackageSpec(name="Juno", version="0.8.2"), \
    PackageSpec(name="OhMyREPL", version="0.5.5"), \
    PackageSpec(name="Revise", version="2.7.3"), \
    PackageSpec(name="Plots", version="1.5.6"), \
    PackageSpec(name="ORCA", version="0.3.1"), \
]); \
Pkg.pin(["PackageCompiler", "Atom", "Juno", "OhMyREPL", "Revise", "Plots", "ORCA"]); \
Pkg.add(["Plotly", "PlotlyJS"]); \
Pkg.add(PackageSpec(name="IJulia", version="1.21.2")); \
Pkg.add(PackageSpec(name="Interact", version="0.10.3")); \
Pkg.add(PackageSpec(name="WebIO", version="0.8.14")); \
Pkg.pin(["IJulia", "Interact", "WebIO"]); \
'

# suppress warning for related to GR backend
ENV GKSwstype=100

# Do Ahead of Time Compilation using PackageCompiler
# For some technical reason, we switch default user to root then we switch back again
USER root

COPY ./.statements /tmp

RUN mkdir -p /sysimages && julia -e '\
    using PackageCompiler; PackageCompiler.create_sysimage(\
        [\
            :IJulia, :OhMyREPL, :Revise, :Plots, \
        ], \
        precompile_statements_file="/tmp/ijuliacompile.jl", \
        precompile_execution_file="/tmp/execution.jl", \
        sysimage_path="/sysimages/ijulia.so", \
    ) \
    '

# Make NB_USER Occupy julia binary
RUN chown -R ${NB_UID} /usr/local/julia /sysimages
# Swich user again to NB_USER
USER ${NB_USER}

# Pkgs with respect to Jupyter
# When initialize jupyter notebook ...
# Install kernel so that `JULIA_PROJECT` should be ${HOME}
RUN jupyter nbextension uninstall --user webio/main && \
    jupyter nbextension uninstall --user webio-jupyter-notebook && \
    julia -e '\
              using IJulia, WebIO ; \
              WebIO.install_jupyter_nbextension(); \
              envhome=ENV["HOME"]; \
              installkernel("Julia", "--project=$envhome", "-J/sysimages/ijulia.so");\
              ' && \
    echo "Done"

# Make sure the contents of our repo are in ${HOME}
WORKDIR ${HOME}
COPY ./experiments/notebook ${HOME}
COPY ./requirements.txt ${HOME}
COPY ./Project.toml ${HOME}

USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

RUN pip install -r requirements.txt

# Initialize Julia package using /work/Project.toml
RUN rm -f Manifest.toml && julia --project=${HOME} -e 'using Pkg; \
Pkg.instantiate(); \
Pkg.precompile()' && \
# Check Julia version \
julia -e 'using InteractiveUtils; versioninfo()'

# For Jupyter Notebook
EXPOSE 8888
# For Http Server
EXPOSE 8000
