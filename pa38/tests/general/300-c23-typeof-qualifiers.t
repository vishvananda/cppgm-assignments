const _Atomic int counter = 0;
extern typeof(counter) counter;
extern typeof_unqual(counter) plain;
int plain;

const int *const selected = &plain;
extern typeof_unqual(selected) pointer;
const int *pointer;

typedef const _Atomic int AtomicMatrix[2][3];
typeof_unqual(AtomicMatrix) atomic_matrix;
extern _Atomic int atomic_matrix[2][3];

const int values[2][3] = {{1, 2, 3}, {4, 5, 6}};
extern typeof(values) values;
typeof_unqual(values) copy;
extern int copy[2][3];

static int add(int a, int b) { return a + b; }
typeof(add) *operation = add;
static_assert(sizeof(typeof("text")) == 5);

int main(void)
{
    plain = 40;
    pointer = &plain;
    copy[0][1] = values[0][1];
    return operation(*pointer, copy[0][1]) != 42;
}
