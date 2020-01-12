.phony : all, build, web

OS:=$(shell uname -s)

all: build

build:
	docker-compose build
	docker build -t jlatom .
	docker-compose run --rm julia julia --project=. -e 'using Pkg; Pkg.instantiate()'

atom:
ifeq ($(OS), Linux)
	docker run --rm -it --network=host -v ${PWD}:/work -w /work jlatom julia -L .atom/init_linux.jl
endif
ifeq ($(OS),Darwin) # i.e. macOS
	docker run --rm -it --network=host -v ${PWD}:/work -w /work jlatom julia -L .atom/init_mac.jl
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
