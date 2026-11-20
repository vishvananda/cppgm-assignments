// expect exit 0
using Predicate = int (*)(int);

int increment(int n) { return n + 1; }

struct Callback
{
    operator Predicate() const { return increment; }
};

int main()
{
    Callback callback;
    return (*callback)(41) != 42;
}
