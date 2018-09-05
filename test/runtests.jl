using LorentzVectors
using Test
using Random

Random.seed!(8372946187652352328)

@testset "All tests" begin
    include("basics.jl")
    include("algebra.jl")
    include("random.jl")
    include("geometry.jl")
end;
