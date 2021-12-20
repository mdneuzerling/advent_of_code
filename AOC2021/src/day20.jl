module Day20

import ..data_dir # from parent module
input = read(joinpath(data_dir, "day20"), String)

export part1, part2

const pixel_map = Dict(
    "." => Int8(0),
    "#" => Int8(1)
)

read_algorithm(algorithm::AbstractString, hash_value::Int) = pixel_map[string(algorithm[hash_value+1])]

function parse_input(input::AbstractString)
    lines = split(input, "\n", keepempty = false)
    algorithm = popfirst!(lines)
    arrayed = [(x -> pixel_map[x]).(split(line, "")) for line in lines]
    image = Matrix(transpose(hcat(arrayed...))) # turn into a Matrix with this ugly code
    return algorithm, image
end

function out_of_bounds(m::Matrix{Int8}, row::Int, column::Int)
    nrows, ncols = size(m)
    row < 1 || row > nrows || column < 1 || column > ncols
end

function pixel(m::Matrix{Int8}, row::Int, column::Int, default::Int8)
    if out_of_bounds(m, row, column)
        return default
    end
    return m[row, column]
end

function neighbourhood(m::Matrix{Int8}, row::Int, column::Int, default::Int8)
    neighbours = Vector{Int8}()
    for i = row-1:row+1
        for j = column-1:column+1
            push!(neighbours, pixel(m, i, j, default))
        end
    end
    return neighbours
end

function neighbourhood_hash(m::Matrix{Int8}, row::Int, column::Int, default::Int8)
    neighbours = neighbourhood(m, row, column, default)
    neighbourhood_hash_string = join(string.(neighbours))
    parse(Int64, neighbourhood_hash_string, base = 2)
end

function add_border(image::Matrix{Int8}, pad_with::Int8 = Int8(0), border_size::Int = 2)
    pad_function = Bool(pad_with) ? ones : zeros
    nrows, ncols = size(image)
    vcat(
        pad_function(Int8, border_size, ncols + 2 * border_size),
        [pad_function(Int8, nrows, border_size) image pad_function(Int8, nrows, border_size)],
        pad_function(Int8, border_size, ncols + 2 * border_size)
    )
end

function enhance(algorithm::AbstractString, image::Matrix{Int8}, infinity::Int8 = Int8(0))
    padded = add_border(image, infinity)
    resulting_matrix = zeros(Int8, size(padded)...)
    nrows, ncols = size(padded)
    for row = 1:nrows
        for column = 1:ncols
            hash_value = neighbourhood_hash(padded, row, column, infinity)
            resulting_matrix[row, column] = read_algorithm(algorithm, hash_value)
        end
    end
    infinity_hash_value = parse(Int64, repeat(string(infinity), 9), base = 2)
    new_infinity = read_algorithm(algorithm, infinity_hash_value)
    return resulting_matrix, new_infinity
end

function part1(input = input)
    algorithm, image = parse_input(input)
    infinity = Int8(0)
    for i = 1:2
        image, infinity = enhance(algorithm, image, infinity)
    end
    sum(image)
end

function part2(input = input)
    algorithm, image = parse_input(input)
    infinity = Int8(0)
    for i = 1:50
        image, infinity = enhance(algorithm, image, infinity)
    end
    sum(image)
end

end #module
