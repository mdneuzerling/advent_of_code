use core::str::Split;
use once_cell::sync::Lazy;
use std::collections::HashMap;

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn individual_play_1() {
        let result = score('A', 'Y');
        assert_eq!(result, 8);
    }

    #[test]
    fn individual_play_2() {
        let result = score('B', 'X');
        assert_eq!(result, 1);
    }

    #[test]
    fn individual_play_3() {
        let result = score('C', 'Z');
        assert_eq!(result, 6);
    }

    #[test]
    fn aoc_example() {
        let result = solve(include_str!("../../test.txt"));
        assert_eq!(result, 15);
    }
}

// for reasons that aren't entirely clear to me, Rust is very picky about what
// can be used in a static, and it doesn't like static hashmaps. Possibly
// this is because hashmaps store their data on the heap, and heap allocation
// is performed at runtime. By using lazy evaluation we defer the definition
// of this hashmap to runtime (see this take place in the main function)
// One other note here: || is a nullary closure. So the function that returns
// the actual hashmap is called in runtime.
static SHAPE_VALUES: Lazy<HashMap<char, u32>> =
    Lazy::new(|| HashMap::from([('X', 1), ('Y', 2), ('Z', 3)]));

fn score(opponent: char, response: char) -> u32 {
    // We use the & here because .get returns the reference of the value,
    // not the value itself)
    let shape_score: &u32 = SHAPE_VALUES
        .get(&response)
        // could use .expect here but with string formatting it will be
        // expensive as it will format even if there is no error.
        .unwrap_or_else(|| panic!("unexpected response {}", response));
    let outcome_score: u32 = if is_draw(opponent, response) {
        3
    } else if is_winning_response(opponent, response) {
        6
    } else {
        0
    };
    let result: u32 = shape_score + outcome_score;

    return result;
}

fn score_play(play: Vec<char>) -> u32 {
    let opponent: char = play[0];
    let response: char = play[1];
    return score(opponent, response);
}

fn is_draw(opponent: char, response: char) -> bool {
    return (opponent == 'A' && response == 'X') || // rock met with rock
    (opponent == 'B' && response == 'Y') || // paper met with paper
    (opponent == 'C' && response == 'Z'); // scissors met with scissors
}

fn is_winning_response(opponent: char, response: char) -> bool {
    return (opponent == 'A' && response == 'Y') || // rock met with paper
    (opponent == 'B' && response == 'Z') || // paper met with scissors
    (opponent == 'C' && response == 'X'); // scissors met with rock
}

fn get_play_from_line(input_line: &str) -> Vec<char> {
    let mut chars_in_line: Vec<char> = input_line.chars().collect();
    chars_in_line.retain(|&x| x != ' ');
    return chars_in_line;
}

fn solve(input: &str) -> u32 {
    let lines: Split<&str> = input.split("\n");
    let plays = lines.map(|line: &str| get_play_from_line(line));
    let scores = plays.map(|play: Vec<char>| -> u32 { score_play(play) });
    return scores.sum::<u32>();
}

fn main() {
    let solution = solve(include_str!("../../input.txt"));
    println!("{}", solution);
}
