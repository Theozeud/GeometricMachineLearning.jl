
using SafeTestsets

@safetestset "Check parameterlength                                                           " begin include("parameterlength/check_parameterlengths.jl") end
@safetestset "Arrays #1                                                                       " begin include("arrays/array_tests.jl") end
@safetestset "Sampling of arrays                                                              " begin include("arrays/random_generation_of_custom_arrays.jl") end
@safetestset "Manifolds (Grassmann):                                                          " begin include("manifolds/grassmann_manifold.jl") end
@safetestset "Gradient Layer                                                                  " begin include("layers/gradient_layer_tests.jl") end
@safetestset "Test symplecticity of upscaling layer                                           " begin include("layers/sympnet_layers_test.jl") end 
@safetestset "Hamiltonian Neural Network                                                      " begin include("hamiltonian_neural_network_tests.jl") end
@safetestset "Manifold Neural Network Layers                                                  " begin include("layers/manifold_layers.jl") end
@safetestset "Custom AD rules for kernels                                                     " begin include("custom_ad_rules/kernel_pullbacks.jl") end
@safetestset "ResNet                                                                          " begin include("layers/resnet_tests.jl") end
@safetestset "Transformer Networks #1                                                         " begin include("transformer_related/multi_head_attention_stiefel_optim_cache.jl") end
@safetestset "Transformer Networks #2                                                         " begin include("transformer_related/multi_head_attention_stiefel_retraction.jl") end
@safetestset "Transformer Networks #3                                                         " begin include("transformer_related/multi_head_attention_stiefel_setup.jl") end
@safetestset "Transformer Networks #4                                                         " begin include("transformer_related/transformer_setup.jl") end
@safetestset "Transformer Networks #5                                                         " begin include("transformer_related/transformer_application.jl") end
@safetestset "Transformer Networks #6                                                         " begin include("transformer_related/transformer_gradient.jl") end
@safetestset "Transformer Networks #7                                                         " begin include("transformer_related/transformer_optimizer.jl") end
@safetestset "Attention layer #1                                                              " begin include("attention_layer/attention_setup.jl") end
@safetestset "(MultiHead)Attention                                                            " begin include("attention_layer/apply_multi_head_attention.jl") end
@safetestset "Classification layer                                                            " begin include("layers/classification.jl") end
@safetestset "Optimizer #1                                                                    " begin include("optimizers/utils/global_sections.jl") end
@safetestset "Optimizer #2                                                                    " begin include("optimizers/utils/optimization_step.jl") end
@safetestset "Optimizer #3                                                                    " begin include("optimizers/utils/modified_exponential.jl") end
@safetestset "Optimizer #4                                                                    " begin include("optimizers/optimizer_convergence_tests/svd_optim.jl") end
@safetestset "Optimizer #5                                                                    " begin include("optimizers/optimizer_convergence_tests/psd_optim.jl") end
@safetestset "Data                                                                            " begin include("data/test_data.jl") end
@safetestset "Batch                                                                           " begin include("data/test_batch.jl") end
@safetestset "Method                                                                          " begin include("train!/test_method.jl") end
@safetestset "Matching                                                                        " begin include("data/test_matching.jl") end
@safetestset "TrainingSet                                                                     " begin include("train!/test_trainingSet.jl") end
@safetestset "Training                                                                        " begin include("train!/test_training.jl") end
@safetestset "NeuralNetSolution                                                               " begin include("train!/test_neuralnet_solution.jl") end
@safetestset "Problem & Integrators                                                           " begin include("integrator/test_integrator.jl") end

@safetestset "Test data loader for q and p data                                               " begin include("data_loader/batch_data_loader_qp_test.jl") end
@safetestset "Test mnist_utils.                                                               " begin include("data_loader/mnist_utils.jl") end
@safetestset "Test the data loader in combination with optimization_step!                     " begin include("data_loader/data_loader_optimization_step.jl") end
@safetestset "Optimizer functor with data loader for Adam                                     " begin include("data_loader/optimizer_functor_with_adam.jl")