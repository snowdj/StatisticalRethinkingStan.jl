
using Markdown
using InteractiveUtils

using Pkg, DrWatson

begin
	@quickactivate "StatisticalRethinkingStan"
	using StanSample
	using StatisticalRethinking
end

for suf in ["MA", "AM"]
  include(projectdir("models", "05", "m5.4.$(suf)s.jl"))
end

md"## Clip-05-13-14s.jl"

if success(rc5_4_AMs)
	begin
		pMA = plotbounds(df, :M, :A, dfa5_4_MAs, [:a, :bMA, :sigma])
		pAM = plotbounds(df, :A, :M, dfa5_4_AMs, [:a, :bAM, :sigma])
		plot(pAM, pMA, layout=(1, 2))
	end
end

md"##### Compute standardized residuals."

if success(rc5_4_MAs)
	begin
		figs = Vector{Plots.Plot{Plots.GRBackend}}(undef, 4)
		a = -2.5:0.1:3.0
		mu_MA = mean(part5_4_MAs.a) .+ mean(part5_4_MAs.bMA)*a
		figs[1] = plot(xlab="Age at marriage (std)", ylab="Marriage rate (std)", leg=false)
		plot!(a, mu_MA)
		scatter!(df[:, :A_s], df[:, :M_s])
		annotate!([(df[9, :A_s]-0.1, df[9, :M_s], Plots.text("DC", 6, :red, :right))])
	end
end

if success(rc5_4_AMs)
	begin
		m = -2.0:0.1:3.0
		mu_AM = mean(part5_4_AMs.a) .+ mean(part5_4_AMs.bAM)*m
		figs[2] = plot(ylab="Age at marriage (std)", xlab="Marriage rate (std)", leg=false)
		plot!(m, mu_AM)
		scatter!(df[:, :M_s], df[:, :A_s])
		annotate!([(df[9, :M_s]+0.2, df[9, :A_s], Plots.text("DC", 6, :red, :left))])
	end
end

if success(rc5_4_MAs)
	begin
		mu_MA_obs = mean(part5_4_MAs.a) .+ mean(part5_4_MAs.bMA)*df[:, :A_s]
		res_MA = df[:, :M_s] - mu_MA_obs

		df2 = DataFrame(
			:d => df[:, :D_s],
			:r => res_MA
		)

		m1 = lm(@formula(d ~ r), df2)
		#coef(m1) |> display

		figs[3] = plot(xlab="Marriage rate residuals", ylab="Divorce rate (std)", leg=false)
		plot!(m, coef(m1)[1] .+ coef(m1)[2]*m)
		scatter!(res_MA, df[:, :D_s])
		vline!([0.0], line=:dash, color=:black)
		annotate!([(res_MA[9], df[9, :D_s]+0.1, Plots.text("DC", 6, :red, :bottom))])
	end
end

if success(rc5_4_AMs)
	begin
		mu_AM_obs = mean(part5_4_AMs.a) .+ mean(part5_4_AMs.bAM)*df[:, :M_s]
		res_AM = df[:, :A_s] - mu_AM_obs
		df3 = DataFrame(
			:d => df[:, :D_s],
			:r => res_AM
		)

		m2 = lm(@formula(d ~ r), df3)
		#coef(m2) |> display

		figs[4] = plot(xlab="Age at marriage residuals", ylab="Divorce rate (std)", leg=false)
		plot!(a, coef(m2)[1] .+ coef(m2)[2]*a)
		scatter!(res_AM, df[:, :D_s])
		vline!([0.0], line=:dash, color=:black)
		annotate!([(res_AM[9]-0.1, df[9, :D_s], Plots.text("DC", 6, :red, :right))])
	end
end

plot(figs..., layout=(2,2))

md"## End of clip-05-13-14s.jl"

