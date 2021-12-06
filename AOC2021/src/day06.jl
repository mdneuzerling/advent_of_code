module Day06

import ..data_dir # from parent module
input = read(joinpath(data_dir, "day06"), String)

export part1, part2

"""
Converts a string like "0,1,1,1,2,2" into a vector
[1
 3
 2]
Note the change in 0-based indexing to 1-based indexing.
"""
function collect_days_to_spawn(input::String)
    days_to_spawn = [parse(Int8, string(day)) for day in split(input, ",")]
    # the below line converts the 0-based indexing of the input to 1-based indexing
    [count(x -> x == (day - 1), days_to_spawn) for day = 1:size(age_matrix)[1]]
end

const age_matrix = [
    0 1 0 0 0 0 0 0 0
    0 0 1 0 0 0 0 0 0
    0 0 0 1 0 0 0 0 0
    0 0 0 0 1 0 0 0 0
    0 0 0 0 0 1 0 0 0
    0 0 0 0 0 0 1 0 0
    1 0 0 0 0 0 0 1 0
    0 0 0 0 0 0 0 0 1
    1 0 0 0 0 0 0 0 0]

function age(days_to_spawn::Vector{Int64}, days::Int64 = 1)
    age_matrix^days * days_to_spawn
end

function count_after_aging(days_to_spawn::Vector{Int64}, days::Int64)
    aged = age(days_to_spawn, days)
    sum(values(aged))
end

function part1(; input = input)
    days_to_spawn = collect_days_to_spawn(input)
    count_after_aging(days_to_spawn, 80)
end

function part2(; input = input)
    days_to_spawn = collect_days_to_spawn(input)
    count_after_aging(days_to_spawn, 256)
end

end # module