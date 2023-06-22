struct LnnExactIntegrator <: LnnTrainingIntegrator end

function loss_single(::LnnExactIntegrator, nn::LuxNeuralNetwork{<:LagrangianNeuralNetwork}, qₙ, q̇ₙ, q̈ₙ, params = nn.params)
    sum(∇q∇q̇L(nn,qₙ, q̇ₙ, params))  #inv(∇q̇∇q̇L(nn, qₙ, q̇ₙ, params))*(∇qL(nn, qₙ, q̇ₙ, params) - ∇q∇q̇L(nn, qₙ, q̇ₙ, params))
end

loss(ti::LnnExactIntegrator, nn::LuxNeuralNetwork{<:LagrangianNeuralNetwork}, datat::DataTarget{DataTrajectory}, index_batch = get_batch(datat), params = nn.params) =
mapreduce(x->loss_single(ti, nn, datat.get_data[:q](x[1],x[2]), datat.get_data[:q̇](x[1],x[2]), datat.get_target[:q̈](x[1],x[2]), params), +, index_batch)

loss(ti::LnnExactIntegrator, nn::LuxNeuralNetwork{<:LagrangianNeuralNetwork}, datat::DataTarget{DataSampled}, index_batch = get_batch(datat), params = nn.params) = 
mapreduce(n->loss_single(ti, nn, datat.get_data[:q](n), datat.get_data[:q̇](n), datat.get_target[:q̈](n), params), +, index_batch)

required_key(::LnnExactIntegrator) = (:q,:q̇,:q̈)