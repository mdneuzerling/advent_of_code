module Day11

import ..data_dir # from parent module
input = read(joinpath(data_dir, "day11"), String)

export part1, part2

const matrix_size = 10

function string_block_to_matrix(string_block::AbstractString)
    as_arrays = split.(split(string_block, "\n"), "")
    as_int_arrays = [parse.(Int64, array) for array in as_arrays]
    # Transposing changes the type!
    Matrix(transpose(hcat(as_int_arrays...)))
end

function out_of_bounds(row::Int64, column::Int64)
    row < 1 || row > matrix_size || column < 1 || column > matrix_size
end

function neighbours(coordinates::CartesianIndex{2})
    row, column = coordinates.I
    candidates = [
        (row - 1, column), (row + 1, column),
        (row, column - 1), (row, column + 1),
        (row - 1, column - 1), (row - 1, column + 1),
        (row + 1, column - 1), (row + 1, column + 1),
    ]
    in_bounds = filter(candidate -> !out_of_bounds(candidate...), candidates)
    [CartesianIndex(p...) for p in in_bounds]
end

function neighbours_matrix(coordinate::CartesianIndex{2})
    as_matrix = zeros(Int64, matrix_size, matrix_size)
    for neighbour in neighbours(coordinate)
        as_matrix[neighbour] = 1
    end
    as_matrix
end

function neighbours_matrix(coordinates::Vector{CartesianIndex{2}})
    sum(neighbours_matrix.(coordinates))
end

increment(octopuses::Matrix{Int64}) = octopuses + ones(Int64, size(octopuses)...)
rollover(x::Int64) = mod(min(x, 10), 10)
rollover(octopuses::Matrix{Int64}) = rollover.(octopuses)

function flash(
    octopuses::Matrix{Int64},
    flashed::Vector{CartesianIndex{2}} = Vector{CartesianIndex{2}}()
)
    above_9 = findall(x -> x > 9, octopuses)
    new_flashes = above_9[(!in).(above_9, Ref(flashed))]
    if length(new_flashes) == 0
        return rollover(octopuses), flashed
    end
    octopuses += neighbours_matrix(new_flashes)
    octopuses, flashed = flash(octopuses, [flashed; new_flashes])
end

step(octopuses::Matrix{Int64}) = octopuses |> increment |> flash

function part1(input = input)
    octopuses = string_block_to_matrix(input)
    n_flashes = 0
    for i = 1:100
        octopuses, flashed = step(octopuses)
        n_flashes += length(flashed)
    end
    n_flashes
end

function part2(input = input)
    octopuses = string_block_to_matrix(input)
    n_flashes = 0
    i = 1
    while true
        octopuses, flashed = step(octopuses)
        if length(flashed) == matrix_size^2
            return (i)
        end
        i += 1
    end
end

end #module
