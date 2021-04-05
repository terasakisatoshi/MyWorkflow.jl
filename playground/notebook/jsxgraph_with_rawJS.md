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

# JSXGraph

```julia
using JSExpr
using WebIO

n=Node(
    :div,
    id = "board",
    className = "jxgbox",
    attributes=Dict(
        :style=>"width:500px; height:500px;margin:0 auto;"
    )
)

w = Scope(
    imports=[
            "https://cdnjs.cloudflare.com/ajax/libs/jsxgraph/1.1.0/jsxgraphcore.js",
            "https://cdnjs.cloudflare.com/ajax/libs/jsxgraph/1.1.0/jsxgraph.css",
    ]
)(n)

onmount(
    w, 
    js"""
    (function(){
        var board = JXG.JSXGraph.initBoard(
            "board",
            {
                boundingbox: [-15, 15, 15, -15],
                axis: true
            }
        );
        var board=JXG.JSXGraph.initBoard("board",{"axis":true,"boundingbox":[-15,15,15,-15]});
        var a = board.create("slider", [[7, 7], [11, 7], [-3, 0.1, 10]], { name: "a" });
        var b = board.create("slider", [[7, 6], [11, 6], [-1, 1, 5]], { name: "b" });
        var c = board.create("slider", [[7, 5], [11, 5], [-10, -5, 2]], { name: "c" });
        // y = ax^2+bx+c
        var func = board.create(
            "functiongraph",
            [
                function (x) {
                    return a.Value() * x * x + b.Value() * x + c.Value();
                }
            ]
        )
        var quadratic = board.create(
            'text',
            [
                2,
                10,
                function () {
                    return 'f(x) = ax^2+bx+c';
                }
            ],
            { fontSize: 20 }
        );
        return board;
    })
    """
)
```
