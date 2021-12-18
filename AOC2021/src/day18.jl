module Day18

import Base.+, Base.==
import ..data_dir # from parent module
input = read(joinpath(data_dir, "day18"), String)

export part1, part2

const digits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

mutable struct SnailfishInteger
    depth::Int64
    value::Int64
end

function ==(s1::SnailfishInteger, s2::SnailfishInteger)
    s1.depth == s2.depth && s1.value == s2.value
end

function +(s1::Vector{SnailfishInteger}, s2::Vector{SnailfishInteger})
    # Without the deepcopies, `s1` and `s2` get modified by `reduce!`
    new_s = vcat(deepcopy(s1), deepcopy(s2))
    for i in new_s
        i.depth += 1
    end
    reduce!(new_s)
    new_s
end

# Search left-to-right, replacing all side-by-side pairs of the same
# depth with their magnitude, until only one value remains (the magnitude)
function magnitude(s::Vector{SnailfishInteger})
    s_copy = deepcopy(s)
    while length(s_copy) > 1
        max_depth = maximum(n.depth for n in s_copy)
        for i = 1:length(s_copy)-1
            lhs = s_copy[i]
            rhs = s_copy[i+1]
            if lhs.depth == rhs.depth == max_depth
                mag = 3 * lhs.value + 2 * rhs.value
                s_copy[i] = SnailfishInteger(lhs.depth - 1, mag)
                deleteat!(s_copy, i + 1)
                break
            end
            if i == length(s_copy) - 1
                throw(ArgumentError("No pairs found"))
            end
            # print(join(s, "\n"), "\n", "\n")
        end
    end
    # Only one SnailfishInteger remains, and its value is the magnitude
    s_copy[1].value
end

function snailfish_parse(input::AbstractString)
    result = Vector{SnailfishInteger}()
    depth = 0
    characters = split(input, "")
    while length(characters) > 0
        c = popfirst!(characters)
        if c == "["
            depth += 1
        elseif c == "]"
            depth -= 1
        elseif c == ","
            continue
        else
            digits_so_far = c
            while length(characters) > 0 && characters[1] ∈ digits
                digits_so_far = digits_so_far * popfirst!(characters)
            end
            snailfish_integer = SnailfishInteger(depth, parse(Int64, digits_so_far))
            push!(result, snailfish_integer)
        end
    end
    result
end

# lhs and rhs are left/right-hand side indices
function explode!(s::Vector{SnailfishInteger})
    for lhs = 1:length(s)-1
        if s[lhs].depth > 4
            rhs = lhs + 1 # right hand side
            if lhs > 1
                s[lhs-1].value += s[lhs].value
            end
            if rhs < length(s)
                s[rhs+1].value += s[rhs].value
            end
            deleteat!(s, rhs)
            s[lhs] = SnailfishInteger(s[lhs].depth - 1, 0) # new element has decremented depth, value 0
            return true
        end
    end
    return false
end

function split!(s::Vector{SnailfishInteger})
    for i = 1:length(s)
        depth, value = s[i].depth, s[i].value
        if value > 9
            lhs = Int(floor(value / 2))
            rhs = Int(ceil(value / 2))
            insert!(s, i + 1, SnailfishInteger(depth + 1, rhs))
            insert!(s, i + 1, SnailfishInteger(depth + 1, lhs))
            deleteat!(s, i)
            return true
        end
    end
    return false
end

function reduce!(s::Vector{SnailfishInteger})
    did_explode = explode!(s)
    if did_explode
        return reduce!(s)
    end

    did_split = split!(s)
    if did_split
        return reduce!(s)
    end

    s
end

function part1(input = input)
    numbers = snailfish_parse.(split(input, "\n"))
    summed = sum(numbers)
    magnitude(summed)
end

function part2(input = input)
    numbers = snailfish_parse.(split(input, "\n"))
    magnitudes = Vector{Int64}()
    for i = 1:length(numbers)
        for j = 1:length(numbers)
            if i == j
                continue
            end
            push!(magnitudes, magnitude(numbers[i] + numbers[j]))
            push!(magnitudes, magnitude(numbers[j] + numbers[i]))
        end
    end
    maximum(magnitudes)
end

end #module
