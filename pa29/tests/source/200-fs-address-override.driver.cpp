extern "C" const void* thread_pointer();

int main()
{
    return thread_pointer() != __builtin_thread_pointer();
}
