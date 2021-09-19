FROM julia:1.6.2

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


RUN jupyter notebook --generate-config && \
    echo "\
c.ContentsManager.default_jupytext_formats = 'ipynb,jl'\n\
c.NotebookApp.contents_manager_class = 'jupytext.TextFileContentsManager'\n\
c.NotebookApp.open_browser = False\n\
" >> ${HOME}/.jupyter/jupyter_notebook_config.py

# Install/enable extension for Jupyter Notebook users
RUN pip3 install jupyter-resource-usage && \
    jupyter contrib nbextension install --user && \
    jupyter nbextensions_configurator enable --user && \
    # enable extensions what you want
    jupyter nbextension enable select_keymap/main && \
    jupyter nbextension enable highlight_selected_word/main && \
    jupyter nbextension enable toggle_all_line_numbers/main && \
    jupyter nbextension enable varInspector/main && \
    jupyter nbextension enable toc2/main && \
    jupyter nbextension enable equation-numbering/main && \
    jupyter nbextension enable execute_time/ExecuteTime && \
    echo Done

# Install packages for R
USER root
RUN Rscript -e "install.packages(c('IRkernel')); IRkernel::installspec()" && \
    Rscript -e "install.packages('ggplot2')"
USER ${NB_USER}

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
using Revise\n\
\n\
' >> ${HOME}/.julia/config/startup.jl && cat ${HOME}/.julia/config/startup.jl

ENV JULIA_PROJECT=${HOME}

# Install Julia Packages
RUN julia -e 'using Pkg; \
Pkg.add([\
    PackageSpec(name="Atom", version="0.12.30"), \
    PackageSpec(name="Juno", version="0.8.4"), \
    PackageSpec(name="PackageCompiler", version="1.5.0"), \
    PackageSpec(name="OhMyREPL", version="0.5.10"), \
    PackageSpec(name="Plots", version="1.22.1"), \
    PackageSpec(name="StatsPlots", version="0.14.25"), \
    PackageSpec(name="DifferentialEquations", version="6.18.0"), \
    PackageSpec(name="Revise", version="3.1.17"), \
]); \
Pkg.pin(["PackageCompiler", "Atom", "Juno", "OhMyREPL", "Revise", "Plots"]); \
Pkg.add(["PlotlyJS"]); \
'

# suppress warning for related to GR backend
ENV GKSwstype=100

# Do Ahead of Time Compilation using PackageCompiler
# For some technical reason, we switch default user to root then we switch back again
USER root

# suppress warning for related to GR backend
ENV GKSwstype=100

# Install test dependencies for Plots.jl
#RUN julia -e 'ENV["PYTHON"]=Sys.which("python3"); \
#              ENV["JUPYTER"]=Sys.which("jupyter"); \
#              using Pkg; \
#              # Install test dependencies for IJulia \
#              Pkg.add(PackageSpec(name="JSON", version="0.21.1")); \
#              # Install test dependencies for Plots \
#              Pkg.add([\
#                  PackageSpec(name="FileIO", version="1.6.5"), \
#                  PackageSpec(name="StableRNGs", version="1.0.0"), \
#                  PackageSpec(name="Gtk", version="1.1.7"), \
#                  PackageSpec(name="Distributions", version="0.24.15"), \
#                  PackageSpec(name="GeometryTypes", version="0.8.4"), \
#                  PackageSpec(name="GeometryBasics", version="0.3.11"), \
#                  PackageSpec(name="HDF5", version="0.15.4"), \
#                  PackageSpec(name="ImageMagick", version="1.2.0"), \
#                  PackageSpec(name="Images", version="0.23.3"), \
#                  PackageSpec(name="OffsetArrays", version="1.6.2"), \
#                  PackageSpec(name="PGFPlotsX", version="1.2.10"), \
#                  PackageSpec(name="RecipesBase", version="1.1.1"), \
#                  PackageSpec(name="StaticArrays", version="1.1.0"), \
#                  PackageSpec(name="TestImages", version="1.4.0"), \
#                  PackageSpec(name="UnicodePlots", version="1.3.0"), \
#              PackageSpec(name="VisualRegressionTests", version="1.0.0"), \
#              ]) ;\
#              Pkg.pin([\
#                  "ImageMagick", "VisualRegressionTests", "FileIO", \
#                  "StableRNGs", "Gtk", "GeometryTypes", "GeometryBasics", \
#                  "HDF5", "PGFPlotsX", "StaticArrays", "OffsetArrays", \
#                  "UnicodePlots", "Distributions", \
#                  "Images", "TestImages", "RecipesBase", \
#              ]) \
#              '
#
# Install kernel so that `JULIA_PROJECT` should be $JULIA_PROJECT
RUN jupyter nbextension uninstall --user webio/main && \
    jupyter nbextension uninstall --user webio-jupyter-notebook && \
    julia -e '\
              using Pkg; \
              Pkg.add(PackageSpec(name="IJulia",version="1.23.2")); \
              Pkg.add(PackageSpec(name="Interact", version="0.10.3")); \
              Pkg.add(PackageSpec(name="WebIO", version="0.8.15")); \
              Pkg.pin(["IJulia", "Interact", "WebIO"]); \
              using IJulia, WebIO; \
              WebIO.install_jupyter_nbextension(); \
              envhome=ENV["HOME"]; \
              installkernel("Julia", "--project=$envhome");\
              ' && \
    echo "Done"

#COPY ./.statements /tmp

# generate traced_nb.jl
#RUN jupytext --to ipynb --execute /tmp/nb.jl
#RUN julia -e '\
#    using IJulia; envhome=ENV["HOME"]; installkernel("Julia", "--project=$envhome"); \
#'  

# generate precompile_statements_file
#RUN xvfb-run julia \
#             --trace-compile=traced_runtests.jl \
#             -e '\
#                ENV["CI"]="true"; \
#                using Plots; \
#                try include(joinpath(pkgdir(Plots), "test", "runtests.jl")) catch end \
#                '

# update sysimage
#RUN julia -e 'using PackageCompiler; \
#              create_sysimage(\
#                  [:Plots, :Revise, :OhMyREPL], \
#                  precompile_statements_file=["/tmp/traced_nb.jl"], \
#                  cpu_target = PackageCompiler.default_app_cpu_target(), \
#                  replace_default=true, \
#              )'

# Make NB_USER Occupy julia binary
RUN chown -R ${NB_UID} /usr/local/julia
# Swich user again to NB_USER
USER ${NB_USER}

# Make sure the contents of our repo are in ${HOME}
WORKDIR ${HOME}
COPY ./playground/notebook ${HOME}
COPY ./requirements.txt ${HOME}
COPY ./Project.toml ${HOME}
# we need copy  src/MyWorkflow.jl from julia 1.5
COPY ./src/MyWorkflow.jl ${HOME}/src/MyWorkflow.jl

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
