---
jupyter:
  jupytext:
    formats: jl,md
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.2'
      jupytext_version: 1.5.2
  kernelspec:
    display_name: Julia 1.6.0
    language: julia
    name: julia-1.6
---

# Clang

clang is an open-source compiler built on the LLVM framework and targeting C, C++, and Objective-C. LLVM is also the JIT backend for Julia. Due to a highly modular design, Clang has in recent years become the core of a growing number of projects utilizing pieces of the compiler, such as tools for source-to-souce translation, static analysis and security evaluation, and editor tools for code completion, formatting, etc.

While LLVM and Clang are written in C++, the Clang project maintains a C-exported interface called "libclang" which provides access to the abstract syntax tree and type representations. Thanks to the ubiquity of support for C calling conventions, a number of languages have utilized libclang as a basis for tooling related ot C and C++.

The Clang.jl Julia package wraps libclang, provides a small convenience API for Julia-style programming, and provides a C-to-Julia wrapper generator built on libclang functionality.

```julia
using Clang
using Clang_jll
```

```julia
example_h = raw"""
struct ExStruct {
    int    kind;
    char*  name;
    double* data;
};


void setvalue(struct ExStruct* e, int k, char* c, double* data);
struct ExStruct create(int k, char* c, double* data);
"""

example_c = raw"""
#include "example.h"

void setvalue(struct ExStruct* e, int k, char* c, double* data){
	e->kind = k;
	e->name = c;
	e->data = data;
}

struct ExStruct create(int k, char* c, double* data){
	struct ExStruct e;
	e.kind = k;
	e.name = c;
	e.data = data;
	return e;
}
"""

main_c = raw"""
#include <stdio.h>
#include "example.h"

int main(){
	struct ExStruct e;
	double a[3];
	a[0]=-0.0;
	a[1]=-1.0;
	a[2]=-2.0;
	e = create(42, "Hello", a);
	printf("%d\n", e.kind);
	printf("%s\n", e.name);
	printf("%f\n", e.data[0]);
	printf("%f\n", e.data[1]);
	printf("%f\n", e.data[2]);

	setvalue(&e, 42, "Hello", a);
	printf("%d\n", e.kind);
	printf("%s\n", e.name);
	printf("%f\n", e.data[0]);
	printf("%f\n", e.data[1]);
	printf("%f\n", e.data[2]);
	return 0;
}
"""


headerfile = "example.h"
cfile = "example.c"
mainfile = "main.c"

open(headerfile, "w") do f
    print(f, example_h)
end

open(cfile, "w") do f
    print(f, example_c)
end

open(mainfile, "w") do f
    print(f, main_c)
end

trans_unit = parse_header(headerfile)
```

```julia

const LIBCLANG_INCLUDE = joinpath(dirname(Clang_jll.libclang_path), "..", "include", "clang-c") |> normpath
const TARGET_HEADERS = ["example.h"]

wrapcontext = init(;
    headers = TARGET_HEADERS,
    output_file = joinpath(@__DIR__, "example_api.jl"),
    common_file = joinpath(@__DIR__, "example_common.jl"),
    clang_includes = vcat(LIBCLANG_INCLUDE, CLANG_INCLUDE),
    clang_args = ["-I", joinpath(LIBCLANG_INCLUDE, "..")],
    header_wrapped = (root, current)->root == current,
    header_library = x->"example",
    clang_diagnostics = true,
)

wrapcontext |> run
```

```julia
run(`gcc -shared -fPIC -o example.so example.c`)
run(`gcc main.c example.c`)
run(`./a.out`)
```

```julia
const example="./example.so" # should be set const
include("example_common.jl")
include("example_api.jl")

e = create(42,"Hello",[1.,2.,3.])
refe = Ref(e)

@show e.kind
@show e.name |> unsafe_string
@show unsafe_load.(Ref(e.data), [1,2,3])


setvalue(refe,1,"Hi",[-1.,-2.,-3.])

@show refe.x.kind
@show refe.x.name |> unsafe_string
@show unsafe_load.(Ref(refe.x.data), [1,2,3])
```

# Clean up

```julia
rm("example.c")
rm("main.c")
rm("example.h")
rm("example.so")
rm("a.out")

rm("example_common.jl")
rm("example_api.jl")

rm("LibTemplate.jl")
rm("ctypes.jl")
```
