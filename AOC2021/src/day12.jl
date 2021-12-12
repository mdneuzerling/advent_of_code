module Day12

import ..data_dir # from parent module
input = read(joinpath(data_dir, "day12"), String)

export part1, part2

struct Graph
    vertices::Vector{String}
    edges::Vector{Tuple{String,String}}
end

function Graph(input::AbstractString)
    raw_edges = string.(split(input, "\n"))
    edges = Tuple{String,String}.(split.(raw_edges, "-"))
    vertices = String.(vcat(split.(raw_edges, "-")...))
    Graph(vertices, edges)
end

function neighbours(graph::Graph, vertex::AbstractString)
    result = []
    for edge in graph.edges
        x, y = edge
        if x == vertex
            push!(result, y)
        elseif y == vertex
            push!(result, x)
        end
    end
    result
end

cave_size(vertex::String) = uppercase(vertex) == vertex ? "large" : "small"

function traverse1(
    graph::Graph,
    path_so_far = Vector{String}(),
    next_vertex = "start"
)
    updated_path = [path_so_far; next_vertex]
    if next_vertex == "end"
        return Set([updated_path])
    end
    valid_neighbours = filter(
        candidate -> cave_size(candidate) == "large" || candidate ∉ updated_path,
        neighbours(graph, next_vertex)
    )
    if length(valid_neighbours) == 0 # dead end
        return Set{Vector{String}}()
    end
    return ∪([traverse1(graph, updated_path, neighbour) for neighbour in valid_neighbours]...)
end

function part1(input = input)
    input |> Graph |> traverse1 |> length
end

function can_visit_small_cave_twice(path::Vector{String})
    small_caves = filter(vertex -> lowercase(vertex) == vertex, path)
    unique(small_caves) == small_caves
end

function traverse2(
    graph::Graph,
    path_so_far = Vector{String}(),
    next_vertex = "start",
)
    updated_path = [path_so_far; next_vertex]
    if !can_visit_small_cave_twice(updated_path)
        return traverse1(graph, path_so_far, next_vertex)
    end
    if next_vertex == "end"
        return Set([updated_path])
    end
    valid_neighbours = filter(
        neighbour -> neighbour != "start",
        neighbours(graph, next_vertex)
    )
    return ∪([traverse2(graph, updated_path, neighbour) for neighbour in valid_neighbours]...)
end

function part2(input = input)
    input |> Graph |> traverse2 |> length
end

end #module
