module TestDay12

import AOC2021.Day12.part1, AOC2021.Day12.part2
using Test

test_input_short = """
dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc"""

test_input_long = """
fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW"""

@testset "Day 12" begin
    @testset "part 1" begin
        @test part1(test_input_short) == 19
        @test part1(test_input_long) == 226
    end
    @testset "part 2" begin
        @test part2(test_input_short) == 103
        @test part2(test_input_long) == 3509
    end
end

end # module
