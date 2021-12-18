module TestDay18

import AOC2021.Day18.part1, AOC2021.Day18.part2
import AOC2021.Day18.snailfish_parse
import AOC2021.Day18.explode!, AOC2021.Day18.split!, AOC2021.Day18.reduce!, AOC2021.Day18.magnitude
using Test

test_input = """
[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]"""

@testset "Day 18" begin
    @testset "snailfish arithmetic" begin
        added = snailfish_parse("[1,2]") + snailfish_parse("[[3,4],5]")
        @test added == snailfish_parse("[[1,2],[[3,4],5]]")

        s = snailfish_parse("[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]")
        explode!(s)
        @test s == snailfish_parse("[[[[0,7],4],[7,[[8,4],9]]],[1,1]]")
        explode!(s)
        @test s == snailfish_parse("[[[[0,7],4],[15,[0,13]]],[1,1]]")
        split!(s)
        @test s == snailfish_parse("[[[[0,7],4],[[7,8],[0,13]]],[1,1]]")
        split!(s)
        @test s == snailfish_parse("[[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]")
        explode!(s)
        @test s == snailfish_parse("[[[[0,7],4],[[7,8],[6,0]]],[8,1]]")

        s = snailfish_parse("[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]")
        reduce!(s)
        @test s == snailfish_parse("[[[[0,7],4],[[7,8],[6,0]]],[8,1]]")

        @test magnitude(snailfish_parse("[[1,2],[[3,4],5]]")) == 143
        @test magnitude(snailfish_parse("[[[[0,7],4],[[7,8],[6,0]]],[8,1]]")) == 1384
        @test magnitude(snailfish_parse("[[[[1,1],[2,2]],[3,3]],[4,4]]")) == 445
        @test magnitude(snailfish_parse("[[[[3,0],[5,3]],[4,4]],[5,5]]")) == 791
        @test magnitude(snailfish_parse("[[[[5,0],[7,4]],[5,5]],[6,6]]")) == 1137
        @test magnitude(snailfish_parse("[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]")) == 3488

    end
    @testset "part 1" begin
        @test true
        @test part1(test_input) == 4140
    end
    @testset "part 2" begin
        @test part2(test_input) == 3993
    end
end

end # module
