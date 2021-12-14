module TestDay13

import AOC2021.Day13.part1, AOC2021.Day13.part2
using Test

test_input = """
6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5"""

@testset "Day 13" begin
    @testset "part 1" begin
        @test part1(test_input) == 17
    end
    # @testset "part 2" begin
    # @test part2(test_input) == true
    # end
end

end # module
