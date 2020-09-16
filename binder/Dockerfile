FROM terasakisatoshi/myworkflowjl:latest

# suppress warning for related to GR backend
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}
ENV JULIA_PROJECT=${HOME}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

USER root
# Make NB_USER Occupy julia binary
RUN chown -R ${NB_UID} /usr/local/julia /sysimages
# Swich user again to NB_USER
USER ${NB_USER}

# Make sure the contents of our repo are in ${HOME}
WORKDIR ${HOME}
COPY ./experiments/notebook ${HOME}
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
