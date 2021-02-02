.phony : all, pull, build, atom, web, test, clean

OS:=$(shell uname -s)
DOCKERIMAGE=myworkflowjl

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
	rm -f Manifest.toml
	docker pull ${REMOTE_DOCKER_REPOSITORY}
	docker tag ${REMOTE_DOCKER_REPOSITORY} ${DOCKERIMAGE}
	docker-compose run --rm julia julia --project=/work -e 'using Pkg; Pkg.instantiate()'

build:
	rm -f Manifest.toml
	docker build -t ${DOCKERIMAGE} .
	docker-compose build
	docker-compose run --rm julia julia --project=/work -e 'using Pkg; Pkg.instantiate()'

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
		'
	python3 -m http.server --bind 0.0.0.0 --directory docs/build

test: build
	docker-compose run --rm julia julia -e 'using Pkg; Pkg.activate("."); Pkg.test()'
	docker-compose run --rm julia julia -e 'using Pkg; Pkg.activate("."); Pkg.instantiate(); include("playgound/test/runtests.jl")'

clean:
	docker-compose down
	rm -f docs/src/weavesample.md
	rm -f playgound/notebook/*.ipynb
	rm -rf playgound/notebook/*.gif
	rm -f  Manifest.toml docs/Manifest.toml
	rm -rf docs/build

