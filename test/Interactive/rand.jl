using PyPlot

function test_rand()
    random_vectors = rand(SpatialVector{Float64}, 1000)
    scatter3D(
        map(v -> v.x, random_vectors),
        map(v -> v.y, random_vectors),
        map(v -> v.z, random_vectors)
    )
end
