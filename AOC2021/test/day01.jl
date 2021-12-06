module TestDay01

import AOC2021.Day01.part1, AOC2021.Day01.part2
using Test

test_input_raw = """
199
200
208
210
200
207
240
269
260
263"""

test_input = [string(x) for x in split(test_input_raw, "\n")]

@testset "Day 01" begin
    @testset "part 1" begin
        @test part1(; input = test_input) == 7
    end
    @testset "part 2" begin
        @test part2(; input = test_input) == 5
    end
end

end # module
