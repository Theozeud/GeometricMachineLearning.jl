
using SafeTestsets

@safetestset "Arrays                                                                          " begin include("arrays/array_tests_new.jl") end
@safetestset "Abstract Layer                                                                  " begin include("layers/abstract_layer_tests.jl") end
@safetestset "Feed Forward Layer                                                              " begin include("layers/feed_forward_layer_tests.jl") end
@safetestset "Gradient Layer                                                                  " begin include("layers/gradient_layer_tests.jl") end
@safetestset "Linear Layer                                                                    " begin include("layers/linear_layer_tests.jl") end
@safetestset "Symplectic Layers                                                               " begin include("layers/symplectic_layer_tests.jl") end
@safetestset "Abstract Neural Network                                                         " begin include("abstract_neural_network_tests.jl") end
@safetestset "Vanilla Neural Network                                                          " begin include("vanilla_neural_network_tests.jl") end
@safetestset "Hamiltonian Neural Network                                                      " begin include("hamiltonian_neural_network_tests.jl") end
@safetestset "Custom AD rules for kernels                                                     " begin include("custom_ad_rules/kernel_pullbacks.jl") end
