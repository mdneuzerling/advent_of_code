module Day08

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

function split_display(display::AbstractString)
    raw_patterns, raw_output = split(display, " | ")
    patterns = [Set(string.(split(p, ""))) for p in split(raw_patterns, " ")]
    outputs = [Set(string.(split(p, ""))) for p in split(raw_output, " ")]
    patterns, outputs
end

function patterns_of_length(patterns::Vector{Set{String}}, l::Int64)
    filter(x -> length(x) == l, patterns)
end

function identify_configuration(patterns::Vector{Set{String}})
    # these are uniquely identifiable from the number of segments 
    one = first(patterns_of_length(patterns, 2))
    four = first(patterns_of_length(patterns, 4))
    seven = first(patterns_of_length(patterns, 3))
    eight = first(patterns_of_length(patterns, 7))

    # There are three 6-segment elements: six, nine, zero
    patterns_of_length_6 = patterns_of_length(patterns, 6)
    # four is a subset of nine but not six or zero
    nine = filter(s -> four ⊆ s, patterns_of_length_6) |> first
    # six is the only 6-segment digit that is not a superset of one
    six = filter(s -> one ⊈ s, patterns_of_length_6) |> first
    # and by process of elimination
    zero = filter(s -> s ∉ [six, nine], patterns_of_length_6) |> first

    # The three remaining elements are of 5 segments
    patterns_of_length_5 = patterns_of_length(patterns, 5)
    # three overlaps with one
    three = filter(s -> one ⊆ s, patterns_of_length_5) |> first
    # five is a subset of six
    five = filter(s -> s ⊆ six, patterns_of_length_5) |> first
    # and the last is two
    two = filter(s -> s ∉ [three, five], patterns_of_length_5) |> first

    Dict(
        zero => 0,
        one => 1,
        two => 2,
        three => 3,
        four => 4,
        five => 5,
        six => 6,
        seven => 7,
        eight => 8,
        nine => 9
    )
end

function identify_digits_in_output(display::AbstractString)
    patterns, outputs = split_display(display)
    configuration = identify_configuration(patterns)
    [configuration[output] for output in outputs]
end

function part1(input = input)
    digits_in_outputs = identify_digits_in_output.(input)
    target_digits = [1, 4, 7, 8]
    counts = [length(filter(x -> x ∈ target_digits, digits)) for digits in digits_in_outputs]
    sum(counts)
end

function glue_digits(digits::Vector{Int64})
    n_digits = length(digits)
    sum([digits[i] * 10^(n_digits - i) for i = 1:n_digits])
end

function part2(input = input)
    digits_in_outputs = identify_digits_in_output.(input)
    as_numbers = glue_digits.(digits_in_outputs)
    sum(as_numbers)
end

end #module
