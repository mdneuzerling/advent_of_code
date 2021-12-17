module TestDay17

import AOC2021.Day17.part1, AOC2021.Day17.part2
using Test

test_input = "target area: x=20..30, y=-10..-5"

@testset "Day 17" begin
    @testset "part 1" begin
        @test part1(test_input) == 45
    end
    @testset "part 2" begin
        @test part2(test_input) == 112
    end
end

end # module
