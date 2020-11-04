"""
    MyWorkflow
This is an example of Julia module. These docstrings can be seen on github
"""
module MyWorkflow

export func

"""
    func(x)
Returns double the numer `x` plus `1`.

```jldoctest
julia> func(2)
5
```
"""
func(x) = 2x + 1

"""
    hello(msg::String)
print string `Hello` followed by `msg`

```jldoctest
julia> MyWorkflow.hello("world")
"helloworld"
```
"""
hello(msg::String) = "hello" * msg

end
