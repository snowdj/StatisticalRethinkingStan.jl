
using Markdown
using InteractiveUtils

using Pkg, DrWatson

begin
	@quickactivate "StatisticalRethinkingStan"
	using StanSample
	using StatisticalRethinking
end

md"## Clip-04-37-44s.jl"

begin
	df = CSV.read(sr_datadir("Howell1.csv"), DataFrame)
	df = filter(row -> row[:age] >= 18, df)
	mean_weight = mean(df.weight)
	df.weight_c = df.weight .- mean_weight
end

Text(precis(df; io=String))

md"##### Define the Stan language model."

m4_3 = "
data {
 int < lower = 1 > N; // Sample size
 vector[N] height; // Predictor
 vector[N] weight; // Outcome
}

parameters {
 real alpha; // Intercept
 real beta; // Slope (regression coefficients)
 real < lower = 0 > sigma; // Error SD
}

model {
 height ~ normal(alpha + weight * beta , sigma);
}
";

md"##### Define the SampleModel."

m4_3s = SampleModel("m4.3s", m4_3);

md"##### Input data."

m4_3_data = Dict("N" => length(df.height), "height" => df.height, "weight" => df.weight_c);

md"##### Sample using stan_sample."

rc4_3s = stan_sample(m4_3s, data=m4_3_data);

if success(rc4_3s)

	# Describe the draws
	
	dfa4_3s = read_samples(m4_3s; output_format=:dataframe)
	part4_3s = Particles(dfa4_3s)
end

md"### snippet 4.37"

if success(rc4_3s)

	# Plot regression line using means and observations

	scatter(df.weight_c, df.height, lab="Observations",
	  ylab="height [cm]", xlab="weight[kg]")
	xi = -16.0:0.1:18.0
	yi = mean(dfa4_3s.alpha) .+ mean(dfa4_3s.beta)*xi;
	plot!(xi, yi, lab="Regression line")
end

md"### snippet 4.44"

if success(rc4_3s)

	quap4_3s = quap(dfa4_3s)
end

plot(plot(quap4_3s.alpha, lab="\\alpha"), plot(quap4_3s.beta, lab="\\beta"), layout=(2, 1))

md"## End of clip-04-37-44s.jl"

