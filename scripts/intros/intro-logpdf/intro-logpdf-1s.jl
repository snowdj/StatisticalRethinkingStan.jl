
using Markdown
using InteractiveUtils

using Pkg, DrWatson

begin
	@quickactivate "StatisticalRethinkingStan"
	using StanSample
	using StatisticalRethinking
end

md"## Intro-logpdf-1s.jl"

begin
	df = CSV.read(sr_datadir("Howell1.csv"), DataFrame; delim=';')
	df2 = filter(row -> row[:age] >= 18, df)
end;

md"##### This is an alternative way of writing the Stan language model for the heights example."

md"##### This is referred to in chapter 9. The model block resembles the way loglik() functions used for Optim are constructed."

heightsmodel = "
// Inferring a Rate
data {
  int<lower=1> N;
  real<lower=0> h[N];
}
parameters {
  real mu;
  real<lower=0,upper=250> sigma;
}
model {
  // Priors for mu and sigma
  target += normal_lpdf(mu | 178, 20);

  // Observed heights, add loglikelihood to target
  target += normal_lpdf(h | mu, sigma);
}
";

sm = SampleModel("heights", heightsmodel);

heightsdata = Dict("N" => length(df2[:, :height]), "h" =>df2.height);

rc = stan_sample(sm, data=heightsdata);

if success(rc)
  chn = read_samples(sm; output_format=:mcmcchains)
end

md"## End intro-logpdf-1s.jl"

