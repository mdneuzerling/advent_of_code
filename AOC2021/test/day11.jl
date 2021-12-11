module TestDay11

import AOC2021.Day11.part1, AOC2021.Day11.part2
using Test

test_input = """
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526"""

@testset "Day 11" begin
    @testset "part 1" begin
        @test part1(test_input) == 1656
    end
    @testset "part 2" begin
        @test part2(test_input) == 195
    end
end

end # module
