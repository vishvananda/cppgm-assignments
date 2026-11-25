typedef int Status;
static const enum Status *selected;
enum Status;

struct Box
{
    enum Status *item;
    int (*read)(enum Status);
};

extern enum Status current;
enum Status get(void);

enum Status { idle = -1, busy = 7 };
enum Status current = busy;

enum Status get(void) { return current; }
static int read(enum Status value) { return value; }

int main(void)
{
    typedef int Box;
    struct Box box = { &current, read };
    Status expected = busy;
    selected = &current;
    if (get() != expected || box.read(*box.item) != expected)
        return 1;
    *box.item = idle;
    return *selected != idle;
}
