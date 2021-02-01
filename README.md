# MyWorkflow

[![Build Status](https://github.com/terasakisatoshi/MyWorkflow.jl/workflows/CI/badge.svg)](https://github.com/terasakisatoshi/MyWorkflow.jl/actions)
[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://terasakisatoshi.github.io/MyWorkflow.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://terasakisatoshi.github.io/MyWorkflow.jl/dev)

- An example of workflow using Docker and GitHub Actions

# Have a try MyWorkflow.jl

- MyWorkflow.jl master (nightly) [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/terasakisatoshi/MyWorkflow.jl/master) Julia v1.5.3

- MyWorkflow.jl v0.21.0 (stable) [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/terasakisatoshi/MyWorkflow.jl/v0.21.0) Julia v1.5.3

- MyWorkflow.jl v0.19.2 (old) [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/terasakisatoshi/MyWorkflow.jl/v0.19.2) Julia v1.5.2

# Feature

- This repository gives us some useful techniques such as:
  1. how to utilize Docker Docker Compose with your Julia workflow.
  2. how to customize Julia's system image via PackageCompiler.jl to reduce an overhead of package's loading time e.g. Plots.jl etc...
  3. how to share our work on the Internet. Check our repository on Binder from [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/terasakisatoshi/MyWorkflow.jl/master)
  4. how to use GitHub actions as a CI functionality.
  5. how to communicate between a Docker container and Juno/Atom

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
│   ├── Project.toml
│   ├── make.jl
│   └── src
│       ├── assets
│       │   ├── lab.png
│       │   ├── open_notebook_on_jupyterlab.png
│       │   ├── port9999.png
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
│       ├── clang.jl
│       ├── coordinate_system.jl
│       ├── curve.jl
│       ├── example.jl
│       ├── fitting.jl
│       ├── gradient_descent.jl
│       ├── histogram_eq.jl
│       ├── hop_step_jump.jl
│       ├── image_filtering.jl
│       ├── interact_sample.jl
│       ├── iris.jl
│       ├── lazysets.jl
│       ├── linear_regression.jl
│       ├── n-Soliton.jl
│       ├── ode.jl
│       ├── plotly_surface.jl
│       ├── plots_fill_example.jl
│       ├── plots_sample.jl
│       ├── pyplot.jl
│       ├── rcall.jl
│       ├── seaborn.jl
│       ├── tangent_space.jl
│       └── tangent_vector.jl
├── gitpod
│   └── Dockerfile
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

- To test out you've installed docker, just try:

```
$ docker run --rm -it julia
# some staff happens ...
```

- It will initialize the fresh Julia environment even if you do not have a Julia on your (host) machine.

## Buiding Docker image

- O.K. Let's build a Docker image for our purpose. Just run:

```
$ make build
```

which is exactly equivalent to the following procedure:

```
$ rm -f Manifest.toml
$ docker build -t myworkflojl .
$ docker-compose build
$ docker-compose run --rm julia julia --project=/work -e 'using Pkg; Pkg.instantiate()'
```

## Pull Docker image (Optional)

- Running `make build` may take much time to build our Docker image. Please use `make pull` instead.

```console
$ make pull
```

which is almost equivalent to:

```console
$ rm -f Manifest.toml
$ docker pull myworkflowjl
$ docker-compose run --rm julia julia --project=/work -e 'using Pkg; Pkg.instantiate()'
```

## Running Jupyter Notebook/JupyterLab

```console
$ docker-compose up jupyter
myjupyter  |     To access the notebook, open this file in a browser:
myjupyter  |         file:///root/.local/share/jupyter/runtime/nbserver-1-open.html
myjupyter  |     Or copy and paste one of these URLs:
myjupyter  |         http://4a27c4a06b0f:8888/?token=xxxxxxxxxxxxxxxxxxxxxxx
myjupyter  |      or http://127.0.0.1:8888/?token=xxxxxxxxxxxxxxxxxxxxxxx
```

Then open your web browser and access to `http://127.0.0.1:8888/?token=xxxxxxxxxxxxxxxxxxxxxxx`.

You can also initialize JupyterLab as you like via

```console
$ docker-compose up lab
```

- You'll see a JupyterLab screen its theme is Monokai++ (This choice comes from my preference.) :D .

![img](docs/src/assets/lab.png)

- If you like to open `experiments/notebook/<ournotebook>.jl`, right click the file to select and `Open with` -> `Notebook`. You're good to go.

 ![img](docs/src/assets/open_notebook_on_jupyterlab.png)

- Note that since we adopt `jupytext` technology, we do not have to commit/push `*.ipynb` file. Namely, we can manage Jupyter Notebook as a normal source code.

- Enjoy your Jupyter life.

## Running Pluto

[Pluto.jl](https://github.com/fonsp/Pluto.jl) is a lightweight reactive notebooks for Julia. Just run the following command:

### using Docker Compose

```console
$ docker-compose up pluto
```

Then, go to `localhost:9999`

### From Jupyter Notebook/Lab

- Run `docker-compose up jupyter` and then click `New` button on the top right of your browser. Then select `Pluto Notebook`.

![image](https://user-images.githubusercontent.com/16760547/98430578-c472d800-20f1-11eb-9dd7-fbcd7e7a086b.png)


## Connect to docker container with Juno/Atom (For Linux or Mac users only)

- We we will assume you've installed Juno.
- Go to `Open Settings` -> `Julia Client` -> `Julia Options` -> `Port for Communicating with the Julia process` and set value from `random` to `9999`.

![imgs](docs/src/assets/port9999.png)

- To connect to Docker container, open your Atom editor and open command palette(via `Cmd+shift+p` or `Ctrl+shift+p`). Then select `Julia Client Connect External Process`. Finally again open command palette and select `Julia Client: New Terminal`. You'll see a terminal at the bottom of the Atom edetor's screen. After that, simply run `make atom` or


```console
# For Mac user
$  docker run --rm -it --network=host -v ${PWD}:/work -w /work myworkflowjl julia -J/sysimages/atom.so --project=@. -L .atom/init_mac.jl
```

```console
# For Linux user
$ docker run --rm -it --network=host -v ${PWD}:/work -w /work myworkflowjl julia -J/sysimages/atom.so --project=@. -L .atom/init_linux.jl
```

It will show Julia's REPL inside of the terminal. `pwd()` should output `"/work"`, otherwise (e.g. `~/work/MyWorkflow.jl`)  you're something wrong (opening your Julia session on your host).

```console
julia> pwd()
"/work"
```

- Since our Docker image adopts `sysimage` which include precompile statements related to `Atom` or `Plots.jl` generated by `PackageCompiler.jl`. You'll find the speed of `using Plots; plot(sin)` is much extremely faster than that of runs on Julia session on your host.

```
# our sysimage
julia> @time begin using Plots; plot(sin) end
  0.022140 seconds (38.23 k allocations: 1.731 MiB) # <- Fast
```

```
# normal Julia
julia> @time begin using Plots; plot(sin) end
 14.006315 seconds (42.16 M allocations: 2.131 GiB, 3.86% gc time) #<- So slow ...
```


- You can reproduce the `sysimage` by yourself to reduce the latency of loading time of heavy packages. See This issue https://github.com/JuliaLang/PackageCompiler.jl/issues/352.

## Create docs/test

By running `make web`, you can create documentation files for our packages MyWorkflow.jl, namely:

```console
$ make web

julia --project=docs -e '\
    using Pkg;\
    Pkg.develop(PackageSpec(path=pwd()));\
    Pkg.instantiate();\
    include("docs/make.jl");\
    '
Path `~/work/MyWorkflow.jl` exists and looks like the correct package. Using existing path.
  Resolving package versions...
No Changes to `~/work/MyWorkflow.jl/docs/Project.toml`
No Changes to `~/work/MyWorkflow.jl/docs/Manifest.toml`
┌ Info: Weaving chunk 1 from line 25
└   progress = 0.0
┌ Info: Weaved all chunks
└   progress = 1
[ Info: Weaved to /Users/terasaki/work/MyWorkflow.jl/docs/src/weavesample.md
[ Info: SetupBuildDirectory: setting up build directory.
[ Info: Doctest: running doctests.
[ Info: ExpandTemplates: expanding markdown templates.
[ Info: CrossReferences: building cross-references.
[ Info: CheckDocument: running document checks.
[ Info: Populate: populating indices.
[ Info: RenderDocument: rendering document.
[ Info: HTMLWriter: rendering HTML pages.
┌ Warning: Documenter could not auto-detect the building environment Skipping deployment.
└ @ Documenter ~/.julia/packages/Documenter/3Y8Kg/src/deployconfig.jl:75
python3 -m http.server --bind 0.0.0.0 --directory docs/build
Serving HTTP on 0.0.0.0 port 8000 (http://0.0.0.0:8000/) ...
```

- It is good idea to run using `doctest`:

```console
$ julia --project=@.
julia> 
julia> using MyWorkflow, Documenter; DocMeta.setdocmeta!(MyWorkflow, :DocTestSetup, :(using MyWorkflow); recursive=true) ;doctest(MyWorkflow)

[ Info: SetupBuildDirectory: setting up build directory.
[ Info: Doctest: running doctests.
[ Info: Skipped ExpandTemplates step (doctest only).
[ Info: Skipped CrossReferences step (doctest only).
[ Info: Skipped CheckDocument step (doctest only).
[ Info: Skipped Populate step (doctest only).
[ Info: Skipped RenderDocument step (doctest only).
Test Summary:        | Pass  Total
Doctests: MyWorkflow |    1      1
Test.DefaultTestSet("Doctests: MyWorkflow", Any[], 1, false)
```
