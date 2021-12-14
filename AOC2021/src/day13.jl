module Day13

import ..data_dir # from parent module
input = read(joinpath(data_dir, "day13"), String)

export part1, part2

struct Paper
    coordinates::Vector{Tuple{Int64,Int64}}
    folds::Vector{Tuple{AbstractString,Int64}}
end

function Paper(input::AbstractString)
    raw_coordinates, raw_folds = split(input, "\n\n")
    coordinates = [Tuple(parse.(Int64, x)) for x in split.(split(raw_coordinates, "\n"), ",")]

    fold_equations = last.(split.(split(raw_folds, "\n"), " "))
    folds = [Tuple([string(axis), parse(Int64, amount)]) for (axis, amount) in split.(fold_equations, "=")]
    Paper(coordinates, folds)
end

function horizontal_fold(coordinates::Vector{Tuple{Int64,Int64}}, fold_line::Int64)
    # fold up
    below_fold = [coordinate for coordinate in coordinates if coordinate[2] > fold_line]
    above_fold = coordinates[(!in).(coordinates, Ref(below_fold))]

    below_fold_x = [coordinate[1] for coordinate in below_fold]
    below_fold_y = [coordinate[2] for coordinate in below_fold]
    mirrored_y_coordinates = [fold_line - (y - fold_line) for y in below_fold_y]
    mirrored = collect(zip(below_fold_x, mirrored_y_coordinates))
    unique([above_fold; mirrored])
end

function vertical_fold(coordinates::Vector{Tuple{Int64,Int64}}, fold_line::Int64)
    # fold left
    right_of_fold = [coordinate for coordinate in coordinates if coordinate[1] > fold_line]
    left_of_fold = coordinates[(!in).(coordinates, Ref(right_of_fold))]

    right_of_fold_x = [coordinate[1] for coordinate in right_of_fold]
    right_of_fold_y = [coordinate[2] for coordinate in right_of_fold]
    mirrored_x_coordinates = [fold_line - (x - fold_line) for x in right_of_fold_x]
    mirrored = collect(zip(mirrored_x_coordinates, right_of_fold_y))
    unique([left_of_fold; mirrored])
end

function fold(coordinates::Vector{Tuple{Int64,Int64}}, fold::Tuple{AbstractString,Int64})
    axis, amount = fold
    axis == "x" ? vertical_fold(coordinates, amount) : horizontal_fold(coordinates, amount)
end

function part1(input = input)
    paper = Paper(input)
    first_fold = first(paper.folds)
    new_coordinates = fold(paper.coordinates, first_fold)
    length(new_coordinates)
end

function print_coordinates(coordinates::Vector{Tuple{Int64,Int64}})
    max_x = maximum(x for (x, y) in coordinates)
    max_y = maximum(y for (x, y) in coordinates)
    display = ""
    for j = 0:max_y
        for i = 0:max_x
            if (i, j) in coordinates
                display = display * "█"
            else
                display = display * " "
            end
        end
        display = display * "\n"
    end
    print(display)
end

function part2(input = input)
    paper = Paper(input)
    coordinates = paper.coordinates
    folds = paper.folds
    while length(folds) > 0
        first_fold = popfirst!(folds)
        coordinates = fold(coordinates, first_fold)
    end
    print_coordinates(coordinates)
end

end #module
