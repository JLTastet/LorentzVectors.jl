# LorentzVectors.jl

[![Build Status](https://travis-ci.org/JLTastet/LorentzVectors.jl.svg?branch=master)](https://travis-ci.org/JLTastet/LorentzVectors.jl)
[![codecov.io](http://codecov.io/github/JLTastet/LorentzVectors.jl/coverage.svg?branch=master)](http://codecov.io/github/JLTastet/LorentzVectors.jl?branch=master)
[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)

This package defines the `LorentzVector{T}` and `SpatialVector{T}` types for use in computations involving Special Relativity. These types are statically allocated and should therefore be very fast.

The usual algebraic operations are implemented, as well as some domain-specific functions (such as `boost`) and many convenience methods.

The signature of the Minkowski metric (used for the inner product) is `+,-,-,-`.

:arrow_down: Installing
---

This package is now registered. To install it, just issue the following command from the Julia REPL:

```
(v1.0) pkg> add LorentzVectors
```

:information_source: Usage
---

```julia
using LorentzVectors

p1 = Vec4(10, 0, 0, 10)
p2 = Vec4(7, 0, 1, 5)

m1 = √(p1⋅p1)
@assert m1 == 0 # p1 is lightlike, so its mass must be zero
m2 = √(p2⋅p2)
@assert m2 > 0

β1 = Vec3(p1/p1.t)
@assert norm(β1) ≈ 1 # Check that p1 travels at the speed of light

p2_rest = boost(p2, p2/p2.t) # Boost p2 to its rest frame
@assert p2_rest.t ≈ m2 # Check that its energy at rest is equal to its mass

@assert boost(p2, zero(Vec3)) ≈ p2 # Identity boost

p_tot = p1 + p2
β_cm = p_tot/p_tot.t # Compute the velocity of the center of mass (CM)
p1_cm = boost(p1, β_cm) # Boost p1 and p2 to the CM frame
p2_cm = boost(p2, β_cm)
@assert norm(Vec3(p1_cm + p2_cm)) < 1e-12 # Check that the spatial parts cancel in the CM

u1 = rand(Vec3{Float64}) # Generate a random 3-vector on the unit sphere
@assert norm(u1) ≈ 1
u2 = normalize(Vec3(p2)) # Extract the spatial direction of p2
@assert norm(u2) ≈ 1

@assert Vec4 === LorentzVector # Long forms
@assert Vec3 === SpatialVector

x = Vec3(1f0, 0, 0) # Float64 is used by default, but it can be overriden
@assert typeof(x) == Vec3{Float32}
```

For more examples, have a look in the `test` directory.

:heart: Contributing
---

All contributions and suggestions are welcome ! Just open an issue or directly send a PR.
