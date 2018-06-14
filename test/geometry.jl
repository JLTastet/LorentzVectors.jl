@testset "Geometry" begin
    @testset "Boosts" begin
        β0 = Vec3(0, 0, 0)
        u1 = Vec4(1.2, 0.2, 0.2, 1.)
        @test boost(u1, β0) ≈ u1
        β1 = Vec3(0, 0, 0.85)
        v1 = boost(u1, β1)
        @test u1⋅u1 ≈ v1⋅v1
        β2 = u1 / u1.t
        v2 = boost(u1, β2)
        @test v2.t^2 ≈ u1⋅u1
        ε = 1e-16
        @test norm(Vec3(v2)) < ε
        β3 = Vec3(0.55, -0.37, 0.11)
        v3 = boost(u1, β3)
        u3 = boost(v3, -β3)
        @test u1 ≈ u3
    end
end
