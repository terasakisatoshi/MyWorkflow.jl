# MyWorkflow


[![Build Status](https://github.com/terasakisatoshi/MyWorkflow.jl/workflows/CI/badge.svg)](https://github.com/terasakisatoshi/MyWorkflow.jl/actions)
[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://terasakisatoshi.github.io/MyWorkflow.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://terasakisatoshi.github.io/MyWorkflow.jl/dev)

- dev    (master) [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/terasakisatoshi/MyWorkflow.jl/master)
- stable (v0.11.1)  [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/terasakisatoshi/MyWorkflow.jl/v0.11.1)

- An example of workflow using Docker and GitHub Actions

# Feature

- This repository gives us some useful techniques such as:
  1. how to utilize Docker Docker Compose with your Julia workflow.
  2. how to customize Julia's system image via PackageCompiler.jl to reduce an overhead of package's loading time e.g. Plots.jl, PyCall.jl, or DataFrames.jl etc...
  3. how to share our work on the Internet. Check our repository on Binder from [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/terasakisatoshi/MyWorkflow.jl/master)
  4. how to use GitHub actions as a CI functionality.


# Directory Structure

```console
$ tree .
.
├── Dockerfile
├── LICENSE
├── Makefile
├── Project.toml
├── README.md
├── binder
│   └── Dockerfile
├── docker-compose.yml
├── docs
│   ├── Manifest.toml
│   ├── Project.toml
│   ├── make.jl
│   └── src
│       ├── assets
│       │   └── theorem.css
│       ├── example.md
│       ├── index.md
│       ├── math.md
│       ├── myworkflow.md
│       └── weavesample.jmd
├── experiments
│   └── notebook
│       ├── Chisq.jl
│       ├── Harris.jl
│       ├── Rotation3D.jl
│       ├── apply_PCA_to_MNIST.jl
│       ├── box_and_ball_system.jl
│       ├── coordinate_system.jl
│       ├── curve.jl
│       ├── example.jl
│       ├── fitting.jl
│       ├── histogram_eq.jl
│       ├── image_filtering.jl
│       ├── interact_sample.jl
│       ├── n-Soliton.jl
│       ├── ode.jl
│       ├── plotly_surface.jl
│       ├── plots_sample.jl
│       ├── tangent_space.jl
│       ├── tangent_vector.jl
│       └── turing_getting_started.jl
├── requirements.txt
├── src
│   └── MyWorkflow.jl
└── test
    └── runtests.jl
```

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
$ docker build -t myworkflowjl .
```

### Case 2: Use Docker Compose

```console
$ docker-compose build --parallel
```

### Case 3: Use Makefile

```
$ make build
```

### Case 4: Use pre-built image

```
$ make pull
```

## Run Docker Container

- There are also two ways to run

### Case 1: Use Docker Container

#### Initialize Julia via REPL.

```console
$ docker run --rm -it myworkflowjl
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.4.1 (2020-04-14)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia> using Pkg; Pkg.instantiate() # Once execute this, you do not have to do again when you initialize docker
julia> using Example
julia> hello("World")
"Hello, World"
```

#### Initialize Julia via Jupyter Notebook

```console
$ docker run --rm -v $PWD:/work -w /work -p 8888:8888 --name myworkflowjl myworkflowjl jupyter notebook --ip=0.0.0.0 --allow-root
... some stuff happens
```

Open your web browser and access http://localhost:8000/

### Case 2: Use Docker Compose

#### Initialize Julia via REPL

```console
$ docker-compose run --rm julia
_       _ _(_)_     |  Documentation: https://docs.julialang.org
(_)     | (_) (_)    |
_ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
| | | | | | |/ _` |  |
| | |_| | | | (_| |  |  Version 1.4.1 (2020-04-14)
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
$ make clean
```

## Generate docs

### Run Makefile on your local machine

- Make sure your version of Python >= 3.7

```
$ make web
```

### Use Docker Compose


```console
$ docker-compose up web
```

Open your web browser and access http://localhost:8000/
