var max_value = Int32.Parse(args[0]);

var prime_count = PrimeCounter.get_prime_count(max_value);
Console.WriteLine($"C#: {prime_count} prime numbers up to {max_value}");

class PrimeCounter
{
    public static bool check_prime(int test_value)
    {
        if (test_value % 2 == 0)
            return false;

        return Enumerable.Range(3, Math.Max((int)Math.Sqrt(test_value) - 2, 0))
            .Where(i => i % 2 != 0)
            .All(i => test_value % i != 0);
    }

    public static int get_prime_count(IEnumerable<int> block)
    {
        return block.Select(value => check_prime(value))
        .Count(result => result);
    }

    public static int get_prime_count(int max_value)
    {
        var number_of_blocks = Environment.ProcessorCount * 10;

        return Enumerable.Range(3, number_of_blocks)
            .Select(start_value => Enumerable.Range(start_value, Math.Max(max_value - start_value, 0))
                .Where((elem, idx) => idx % number_of_blocks == 0))
            .AsParallel()
            .Select(block => get_prime_count(block))
            .Aggregate(1, (aggregator, value) => aggregator + value);
    }
}