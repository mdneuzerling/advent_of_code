module Day03

using Chain
using Statistics

import ..DATA_DIR # from parent module

export part1, part2

const DATA_FILE = joinpath(DATA_DIR, "day03")
const INPUT = readlines(DATA_FILE) # read into an array, each line is an element

# Shared code between parts 1 and 2

function binary_string_to_bool_array(binary_string::String)
    bits = split(binary_string, "")
    map(x -> parse(Bool, x), bits)
end

bitstring_to_int(x::String) = parse(Int, "0b" * x)

# Part 1

function part1()
    gamma_bitstring = @chain INPUT begin
        map(x -> binary_string_to_bool_array(x), _) # take input as array of arrays
        transpose(hcat(_...)) # convert to matrix and transpose to rows * columns
        mean(_, dims = 1) # take column-wise means
        map(x -> round(Int, x, RoundNearestTiesUp), _) # round and convert to integers
        join(_[1, :], "") # extract first (and only) row and join to a string
    end

    gamma = bitstring_to_int(gamma_bitstring)
    # Equivalent to flipping the least significant bits
    epsilon_bitstring = last(bitstring(~gamma), length(gamma_bitstring))
    epsilon = bitstring_to_int(epsilon_bitstring)

    gamma * epsilon
end

# Part 2

function part2()
    input_arrays = map(x -> binary_string_to_bool_array(x), INPUT)

    oxygen_matrix = transpose(hcat(input_arrays...))
    column = 1
    while size(oxygen_matrix)[1] > 1
        average_value = mean(oxygen_matrix[:, column])
        most_common_bit = round(Int, average_value, RoundNearestTiesUp)
        row_indices_to_keep = filter(i -> oxygen_matrix[i, column] == most_common_bit, 1:size(oxygen_matrix)[1])
        oxygen_matrix = oxygen_matrix[row_indices_to_keep, :]
        column += 1
    end

    # extract first (and only) row and join to a string
    oxygen_remaining_row = map(b -> Int(b), oxygen_matrix[1, :])
    oxygen_bitstring = join(oxygen_remaining_row, "")
    oxygen = bitstring_to_int(oxygen_bitstring)

    co2_matrix = transpose(hcat(input_arrays...))
    column = 1
    while size(co2_matrix)[1] > 1
        average_value = mean(co2_matrix[:, column])
        least_common_bit = round(Int, (1 - average_value), RoundNearest) # will round down
        row_indices_to_keep = filter(i -> co2_matrix[i, column] == least_common_bit, 1:size(co2_matrix)[1])
        co2_matrix = co2_matrix[row_indices_to_keep, :]
        column += 1
    end

    # extract first (and only) row and join to a string
    co2_remaining_row = map(b -> Int(b), co2_matrix[1, :])
    co2_bitstring = join(co2_remaining_row, "")
    co2 = bitstring_to_int(co2_bitstring)

    oxygen * co2
end

end # module