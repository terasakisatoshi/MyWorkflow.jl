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
    display_name: Julia 1.5.2
    language: julia
    name: julia-1.5
---

# Visualize Iris dataset

```julia
using ScikitLearn
using DataFrames
using Plots
```

## Load iris dataset via `sklearn.datasets.load_iris`

```julia
@sk_import datasets:load_iris
```

```julia
iris = load_iris()
```

```julia
data = iris["data"]
target = iris["target"]
feature_names = ["SepalL","SepalW","PetalL","PetalW"]
target_names = iris["target_names"];
```

```julia
df = DataFrame(data, feature_names)
df.target = target
first(df,5)
```

## Plot scatter

```julia
scatter(df.SepalL, df.SepalW)
```

## Grid Scatter Plots

```julia
splots = []

for j in 1:length(feature_names)
    for i in 1:length(feature_names)
        xfname = feature_names[i]
        yfname = feature_names[j]
        s = plot()
        if i != j
            for t in 0:length(target_names) - 1
                fx = df[!, xfname]
                fy = df[!, yfname]
                scatter!(
                    s,
                    fx[df[!, :target] .== t],
                    fy[df[!, :target] .== t],
                    label=:none,
                    xlabel=xfname,
                    ylabel=yfname,
                )
            end
        else
            histogram!(s, df[!, xfname], label=:none)
        end
        push!(splots, s)
    end
end

plot(splots..., layout=grid(4, 4), figsize=(10, 10), size=(800, 800))
```
