import sys
import math
import multiprocessing

class PrimeCounter:

    @staticmethod
    def check_prime(test_value):
        if test_value % 2 == 0:
            return False
        return all(test_value % i for i in range(3, int(math.sqrt(test_value)) + 1, 2))

    @staticmethod
    def get_prime_count_block(block):
        return sum(PrimeCounter.check_prime(value) for value in block)
            
    @staticmethod
    def get_prime_count(max_value):
        number_of_blocks = multiprocessing.cpu_count() * 10

        with multiprocessing.Pool() as pool:
            block_results = list(pool.imap_unordered(
                                    PrimeCounter.get_prime_count_block,
                                    ((range(start_value, max_value + 1, number_of_blocks)) for start_value in range(3, (number_of_blocks + 3)))))

        return sum(block_results) + 1

if __name__ == '__main__':
    max_value = int(sys.argv[1])
    
    prime_count = PrimeCounter.get_prime_count(max_value)
    print(f"Python: {prime_count} prime numbers up to {max_value}")