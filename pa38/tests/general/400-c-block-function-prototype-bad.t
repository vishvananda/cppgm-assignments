int callback(void);

void call(void)
{
    extern int callback();
    callback(1);
}
