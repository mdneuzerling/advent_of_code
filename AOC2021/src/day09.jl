module Day09

import ..data_dir # from parent module
input = read(joinpath(data_dir, "day09"), String)

export part1, part2

"""
Horrendous logic for converting this string of integers to a matrix.
There must be a better way, but I can't find it.
"""
function string_block_to_matrix(string_block::AbstractString)
    as_arrays = split.(split(string_block, "\n"), "")
    as_int_arrays = [parse.(Int64, array) for array in as_arrays]
    # Transposing changes the type!
    Matrix(transpose(hcat(as_int_arrays...)))
end

function out_of_bounds(heatmap::Matrix{Int64}, row::Int64, column::Int64)
    heatmap_height, heatmap_width = size(heatmap)
    row < 1 || row > heatmap_height || column < 1 || column > heatmap_width
end

function identify_neighbours(heatmap::Matrix{Int64}, row::Int64, column::Int64)
    candidates = [
        (row - 1, column), (row + 1, column),
        (row, column - 1), (row, column + 1)
    ]
    filter(candidate -> !out_of_bounds(heatmap, candidate...), candidates)
end

function risk_level(heatmap::Matrix{Int64}, row::Int64, column::Int64)
    value = heatmap[row, column] # matrices are indexed row then column
    if value == 9
        return (false)
    end
    neighbours = identify_neighbours(heatmap, row, column)
    is_minimum = all(value < heatmap[neighbour...] for neighbour in neighbours)
    is_minimum * (1 + value) # non-minima don't get a risk value
end

function add_to_basin(
    heatmap::Matrix{Int64},
    unclaimed::Vector{Tuple{Int64,Int64}},
    row::Int64,
    column::Int64
)
    # can't pop by value, so I need to get the index
    index_in_unclaimed = findfirst(x -> x == (row, column), unclaimed)
    if isnothing(index_in_unclaimed) # already claimed by another path
        return Set{Tuple{Int64,Int64}}()
    end
    in_basin = Set([popat!(unclaimed, index_in_unclaimed)])
    neighbours = [neighbour for neighbour in identify_neighbours(heatmap, row, column)
                  if neighbour in unclaimed]
    if length(neighbours) == 0
        return (in_basin)
    end
    for neighbour in neighbours
        in_basin = in_basin ∪ add_to_basin(heatmap, unclaimed, neighbour...)
    end
    in_basin
end

function part1(input = input)
    heatmap = string_block_to_matrix(input)
    n_rows, n_cols = size(heatmap)
    total_risk_level = 0
    for row = 1:n_rows, column = 1:n_cols
        total_risk_level += risk_level(heatmap, row, column)
    end
    total_risk_level
end

"""
I think the key component here is every element (except 9) is in exactly one basin
"""
function part2(input = input)
    heatmap = string_block_to_matrix(input)
    n_rows, n_cols = size(heatmap)
    unclaimed = [(row, column) for row in 1:n_rows, column in 1:n_cols if heatmap[row, column] != 9]
    basins = Vector{Set{Tuple{Int64,Int64}}}()
    while length(unclaimed) > 0
        push!(basins, add_to_basin(heatmap, unclaimed, unclaimed[1]...))
    end
    basin_sizes = map(x -> length(x), basins)
    last(sort(basin_sizes), 3) |> prod
end

end #module
