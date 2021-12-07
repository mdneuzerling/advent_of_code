module TestDay06

import AOC2021.Day06.part1, AOC2021.Day06.part2
using Test

test_input_raw = """
3,4,3,1,2"""

test_input = test_input_raw # no transformation needed her

@testset "Day 06" begin
    @testset "part 1" begin
        @test part1(test_input) == 5934
    end
    @testset "part 2" begin
        @test part2(test_input) == 26984457539
    end
end

end # module
