module Day01

using Chain
using ShiftedArrays

import ..DATA_DIR # from parent module

export part1, part2

const DATA_FILE = joinpath(DATA_DIR, "day01")
const INPUT = readlines(DATA_FILE) # read into an array, each line is an element

# PART 1 
part1 = function ()
    @chain INPUT begin
        map(x -> parse(Int32, x), _) # convert strings to integers
        _ .- lag(_) # compute difference with previous value
        _[2:end] # remove first element, which will be missing
        filter(x -> x > 0, _) # filter to the increases in value
        length # now count
    end
end

# PART 2
part2 = function ()
    @chain INPUT begin
        map(x -> parse(Int32, x), _) # convert strings to integers
        _ + lag(_) + lag(_, 2) # compute the sum of each value with its previous 2
        _ - lag(_) # now compute the difference with the previous element
        _[4:end] # remove first three elements, since we're summing triples
        filter(x -> x > 0, _) # filter to positive values, which are the increases in value
        length # now count
    end
end

end # module
