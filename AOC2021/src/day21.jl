module Day21

using Memoize

import ..data_dir # from parent module
input = read(joinpath(data_dir, "day21"), String)

export part1, part2

function parse_player(player_string::AbstractString)
    numbers = [match.match for match in eachmatch(r"[[:digit:]]+", player_string)]
    Player(parse.(Int64, numbers)...)
end

function parse_players(input::AbstractString)
    player_strings = split(input, "\n", keepempty = false)
    parse_player.(player_strings)
end

mutable struct Player
    number::Int64
    position::Int64
    score::Int64
end
Player(number, position) = Player(number, position, 0)
Player(number) = Player(number, 0, 0)

new_position(position::Int64, movement::Int64) = mod(position + movement - 1, 10) + 1

function move!(player::Player, movement::Int64)
    player.position = new_position(player.position, movement)
    player.score += player.position
end

mutable struct DeterministicDice
    sequence::Vector{Int64}
    rolls::Int64
end
DeterministicDice(size::Int64) = DeterministicDice(collect(1:size), 0)

function roll!(dice::DeterministicDice)
    if dice.rolls == length(dice.sequence)
        dice.rolls = 0
    end
    dice.rolls += 1
    return dice.sequence[dice.rolls]
end

function roll!(dice::DeterministicDice, times::Int64)
    sum(roll!(dice) for i = 1:times)
end

function part1(input = input)
    players = parse_players(input)
    sort!(players, by = p -> p.number)
    dice = DeterministicDice(100)
    n_rolls = 0
    while true
        for player in players
            move!(player, roll!(dice, 3))
            n_rolls += 3
            if player.score >= 1000
                losing_player = first(filter(p -> p.number != player.number, players))
                return losing_player.score * n_rolls
            end
        end
    end
end

# enumerating the possible outcomes of rolling 3d3, the frequencies of each total:
const dice_sums = [(3, 1), (4, 3), (5, 6), (6, 7), (7, 6), (8, 3), (9, 1)]

# adapted from code by https://github.com/AxlLind
# https://github.com/AxlLind/AdventOfCode2021/blob/main/src/bin/21.rs
@memoize function dirac_dice_game(
    this_player_position::Int64,
    other_player_position::Int64,
    this_player_score::Int64 = 0,
    other_player_score::Int64 = 0
)
    if other_player_score >= 21
        return 0, 1 # other player wins
    end

    score = (0, 0)
    for (roll, times) in dice_sums
        this_player_new_position = new_position(this_player_position, roll)
        this_player_new_score = this_player_score + this_player_new_position
        # Note that the players alternate below
        other_player_wins, this_player_wins = dirac_dice_game(
            other_player_position,
            this_player_new_position,
            other_player_score,
            this_player_new_score
        )
        score = score .+ times .* (this_player_wins, other_player_wins)
    end

    score
end

function part2(input = input)
    players = parse_players(input)
    sort!(players, by = p -> p.number)
    wins = dirac_dice_game(players[1].position, players[2].position)
    maximum(wins)
end

end #module
