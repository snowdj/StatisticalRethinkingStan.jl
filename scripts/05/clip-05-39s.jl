
using Markdown
using InteractiveUtils

using Pkg, DrWatson

begin
	@quickactivate "StatisticalRethinkingStan"
	using StanSample
	using StatisticalRethinking
end

for i in 5:7
	include(projectdir("models", "05", "m5.$(i)s.jl"))
end

md"## Clip-05-39s.jl"

md"### snippet 5.39"

begin
	(s1, p1) = plotcoef([m5_5s, m5_6s, m5_7s], [:a, :bN, :bM];
		title="Masked relationships: bN & bM Normal estimates")
	p1
end

s1

begin
	(s2, p2) = plotcoef([m5_5s, m5_6s, m5_7s], [:a, :bN, :bM];
		title="Masked relationships: bN & bM Normal estimates", func=quap)
	p2
end

s2

md"## End of clip-05-39s.jl"

