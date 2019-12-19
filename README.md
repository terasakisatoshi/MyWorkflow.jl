# MyWorkflow

[![Build Status](https://github.com/terasakisatoshi/MyWorkflow.jl/workflows/CI/badge.svg)](https://github.com/terasakisatoshi/MyWorkflow.jl/actions)
[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://terasakisatoshi.github.io/MyWorkflow.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://terasakisatoshi.github.io/MyWorkflow.jl/dev)


- An example of workflow using Docker and GitHub Actions


# How to use

## Prepare Environment

- Install Docker and Docker Compose. see the following link to learn more with your operating system:
  - [Install Docker Desktop on Windows](https://docs.docker.com/docker-for-windows/install/)
  - [Install Docker Desktop on Mac](https://docs.docker.com/docker-for-mac/install/)
  - [Get Docker Engine - Community for Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
  
## Build Docker image

- There are several ways to build

### Case 1: Use Docker

```console
$ docker build -t myjulia .
```

### Case 2: Use Docker Compose

```console
$ docker-compose build --parallel
```

### Case 3: Use Makefile

```
$ make build
```

## Run Docker Container

- There are also two ways to run

### Case 1: Use Docker Container

#### Initialize Julia via REPL.

```console
$ docker run --rm -it myjulia julia --project=.
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.3.0 (2019-11-26)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia> using Example
julia> hello("World")
"Hello, World"
```

#### Initialize Julia via Jupyter Notebook

```console
$ docker run --rm -v $PWD:/work -w /work -p 8888:8888 --name myjupyter myjulia jupyter notebook --ip=0.0.0.0 --allow-root
... some stuff happens
```

Open your web browser and access `localhost:8888`

### Case 2: Use Docker Compose

#### Initialize Julia via REPL

```console
$ docker-compose run --rm julia
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.3.0 (2019-11-26)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia> using Example
julia> hello("World")
"Hello, World"
```

#### Initialize Julia via Jupyter Notebook

```console
$ docker-compose up jupyter
... some stuff happens

```

Open your web browser and access http://localhost:8888/

#### Clean up

```console
$ docker rmi myjulia
$ docker-compose down
```

## Generate `docs/build`

Just run `make web` on your local machine or


```console
$ docker-compose up web
```

Open your web browser and access http://localhost:8000/

