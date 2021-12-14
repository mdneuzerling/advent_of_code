module Day14

import ..data_dir # from parent module
input = read(joinpath(data_dir, "day14"), String)

export part1, part2

struct Insertion
    pattern::AbstractString
    insert::AbstractString
end

function Insertion(rule::AbstractString)
    Insertion(split(rule, " -> ")...)
end

function template_and_insertions(input::AbstractString)
    lines = split(input, "\n")
    template = lines[1]
    insertions = Insertion.(lines[3:end])
    return template, insertions
end

function insert_after(s::AbstractString, to_insert::AbstractString, index::Int64)
    s[1:index] * to_insert * s[index+1:end]
end

function substitute(template::AbstractString, insertions::Vector{Insertion})
    characters_to_insert = Vector{Tuple{Int64,AbstractString}}()
    for i = 1:length(template)-1
        current_pair = template[i] * template[i+1]
        for insertion in insertions
            if current_pair == insertion.pattern
                push!(characters_to_insert, (i, insertion.insert))
                break
            end
        end
    end

    for i = 1:length(characters_to_insert)
        index, to_insert = characters_to_insert[i]
        offset = i - 1
        index_with_offset = index + offset
        template = insert_after(template, to_insert, index_with_offset)
    end

    return template
end

function most_common_minus_least_common(template::AbstractString)
    letters = split(template, "")
    counts = [count(x -> x == letter, letters) for letter in unique(letters)]
    maximum(counts) - minimum(counts)
end

function part1(input = input)
    template, insertions = template_and_insertions(input)
    for i = 1:10
        template = substitute(template, insertions)
    end
    most_common_minus_least_common(template)
end

mutable struct CompressedTemplate
    pairs::Dict{Tuple{Char,Char},Int64}
    letter_counts::Dict{Char,Int64}
end

function CompressedTemplate(template::AbstractString)
    pairs = Dict{Tuple{Char,Char},Int64}()
    for i = 1:length(template)-1
        current_pair = (template[i], template[i+1])
        pairs[current_pair] = get(pairs, current_pair, 0) + 1
    end

    letters = split(template, "")
    letter_counts = Dict(only(letter) => count(x -> x == letter, letters) for letter in unique(letters))

    CompressedTemplate(pairs, letter_counts)
end

function pair(insertion::Insertion)
    left, right = split(insertion.pattern, "")
    (only(left), only(right))
end

function new_pairs(insertion::Insertion)
    left, right = split(insertion.pattern, "")
    # only converts to Char
    left, right, insert = only(left), only(right), only(insertion.insert)
    return (left, insert), (insert, right)
end

function substitute(template::CompressedTemplate, insertions::Vector{Insertion})
    new_template = deepcopy(template)
    for insertion in insertions
        current_pattern = pair(insertion)
        occurrences = get(template.pairs, current_pattern, 0)

        pair_left, pair_right = new_pairs(insertion)
        new_template.pairs[pair_left] = get(new_template.pairs, pair_left, 0) + occurrences
        new_template.pairs[pair_right] = get(new_template.pairs, pair_right, 0) + occurrences
        new_template.pairs[current_pattern] = get(new_template.pairs, current_pattern, 0) - occurrences

        new_letter = only(insertion.insert)
        new_template.letter_counts[new_letter] = get(new_template.letter_counts, new_letter, 0) + occurrences
    end
    new_template
end

function most_common_minus_least_common(template::CompressedTemplate)
    counts = values(template.letter_counts)
    maximum(counts) - minimum(counts)
end

function part2(input = input)
    template, insertions = template_and_insertions(input)
    template = CompressedTemplate(template)
    for i = 1:40
        template = substitute(template, insertions)
    end
    most_common_minus_least_common(template)
end

end #module
