.phony : all, pull, build, atom, web, test, test-parallel, clean

OS:=$(shell uname -s)
DOCKERIMAGE=myworkflowjl

SYSIMAGE=/sysimages/ijulia.so

# leave conditional branch just in case.
ifeq ($(OS), Linux)
TAG=latest
REMOTE_DOCKER_REPOSITORY:=terasakisatoshi/${DOCKERIMAGE}:${TAG}
endif
ifeq ($(OS), Darwin)
TAG=latest
REMOTE_DOCKER_REPOSITORY:=terasakisatoshi/${DOCKERIMAGE}:${TAG}
endif

all: build

pull:
	-rm -f Manifest.toml
	docker pull ${REMOTE_DOCKER_REPOSITORY}
	docker tag ${REMOTE_DOCKER_REPOSITORY} ${DOCKERIMAGE}
	docker-compose run --rm julia julia -J ${SYSIMAGE} --project=/work -e 'using Pkg; Pkg.instantiate()'

build:
	-rm -f Manifest.toml
	docker build -t ${DOCKERIMAGE} .
	docker-compose build
	docker-compose run --rm julia julia -J ${SYSIMAGE} --project=/work -e 'using Pkg; Pkg.instantiate()'

atom:
ifeq ($(OS), Linux)
	docker run --rm -it --network=host -v ${PWD}:/work -w /work ${DOCKERIMAGE} julia -J/sysimages/atom.so --project=@. -L .atom/init_linux.jl
endif
ifeq ($(OS), Darwin) # i.e. macOS
	docker run --rm -it --network=host -v ${PWD}:/work -w /work ${DOCKERIMAGE} julia -J/sysimages/atom.so --project=@. -L .atom/init_mac.jl
endif
# Excecute in docker container
web: docs
	julia --project=docs -e '\
		using Pkg;\
		Pkg.develop(PackageSpec(path=pwd()));\
		Pkg.instantiate();\
		include("docs/make.jl");\
		using LiveServer; serve(dir="docs/build", host="0.0.0.0");\
		'

test: build
	docker-compose run --rm julia julia -J ${SYSIMAGE} -e 'using Pkg; Pkg.activate("."); Pkg.test()'
	docker-compose run --rm julia julia -J ${SYSIMAGE} -e 'using Pkg; Pkg.activate("."); Pkg.instantiate(); include("playground/test/runtests.jl")'

test-parallel: build
	docker-compose run --rm julia julia -J ${SYSIMAGE} -e 'using Pkg; Pkg.activate("."); Pkg.test()'
	docker-compose run --rm julia julia -J ${SYSIMAGE} -t auto -e 'using Pkg; Pkg.activate("."); Pkg.instantiate(); include("playground/test/runtests.jl")'

clean:
	docker-compose down
	-rm -f docs/src/weavesample.md
	-rm -f playground/notebook/*.ipynb
	-rm -rf playground/notebook/*.gif
	-rm -rf playground/notebook/*.png
	-rm -f  Manifest.toml docs/Manifest.toml
	-rm -rf docs/build

