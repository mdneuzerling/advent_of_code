module Day05

import Base.show, Base.string
import ..data_dir # from parent module

export part1, part2

struct Point
    x::Int64
    y::Int64
end

function string(point::Point)
    "$(point.x),$(point.y)"
end

function show(io::IO, point::Point)
    println(io, string(point))
end

function Point(point_defn::AbstractString)
    x_string, y_string = split(point_defn, ",")
    x, y = parse(Int64, x_string), parse(Int64, y_string)
    Point(x, y)
end

struct Line
    a::Point
    b::Point
end

function string(line::Line)
    "$(string(line.a)) -> $(string(line.b))"
end

function show(io::IO, line::Line)
    println(io, string(line))
end

function Line(line_defn::AbstractString)
    point_defns = split(line_defn, " -> ")
    a_string, b_string = point_defns[1], point_defns[2]
    a, b = Point(a_string), Point(b_string)
    Line(a, b)
end

is_horizontal(line::Line) = (line.a.y == line.b.y)
is_vertical(line::Line) = (line.a.x == line.b.x)

"""
Julia sees no points for the range `5:1` since `5 > 1`. This function makes sure
the step is correct (either 1 or -1) so that `5:1 == [5, 4, 3, 2, 1]`.
"""
function sequence(i, j)
    if i > j
        range(i, j, step = -1)
    else
        range(i, j, step = 1)
    end
end

"""
Also known as _gradient_
"""
slope(line) = (line.b.y - line.a.y) / (line.b.x - line.a.x)

"""
Returns a dictionary indexed by points and with values the number of occurrences of 
each points. Points that aren't on any of the given lines will not appear in the
dictionary at all.

Lines are either horizontal, vertical, or diagonal at a 45° angle. In the diagonal
case, the slope is ±1, so we don't need to worry about non-integral coordinates.

The vertical line case has to be handled separately because the slope is NaN due to
a division by zero
"""
function points_on_line(line::Line)
    if is_vertical(line)
        return ([Point(line.a.x, j) for j in sequence(line.a.y, line.b.y)])
    end

    slope_of_line = slope(line)
    points = Vector{Point}()
    for i in sequence(0, line.b.x - line.a.x)
        # Move 1 along and 1 up/down each time
        point = Point(
            Int(line.a.x + i),
            Int(line.a.y + (i * slope_of_line))
        )
        push!(points, point)
    end
    points
end

"""
Returns a dictionary indexed by points and with values the number of occurrences of 
each points. Points that aren't on any of the given lines will not appear in the
dictionary at all.
"""
function points_on_lines(lines::Vector{Line})
    occurrences = Dict{Point,Int64}()
    for line in lines
        for point in points_on_line(line)
            occurrences[point] = get(occurrences, point, 0) + 1
        end
    end
    occurrences
end

function count_multiple_occurrences(lines::Vector{Line})
    occurrences = points_on_lines(lines)
    length([p for p in keys(occurrences) if occurrences[p] > 1])
end

# Parse the input 
const data_file = joinpath(data_dir, "day05")
const input = readlines(data_file) # read into an array, each line is an element
const lines = [Line(i) for i in input]

function part1(input = input)
    lines = [Line(i) for i in input]
    no_diagonals = [line for line in lines if is_horizontal(line) || is_vertical(line)]
    count_multiple_occurrences(no_diagonals)
end
function part2(input = input)
    lines = [Line(i) for i in input]
    count_multiple_occurrences(lines)
end

end # module
