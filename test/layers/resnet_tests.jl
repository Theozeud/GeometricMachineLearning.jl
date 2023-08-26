using GeometricMachineLearning, Test

function test_resnet(M, batch_size=10, T=Float32)
    model₁ = ResNet(M, tanh, use_bias=true)
    model₂ = ResNet(M, tanh, use_bias=false)
    ps₁ = initialparameters(CPU(), T, model₁)
    ps₂ = initialparameters(CPU(), T, model₂) 
    @test parameterlength(model₁) == M^2
    @test parameterlength(model₂) == M*(M+1)
    A = randn(T, M, M*2, batch_size)
    A₁ = A[:,:,1]
    # test if tensors work
    @test isapprox(model₁(A, ps₁)[:,:,1], model₁(A₁, ps₁))
    @test isapprox(model₂(A, ps₂)[:,:,1], model₂(A₂, ps₂))
end

types = (Float32, Float64)
for T in types 
    for M in 1:2:7
        for batch_size in 1:2:7
            test_resnet(M, batch_size, T)
        end
    end
end