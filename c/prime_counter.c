#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <Winbase.h>
#include <pthread.h>

typedef struct thread_data 
{
   pthread_t id;
   int start_value;
   int end_value;
   int increment;
   int prime_counter;
} thread_data;

int check_prime(int test_value)
{
    for (int divider = 2; divider <= ceil(sqrt(test_value)); divider++)
        if (test_value % divider == 0)
            return 0;

    return 1;
}

void* get_prime_count_block(void* arg)
{
    thread_data* data = (thread_data*)arg;
    data->prime_counter = 0;

    for (int value = data->start_value; value <= data->end_value; value += data->increment)
        if (check_prime(value))
            data->prime_counter++;

    return 0;
}

int get_prime_count(int max_value)
{
    const int number_of_blocks = GetActiveProcessorCount(ALL_PROCESSOR_GROUPS) * 10;
    
    thread_data* data = calloc(number_of_blocks, sizeof(thread_data));
    for (int thread_index = 0; thread_index < number_of_blocks; thread_index++)
    {
        data[thread_index].start_value = thread_index + 3;
        data[thread_index].end_value = max_value;
        data[thread_index].increment = number_of_blocks;
        
        pthread_create(&data[thread_index].id, NULL, get_prime_count_block, (void *)&data[thread_index]);
        thread_index++;
    }

    int prime_counter = 1;
    for (int thread_index = 0; thread_index < number_of_blocks; thread_index++)
    {
        pthread_join(data[thread_index].id, NULL);
        prime_counter += data[thread_index].prime_counter;
    }

    return prime_counter;
}

int main(int argc, char* argv[])
{
    int max_value = atoi(argv[1]);

    int prime_count = get_prime_count(max_value);
    printf("C:      %i prime numbers existing up to %i", prime_count, max_value);

    return 0;
}