module AOC2021

const data_dir = normpath(joinpath(@__FILE__, "..", "..", "data"))

days = filter(
    f -> isfile("src/$f"),
    ["day" * lpad(day, 2, "0") * ".jl" for day = 1:25]
)

@show days

for day in days
    include(day)
end

export solve

function solve(day::Int64, part::Int64)
    module_string = "Day" * lpad(day, 2, "0")
    part_string = string(part)
    module_and_part_string = module_string * ".part" * part_string * "()"
    eval(Meta.parse(module_and_part_string))
end

end # module
