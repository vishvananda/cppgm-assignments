struct Selection { char bytes[1]; };
struct Branch { char bytes[1]; };
struct Pretest { char bytes[1]; };
struct Posttest { char bytes[1]; };
struct Counting { char bytes[1]; };
struct Dispatch { char bytes[1]; };
struct Braced { char bytes[1]; };

int main(void)
{
    if (sizeof(struct Selection { char bytes[4]; }))
        (void)sizeof(struct Branch { char bytes[4]; });
    while (sizeof(struct Pretest { char bytes[4]; }) == 0)
        ;
    do
        {}
    while (sizeof(struct Posttest { char bytes[4]; }) == 0);
    for ((void)sizeof(struct Counting { char bytes[4]; }); 0; )
        ;
    switch (sizeof(struct Dispatch { char bytes[4]; }))
    {
    default:
        (void)sizeof(struct Braced { char bytes[4]; });
    }
    return sizeof(struct Selection) != CONTROL_SIZE ||
           sizeof(struct Branch) != CONTROL_SIZE ||
           sizeof(struct Pretest) != CONTROL_SIZE ||
           sizeof(struct Posttest) != CONTROL_SIZE ||
           sizeof(struct Counting) != CONTROL_SIZE ||
           sizeof(struct Dispatch) != CONTROL_SIZE ||
           sizeof(struct Braced) != 1;
}
