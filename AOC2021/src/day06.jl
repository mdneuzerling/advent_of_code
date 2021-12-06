module Day06

import ..data_dir # from parent module
input = read(joinpath(data_dir, "day06"), String)

export part1, part2

function count_fish_days_to_spawn(input::String)
    days_to_spawn = [parse(Int8, string(day)) for day in split(input, ",")]
    Dict(day => count(x -> x == day, days_to_spawn) for day in unique(days_to_spawn))
end

function age(fish_days_to_spawn::Dict{Int8}{Int64})
    new_counts = Dict{Int8}{Int64}()
    # resisting the urge to use modular arithmetic. 0 becomes 6, but 8 becomes 7
    for days_to_spawn = 1:8
        next_days_to_spawn = days_to_spawn - 1
        new_counts[next_days_to_spawn] = get(fish_days_to_spawn, days_to_spawn, 0)
    end
    new_counts[6] = new_counts[6] + get(fish_days_to_spawn, 0, 0)
    new_counts[8] = get(fish_days_to_spawn, 0, 0) # new babies
    new_counts
end

function age(fish_days_to_spawn::Dict{Int8}{Int64}, days::Int64)
    working_copy = copy(fish_days_to_spawn)
    for i = 1:days
        working_copy = age(working_copy)
    end
    working_copy
end

function count_after_aging(fish_days_to_spawn::Dict{Int8}{Int64}, days::Int64)
    aged = age(fish_days_to_spawn, days)
    sum(values(aged))
end

function part1(; input = input)
    fish_days_to_spawn = count_fish_days_to_spawn(input)
    count_after_aging(fish_days_to_spawn, 80)
end

function part2(; input = input)
    fish_days_to_spawn = count_fish_days_to_spawn(input)
    count_after_aging(fish_days_to_spawn, 256)
end

end # module