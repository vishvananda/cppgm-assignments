static thread_local auto count = 3;
extern _Thread_local int count;

int main(void)
{
    count += 4;
    return count != 7;
}
