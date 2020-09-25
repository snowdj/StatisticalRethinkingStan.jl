
using Markdown
using InteractiveUtils

using Pkg, DrWatson

begin
	@quickactivate "StatisticalRethinkingStan"
	using StanSample
	using StatisticalRethinking
end

md"## Clip-06-06-09s.jl"

begin
	N = 100
	df = DataFrame(
	  :h0 => rand(Normal(10,2 ), N),
	  :treatment => vcat(zeros(Int, Int(N/2)), ones(Int, Int(N/2)))
	);
	df[!, :fungus] = [rand(Binomial(1, 0.5 - 0.4 * df[i, :treatment]), 1)[1] for i in 1:N]
	df[!, :h1] = [df[i, :h0] + rand(Normal(5 - 3 * df[i, :fungus]), 1)[1] for i in 1:N]
end

m6_7 = "
data {
  int <lower=1> N;
  vector[N] h0;
  vector[N] h1;
  vector[N] treatment;
  vector[N] fungus;
}
parameters{
  real a;
  real bt;
  real bf;
  real<lower=0> sigma;
}
model {
  vector[N] mu;
  vector[N] p;
  a ~ lognormal(0, 0.2);
  bt ~ normal(0, 0.5);
  bf ~ normal(0, 0.5);
  sigma ~ exponential(1);
  for ( i in 1:N ) {
    p[i] = a + bt*treatment[i] + bf*fungus[i];
    mu[i] = h0[i] * p[i];
  }
  h1 ~ normal(mu, sigma);
}
"

begin
	m6_7s = SampleModel("m6.7s", m6_7)
	m6_7_data = Dict(
	  :N => nrow(df),
	  :h0 => df[:, :h0],
	  :h1 => df[:, :h1],
	  :fungus => df[:, :fungus],
	  :treatment => df[:, :treatment]
	)
	rc = stan_sample(m6_7s; data=m6_7_data)
	success(rc) && (dfa6_7 = read_samples(m6_7s; output_format=:dataframe))
end

success(rc) && (p6_7 = Particles(dfa6_7))

success(rc) && (Text(precis(dfa6_7; io=String)))

success(rc) && plotcoef([m6_7s], [:a, :bt, :bf], "", "")

md"## End of clip-06-06-09s.jl"

