.phony : all, build, web

all: build

build:
	docker-compose build
	docker build -t myjulia .

# Excecute in docker container
web: docs
	julia --project=docs -e '\
		using Pkg;\
		Pkg.develop(PackageSpec(path=pwd()));\
		Pkg.instantiate();\
		include("docs/make.jl");\
		'
	python3 -m http.server --bind 0.0.0.0 --directory docs/build
