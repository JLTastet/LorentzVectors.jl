using Compat
using Compat.Test
using Compat.LinearAlgebra
using Compat.Random

using LorentzVectors

srand(8372946187652352328)

@testset "All tests" begin
    include("basics.jl")
    include("algebra.jl")
    include("random.jl")
end;
