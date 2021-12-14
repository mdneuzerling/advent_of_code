module TestDay14

import AOC2021.Day14.part1, AOC2021.Day14.part2
using Test

test_input = """
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C"""

@testset "Day 14" begin
    @testset "part 1" begin
        @test part1(test_input) == 1588
    end
    @testset "part 2" begin
        @test part2(test_input) == 2188189693529
    end
end

end # module
