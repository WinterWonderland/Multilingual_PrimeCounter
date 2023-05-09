#include <string>
#include <cmath>
#include <thread>
#include <future>
#include <vector>
#include <iostream>

using namespace std;

class PrimeCounter
{
    public: static bool check_prime(int test_value)
    {
        for (auto divider = 2; divider <= ceil(sqrt(test_value)); divider++)
            if (test_value % divider == 0)
                return false;

        return true;
    }

    public: static int get_prime_count_block(int start, int end, int increment)
    {
        auto prime_counter = 0;

        for (auto value = start; value <= end; value += increment)
            if (check_prime(value))
                prime_counter++;

        return prime_counter;
    }

    public: static int get_prime_count(int max_value)
    {
        const auto number_of_blocks = thread::hardware_concurrency() * 10;
        
        vector<future<int>> tasks;
        for (auto start_value = 3; start_value < number_of_blocks + 3; start_value++)
            tasks.push_back(async(&get_prime_count_block, start_value, max_value, number_of_blocks));

        auto prime_counter = 1;
        for (auto &task : tasks)
            prime_counter += task.get();

        return prime_counter;
    }
};

int main(int argc, char* argv[])
{
    auto max_value = stoi(argv[1]);

    auto prime_count = PrimeCounter::get_prime_count(max_value);
    cout << "C++:    " << prime_count <<   " prime numbers existing up to " << max_value << endl;

    return 0;
}