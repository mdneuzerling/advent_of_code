module Day02

import ..data_dir # from parent module

export part1, part2

const data_file = joinpath(data_dir, "day02")
const input = readlines(data_file) # read into an array, each line is an element

# This solution is going to be a lot longer than needed. I want to explore the
# use of structs and generic functions, and the relationship between "command"
# and "function" seemed perfect.

# I use two structs: Location1 and Location2. These are used in part 1 and
# part 2, respectively. Thanks to Julia's multiple dispatch, I don't need to
# redefine functions between the two parts.

## Shared code for part 1 and 2

valid_manoeuvres = ["forward", "up", "down"]

# Location is the abstract supertype of Location1 and Location2
abstract type Location end
aoc_answer(loc::Location) = loc.horizontal * loc.depth

"""
    manoeuvre!(loc, command)

Interpret the command and use it to manoeuvre the given location. This
function dispatches based on `loc` through the given command. A command
such as "forward 1" is interpreted as `forward!(loc, 1)`.

# Examples
```julia-repl
julia> l = Location1() # initial position (0, 0)
julia> manoeuvre(l, "forward 1")
# new position: (1, 0)
```
"""
function manoeuvre!(loc::Location, command::String)
    command_split = split(command, " ")

    manoeuvre_direction = command_split[1]
    if manoeuvre_direction ∉ valid_manoeuvres
        throw(ArgumentError(
            manoeuvre_direction *
            "is not a valid direction. Must be one of: " *
            join(valid_manoeuvres, ", ")
        ))
    end
    manoeuvre_function = getfield(@__MODULE__, Symbol(manoeuvre_direction * "!"))

    manoeuvre_amount = parse(Int64, command_split[2])

    manoeuvre_function(loc, manoeuvre_amount)
end

# Part 1

mutable struct Location1 <: Location
    horizontal::Int64
    depth::Int64
end
Location1() = Location1(0, 0)

function forward!(loc::Location1, x::Int64)
    loc.horizontal += x
end

function up!(loc::Location1, x::Int64)
    loc.depth -= x
    loc.depth = loc.depth < 0 ? 0 : loc.depth
end

function down!(loc::Location1, x::Int64)
    loc.depth += x
end

function part1(input = input)
    l1 = Location1()
    for command in input
        manoeuvre!(l1, command)
    end
    aoc_answer(l1)
end

## Part 2

mutable struct Location2 <: Location
    horizontal::Int64
    depth::Int64
    aim::Int64
end
Location2() = Location2(0, 0, 0)

function up!(loc::Location2, x::Int64)
    loc.aim -= x
end

function down!(loc::Location2, x::Int64)
    loc.aim += x
end

function forward!(loc::Location2, x::Int64)
    loc.horizontal += x
    loc.depth += loc.aim * x
    loc.depth = loc.depth < 0 ? 0 : loc.depth
end

function part2(input = input)
    l2 = Location2()
    for command in input
        manoeuvre!(l2, command)
    end
    aoc_answer(l2)
end

end # module