module Day16

using DataStructures

import ..data_dir # from parent module
input = read(joinpath(data_dir, "day16"), String)

export part1, part2

# To avoid integer overflows, we convert each hex to a 4-character bitstring
# individually, rather than converting hex to bits all at once
function bits(hex::AbstractString)
    if length(hex) == 1
        return (last(bitstring(parse(Int64, hex; base = 16)), 4))
    end
    return join(bits.(split(hex, "")))
end

decimal(bitstring::AbstractString) = parse(Int64, bitstring; base = 2)
version(packet_bitstring::AbstractString) = packet_bitstring[1:3] |> decimal
type_id(packet_bitstring::AbstractString) = packet_bitstring[4:6] |> decimal

abstract type Packet end

struct LiteralPacket <: Packet
    decoded::Int64
    length::Int64
    version::Int64
    type_id::Int64
end

struct OperatorPacket <: Packet
    subpackets::Vector{Packet}
    length::Int64
    version::Int64
    type_id::Int64
end

function extract_packets(packet_bitstring::AbstractString)
    subpackets = Vector{Packet}()
    remainder = packet_bitstring
    while true
        packet, remainder = extract_next_packet(remainder)
        push!(subpackets, packet)
        if length(remainder) == 0 || unique(remainder) == ['0']
            return subpackets
        end
    end
end

function extract_next_packet(packet_bitstring::AbstractString)
    if type_id(packet_bitstring) == 4
        return extract_literal_packet(packet_bitstring)
    else
        return extract_operator_packet(packet_bitstring)
    end
end

function extract_literal_packet(packet_bitstring::AbstractString)
    last_bit = 11 # header + one group
    while packet_bitstring[last_bit-4] != '0'
        last_bit += 5
    end
    content = packet_bitstring[7:last_bit]
    groups = [content[i:min(i + 4, end)] for i = 1:5:length(content)]
    decoded = [group[2:end] for group in groups] |> join |> decimal
    packet = LiteralPacket(
        decoded,
        last_bit,
        version(packet_bitstring[1:last_bit]),
        4
    )
    return packet, packet_bitstring[last_bit+1:end]
end

function extract_operator_packet(packet_bitstring::AbstractString)
    length_type_id = packet_bitstring[7]
    if length_type_id == '0'
        header_length = 3 + 3 + 1 + 15
        content_start = header_length + 1
        next_subpackets_length = decimal(packet_bitstring[8:content_start-1]) # next 15 bits

        subpackets = Vector{Packet}()
        remainder = packet_bitstring[content_start:end]
        while true
            packet, remainder = extract_next_packet(remainder)
            push!(subpackets, packet)
            subpackets_length = sum(subpacket.length for subpacket in subpackets)
            if subpackets_length == next_subpackets_length
                break
            end
        end
    else # length_type_id == '1'
        header_length = 3 + 3 + 1 + 11
        content_start = header_length + 1
        number_subpackets = decimal(packet_bitstring[8:content_start-1]) # next 11 bits

        subpackets = Vector{Packet}()
        remainder = packet_bitstring[content_start:end]
        while true
            packet, remainder = extract_next_packet(remainder)
            push!(subpackets, packet)
            if length(subpackets) == number_subpackets
                break
            end
        end
        subpackets_length = sum(subpacket.length for subpacket in subpackets)
    end

    packet = OperatorPacket(
        subpackets,
        header_length + subpackets_length,
        version(packet_bitstring),
        type_id(packet_bitstring)
    )

    return packet, remainder
end

sum_versions(packet::LiteralPacket) = packet.version
sum_versions(packet::OperatorPacket) = packet.version + sum(sum_versions(subpacket) for subpacket in packet.subpackets)

function part1(input = input)
    packet_bitstring = bits(input)
    packets = extract_packets(packet_bitstring)
    sum(sum_versions(packet) for packet in packets)
end

decode(packet::LiteralPacket) = packet.decoded

const type_id_function = Dict(
    # Need to make it so that all functions work on vectors
    0 => sum,
    1 => prod,
    2 => minimum,
    3 => maximum,
    # omit 4, which is reserved for literals
    # the following only ever contain two packets
    5 => x -> Int(>(x...)),
    6 => x -> Int(<(x...)),
    7 => x -> Int(==(x...)),
)

function decode(packet::OperatorPacket)
    operation = type_id_function[packet.type_id]
    operation([decode(subpacket) for subpacket in packet.subpackets])
end

function part2(input = input)
    packet_bitstring = bits(input)
    packets = extract_packets(packet_bitstring)
    outermost_packet = packets[1]
    decode(outermost_packet)
end

end #module
