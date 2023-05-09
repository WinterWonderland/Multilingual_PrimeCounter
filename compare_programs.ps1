$max_value = 10000000

New-Item -ItemType Directory -Force -Path cpp/bin | Out-Null
g++ -O2 cpp/prime_counter.cpp -o cpp/bin/PrimeCounter

New-Item -ItemType Directory -Force -Path c/bin | Out-Null
gcc -O2 c/prime_counter.c -o c/bin/PrimeCounter

Write-Output ""
Write-Output ""
Write-Output "compare results:"
Write-Output ""

mix run --no-mix-exs elixir/prime_counter.exs $max_value
python python/prime_counter.py $max_value
dotnet run --project cs/PrimeCounter.csproj $max_value
cpp/bin/PrimeCounter.exe $max_value
c/bin/PrimeCounter.exe $max_value

Write-Output ""
Write-Output ""
Write-Output "measure runtime:"
Write-Output ""

$result = (Measure-Command { mix run --no-mix-exs elixir/prime_counter.exs $max_value }).ToString()
Write-Output "Elixir: $result"

$result = (Measure-Command { python python/prime_counter.py $max_value }).ToString()
Write-Output "Python: $result"

$result = (Measure-Command { cs/bin/PrimeCounter $max_value }).ToString()
Write-Output "C#:     $result"

$result = (Measure-Command { cpp/bin/PrimeCounter.exe $max_value }).ToString()
Write-Output "C++:    $result"

$result = (Measure-Command { c/bin/PrimeCounter.exe $max_value }).ToString()
Write-Output "C:      $result"

Write-Output ""
Write-Output ""
