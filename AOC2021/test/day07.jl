module TestDay07

import AOC2021.Day07.part1, AOC2021.Day07.part2
using Test

test_input_raw = """
16,1,2,0,4,2,7,1,2,14"""

test_input = test_input_raw # no transformation needed here

@testset "Day 07" begin
    @testset "part 1" begin
        @test part1(test_input) == 37
    end
    @testset "part 2" begin
        @test part2(test_input) == 168
    end
end

end # module
