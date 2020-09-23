### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ 629c1314-fdb8-11ea-0810-73f40ec50097
using Pkg, DrWatson

# ╔═╡ 629c6026-fdb8-11ea-222c-01752dee3679
begin
	@quickactivate "StatisticalRethinkingStan"
	using StanSample
	using StatisticalRethinking
end

# ╔═╡ 62a90e5c-fdb8-11ea-2748-a31802543587
for i in 5:7
	include(projectdir("models", "05", "m5.$(i)s.jl"))
end

# ╔═╡ 4ce0616e-fdb7-11ea-0474-63cb801384f5
md"## Clip-05-40.1s.jl"

# ╔═╡ 629ccafc-fdb8-11ea-1012-d11648fe79d0
md"### snippet 5.39"

# ╔═╡ 62a988b4-fdb8-11ea-0cdd-1759b8567402
if success(rc)
	dfa5 = read_samples(m5_5s; output_format=:dataframe)
	title5 = "Kcal_per_g vs. neocortex_perc" * "\n89% predicted and mean rangep1 = plotbounds(
		df, :neocortex_perc, :kcal_per_g,
		dfa5, [:a, :bN, :sigma];
		title=title5
	)
end

# ╔═╡ 62b4472e-fdb8-11ea-3bf0-8b453a2872a9
if success(rc)
	dfa6 = read_samples(m5_6s; output_format=:dataframe)
	title6 = "Kcal_per_g vs. log mass" * "\n89% predicted and mean range"
	p2 = plotbounds(
		df, :lmass, :kcal_per_g,
		dfa6, [:a, :bM, :sigma];
		title=title6
	)
end

# ╔═╡ 62b4cd64-fdb8-11ea-38d9-8d6810b1a4d4
if success(rc)
	dfa7 = read_samples(m5_7s; output_format=:dataframe)
	title7 = "Counterfactual,\nholding M=0.0"
	p3 = plotbounds(
		df, :neocortex_perc, :kcal_per_g,
		dfa7, [:a, :bN, :sigma];
		title=title7
	)
end

# ╔═╡ 62be59ce-fdb8-11ea-2278-8732aa168e50
if success(rc)
	title8 = "Counterfactual,\nholding N=0.0"
	p4 = plotbounds(
		df, :lmass, :kcal_per_g,
		dfa7, [:a, :bM, :sigma];
		title=title8,
		xlab="log(mass)"
	)
end

# ╔═╡ 62beccba-fdb8-11ea-32e6-0fff022ac3fe
plot(p1, p2, p3, p4, layout=(2, 2))

# ╔═╡ 62c8c1fc-fdb8-11ea-32c1-b9d03576a104
md"## End of clip-05-40.1s.jl"

# ╔═╡ Cell order:
# ╟─4ce0616e-fdb7-11ea-0474-63cb801384f5
# ╠═629c1314-fdb8-11ea-0810-73f40ec50097
# ╠═629c6026-fdb8-11ea-222c-01752dee3679
# ╠═629ccafc-fdb8-11ea-1012-d11648fe79d0
# ╠═62a90e5c-fdb8-11ea-2748-a31802543587
# ╠═62a988b4-fdb8-11ea-0cdd-1759b8567402
# ╠═62b4472e-fdb8-11ea-3bf0-8b453a2872a9
# ╠═62b4cd64-fdb8-11ea-38d9-8d6810b1a4d4
# ╠═62be59ce-fdb8-11ea-2278-8732aa168e50
# ╠═62beccba-fdb8-11ea-32e6-0fff022ac3fe
# ╟─62c8c1fc-fdb8-11ea-32c1-b9d03576a104
