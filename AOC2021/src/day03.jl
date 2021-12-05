module Day03

using Chain
using Statistics

import ..data_dir # from parent module

export part1, part2

const data_file = joinpath(data_dir, "day03")
const input = readlines(data_file) # read into an array, each line is an element

# Shared code between parts 1 and 2

function binary_string_to_bool_array(binary_string::String)
    bits = split(binary_string, "")
    map(x -> parse(Bool, x), bits)
end

bitstring_to_int(x::String) = parse(Int, "0b" * x)

# Part 1

function part1()
    gamma_bitstring = @chain input begin
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

function gas_rate(input::Vector{String}, rounding_function::Function)
    input_arrays = map(x -> binary_string_to_bool_array(x), input)

    gas_matrix = transpose(hcat(input_arrays...))
    column = 1
    while size(gas_matrix)[1] > 1
        average_value = mean(gas_matrix[:, column])
        target_bit = rounding_function(average_value)
        row_indices_to_keep = filter(i -> gas_matrix[i, column] == target_bit, 1:size(gas_matrix)[1])
        gas_matrix = gas_matrix[row_indices_to_keep, :]
        column += 1
    end

    # extract first (and only) row and join to a string
    remaining_row = map(b -> Int(b), gas_matrix[1, :])
    gas_bitstring = join(remaining_row, "")
    bitstring_to_int(gas_bitstring)
end

function part2()
    oxygen = gas_rate(
        input,
        x -> round(Int, x, RoundNearestTiesUp)
    )

    co2 = gas_rate(
        input,
        x -> round(Int, (1 - x), RoundNearest) # will round down
    )

    oxygen * co2
end

end # module