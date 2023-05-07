var max_value = int.Parse(args[0]);

var prime_count = PrimeCounter.get_prime_count(max_value);
Console.WriteLine($"C#:     {prime_count} prime numbers existing up to {max_value}");

class PrimeCounter
{
    public static bool check_prime(int test_value)
    {
        return Enumerable.Range(2, Math.Max((int)Math.Sqrt(test_value) - 1, 0))
            .All(divider => test_value % divider != 0);
    }

    public static int get_prime_count(int max_value)
    {
        var number_of_blocks = Environment.ProcessorCount * 10;

        return Enumerable.Range(3, number_of_blocks)
            .Select(start_value => Enumerable.Range(start_value, Math.Max(max_value - start_value, 0))
                .Where((elem, idx) => idx % number_of_blocks == 0))
            .AsParallel()
            .Select(block => block.Count(value => check_prime(value)))
            .Aggregate(1, (aggregater, value) => aggregater + value);
    }
}
