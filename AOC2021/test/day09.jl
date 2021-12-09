module TestDay09

import AOC2021.Day09.part1, AOC2021.Day09.part2, AOC2021.Day09.string_block_to_matrix
using Test

test_input = """
2199943210
3987894921
9856789892
8767896789
9899965678"""

@testset "Day 09" begin
    @testset "part 1" begin
        @test part1(test_input) == 15
    end
    @testset "part 2" begin
        @test part2(test_input) == 1134
    end
end

end # module
