defmodule PrimeCounter do

  def check_prime(test_value) do
      2..ceil(:math.sqrt(test_value))
        |> Enum.all?(fn divider -> rem(test_value, divider) != 0 end)
  end

  def get_prime_count(max_value) do
    number_of_blocks = System.schedulers_online() * 10

    3..(number_of_blocks + 2)
      |> Stream.map(fn start_value -> start_value..max_value//number_of_blocks end)
      |> Task.async_stream(fn block -> Enum.count(block, &check_prime/1) end, ordered: false, timeout: :infinity)
      |> Enum.reduce(1, fn {:ok, value}, aggregater -> aggregater + value end)
  end
end

{max_value, _} = System.argv()
  |> Enum.at(0)
  |> Integer.parse()

prime_count = PrimeCounter.get_prime_count(max_value)
IO.puts("Elixir: #{prime_count} prime numbers existing up to #{max_value}")
