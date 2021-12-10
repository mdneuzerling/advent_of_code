module Day10

using Statistics

import Base.show, Base.-, Base.*
import ..data_dir # from parent module
input = read(joinpath(data_dir, "day10"), String)

export part1, part2

struct Bracket
    left::AbstractString
    right::AbstractString
    orientation::AbstractString
    function Bracket(left::AbstractString, right::AbstractString, orientation::AbstractString)
        if orientation ∉ ["left", "right"]
            throw(ArgumentError("orientation must be \"left\" or \"right\", got: $orientation"))
        end
        new(left, right, orientation)
    end
end

function Bracket(b::AbstractString)
    if b == "("
        Bracket("(", ")", "left")
    elseif b == ")"
        Bracket("(", ")", "right")
    elseif b == "["
        Bracket("[", "]", "left")
    elseif b == "]"
        Bracket("[", "]", "right")
    elseif b == "{"
        Bracket("{", "}", "left")
    elseif b == "}"
        Bracket("{", "}", "right")
    elseif b == "<"
        Bracket("<", ">", "left")
    elseif b == ">"
        Bracket("<", ">", "right")
    else
        throw(ArgumentError("No shortcut for bracket: $b"))
    end
end

function -(bracket::Bracket)
    if bracket.orientation == "left"
        return (Bracket(bracket.left, bracket.right, "right"))
    end
    Bracket(bracket.left, bracket.right, "left")
end

function strip_matching_brackets(brackets::Vector{Bracket})
    for i = 1:length(brackets)-1
        if brackets[i].orientation == "left" && brackets[i] == -brackets[i+1]
            stripped = [brackets[j] for j in 1:length(brackets) if j ∉ [i, i + 1]]
            return strip_matching_brackets(stripped)
        end
    end
    return brackets
end

# Input parsing
function convert_input_to_lines(input::AbstractString)
    raw_lines = split(input, "\n")
    [Bracket.(split(line, "")) for line in raw_lines]
end

# Part 1
const bad_bracket_scores = Dict(
    Bracket(")") => 3,
    Bracket("]") => 57,
    Bracket("}") => 1197,
    Bracket(">") => 25137
)

function first_bad_bracket(brackets::Vector{Bracket})
    stripped = strip_matching_brackets(brackets)
    for i = 2:length(stripped)
        if stripped[i].orientation == "right" && -stripped[i] != stripped[i-1]
            return (stripped[i])
        end
    end
    nothing
end

function part1(input = input)
    lines = convert_input_to_lines(input)
    first_bad_brackets = first_bad_bracket.(lines)
    sum([bad_bracket_scores[bracket] for bracket in first_bad_brackets if !isnothing(bracket)])
end

# Part 2
const completion_values = Dict(
    Bracket(")") => 1,
    Bracket("]") => 2,
    Bracket("}") => 3,
    Bracket(">") => 4
)

function calculate_completion_score(brackets::Vector{Bracket})
    stripped = strip_matching_brackets(brackets)
    if !isnothing(first_bad_bracket(stripped))
        return nothing
    end
    right_half = [-bracket for bracket in reverse(stripped)]
    completion_score = 0
    for bracket in right_half
        completion_score = completion_score * 5
        completion_score += completion_values[bracket]
    end
    completion_score
end

function part2(input = input)
    lines = convert_input_to_lines(input)
    completion_scores = calculate_completion_score.(lines)
    non_missing = [score for score in completion_scores if !isnothing(score)]
    Int(median(non_missing))
end

end #module
