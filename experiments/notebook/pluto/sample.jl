### A Pluto.jl notebook ###
# v0.11.13

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 7978f646-f25e-11ea-052d-2b6a98c1e3c9
begin 
    using Markdown
    hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]));
    tip(text="md(これはTipです)") = Markdown.MD(Markdown.Admonition("correct", "Tip", [text]));
    md"下記のヒントを読んでね"
end

# ╔═╡ eaba0bfe-f253-11ea-0f40-b51436fe83ce
begin 
    using Plots
    using PlutoUI
    using LaTeXStrings
end

# ╔═╡ 1a82d8e4-f255-11ea-013b-a12ca030a545
using Images, TestImages

# ╔═╡ f111e400-f25c-11ea-39c9-2ff328de00b0
md"# Pluto.jl 環境上での対話的ノートブック"

# ╔═╡ 90b3cc2e-f25f-11ea-2991-818b8dddbe36
md"Pluto.jl を用いたサンプルを紹介する．Jupyter notebook でも Interact.jl で実装はできるが， Pluto.jl によるノートブックの方が滑らかにスライダーの変化を楽しむことができる．"

# ╔═╡ 504a76a4-f25f-11ea-2d2b-7f7e2be7fbd0
tip(md"こんな感じのTipを載せることもできる. 次のHintの上にマウスをあててみよう. ぼやけた文字をくっきり写すことができるはずだ")

# ╔═╡ a7d73f04-f25e-11ea-0e3d-3b352eba207f
hint(md"Jupyter notebook のようにコードをまとめたブロックをセル (cell) と呼ぶが, セルに複数行のコードを記述するときは `begin ... end` ブロックで囲む必要がある. またこのHintはマークダウンで記述できる．これ自体の記述をどうしているかを見たい場合はこのセルの左に出てくる目マークを表しているアイコンをクリックすると表示できる．")

# ╔═╡ 7e366740-f260-11ea-131a-a7084a072758
tip(md"セルの右側にある再生ボタンを順次クリックするまたは Shift+Enter で進む. おそらくそんなことをしなくてもPlutoが全てのセルを実行してくれるはずではあるが")

# ╔═╡ 2fd22542-f25d-11ea-18bb-1713026f5026
md"## Plots"

# ╔═╡ e9f43d5e-f25d-11ea-0581-9d370db65eb7
md"""
### Slider を使ってグリグリする

```julia
@bind <変数名> <PlutoUIのオブジェクト>
```

のようにして UI を構築できる UI のコントロール（例えばスライダー）を変化させるとそれに対応する値が<変数名>に反映される.
"""

# ╔═╡ 7e8b6224-f254-11ea-090e-e1c6bd90bb33
begin 
    t_slider = @bind t Slider(-π:0.01:π)
    md"t: $(t_slider) <- touch me"
end

# ╔═╡ a5246d68-f254-11ea-018e-79939c9689f5
begin
    x = range(-π,π,step=0.01)
    y = @. sin(x + 2t)
    plot(x, y, title= "sin(x+t)" * " where t=$t")
    xticks!(
        [-π,-π/2,0,π/2,π], 
        [L"-\pi", L"-\pi/2", L"0", L"\pi/2", L"\pi"]
    )
end

# ╔═╡ 627a1d1a-f25d-11ea-38ea-19f2a7ee5bde
md"## アニメーションを gif で表示"

# ╔═╡ d4996e9c-f25c-11ea-3ad1-6b184dcdb79a
begin 
    anim = @animate for i in 1:10 scatter(rand(10), rand(10), title="i=$i") end
    gif(anim, fps=2)
end

# ╔═╡ 00b739ec-f261-11ea-251e-e929f665952c
md"# 画像アプリケーションの例"

# ╔═╡ 416d498e-f259-11ea-3930-79118483e2c1
begin 
    degree_slider = @bind degree Slider(0:360) 
    md"degree: $(degree_slider)"
end

# ╔═╡ 0e957840-f25b-11ea-3cb1-334f405c5803
@bind name Select(TestImages.remotefiles)

# ╔═╡ 0dcce14c-f255-11ea-0348-ffddd69c792b
begin
    img = testimage(name)
    img1 = imrotate(img, deg2rad(degree)) # without cropping
    img2 = imrotate(img, deg2rad(degree), axes(img)) # with cropping
    img1 = imresize(img1, img2|>size)
    hcat(img1, img2)
end

# ╔═╡ Cell order:
# ╟─f111e400-f25c-11ea-39c9-2ff328de00b0
# ╟─90b3cc2e-f25f-11ea-2991-818b8dddbe36
# ╟─7978f646-f25e-11ea-052d-2b6a98c1e3c9
# ╟─504a76a4-f25f-11ea-2d2b-7f7e2be7fbd0
# ╟─a7d73f04-f25e-11ea-0e3d-3b352eba207f
# ╟─7e366740-f260-11ea-131a-a7084a072758
# ╟─2fd22542-f25d-11ea-18bb-1713026f5026
# ╠═eaba0bfe-f253-11ea-0f40-b51436fe83ce
# ╟─e9f43d5e-f25d-11ea-0581-9d370db65eb7
# ╠═7e8b6224-f254-11ea-090e-e1c6bd90bb33
# ╠═a5246d68-f254-11ea-018e-79939c9689f5
# ╟─627a1d1a-f25d-11ea-38ea-19f2a7ee5bde
# ╠═d4996e9c-f25c-11ea-3ad1-6b184dcdb79a
# ╟─00b739ec-f261-11ea-251e-e929f665952c
# ╠═1a82d8e4-f255-11ea-013b-a12ca030a545
# ╠═416d498e-f259-11ea-3930-79118483e2c1
# ╠═0e957840-f25b-11ea-3cb1-334f405c5803
# ╠═0dcce14c-f255-11ea-0348-ffddd69c792b