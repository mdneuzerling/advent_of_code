module Day08


import Base.\

import ..data_dir # from parent module
input = readlines(joinpath(data_dir, "day08"))

export part1, part2

"""

  0:      1:      2:      3:      4:
 aaaa    ....    aaaa    aaaa    ....
b    c  .    c  .    c  .    c  b    c
b    c  .    c  .    c  .    c  b    c
 ....    ....    dddd    dddd    dddd
e    f  .    f  e    .  .    f  .    f
e    f  .    f  e    .  .    f  .    f
 gggg    ....    gggg    gggg    ....

  5:      6:      7:      8:      9:
 aaaa    aaaa    aaaa    aaaa    aaaa
b    .  b    .  .    c  b    c  b    c
b    .  b    .  .    c  b    c  b    c
 dddd    dddd    ....    dddd    dddd
.    f  e    f  .    f  e    f  .    f
.    f  e    f  .    f  e    f  .    f
 gggg    gggg    ....    gggg    gggg

"""

const patterns_to_digit = Dict(
    Set(["a", "b", "c", "e", "f", "g"]) => 0,
    Set(["c", "f"]) => 1,
    Set(["a", "c", "d", "e", "g"]) => 2,
    Set(["a", "c", "d", "f", "g"]) => 3,
    Set(["b", "c", "d", "f"]) => 4,
    Set(["a", "b", "d", "f", "g"]) => 5,
    Set(["a", "b", "d", "e", "f", "g"]) => 6,
    Set(["a", "c", "f"]) => 7,
    Set(["a", "b", "c", "d", "e", "f", "g"]) => 8,
    Set(["a", "b", "c", "d", "f", "g"]) => 9
)

function split_display(display::AbstractString)
    raw_patterns, raw_output = split(display, " | ")
    patterns = [Set(string.(split(p, ""))) for p in split(raw_patterns, " ")]
    outputs = [Set(string.(split(p, ""))) for p in split(raw_output, " ")]
    patterns, outputs
end

function patterns_of_length(patterns::Vector{Set{String}}, l::Int64)
    filter(x -> length(x) == l, patterns)
end

function fix_pattern(symbol::Set{String}, configuration::Dict{String,String})
    Set([configuration[x] for x in symbol])
end

function fix_and_digitise_output(output::Set{String}, configuration::Dict{String,String})
    fixed_output = fix_pattern(output, configuration)
    patterns_to_digit[fixed_output]
end

function glue_digits(digits::Vector{Int64})
    n_digits = length(digits)
    sum([digits[i] * 10^(n_digits - i) for i = 1:n_digits])
end

\(A::Set, B::Set) = setdiff(A, B)

function identify_configuration(patterns::Vector{Set{String}})
    configuration = Dict{String}{String}()

    # these are uniquely identifiable from the number of segments 
    one = first(patterns_of_length(patterns, 2))
    seven = first(patterns_of_length(patterns, 3))
    four = first(patterns_of_length(patterns, 4))

    # Whatever the difference between one and seven is the "a" segment
    configuration[pop!(seven \ one)] = "a"

    # There are three 6-segment elements
    # six is the only 6-segment digit that overlaps with one exactly once 
    # The remaining are zero and nine. Four is a subset of nine but not zero.
    patterns_of_length_6 = patterns_of_length(patterns, 6)
    six = filter(s -> length(s ∩ one) == 1, patterns_of_length_6) |> first
    nine = filter(s -> s != six && four ⊆ s, patterns_of_length_6) |> first
    zero = filter(s -> s != six && s != nine, patterns_of_length_6) |> first

    # The difference of four and zero also gives us the middle segment, "d"
    configuration[first(four \ zero)] = "d"

    # The overlap between one and six is the "f" segment
    configuration[first(one ∩ six)] = "f"

    # And now we know the remaining part of the one is the "c" segment
    configuration[first(one \ six)] = "c"

    # The only remaining segment of four to be identified is "b"
    middle_segment = first(filter(s -> s ∉ keys(configuration), four))
    configuration[middle_segment] = "b"

    # The only 7-segment digit is eight
    eight = first(patterns_of_length(patterns, 7))
    # and the difference with nine gives the "e" segment
    configuration[first(eight \ nine)] = "e"

    # Leaving exactly one symbol unsolved
    missing_segment = first(eight \ Set(keys(configuration)))
    missing_segment_maps_to = first(eight \ Set(values(configuration)))
    configuration[missing_segment] = missing_segment_maps_to

    configuration
end

function identify_digits_in_output(display::AbstractString)
    patterns, outputs = split_display(display)
    configuration = identify_configuration(patterns)
    [fix_and_digitise_output(output, configuration) for output in outputs]
end

function part1(input = input)
    digits_in_outputs = identify_digits_in_output.(input)
    target_digits = [1, 4, 7, 8]
    counts = [length(filter(x -> x ∈ target_digits, digits)) for digits in digits_in_outputs]
    sum(counts)
end

function part2(input = input)
    digits_in_outputs = identify_digits_in_output.(input)
    as_numbers = glue_digits.(digits_in_outputs)
    sum(as_numbers)
end

end #module
