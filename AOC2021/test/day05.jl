module TestDay05

import AOC2021.Day05.part1, AOC2021.Day05.part2
using Test

test_input_raw = """
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2"""

test_input = [string(x) for x in split(test_input_raw, "\n")]

@testset "Day 05" begin
    @testset "part 1" begin
        @test part1(; input = test_input) == 5
    end
    @testset "part 2" begin
        @test part2(; input = test_input) == 12
    end
end

end # module
