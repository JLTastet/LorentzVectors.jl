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

    @testset "Rotations" begin
        x̂ = Vec3(1, 0, 0)
        ŷ = Vec3(0, 1, 0)
        ẑ = Vec3(0, 0, 1)
        @test rotate(x̂, ẑ, π/2) ≈ ŷ
        @test rotate(ŷ, x̂, π/2) ≈ ẑ
        @test rotate(ẑ, ŷ, π/2) ≈ x̂
        @test rotate(x̂, ẑ, π) ≈ -x̂
        @test rotate(x̂, ŷ, π) ≈ -x̂
        @test rotate(ŷ, ẑ, π) ≈ -ŷ
        @test rotate(ŷ, x̂, π) ≈ -ŷ
        @test rotate(ẑ, x̂, π) ≈ -ẑ
        @test rotate(ẑ, ŷ, π) ≈ -ẑ
        u = Vec3(1.1, -0.3, 0.9)
        k̂ = normalize(Vec3(-0.6, 0.8, 1.3))
        @test rotate(u, k̂, -π/3) ≈ rotate(u, -k̂, π/3)
        @test norm(rotate(u, k̂, 0.6)) ≈ norm(u)
        @test rotate(u, normalize(u), 1.3) ≈ u
        v̂ = normalize(k̂ × u)
        @test rotate(u, v̂, π) ≈ -u
    end
end
