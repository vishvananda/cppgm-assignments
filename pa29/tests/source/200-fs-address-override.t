extern "C" const void* thread_pointer()
{
    const void* result;
    asm("movq %%fs:0, %0" : "=r"(result));
    return result;
}
