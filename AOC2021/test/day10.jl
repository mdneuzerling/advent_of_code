module TestDay10

import AOC2021.Day10.part1, AOC2021.Day10.part2
using Test

test_input = """
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]"""

@testset "Day 10" begin
    @testset "part 1" begin
        @test part1(test_input) == 26397
    end
    @testset "part 2" begin
        @test part2(test_input) == 288957
    end
end

end # module
