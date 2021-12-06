module TestDay02

import AOC2021.Day02.part1, AOC2021.Day02.part2
using Test

test_input_raw = """
forward 5
down 5
forward 8
up 3
down 8
forward 2"""

test_input = [string(x) for x in split(test_input_raw, "\n")]

@testset "Day 02" begin
    @testset "part 1" begin
        @test part1(; input = test_input) == 150
    end
    @testset "part 2" begin
        @test part2(; input = test_input) == 900
    end
end

end # module
