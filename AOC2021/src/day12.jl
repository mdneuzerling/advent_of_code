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

function has_visited_a_small_cave_twice(path::Vector{String})
    small_caves = filter(vertex -> lowercase(vertex) == vertex, path)
    unique(small_caves) != small_caves
end

function traverse(
    graph::Graph,
    path_so_far = Vector{String}(),
    next_vertex = "start";
    allow_small_cave_revisit = false
)
    updated_path = [path_so_far; next_vertex]
    if next_vertex == "end"
        return Set([updated_path])
    end
    if allow_small_cave_revisit && has_visited_a_small_cave_twice(updated_path)
        return traverse(graph, path_so_far, next_vertex; allow_small_cave_revisit = false)
    end
    valid_neighbours = filter(candidate -> candidate != "start", neighbours(graph, next_vertex))
    if !allow_small_cave_revisit
        valid_neighbours = filter(
            candidate -> cave_size(candidate) == "large" || candidate ∉ updated_path,
            valid_neighbours
        )
        if length(valid_neighbours) == 0 # dead end
            return Set{Vector{String}}()
        end
    end
    branches = [
        traverse(graph, updated_path, neighbour; allow_small_cave_revisit = allow_small_cave_revisit)
        for neighbour in valid_neighbours
    ]
    return ∪(branches...)
end

function part1(input = input)
    traverse(
        Graph(input);
        allow_small_cave_revisit = false
    ) |> length
end

function part2(input = input)
    traverse(
        Graph(input);
        allow_small_cave_revisit = true
    ) |> length
end

end #module
