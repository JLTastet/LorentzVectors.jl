@testset "Algebra" begin
    @testset "LorentzVector" begin
        zero = Vec4(0., 0., 0., 0.)
        u1 = Vec4(1., 2., 3., 4.)
        u2 = Vec4(-1., 3., 3., 7.)
        @test -zero == zero
        @test +u1 == u1
        @test +u2 == u2
        @test -(-u1) == u1
        @test -(-u2) == u2
        @test zero + u1 == u1
        @test u1 - u1 == zero
        @test u1 + u1 ≈ 2 * u1
        @test u1 + u1 + u1 ≈ 3 * u1
        @test u1 + u2 ≈ Vec4(0., 5., 6., 11.)
        @test u1 - u2 ≈ Vec4(2., -1., 0., -3.)
        @test 3.5 * u1 ≈ u1 * 3.5
        @test -1.2 * u2 ≈ u2 * (-1.2)
        @test u1 / 2 ≈ Vec4(0.5, 1., 1.5, 2.)
        @test (u1 / 11.) * 11. ≈ u1

        @test zero ⋅ u1 == u1 ⋅ zero == 0.
        @test zero ⋅ u2 == u2 ⋅ zero == 0.
        @test u1 ⋅ u1 ≈ -28.
        @test u2 ⋅ u2 ≈ -66.
        @test u1 ⋅ u2 ≈ -44.

        @test Vec4(1, 0, 0, 1/3) - Vec4(1, 0, 0, 1/5) - Vec4(1, 0, 0, 2/15) ≈ Vec4(-1., 0, 0, 0)
        @test Vec4(1/3, 0, 0, 1) - Vec4(1/5, 0, 0, 1) - Vec4(2/15, 0, 0, 1) ≈ Vec4(0, 0, 0, -1.)
    end;

    @testset "SpatialVector" begin
        zero = Vec3(0., 0., 0.)
        u1 = Vec3(1., 2., 4.)
        u2 = Vec3(-1., 3., 7.)
        @test -zero == zero
        @test +u1 == u1
        @test +u2 == u2
        @test -(-u1) == u1
        @test -(-u2) == u2
        @test zero + u1 == u1
        @test u1 - u1 == zero
        @test u1 + u1 ≈ 2 * u1
        @test u1 + u1 + u1 ≈ 3 * u1
        @test u1 + u2 ≈ Vec3(0., 5., 11.)
        @test u1 - u2 ≈ Vec3(2., -1., -3.)
        @test 3.5 * u1 ≈ u1 * 3.5
        @test -1.2 * u2 ≈ u2 * (-1.2)
        @test u1 / 2 ≈ Vec3(0.5, 1., 2.)
        @test (u1 / 11.) * 11. ≈ u1

        @test zero ⋅ u1 == u1 ⋅ zero == 0.
        @test zero ⋅ u2 == u2 ⋅ zero == 0.
        @test u1 ⋅ u1 ≈ 21.
        @test u2 ⋅ u2 ≈ 59.
        @test u1 ⋅ u2 ≈ 33.

        @test Vec3(0, 1, 0) × Vec3(0, 0, 1) == Vec3(1, 0, 0)
        @test Vec3(0, 0, 1) × Vec3(1, 0, 0) == Vec3(0, 1, 0)
        @test Vec3(1, 0, 0) × Vec3(0, 1, 0) == Vec3(0, 0, 1)
        @test u1 × u1 == zero
        @test u2 × u2 == zero
        @test (u1 × u2) ⋅ u1 == 0
        @test (u1 × u2) ⋅ u2 == 0
        @test u1 × u2 == Vec3(2., -11., 5.)

        @test norm(zero) == 0.
        @test norm(u1) ≈ 4.58257569495584
        @test norm(u2) ≈ 7.681145747868608
        @test norm(Vec3(1, 1, 0)) ≈ √2
        @test norm(Vec3(1, 1, 1)) ≈ √3
        @test norm(Vec3(2, 1, 2)) ≈ 3

        @test normalize(Vec3(1, 1, 0)) ≈ Vec3(1/√2, 1/√2, 0)
        @test normalize(Vec3(1, 1, 1)) ≈ Vec3(1/√3, 1/√3, 1/√3)
        @test normalize(Vec3(2, 2, 1)) ≈ Vec3(2/3, 2/3, 1/3)
    end;
end;
