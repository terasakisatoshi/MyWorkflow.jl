buildweb:
	julia --project=docs -e '\
		using Pkg;\
		Pkg.develop(PackageSpec(path=pwd()));\
		Pkg.instantiate();\
		include("docs/make.jl");\
		'
web: buildweb
	cd docs/build && python3 -m http.server --bind localhost
	cd $(PWD)
