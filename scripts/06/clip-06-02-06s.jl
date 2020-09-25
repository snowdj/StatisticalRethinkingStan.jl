
using Markdown
using InteractiveUtils

using Pkg, DrWatson

begin
	@quickactivate "StatisticalRethinkingStan"
	using StanSample
	using StatisticalRethinking
end

md"## Clip-06-02-06s.jl"

N = 100

md"### Snippet 6.1"

begin
	df = DataFrame(
		height = rand(Normal(10, 2), N),
		leg_prop = rand(Uniform(0.4, 0.5), N),
	)
	df.leg_left = df.leg_prop .* df.height + rand(Normal(0, 0.02), N)
	df.leg_right = df.leg_prop .* df.height + rand(Normal(0, 0.02), N)
end

md"### Snippet 6.2"

m6_1 = "
data {
  int <lower=1> N;
  vector[N] H;
  vector[N] LL;
  vector[N] LR;
}
parameters {
  real a;
  real bL;
  real bR;
  real <lower=0> sigma;
}
model {
  vector[N] mu;
  mu = a + bL * LL + bR * LR;
  a ~ normal(10, 100);
  bL ~ normal(2, 10);
  bR ~ normal(2, 10);
  sigma ~ exponential(1);
  H ~ normal(mu, sigma);
}
";

begin
	m6_1s = SampleModel("m6.1s", m6_1, method=StanSample.Sample(num_samples=1000))
	m_6_1_data = Dict(
	  :H => df[:, :height],
	  :LL => df[:, :leg_left],
	  :LR => df[:, :leg_right],
	  :N => size(df, 1)
	)
	rc = stan_sample(m6_1s, data=m_6_1_data)
	success(rc) && (p = read_samples(m6_1s, output_format=:particles))
end

if success(rc)
	(s0, p0) = plotcoef([m6_1s], [:a, :bL, :bR, :sigma], "", "Multicollinearity between bL and bR", quap)
	plot(p0)
end

if success(rc)
	dfa = read_samples(m6_1s, output_format=:dataframe)

	# Fit a linear regression

	m = lm(@formula(bL ~ bR), dfa)

	# estimated coefficients from the model

	coefs = coef(m)

	p1 = plot(xlabel="bR", ylabel="bL", lab="bL ~ bR")
	plot!(p1, dfa[:, :bR], dfa[:, :bL])
	p2 = density(p.bR.particles + p.bL.particles, xlabel="sum of bL and bR",
		ylabel="Density", lab="bL + bR")
	plot(p1, p2, layout=(1, 2))
end

md"## End of clip-06-02-06s.jl"

