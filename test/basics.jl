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
        @test Vec4(0//1, 1, 2, 3) == Vec4(0., 1., 2., 3.)
        @test Vec4(π, π, π, π) ≈ Vec4(float(π), float(π), float(π), float(π))
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
        @test Vec3(0//1, 1, 2) == Vec3(0., 1., 2.)
        @test Vec3(π, π, π) ≈ Vec3(float(π), float(π), float(π))
    end;

    @testset "Misc. constructors" begin
        x = Vec3(1, 2, 3)
        @test Vec4(0.5, x) == Vec4(0.5, 1., 2., 3.)
        u = Vec4(0, 1, 2, 3)
        @test Vec3(u) == Vec3(1., 2., 3.)
    end;

    @testset "Zero constructor" begin
        x = zero(Vec3)
        @test x === Vec3(0.0, 0.0, 0.0)
        x64 = zero(Vec3{Float64})
        @test x === x64
        x32 = zero(Vec3{Float32})
        @test x32 === Vec3{Float32}(0f0, 0f0, 0f0)
        y = zero(Vec4)
        @test y === Vec4(0.0, 0.0, 0.0, 0.0)
        y64 = zero(Vec4{Float64})
        @test y === y64
        y32 = zero(Vec4{Float32})
        @test y32 === Vec4(0f0, 0f0, 0f0, 0f0)
        @test zeros(Vec3, 2) == [x, x]
        @test zeros(Vec4, 2) == [y, y]
    end
end;
