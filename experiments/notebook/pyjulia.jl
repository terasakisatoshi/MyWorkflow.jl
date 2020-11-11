# ---
# jupyter:
#   jupytext:
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.6.0
#   kernelspec:
#     display_name: Python 3
#     language: python
#     name: python3
# ---

# # Demonstrate PyJulia
#
# - https://github.com/JuliaPy/pyjulia

import sys
sys.version

# # Import Python modules

# +
import random 

from julia.api import Julia
jl = Julia(compiled_modules=False)
# -

def calcpi(N):
    c = 0
    for _ in range(N):
        x = random.random()
        y = random.random()
        if x ** 2 + y ** 2 <1:
            c+=1
    pi_approx = 4 * c/N
    return pi_approx


# %%time
N = 100_000_000
calcpi(N)

# # Load Julia module

jl.using("BenchmarkTools")

# ## Evaluate Julia code

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


# %%time
jl.eval(f"@time calcpi({N})")

# ## Run benchmark

# +
benchmark = jl.eval(f"""
buf = IOBuffer()
show(buf, "text/plain", @benchmark calcpi({N}))
buf |> take! |> String
""")

print(benchmark)
