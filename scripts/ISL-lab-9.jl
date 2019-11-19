# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("MLJTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

# ## Getting started
using MLJ, RDatasets, PrettyPrinting, Random

# We start by generating a 2D cloud of points
Random.seed!(3203)
X = randn(20, 2)
y = vcat(-ones(10), ones(10))

X = MLJ.table(X)
y = categorical(y);

# Let's fit a SVM classifier
@load SVC pkg=LIBSVM

svc_mdl = SVC()
svc = machine(svc_mdl, X, y)

fit!(svc);

# As usual we can check how it performs
ypred = predict(svc, X)
misclassification_rate(ypred, y)

# Not bad.
# ### Basic tuning
# As usual we could tune the model, for instance the penalty encoding the tradeoff between margin width and misclassification:
rc = range(svc_mdl, :cost, lower=0.1, upper=5)
tm = TunedModel(model=svc_mdl, ranges=[rc], tuning=Grid(resolution=10),
                resampling=CV(nfolds=3, rng=33), measure=misclassification_rate)
mtm = machine(tm, X, y)

fit!(mtm)

ypred = predict(mtm, X)
misclassification_rate(ypred, y)

# You could also change the kernel etc.
# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl
