# m5.7s.jl

using Pkg, DrWatson

@quickactivate "StatisticalRethinkingStan"
using StanSample
using StatisticalRethinking

# ### snippet 5.29

df = CSV.read(sr_datadir("milk.csv"), DataFrame; delim=';');
df = filter(row -> !(row[:neocortex_perc] == "NA"), df);
df[!, :neocortex_perc] = parse.(Float64, df[:, :neocortex_perc])
df[!, :lmass] = log.(df[:, :mass])
scale!(df, [:kcal_per_g, :neocortex_perc, :lmass])

m5_7 = "
data {
 int < lower = 1 > N; // Sample size
 vector[N] K; // Outcome
 vector[N] NC; // Predictor
 vector[N] M; // Predictor
}

parameters {
 real a; // Intercept
 real bM; // Slope (regression coefficients)
 real bN; // Slope (regression coefficients)
 real < lower = 0 > sigma;    // Error SD
}

model {
  vector[N] mu;               // mu is a vector
  a ~ normal(0, 0.2);           //Priors
  bN ~ normal(0, 0.5);
  bM ~ normal(0, 0.5);
  sigma ~ exponential(1);
  mu = a + bM * M + bN * NC;
  K ~ normal(mu , sigma);     // Likelihood
}
";

# Define the SampleModel and set the output format to :mcmcchains.

m5_7s = SampleModel("m5.7", m5_7);

# Input data for cmdstan

m5_7_data = Dict("N" => size(df, 1), "M" => df[!, :lmass_s],
    "K" => df[!, :kcal_per_g_s], "NC" => df[!, :neocortex_perc_s]);

# Sample using StanSample

rc5_7s = stan_sample(m5_7s, data=m5_7_data);

if success(rc5_7s)

  # Describe the draws

  dfa5_7s = read_samples(m5_7s; output_format=:dataframe)
  part5_7s = Particles(dfa5_7s)
  quap5_7s = quap(dfa5_7s)
  part5_7s |> display
  
  rethinking = "
             mean   sd  5.5% 94.5%
    a      0.07 0.13 -0.15  0.28
    bN     0.68 0.25  0.28  1.07
    bM    -0.70 0.22 -1.06 -0.35
    sigma  0.74 0.13  0.53  0.95
  "

end
