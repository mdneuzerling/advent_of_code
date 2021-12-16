



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

Vector{Packet}()


