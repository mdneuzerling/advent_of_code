module AOC2021

const data_dir = normpath(joinpath(@__FILE__, "..", "..", "data"))

include("day01.jl")
include("day02.jl")
include("day03.jl")
include("day04.jl")
include("day05.jl")

export solve

function solve(day::Int64, part::Int64)
    module_string = "Day" * lpad(day, 2, "0")
    part_string = string(part)
    module_and_part_string = module_string * ".part" * part_string * "()"
    eval(Meta.parse(module_and_part_string))
end

end # module
