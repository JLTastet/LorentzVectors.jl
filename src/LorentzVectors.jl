__precompile__()

module LorentzVectors

import Base: +, -, *, /, dot, norm, rand

export LorentzVector, SpatialVector, Vec4, Vec3
export +, -, *, /, dot, norm, rand
export boost

"""
    LorentzVector(t, x, y, z)

Lorentz 4-vector, as used in Special Relativity.

The metric convention is g = diag(+1,-1,-1,-1). No distinction is made between
co- and contravariant vectors.
"""
struct LorentzVector{T <: AbstractFloat}
    t :: T
    x :: T
    y :: T
    z :: T
end

"""
    SpatialVector(x, y, z)

Spatial part of a Lorentz 4-vector.
"""
struct SpatialVector{T <: AbstractFloat}
    x :: T
    y :: T
    z :: T
end

"""
    LorentzVector(t, x, y, z)

Promoting constructors for LorentzVector{T}.
"""
LorentzVector(t, x, y, z) = LorentzVector(promote(t, x, y, z)...)
LorentzVector(t::Integer, x::Integer, y::Integer, z::Integer) =
    LorentzVector(float(t), x, y, z)

"""
    SpatialVector(x, y, z)

Promoting constructors for SpatialVector{T}.
"""
SpatialVector(x, y, z) = SpatialVector(promote(x, y, z)...)
SpatialVector(x::Integer, y::Integer, z::Integer) =
    SpatialVector(float(x), y, z)

"""
    SpatialVector(u)

Construct a 3-vector from the spatial part of a 4-vector.
"""
SpatialVector(u::LorentzVector) = SpatialVector(u.x, u.y, u.z)

"""
    LorentzVector(t, u)

Construct a 4-vector from a time component and a 3-vector.
"""
LorentzVector(t::T, u::SpatialVector{U}) where {T,U} =
    LorentzVector(t, u.x, u.y, u.z)

"Alias of LorentzVector"
const Vec4 = LorentzVector

"Alias of SpatialVector"
const Vec3 = SpatialVector

function +(u::LorentzVector)
    u
end

function +(u::LorentzVector, v::LorentzVector)
    @fastmath LorentzVector(u.t + v.t, u.x + v.x, u.y + v.y, u.z + v.z)
end

function -(u::LorentzVector)
    @fastmath LorentzVector(-u.t, -u.x, -u.y, -u.z)
end

function -(u::LorentzVector, v::LorentzVector)
    @fastmath u + (-v)
end

function *(λ::Number, u::LorentzVector)
    @fastmath LorentzVector(λ*u.t, λ*u.x, λ*u.y, λ*u.z)
end

function *(u::LorentzVector, λ::Number)
    @fastmath λ * u
end

function /(u::LorentzVector, λ::Number)
    @fastmath u * (one(λ) / λ)
end

function +(u::SpatialVector)
    u
end

function +(u::SpatialVector, v::SpatialVector)
    @fastmath SpatialVector(u.x + v.x, u.y + v.y, u.z + v.z)
end

function -(u::SpatialVector)
    @fastmath SpatialVector(-u.x, -u.y, -u.z)
end

function -(u::SpatialVector, v::SpatialVector)
    @fastmath u + (-v)
end

function *(λ::Number, u::SpatialVector)
    @fastmath SpatialVector(λ*u.x, λ*u.y, λ*u.z)
end

function *(u::SpatialVector, λ::Number)
    @fastmath λ * u
end

function /(u::SpatialVector, λ::Number)
    @fastmath u * (one(λ) / λ)
end

"""
    dot(u, v)
    u⋅v

Inner product of 4-vectors, in the Minkowsky metric (+,-,-,-).
"""
function dot(u::LorentzVector, v::LorentzVector)
    @fastmath u.t*v.t - u.x*v.x - u.y*v.y - u.z*v.z
end

function dot(u::SpatialVector, v::SpatialVector)
    @fastmath u.x*v.x + u.y*v.y + u.z*v.z
end

"""
    norm(x)
"""
function norm(v::SpatialVector)
    @fastmath sqrt(v⋅v)
end

"""
    rand(rng, SpatialVector)
"""
function rand(r::MersenneTwister, ::Type{V}) where {U <: Real, V <: SpatialVector{U}}
    cθ = 2.*rand(r, U) - 1.
    sθ = sqrt(1.-cθ^2)
    φ = 2π * rand(r, U)
    SpatialVector{U}(sθ * cos(φ), sθ * sin(φ), cθ)
end

function boost(u::LorentzVector, β::LorentzVector)
    boost(u, SpatialVector(β))
end

function boost(u::LorentzVector, β::SpatialVector)
    const γ = one(β.x) / sqrt(one(β.x) - β⋅β)
    if γ == one(γ)
        return u
    end
    const x_old = Vec3(u)
    const t_new = γ * (u.t - β⋅x_old)
    const x_new = x_old + ((γ-one(γ)) * (x_old⋅β) / (β⋅β) - γ*u.t) * β
    LorentzVector(t_new, x_new.x, x_new.y, x_new.z)
end

function microbenchmark(N::Integer)
    u = LorentzVector(1., 0., 0., 1.)
    β = SpatialVector(0.01, 0., 0.)
    s = +1
    for i = 1:N
        s *= -1
        u = boost(u, s * β)
    end
    u
end

end # module LorentzVectors
