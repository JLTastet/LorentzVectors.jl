@testset "Random spatial vector" begin
    for i = 1:10
        @test norm(rand(SpatialVector{Float64})) ≈ 1.
    end;
end;
