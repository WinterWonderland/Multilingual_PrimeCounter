use std::env;
use async_std::task;
use futures::executor::block_on;

fn check_prime(test_value: i32) -> bool
{
    for devider in 2..((test_value as f64).sqrt() as i32 + 1)
    {
        if test_value % devider == 0
        {
            return false;
        }
    }

    return true;
}

async fn get_prime_count_block(start: i32, end: i32, increment: usize) -> i32
{
    let mut prime_counter = 0;

    for value in (start..=end).step_by(increment)
    {
        if check_prime(value)
        {
            prime_counter += 1;
        }
    }

    return prime_counter;
}

async fn get_prime_count(max_value: i32) -> i32
{
    let number_of_blocks = num_cpus::get() * 10;

    let mut tasks = Vec::new();
    for start_value in 3..=(i32::try_from(number_of_blocks).unwrap() + 3)
    {
         tasks.push(task::spawn(get_prime_count_block(start_value, max_value, number_of_blocks)));
    }

    let mut prime_counter = 1;
    for task in tasks
    {
        prime_counter += task.await;
    }

    return  prime_counter;
}

fn main()
{
    let args: Vec<String> = env::args().collect();
    let max_value = args[1].parse::<i32>().unwrap();

    let prime_count = block_on(get_prime_count(max_value));
    println!("Rust:   {prime_count} prime numbers existing up to {max_value}");
}