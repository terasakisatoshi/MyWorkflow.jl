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


- JSXGraph is a cross-browser JavaScript library for interactive geometry, function plotting, charting, and data visualization in the web browser. Here is a sample code using HTML and JavaScript.

<!-- #region -->


```html
<!DOCTYPE html>
<html>

<head>
    <title>Type Script Greeter</title>
    <link rel="stylesheet" type="text/css" href="http://jsxgraph.uni-bayreuth.de/distrib/jsxgraph.css" />
    <script type="text/javascript" src="http://jsxgraph.uni-bayreuth.de/distrib/jsxgraphcore.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
</head>

<body>
    <div id="board" class="jxgbox" style="width:500px; height:500px;"></div>
    <script type="text/javascript">
        JXG.Options.text.useMathJax = true;
        var board = JXG.JSXGraph.initBoard(
            "board",
            {
                boundingbox: [-15, 15, 15, -15],
                axis: true
            }
        );
        /* The slider needs the following input parameters:
        [[x1, y1], [x2, y2], [min, start, max]]
        [x1, y1]: first point of the ruler
        [x2, y2]: last point of the ruler
        min: minimum value of the slider
        start: initial value of the slider
        max: maximum value of the slider
        */
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
                    return '\\[f(x) = ax^2+bx+c\\]';
                }
            ],
            { fontSize: 20 }
        );
    </script>
</body>

</html>
```
<!-- #endregion -->

# Display JSXGraph using WebIO.jl and JSExpr.jl

- We can create JSXGraph object using WebIO.jl and JSExpr.jl as follow:

```julia
using WebIO
using JSExpr

n=Node(
    :div,
    id = "board",
    className = "jxgbox",
    attributes=Dict(
        :style=>"width:500px; height:500px;margin:0 auto;"
    )
)

w = Scope(
    id = "graph",
    imports=[
            "https://cdnjs.cloudflare.com/ajax/libs/jsxgraph/1.1.0/jsxgraphcore.js",
            "https://cdnjs.cloudflare.com/ajax/libs/jsxgraph/1.1.0/jsxgraph.css",
    ]
)(n)



onmount(
    w, 
    @js function ()
        JXG.Options.text.useMathJax = true
        @var board = JXG.JSXGraph.initBoard(
            "board",
            Dict(
                :axis=>true,
                :boundingbox => [-15, 15, 15, -15],
            )
        );
        @var a = board.create("slider", 
            [[7, 7], [11, 7], [-3, 0.1, 10]], 
            Dict(:name => "a" )
        )
        @var b = board.create("slider", [[7, 6], [11, 6], [-1, 1, 5]], Dict(:name => "b" ))
        @var c = board.create("slider", [[7, 5], [11, 5], [-10, -5, 2]], Dict(:name => "c" ))
        @var func = board.create(
            "functiongraph",
            [
                (x) -> a.Value() * x * x + b.Value() * x + c.Value()
            ]
        )
        @var quadratic = board.create(
            "text",
            # I would like to render text using mathjax ...
            [ 2, 10, () -> "f(x) = ax^2+bx+c"], 
            Dict(:fontSize=> 20)
        );
        return board # must be at the end of this function
    end
)

w |> display
```
