FROM julia:1.6.3

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
    r-base \
    libxt6 libxrender1 libxext6 libgl1-mesa-glx libqt5widgets5 # GR \
    && \
    apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* # clean up

# install NodeJS
RUN apt-get update && \
    curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* # clean up

# We need install jupyterlab with sudo user, NOT ${USER}
RUN curl -kL https://bootstrap.pypa.io/get-pip.py | python3 && \
    pip3 install \
    jupyterlab \
    notebook \
    jupytext \
    ipywidgets \
    jupyter-contrib-nbextensions \
    jupyter-nbextensions-configurator \
    jupyter-server-proxy \
    nbconvert \
    ipykernel \
    git+https://github.com/IllumiDesk/jupyter-pluto-proxy.git \
    jupyterlab_code_formatter autopep8 black \
    numpy \
    sympy \
    scipy \
    pandas \
    matplotlib \
    numba

# Install/enable extension for JupyterLab users
RUN jupyter labextension install jupyterlab-topbar-extension && \
    jupyter labextension install jupyterlab-system-monitor && \
    jupyter nbextension enable --py widgetsnbextension && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build && \
    jupyter labextension install @z-m-k/jupyterlab_sublime --no-build && \
    jupyter labextension install @ryantam626/jupyterlab_code_formatter --no-build && \
    jupyter serverextension enable --py jupyterlab_code_formatter && \
    jupyter labextension install @hokyjack/jupyterlab-monokai-plus --no-build && \
    jupyter labextension install @jupyterlab/server-proxy --no-build && \
    jupyter lab build -y && \
    jupyter lab clean -y && \
    npm cache clean --force && \
    rm -rf ~/.cache/yarn && \
    rm -rf ~/.node-gyp && \
    echo Done

RUN mkdir -p ${HOME}/.local ${HOME}/.jupyter
# Set color theme Monokai++ by default
RUN mkdir -p ${HOME}/.jupyter/lab/user-settings/@jupyterlab/apputils-extension && \
    echo '{"theme": "Monokai++"}' >> \
    ${HOME}/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/themes.jupyterlab-settings

RUN mkdir -p ${HOME}/.jupyter/lab/user-settings/@jupyterlab/notebook-extension && \
    echo '{"codeCellConfig": {"lineNumbers": true}}' \
    >> ${HOME}/.jupyter/lab/user-settings/@jupyterlab/notebook-extension/tracker.jupyterlab-settings

RUN mkdir -p ${HOME}/.jupyter/lab/user-settings/@jupyterlab/shortcuts-extension && \
    echo '{"shortcuts": [{"command": "runmenu:restart-and-run-all", "keys": ["Alt R"], "selector": "[data-jp-code-runner]"}]}' \
    >> ${HOME}/.jupyter/lab/user-settings/@jupyterlab/shortcuts-extension/shortcuts.jupyterlab-settings
RUN chown -R ${NB_UID} ${HOME}

# Install packages for R
RUN Rscript -e "install.packages(c('IRkernel')); IRkernel::installspec()" && \
    Rscript -e "install.packages('ggplot2')"

# switch to USER
USER ${USER}

RUN mkdir -p ${HOME}/.julia/config && \
    echo '\
# set environment variables\n\
ENV["PYTHON"]=Sys.which("python3")\n\
ENV["JUPYTER"]=Sys.which("jupyter")\n\
' >> ${HOME}/.julia/config/startup.jl && cat ${HOME}/.julia/config/startup.jl

ENV JULIA_PROJECT=${HOME}

# suppress warning for related to GR backend
ENV GKSwstype=100

# Do Ahead of Time Compilation using PackageCompiler
# For some technical reason, we switch default user to root then we switch back again
USER root

# suppress warning for related to GR backend
ENV GKSwstype=100

RUN julia -e '\
              using Pkg; \
              Pkg.add(PackageSpec(name="IJulia",version="1.23.2")); \
              Pkg.add(PackageSpec(name="Interact", version="0.10.3")); \
              Pkg.add(PackageSpec(name="WebIO", version="0.8.16")); \
              Pkg.pin(["IJulia", "Interact", "WebIO"]); \
              using IJulia, WebIO; \
              installkernel("Julia");\
              ' && \
    echo "Done"

# Make sure the contents of our repo are in ${HOME}
WORKDIR ${HOME}
COPY ./playground/notebook ${HOME}
COPY ./requirements.txt ${HOME}
COPY ./Project.toml ${HOME}
COPY ./jupytext.toml ${HOME}
# we need copy  src/MyWorkflow.jl from julia 1.5
COPY ./src/MyWorkflow.jl ${HOME}/src/MyWorkflow.jl

# convert all md files except README.md
RUN jupytext --to ipynb `ls *.md | grep -v README`

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

WORKDIR ${HOME}
USER ${USER}

