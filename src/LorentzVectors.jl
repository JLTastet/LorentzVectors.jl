__precompile__()

module LorentzVectors

import Base: +, -, *, dot

export LorentzVector, SpatialVector, Vec4, Vec3
export +, -, *, dot
export boost

"""
    LorentzVector(t, x, y, z)

Contravariant Lorentz 4-vector, as used in Special Relativity.

The metric convention is g = diag(+1,-1,-1,-1).
"""
struct LorentzVector{T}
    t :: T
    x :: T
    y :: T
    z :: T
end

"""
    SpatialVector(x, y, z)

Spatial part of a Lorentz 4-vector.
"""
struct SpatialVector{T}
    x :: T
    y :: T
    z :: T
end

"""
    SpatialVector(u)

Construct a 3-vector from the spatial part of a 4-vector.
"""
SpatialVector(u::LorentzVector) = SpatialVector(u.x, u.y, u.z)

"Alias of LorentzVector"
const Vec4 = LorentzVector

"Alias of SpatialVector"
const Vec3 = SpatialVector

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

function boost(u::LorentzVector, β::LorentzVector)
    β3 = Vec3(β)
    γ = 1 / sqrt(1 - β3⋅β3)
    x3 = Vec3(u)
    t = γ * (u.t - β3⋅x3)
    x = x3 + ((γ-1) * (x3⋅β3) / (β3⋅β3) - γ*u.t) * β3
    Vec4(t, x.x, x.y, x.z)
end

function boost(u::LorentzVector, β::SpatialVector)
    boost(u, LorentzVector(one(typeof(β.x)), β.x, β.y, β.z))
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

end # module Lorentz
