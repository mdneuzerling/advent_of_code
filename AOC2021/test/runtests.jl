tests = ["day" * lpad(day, 2, "0") for day = 1:25 if isfile("day" * lpad(day, 2, "0") * ".jl")]

for test in tests
    include(test * ".jl")
end
