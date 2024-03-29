FROM julia:1.6.4

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

# Install packages for Jupyter Notebook/JupyterLab
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
    jupyterlab_code_formatter autopep8 black

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

# Install/enable extension for JupyterLab users
RUN jupyter labextension install jupyterlab-topbar-extension && \
    jupyter labextension install jupyterlab-system-monitor && \
    #jupyter labextension install @lckr/jupyterlab_variableinspector --no-build && \
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

# Setup default formatter (For Python Users only)
RUN mkdir -p /root/.jupyter/lab/user-settings/@ryantam626/jupyterlab_code_formatter && echo '\
{\n\
    "preferences": {\n\
        "default_formatter": {\n\
            "python": "black",\n\
        }\n\
    }\n\
}\n\
\
'>> /root/.jupyter/lab/user-settings/@ryantam626/jupyterlab_code_formatter/settings.jupyterlab-settings

# Set color theme Monokai++ by default (The selection is due to my hobby)
RUN mkdir -p /root/.jupyter/lab/user-settings/@jupyterlab/apputils-extension && echo '\
{\n\
    "theme": "Monokai++"\n\
}\n\
\
' >> /root/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/themes.jupyterlab-settings

# Show line numbers by default
RUN mkdir -p /root/.jupyter/lab/user-settings/@jupyterlab/notebook-extension && echo '\
{\n\
    "codeCellConfig": {\n\
        "lineNumbers": true,\n\
    },\n\
}\n\
\
' >> /root/.jupyter/lab/user-settings/@jupyterlab/notebook-extension/tracker.jupyterlab-settings

# assign `Alt-R` to restart run all command 
RUN mkdir -p /root/.jupyter/lab/user-settings/@jupyterlab/shortcuts-extension && echo '\
{\n\
    "shortcuts": [\n\
        {\n\
            "command": "runmenu:restart-and-run-all",\n\
            "keys": [\n\
                "Alt R"\n\
            ],\n\
            "selector": "[data-jp-code-runner]"\n\
        }\n\
    ]\n\
}\n\
' >> /root/.jupyter/lab/user-settings/@jupyterlab/shortcuts-extension/shortcuts.jupyterlab-settings

# Install packages for R
RUN Rscript -e "install.packages(c('IRkernel')); IRkernel::installspec()" && \
    Rscript -e "install.packages('ggplot2')"

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
using Revise \n\
\n\
' >> ${HOME}/.julia/config/startup.jl && cat ${HOME}/.julia/config/startup.jl

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
Pkg.add(["Documenter", "Literate", "Weave", "Franklin", "NodeJS"]); \
using NodeJS; run(`$(npm_cmd()) install highlight.js`); using Franklin; \
'

# suppress warning for related to GR backend
ENV GKSwstype=100

# Install test dependencies for Plots.jl
RUN julia -e 'ENV["PYTHON"]=Sys.which("python3"); \
              ENV["JUPYTER"]=Sys.which("jupyter"); \
              using Pkg; \
              # Install test dependencies for IJulia \
              Pkg.add(PackageSpec(name="JSON", version="0.21.1")); \
              # Install test dependencies for Plots \
              Pkg.add([\
                  PackageSpec(name="Clustering", version="0.14.2"), \
                  PackageSpec(name="FileIO", version="1.11.1"), \
                  PackageSpec(name="StableRNGs", version="1.0.0"), \
                  PackageSpec(name="Gtk", version="1.1.8"), \
                  PackageSpec(name="Distributions", version="0.25.16"), \
                  PackageSpec(name="GeometryTypes", version="0.8.4"), \
                  PackageSpec(name="GeometryBasics", version="0.4.1"), \
                  PackageSpec(name="HDF5", version="0.15.6"), \
                  PackageSpec(name="ImageMagick", version="1.2.1"), \
                  PackageSpec(name="Images", version="0.24.1"), \
                  PackageSpec(name="OffsetArrays", version="1.10.7"), \
                  PackageSpec(name="PGFPlotsX", version="1.4.1"), \
                  PackageSpec(name="RecipesBase", version="1.1.2"), \
                  PackageSpec(name="StaticArrays", version="1.2.12"), \
                  PackageSpec(name="TestImages", version="1.6.1"), \
                  PackageSpec(name="UnicodePlots", version="2.4.4"), \
                  PackageSpec(name="RecipesPipeline", version="0.4.1"), \
                  PackageSpec(name="VisualRegressionTests", version="1.1.1"), \
                  PackageSpec(name="NaNMath", version="0.3.5"), \
              ]) ;\
              Pkg.pin([\
                　"NaNMath", \
                  "ImageMagick", "VisualRegressionTests", "FileIO", \
                  "StableRNGs", "Gtk", "GeometryTypes", "GeometryBasics", \
                  "HDF5", "PGFPlotsX", "StaticArrays", "OffsetArrays", \
                  "UnicodePlots", "Distributions", \
                  "Images", "TestImages", "RecipesBase", "RecipesPipeline", \
              ]) \
              '

# Install kernel so that `JULIA_PROJECT` should be $JULIA_PROJECT
RUN pip install webio_jupyter_extension && \
    julia -e '\
              using Pkg; \
              Pkg.add(PackageSpec(name="IJulia",version="1.23.2")); \
              Pkg.add(PackageSpec(name="Interact", version="0.10.3")); \
              Pkg.add(PackageSpec(name="WebIO", version="0.8.16")); \
              Pkg.pin(["IJulia", "Interact", "WebIO"]); \
              using IJulia, WebIO; \
              envhome="/work"; \
              installkernel("Julia", "--project=$envhome", "--trace-compile=/tmp/traced_nb.jl");\
              ' && \
    echo "Done"

COPY ./.statements /tmp
# generate traced_nb.jl
RUN jupytext --to ipynb --execute /tmp/nb.jl
RUN julia -e '\
    using IJulia; installkernel("Julia", "--project=/work", "--sysimage=/sysimages/ijulia.so"); \
'  

# generate precompile_statements_file
RUN xvfb-run julia \
             --trace-compile=traced_runtests.jl \
             -e '\
                ENV["CI"]="true"; \
                using Plots, StatsPlots; \
                try include(joinpath(pkgdir(Plots), "test", "runtests.jl")) catch end; \
                include(joinpath(pkgdir(StatsPlots), "test", "runtests.jl")); \
                ENV["CI"]="false"; \
                '

# update sysimage
RUN mkdir /sysimages && julia -e 'using PackageCompiler; \
              create_sysimage(\
                  [:StatsPlots, :Plots], \
                  precompile_statements_file=["traced_runtests.jl", "/tmp/traced_nb.jl"], \
                  sysimage_path="/sysimages/ijulia.so", \
                  cpu_target = PackageCompiler.default_app_cpu_target(), \
              )'

# generate sysimage for Atom/Juno user
RUN julia -J /sysimages/ijulia.so -e '\
    using PackageCompiler; PackageCompiler.create_sysimage(\
        [:Plots, :Juno, :Atom], \
        precompile_statements_file="/tmp/atomcompile.jl", \
        sysimage_path="/sysimages/atom.so", \
        cpu_target = PackageCompiler.default_app_cpu_target(), \
    ) \
    '

WORKDIR /work
ENV JULIA_PROJECT=/work
COPY ./requirements.txt /work/requirements.txt
RUN pip install -r requirements.txt
COPY ./Project.toml /work/Project.toml
COPY ./src/MyWorkflow.jl /work/src/MyWorkflow.jl

# Initialize Julia package using /work/Project.toml
RUN rm -f Manifest.toml && julia -J /sysimages/ijulia.so -e 'using Pkg; \
Pkg.instantiate(); \
Pkg.precompile(); \
' && \
# Check Julia version \
julia -J /sysimages/ijulia.so -e 'using InteractiveUtils; versioninfo()'

# For Jupyter Notebook
EXPOSE 8888
# For Http Server
EXPOSE 8000

CMD ["julia"]
