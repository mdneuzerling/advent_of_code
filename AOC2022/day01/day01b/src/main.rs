use core::str::Split;

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = solve(include_str!("../../test.txt"));
        assert_eq!(result, 45000);
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
    let mut calories = split
        .map(|elf| sum_calorie_lines(elf))
        .collect::<Vec<i32>>();
    calories.sort_by(|a, b| b.cmp(a));
    calories.truncate(3);
    // let calories_sorted = calories.collect::<Vec<i32>>().sort_by(|a, b| b.cmp(a));
    return calories.iter().sum();
}

fn main() {
    println!("{}", solve(include_str!("../../input.txt")));
}
