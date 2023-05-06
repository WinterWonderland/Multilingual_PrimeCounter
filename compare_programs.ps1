$max_value = 10000000

Write-Output ""
Write-Output ""
Write-Output "compare results:"
Write-Output ""

mix run --no-mix-exs elixir/prime_counter.exs $max_value

Write-Output ""
Write-Output ""
Write-Output "measure runtime:"
Write-Output ""

$elixir_result = (Measure-Command { mix run --no-mix-exs elixir/prime_counter.exs $max_value}).ToString()

Write-Output "Elixir: $elixir_result"

Write-Output ""
Write-Output ""
