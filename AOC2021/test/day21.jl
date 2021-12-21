module TestDay21

import AOC2021.Day21.part1, AOC2021.Day21.part2
using Test

test_input = """
Player 1 starting position: 4
Player 2 starting position: 8"""

@testset "Day 21" begin
    @testset "part 1" begin
        @test part1(test_input) == 739785
    end
    @testset "part 2" begin
        @test part2(test_input) == 444356092776315
    end
end

end # module
