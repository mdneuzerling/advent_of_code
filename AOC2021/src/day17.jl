module Day17

import Base.in, Base.>
import ..data_dir # from parent module
input = read(joinpath(data_dir, "day17"), String)

export part1, part2

mutable struct Probe
    x::Int64
    y::Int64
    v_x::Int64
    v_y::Int64
end

Probe(v_x::Int64, v_y::Int64) = Probe(0, 0, v_x, v_y)

function step!(probe::Probe)
    probe.x += probe.v_x
    probe.y += probe.v_y
    probe.v_x = probe.v_x >= 0 ? max(0, probe.v_x - 1) : probe.v_x + 1
    probe.v_y = probe.v_y - 1
    (probe.x, probe.y)
end

struct TargetSpace
    x_left::Int64
    x_right::Int64
    y_top::Int64
    y_bottom::Int64
end

function TargetSpace(input::AbstractString)
    xrange = match(r"(?<=x=)(.*)(?=,)", input).match
    x_left, x_right = map(d -> parse(Int64, d), split(xrange, ".."))
    yrange = match(r"(?<=y=)(.*)(?=$)", input).match
    y_bottom, y_top = map(d -> parse(Int64, d), split(yrange, ".."))
    TargetSpace(x_left, x_right, y_top, y_bottom)
end

function in(probe::Probe, target_space::TargetSpace)
    (target_space.x_left <= probe.x <= target_space.x_right) &&
        (target_space.y_bottom <= probe.y <= target_space.y_top)
end

function >(probe::Probe, target_space::TargetSpace)
    probe.x > target_space.x_right || probe.y < target_space.y_bottom
end

function simple_brute_force(target_space::TargetSpace, search_space_length = 100)
    successes = Vector{Tuple{Int64,Int64}}()
    axis_values = -search_space_length:search_space_length
    candidates = [(x_v, y_v) for x_v in axis_values for y_v in axis_values]
    for candidate in candidates
        probe = Probe(candidate...)
        while true
            step!(probe)
            probe > target_space && break
            if probe ∈ target_space
                push!(successes, candidate)
                break
            end
        end
    end
    if length(successes) == 0
        throw(ArgumentError("no successes in candidate space"))
    end
    successes
end

function max_height(successes::Vector{Tuple{Int64,Int64}})
    max_y_v = sort(successes, by = last, rev = true)[1][2]
    Int(max_y_v * (max_y_v + 1) / 2) # Good ol' triangle numbers
end

function part1(input = input)
    target_space = TargetSpace(input)
    successes = simple_brute_force(target_space, 100)
    max_height(successes)
end

function part2(input = input)
    target_space = TargetSpace(input)
    successes = simple_brute_force(target_space, 1000)
    length(successes)
end

end #module
