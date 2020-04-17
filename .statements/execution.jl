using Plots

p1=plot(sin)
p2=plot!(p1, cos)
p1 |> display
p2 |> display
plot([sin,cos]) |> display
plot(rand(10),rand(10)) |> display
scatter(rand(10),rand(10)) |> display
