module TestDay03

import AOC2021.Day03.part1, AOC2021.Day03.part2
using Test

test_input_raw = """
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010"""

test_input = [string(x) for x in split(test_input_raw, "\n")]

@testset "Day 03" begin
    @testset "part 1" begin
        @test part1(; input = test_input) == 198
    end
    @testset "part 2" begin
        @test part2(; input = test_input) == 230
    end
end

end # module
