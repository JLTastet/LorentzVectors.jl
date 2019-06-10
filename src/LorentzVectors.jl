__precompile__()

module LorentzVectors

import LinearAlgebra: dot, ⋅, cross, ×, norm, normalize
import Random: rand, MersenneTwister

import Base: +, -, *, /, ==, isapprox, ≈, zero

export LorentzVector, SpatialVector, Vec4, Vec3
export +, -, *, /, ==, isapprox, ≈, dot, ⋅, cross, ×, norm, normalize, rand, zero
export boost, rotate

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
LorentzVector(t::T, x::T, y::T, z::T) where {T <: Union{Integer, Rational, Irrational}} =
    LorentzVector(float(t), x, y, z)

"""
    SpatialVector(x, y, z)

Promoting constructors for SpatialVector{T}.
"""
SpatialVector(x, y, z) = SpatialVector(promote(x, y, z)...)
SpatialVector(x::T, y::T, z::T) where {T <: Union{Integer, Rational, Irrational}} =
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

"""
    zero(LorentzVector{T})
    zero(LorentzVector)

Constructs a zero four-vector.
"""
zero(::Type{LorentzVector{T}}) where {T} = LorentzVector{T}(zero(T), zero(T), zero(T), zero(T))
zero(::Type{LorentzVector}) = zero(LorentzVector{Float64})

"""
    zero(SpatialVector{T})
    zero(SpatialVector)

Constructs a zero three-vector.
"""
zero(::Type{SpatialVector{T}}) where {T} = SpatialVector{T}(zero(T), zero(T), zero(T))
zero(::Type{SpatialVector}) = zero(SpatialVector{Float64})

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

function ==(u::LorentzVector, v::LorentzVector)
    u.t == v.t && u.x == v.x && u.y == v.y && u.z == v.z
end

function ==(u::SpatialVector, v::SpatialVector)
    u.x == v.x && u.y == v.y && u.z == v.z
end

function isapprox(u::LorentzVector, v::LorentzVector;
                  atol::Real=0,
                  rtol::Real=atol>0 ? 0 : √min(eps(typeof(u.x)), eps(typeof(v.x))))
    err = max(abs(u.t - v.t), norm(Vec3(u)-Vec3(v)))
    err <= max(atol, rtol*max(abs(u.t), abs(v.t), norm(Vec3(u)), norm(Vec3(v))))
end

function isapprox(u::SpatialVector, v::SpatialVector;
                  atol::Real=0,
                  rtol::Real=atol>0 ? 0 : √min(eps(typeof(u.x)), eps(typeof(v.x))))
    err = norm(u-v)
    err <= max(atol, rtol*max(norm(u), norm(v)))
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
    cross(u, v)
    u×v

Cross product of two spatial vectors.
"""
function cross(u::SpatialVector, v::SpatialVector)
    @fastmath SpatialVector(
        u.y*v.z - u.z*v.y,
        u.z*v.x - u.x*v.z,
        u.x*v.y - u.y*v.x)
end

"""
    norm(x)
"""
function norm(v::SpatialVector)
    @fastmath sqrt(v⋅v)
end

"""
    normalize(x)
"""
function normalize(v::SpatialVector)
    v / norm(v)
end

"""
    rand(rng, SpatialVector)
"""
function rand(r::MersenneTwister, ::Type{V}) where {U <: Real, V <: SpatialVector{U}}
    cθ = 2*rand(r, U) - 1
    sθ = sqrt(1-cθ^2)
    φ = 2π * rand(r, U)
    SpatialVector{U}(sθ * cos(φ), sθ * sin(φ), cθ)
end

function boost(u::LorentzVector, β::LorentzVector)
    boost(u, SpatialVector(β))
end

function boost(u::LorentzVector, β::SpatialVector)
    γ = one(β.x) / sqrt(one(β.x) - β⋅β)
    if γ == one(γ)
        return u
    end
    x_old = Vec3(u)
    t_new = γ * (u.t - β⋅x_old)
    x_new = x_old + ((γ-one(γ)) * (x_old⋅β) / (β⋅β) - γ*u.t) * β
    LorentzVector(t_new, x_new.x, x_new.y, x_new.z)
end

"""
Rotate a vector v by an angle θ around the unit vector k̂, using Rodrigues' rotation formula.

Note: k̂ *must* be normalized, otherwise this method will return the wrong result.

Source: https://en.wikipedia.org/wiki/Rodrigues%27_rotation_formula
"""
function rotate(v::SpatialVector, k̂::SpatialVector, θ::Real)
    v*cos(θ) + (k̂×v)*sin(θ) + k̂*(k̂⋅v)*(1-cos(θ))
end

end # module LorentzVectors
