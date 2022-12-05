use core::str::Split;

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn aoc_example() {
        let result = solve(include_str!("../../test.txt"));
        assert_eq!(result, 24000);
    }
}

fn sum_calorie_lines(calorie_lines: &str) -> i32 {
    return calorie_lines
        .lines()
        .map(|line| line.parse::<i32>().unwrap())
        .sum();
}

fn solve(input: &str) -> i32 {
    let split: Split<&str> = input.split("\n\n");
    let calories = split.map(|elf| sum_calorie_lines(elf));
    return calories.max().unwrap();
}

fn main() {
    println!("{}", solve(include_str!("../../input.txt")));
}
