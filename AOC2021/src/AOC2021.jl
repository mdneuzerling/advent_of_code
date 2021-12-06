module AOC2021

const data_dir = normpath(joinpath(@__FILE__, "..", "..", "data"))

const PKGDIR = pkgdir(AOC2021)
src_path(day::AbstractString) = joinpath(PKGDIR, "src", "$day.jl")

const DAYS = ["day" * lpad(day, 2, "0") for day = 1:25]
const SRC_PATHS = let
    paths = src_path.(DAYS)
    existing_paths = filter(isfile, paths)
end

for path in SRC_PATHS
    include(path)
end

export solve

function solve(day::Int64, part::Int64)
    module_string = "Day" * lpad(day, 2, "0")
    part_string = string(part)
    module_and_part_string = module_string * ".part" * part_string * "()"
    eval(Meta.parse(module_and_part_string))
end

end # module
