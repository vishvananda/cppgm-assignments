struct Entry { const int* number; int (*call)(); };

static const int first_number = 15;
static const int second_number = 27;
static int first_call() { return 31; }
static int second_call() { return 93; }

__attribute__((used, section(".custom_entries")))
static const Entry first = {&first_number, first_call};
__attribute__((used, section(".custom_entries")))
static const Entry second = {&second_number, second_call};

int main()
{
    const volatile Entry* a = &first;
    const volatile Entry* b = &second;
    return *a->number != 15 || *b->number != 27 || a->call() != 31 || b->call() != 93;
}
