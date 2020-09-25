# m6.4s.jl

using Pkg, DrWatson
@quickactivate "StatisticalRethinkingStan"
using StanSample
using StatisticalRethinking

df = CSV.read(sr_datadir("milk.csv"), DataFrame; delim=';');
scale!(df, [:kcal_per_g, :perc_fat, :perc_lactose])

m6_4 = "
data{
  int <lower=1> N;              // Sample size
  vector[N] K;
  vector[N] L;
}
parameters{
  real a;
  real bL;
  real<lower=0> sigma;
}
model{
  vector[N] mu;
  sigma ~ exponential( 1 );
  a ~ normal( 0 , 0.2 );
  bL ~ normal( 0 , 0.5 );
  mu = a + bL * L;
  K ~ normal( mu , sigma );
}
";

# Define the SampleModel and set the output format to :mcmcchains.

m6_4s = SampleModel("m6.4s", m6_4);
m6_4_data = Dict("N" => size(df, 1), "L" => df[:, :perc_lactose_s],
    "K" => df[!, :kcal_per_g_s]);
rc = stan_sample(m6_4s, data=m6_4_data);
success(rc) && (dfa6_4 = read_samples(m6_4s; output_format=:dataframe))

success(rc) && (p6_4 = Particles(dfa6_4))

# End of m6.4s.jl