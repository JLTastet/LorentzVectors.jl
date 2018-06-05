@testset "Promoting constructors" begin
    @testset "LorentzVector" begin
        @test Vec4(0, 1, 2, 3) == Vec4(0., 1., 2., 3.)
        @test typeof(Vec4(0, 1, 2, 3)) == LorentzVector{Float64}
        @test Vec4(0., 1, 2, 3) == Vec4(0., 1., 2., 3.)
        @test typeof(Vec4(0., 1, 2, 3)) == LorentzVector{Float64}
        @test typeof(Vec4(0f0, 1, 2, 3)) == LorentzVector{Float32}
        @test typeof(Vec4(0, 1f0, 2, 3)) == LorentzVector{Float32}
        @test typeof(Vec4(0, 1, 2f0, 3)) == LorentzVector{Float32}
        @test typeof(Vec4(0, 1, 2, 3f0)) == LorentzVector{Float32}
        @test typeof(Vec4(0f0, 1., 2f0, 3f0)) == LorentzVector{Float64}
    end;

    @testset "SpatialVector" begin
        @test Vec3(0, 1, 2) == Vec3(0., 1., 2.)
        @test typeof(Vec3(0, 1, 2)) == SpatialVector{Float64}
        @test Vec3(0., 1, 2) == Vec3(0., 1., 2.)
        @test typeof(Vec3(0., 1, 2)) == SpatialVector{Float64}
        @test typeof(Vec3(0f0, 1, 2)) == SpatialVector{Float32}
        @test typeof(Vec3(0, 1f0, 2)) == SpatialVector{Float32}
        @test typeof(Vec3(0, 1, 2f0)) == SpatialVector{Float32}
        @test typeof(Vec3(0f0, 1., 2f0)) == SpatialVector{Float64}
    end;

    @testset "Misc. constructors" begin
        x = Vec3(1, 2, 3)
        @test Vec4(0.5, x) == Vec4(0.5, 1., 2., 3.)
        u = Vec4(0, 1, 2, 3)
        @test Vec3(u) == Vec3(1., 2., 3.)
    end;
end;
