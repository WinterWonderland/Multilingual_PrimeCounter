$max_value = 10000000

Write-Output ""
Write-Output ""
Write-Output "compare results:"
Write-Output ""

mix run --no-mix-exs elixir/prime_counter.exs $max_value
python python/prime_counter.py $max_value
dotnet run --project cs/PrimeCounter.csproj $max_value

Write-Output ""
Write-Output ""
Write-Output "measure runtime:"
Write-Output ""

$elixir_result = (Measure-Command { mix run --no-mix-exs elixir/prime_counter.exs $max_value }).ToString()
Write-Output "Elixir: $elixir_result"

$python_result = (Measure-Command { python python/prime_counter.py $max_value }).ToString()
Write-Output "Python: $python_result"

$cs_result = (Measure-Command { cs/bin/PrimeCounter $max_value }).ToString()
Write-Output "C#:     $cs_result"

Write-Output ""
Write-Output ""
