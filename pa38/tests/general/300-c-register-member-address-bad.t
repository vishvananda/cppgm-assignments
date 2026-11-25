struct Inner { int value; };
struct Outer { struct Inner inner; };

int *address(void)
{
    register struct Outer object = {{7}};
    return &((object.inner).value);
}
