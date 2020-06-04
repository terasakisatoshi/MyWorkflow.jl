FROM gitpod/workspace-full

RUN sudo apt-get update && \
    sudo apt-get install -y \
    build-essential \
    cmake \
    python3 \
    python3-dev \
    python3-distutils \
    curl \
    ca-certificates \
    xvfb \
    dvipng \
    texlive-latex-recommended  \
    zip \
    libxt6 libxrender1 libxext6 libgl1-mesa-glx libqt5widgets5 # GR && \
    apt-get clean && rm -rf /var/lib/apt/lists/* # clean up    

RUN curl -kL https://bootstrap.pypa.io/get-pip.py | python3 && \
    pip3 install \
    matplotlib \
    numpy \
    sympy==1.5.* \
    numba

RUN echo ${HOME}
RUN curl -kL https://julialang-s3.julialang.org/bin/linux/x64/1.4/julia-1.4.2-linux-x86_64.tar.gz --output ${HOME}/julia-1.4.2.tar.gz && \
    tar -xvzf ${HOME}/julia-1.4.2.tar.gz

ENV PATH=${HOME}/julia-1.4.2/bin:${PATH}

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

RUN julia -e 'using InteractiveUtils; versioninfo()'

ARG WDIR=${HOME}
WORKDIR ${WDIR}

RUN julia -e 'using Pkg; \
Pkg.add([\
    PackageSpec(name="PackageCompiler", version="1.1.1"), \
    PackageSpec(name="Atom", version="0.12.11"), \
    PackageSpec(name="Juno", version="0.8.2"), \
    PackageSpec(name="OhMyREPL", version="0.5.5"), \
    PackageSpec(name="Revise", version="2.7.0"), \
    PackageSpec(name="Plots", version="1.3.3"), \
]); \
Pkg.pin(["PackageCompiler", "Atom", "Juno", "OhMyREPL", "Revise", "Plots"]); \
Pkg.add(["Plotly", "PlotlyJS", "ORCA"]); \
Pkg.add(["Documenter", "Literate", "Weave", "Franklin", "NodeJS"]); \
using NodeJS; run(`$(npm_cmd()) install highlight.js`); using Franklin; \
'

# suppress warning for related to GR backend
ENV GKSwstype=100
# Do Ahead of Time Compilation using PackageCompiler
# For some technical reason, we switch default user to root then we switch back again

RUN julia --trace-compile="traced.jl" -e '\
    using Plots; \
    plot(sin); plot(rand(10),rand(10)) |> display; \
    ' && \
    julia -e 'using PackageCompiler; \
              PackageCompiler.create_sysimage(\
                  [\
                    :OhMyREPL, :Revise, :Plots, \
                  ], \
                  precompile_statements_file="traced.jl", \
                  replace_default=true); \
             ' && \
    rm traced.jl

ARG WDIR=/workspace/MyWorkflow.jl
WORKDIR ${WDIR}
ENV JULIA_PROJECT=${WDIR}
RUN sudo mkdir -p ${WDIR} && sudo chown gitpod:gitpod -R ${WDIR}
COPY ./Project.toml ${WDIR}/Project.toml
RUN sudo chown gitpod:gitpod -R ${WDIR}
# Initialize Julia package using ${WDIR}/Project.toml
RUN julia -e 'using Pkg; \
Pkg.instantiate(); \
Pkg.precompile(); \
' && \
# Check Julia version \
julia -e 'using InteractiveUtils; versioninfo()'

# For Jupyter Notebook
EXPOSE 8888
# For Http Server
EXPOSE 8000
