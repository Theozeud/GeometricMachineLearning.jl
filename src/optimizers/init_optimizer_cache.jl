@doc raw"""
Wrapper for the functions `setup_adam_cache`, `setup_momentum_cache`, `setup_gradient_cache`, `setup_bfgs_cache`.
These appear outside of `optimizer_caches.jl` because the `OptimizerMethods` first have to be defined.
"""
init_optimizer_cache(::GradientOptimizer, x) = setup_gradient_cache(x)
init_optimizer_cache(::MomentumOptimizer, x) = setup_momentum_cache(x)
init_optimizer_cache(::AdamOptimizer, x) = setup_adam_cache(x)
init_optimizer_cache(::BFGSOptimizer, x) = setup_bfgs_cache(x)