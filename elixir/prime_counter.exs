defmodule PrimeCounter do

  def check_prime(test_value) do
    if rem(test_value, 2) == 0 do
      false
    else
      3..trunc(:math.sqrt(test_value) + 1)//2
        |> Stream.map(fn i -> rem(test_value, i) end)
        |> Enum.all?(fn i -> i > 0 end)
    end
  end

  def get_prime_count(start_value, max_value, number_of_blocks) do
    start_value..max_value//number_of_blocks
      |> Stream.map(&check_prime/1)
      |> Enum.count(fn b -> b end)
  end

  def get_prime_count(max_value) do
    number_of_blocks = System.schedulers_online() * 10

    3..(number_of_blocks + 2)
      |> Task.async_stream(PrimeCounter, :get_prime_count, [max_value, number_of_blocks], ordered: false, timeout: :infinity)
      |> Enum.reduce(1, fn {:ok, num}, acc -> num + acc end)
  end
end

{max_value, _} = System.argv()
  |> Enum.at(0)
  |> Integer.parse()

prime_count = PrimeCounter.get_prime_count(max_value)
IO.puts("Elixir: #{prime_count} prime numbers up to #{max_value}")
