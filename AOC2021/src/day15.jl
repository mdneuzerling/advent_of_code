module Day15

using DataStructures

import ..data_dir # from parent module
input = read(joinpath(data_dir, "day15"), String)

export part1, part2

function string_block_to_matrix(string_block::AbstractString)
    as_arrays = split.(split(string_block, "\n"), "")
    as_int_arrays = [parse.(Int64, array) for array in as_arrays]
    # Transposing changes the type!
    Matrix(transpose(hcat(as_int_arrays...)))
end

function out_of_bounds(heatmap::Matrix{Int64}, position::Tuple{Int64,Int64})
    row, column = position
    heatmap_height, heatmap_width = size(heatmap)
    row < 1 || row > heatmap_height || column < 1 || column > heatmap_width
end

function neighbours(heatmap::Matrix{Int64}, position::Tuple{Int64,Int64})
    row, column = position
    candidates = [
        (row - 1, column), (row + 1, column),
        (row, column - 1), (row, column + 1)
    ]
    filter(candidate -> !out_of_bounds(heatmap, candidate), candidates)
end

function dijkstra(heatmap::Matrix{Int64})
    source = (1, 1) # top-left corner
    target = size(heatmap) # bottom-right corner

    risk_from_source = BinaryMinHeap{Tuple{Int64,Int64,Int64}}()
    push!(risk_from_source, (0, source...))

    counted = Vector{Tuple{Int64,Int64}}()

    while true
        println("Counted $(length(counted)) vertices")
        risk, row, column = pop!(risk_from_source)
        vertex = (row, column)
        if vertex in counted
            continue
        end
        push!(counted, vertex)

        if vertex == target
            return risk
        end

        uncounted_neighbours = filter(v -> v ∉ counted, neighbours(heatmap, vertex))

        for neighbour in uncounted_neighbours
            neighbour_risk = risk + heatmap[neighbour...]
            push!(risk_from_source, (neighbour_risk, neighbour...))
        end
    end
end

function part1(input = input)
    heatmap = string_block_to_matrix(input)
    dijkstra(heatmap)
end

function increment(heatmap::Matrix{Int64}, times::Int64 = 1)
    for i = 1:times
        heatmap = @. max(mod(heatmap + 1, 10), 1)
    end
    heatmap
end

function expand_heatmap(heatmap::Matrix{Int64}, times::Int64)
    horizontal_expansion_vector = Vector{Matrix{Int64}}()
    for i = 1:times
        push!(horizontal_expansion_vector, increment(heatmap, i - 1))
    end
    horizontal_expansion = hcat(horizontal_expansion_vector...)

    vertical_expansion_vector = Vector{Matrix{Int64}}()
    for i = 1:times
        push!(vertical_expansion_vector, increment(horizontal_expansion, i - 1))
    end
    vertical_expansion = vcat(vertical_expansion_vector...)

    vertical_expansion
end

function part2(input = input)
    heatmap = string_block_to_matrix(input)
    expanded_heatmap = expand_heatmap(heatmap, 5)
    dijkstra(expanded_heatmap)
end

end #module
