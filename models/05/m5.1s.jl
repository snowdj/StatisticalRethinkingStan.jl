# m5_1s.jl

using Pkg, DrWatson
@quickactivate "StatisticalRethinkingStan"
using StanSample
using StatisticalRethinking

# ### snippet 5.1

df = CSV.read(sr_datadir("WaffleDivorce.csv"), DataFrame);

# ### snippet 5.1

scale!(df, [:Marriage, :MedianAgeMarriage, :Divorce])
println()

m5_1 = "
data {
 int < lower = 1 > N; // Sample size
 vector[N] D; // Outcome
 vector[N] A; // Predictor
}

parameters {
 real a; // Intercept
 real bA; // Slope (regression coefficients)
 real < lower = 0 > sigma;    // Error SD
}

model {
  vector[N] mu;               // mu is a vector
  a ~ normal(0, 0.2);         //Priors
  bA ~ normal(0, 0.5);
  sigma ~ exponential(1);
  mu = a + bA * A;
  D ~ normal(mu , sigma);     // Likelihood
}
";

# Define the SampleModel and set the output format to :mcmcchains.

m5_1s = SampleModel("m5.1", m5_1);

# Input data for cmdstan

m5_1_data = Dict("N" => size(df, 1), "D" => df[!, :Divorce_s],
    "A" => df[!, :MedianAgeMarriage_s]);

# Sample using StanSample

rc5_1s = stan_sample(m5_1s, data=m5_1_data);

if success(rc5_1s)

  # Describe the draws

  dfa5_1s = read_samples(m5_1s; output_format=:dataframe)

  # Result rethinking

  rethinking = "
           mean   sd  5.5% 94.5%
    a      0.00 0.10 -0.16  0.16
    bA    -0.57 0.11 -0.74 -0.39
    sigma  0.79 0.08  0.66  0.91
  "

  part5_1s = Particles(dfa5_1s)
  part5_1s |> display

end
