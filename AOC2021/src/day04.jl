module Day04

import Base.show
import ..data_dir # from parent module

export part1, part2

# Matrix conversion is hard
as_matrix(vectors::Vector{Vector{Int64}}) = Matrix(transpose(hcat(vectors...)))

# Define BingoGame and BingoBoard structs --- a BingoGame is a BingoBoard with state

const bingo_board_size = 5 # number of rows and columns

struct BingoBoard
    definition::Matrix{Int64}
end

function BingoBoard(text_definition::Vector{String})
    parse_row(row) = map(x -> parse(Int, x), split(row))
    as_vectors = map(x -> parse_row(x), text_definition)
    BingoBoard(as_matrix(as_vectors))
end

mutable struct BingoGame
    board::BingoBoard
    state::Matrix{Bool}
end

BingoGame(board::BingoBoard) = BingoGame(
    board,
    zeros(Int64, size(board.definition)...)
)

BingoGame(text_definition::Vector{String}) = BingoGame(BingoBoard(text_definition))

function show(io::IO, game::BingoGame)
    defn = game.board.definition
    rows, cols = size(defn)
    to_print = Vector{String}()
    for row = 1:rows
        row_to_print = Vector{String}()
        for col = 1:cols
            number_to_print = lpad(defn[row, col], 2, " ")
            if game.state[row, col]
                number_to_print = "\033[;1m" * number_to_print * "\033[0m"
            end
            push!(row_to_print, number_to_print)
        end
        push!(to_print, join(row_to_print, " "))
    end
    println(io, join(to_print, "\n"))
end

function show(io::IO, board::BingoBoard)
    show(io, BingoGame(board))
end

# Functions for playing a BingoGame

function update!(game::BingoGame, number::Int)
    match_coords = findfirst(x -> x == number, game.board.definition)
    if !isnothing(match_coords)
        game.state[match_coords] = true
    end
end

function has_won(state::Matrix{Bool})
    winning = false
    for i = 1:bingo_board_size
        if all(state[i, :]) || all(state[:, i])
            winning = true
            break
        end
    end
    winning
end

has_won(game::BingoGame) = has_won(game.state)

function score(game::BingoGame, number)
    negated_state = ones(Bool, size(game.state)...) - game.state
    unmarked_numbers_only = negated_state .* game.board.definition # Hadamard product
    sum_unmarked_numbers = sum(unmarked_numbers_only)
    number * sum_unmarked_numbers
end

# Parse the input 
const data_file = joinpath(data_dir, "day04")
const input = readlines(data_file) # read into an array, each line is an element
const numbers = map(x -> parse(Int, x), split(input[1], ","))
const input_without_numbers = filter(x -> x != "", input)[2:end]
const board_inputs = [
    input_without_numbers[i:i+4]
    for i in range(1, Int(length(input_without_numbers)), step = bingo_board_size)
]
const bingo_boards = [BingoBoard(x) for x in board_inputs]

"""
Iterate through all of the numbers until a winning game is identified, then stop.
If multiple games win in a single round, we take the first in the array.
"""
function part1()
    println("Let's play Bingo!\n")
    games = [BingoGame(board) for board in bingo_boards]
    winning_game = nothing
    number_index = 0
    while isnothing(winning_game)
        number_index += 1
        number = numbers[number_index]
        println("Turn " * string(number_index) * " with number " * string(number))
        for game in games
            update!(game, number)
            # Don't check for a win before turn 5
            if number_index >= 5 && has_won(game)
                winning_game = game
                break
            end
        end
    end
    println()
    println("Winner with score " * string(score(winning_game, numbers[number_index])))
    println()
    winning_game
end

"""
A little different to part 1. We need to find the _last_ game to win. The approach here
is to update every game, and then identify the first game in the array to win.
Then we remove all winning games and continue until all of the games are won. This way
we're constantly updating _winning_game_ with the most recent victory, and the last
iteration of the `while` loop will evaluate the last games to win.
"""
function part2()
    println("Let's play Bingo!\n")
    games = [BingoGame(board) for board in bingo_boards]
    winning_game = nothing
    number_index = 0
    while length(games) > 0
        number_index += 1
        number = numbers[number_index]
        println("Turn " * string(number_index) * " with number " * string(number))
        for game in games
            update!(game, number)
        end
        for game in games
            # Don't check for a win before turn 5
            if number_index >= 5 && has_won(game)
                winning_game = game
                break
            end
        end
        games = games[(!has_won).(games)]
    end
    println()
    println("Winner with score " * string(score(winning_game, numbers[number_index])))
    println()
    winning_game
end

end # module
