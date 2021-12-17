module TestDay16

import AOC2021.Day16.part1, AOC2021.Day16.part2, AOC2021.Day16.bits, AOC2021.Day16.extract_next_packet
using Test

@testset "Day 16 basics" begin
    @testset "basic literal" begin
        literal = "D2FE28"
        literal_bitstring = bits(literal)
        packet, _ = extract_next_packet(literal_bitstring)
        @test packet.decoded == 2021
    end
    @testset "basic operator length bit type 0" begin
        operator = "38006F45291200"
        operator_bitstring = bits(operator)
        packet, _ = extract_next_packet(operator_bitstring)
        literals = [packet for packet in packet.subpackets]
        @test literals[1].decoded == 10
        @test literals[2].decoded == 20
    end
    @testset "basic operator length bit type 1" begin
        operator = "EE00D40C823060"
        operator_bitstring = bits(operator)
        packet, _ = extract_next_packet(operator_bitstring)
        literals = [packet for packet in packet.subpackets]
        @test literals[1].decoded == 1
        @test literals[2].decoded == 2
        @test literals[3].decoded == 3
    end
end

@testset "Day 16" begin
    @testset "part 1" begin
        @test part1("8A004A801A8002F478") == 16
        @test part1("620080001611562C8802118E34") == 12
        @test part1("C0015000016115A2E0802F182340") == 23
        @test part1("A0016C880162017C3686B18A3D4780") == 31
    end
    @testset "part 2" begin
        @test part2("C200B40A82") == 3
        @test part2("04005AC33890") == 54
        @test part2("880086C3E88112") == 7
        @test part2("CE00C43D881120") == 9
        @test part2("D8005AC2A8F0") == 1
        @test part2("F600BC2D8F") == 0
        @test part2("9C005AC2F8F0") == 0
        @test part2("9C0141080250320F1802104A08") == 1
    end
end

end # module
