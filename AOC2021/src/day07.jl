module Day07

using Statistics

import ..data_dir # from parent module
input = read(joinpath(data_dir, "day07"), String)

export part1, part2

"""
The total fuel required to align all crab submarines to `target`
This function accepts an optional `fuel_cost_function` which calculates the fuel
required to move a crab submarine from one location to another. This function 
should act on non-negative integer values (ie. absolute difference). The default
is the `identity` function, in which the distance between the two locations is
also the fuel cost.
"""
function fuel_to_align(
    positions::Vector{Int64},
    target::Integer,
    fuel_cost_function::Function = identity
)
    absolute_movements = abs.(positions .- target)
    fuel_costs = fuel_cost_function.(absolute_movements)
    sum(fuel_costs)
end

"""
I'm calling this `brute_force` since it inelegantly searches the entire solution
space for a minimum cost. If this function isn't good enough for part 2 I can
look for leaner search strategies (starting from median position maybe?).

Starting with the assumption that the optimal position must be somewhere between
the minimum and maximum positions, we can check each possible position between 
the two to determine the minimum fuel consumption.
"""
function brute_force(positions::Vector{Int64}, fuel_cost_function::Function = identity)
    minimum_fuel = Inf
    for position = minimum(positions):maximum(positions)
        required_fuel = fuel_to_align(positions, position, fuel_cost_function)
        minimum_fuel = min(required_fuel, minimum_fuel)
    end
    Integer(minimum_fuel)
end

function part1(input = input)
    positions = [parse(Int64, position) for position in split(input, ",")]
    brute_force(positions)
end

"""
I think this is an appropriate name? We're summing an arithmetic sequence.
"""
arithmetic_fuel_cost(movement::Int64) = sum(1:movement)

function part2(input = input)
    positions = [parse(Int64, position) for position in split(input, ",")]
    brute_force(positions, arithmetic_fuel_cost)
end

end # module
