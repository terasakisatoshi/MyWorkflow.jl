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
    display_name: Python 3
    language: python
    name: python3
---

# Demonstrate PyJulia

- https://github.com/JuliaPy/pyjulia

```python
import sys
sys.version
```

# Import Python modules

```python
import random 

from julia.api import Julia
jl = Julia(compiled_modules=False)
```

```python
def calcpi(N):
    c = 0
    for _ in range(N):
        x = random.random()
        y = random.random()
        if x ** 2 + y ** 2 <1:
            c+=1
    pi_approx = 4 * c/N
    return pi_approx
```


```python
%%time
N = 100_000_000
calcpi(N)
```

# Load Julia module

```python
jl.using("BenchmarkTools")
```

## Evaluate Julia code

```python
jl.eval(
"""
function calcpi(N)
    c = 0
    for _ in 1:N
        x = rand()
        y = rand()
        if x^2 + y^2 < 1
            c += 1  
        end
    end
    pi_approx = 4c/N
    return pi_approx
end
"""
)
```


```python
%%time
jl.eval(f"@time calcpi({N})")
```

## Run benchmark

```python
benchmark = jl.eval(f"""
buf = IOBuffer()
show(buf, "text/plain", @benchmark calcpi({N}))
buf |> take! |> String
""")

print(benchmark)
```
