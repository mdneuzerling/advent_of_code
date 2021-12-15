module TestDay15

import AOC2021.Day15.part1, AOC2021.Day15.part2
using Test

test_input = """
1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581"""

@testset "Day 15" begin
    @testset "part 1" begin
        @test part1(test_input) == 40
    end
    @testset "part 2" begin
        @test part2(test_input) == 315
    end
end

end # module
