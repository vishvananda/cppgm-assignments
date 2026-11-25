const const int value = 12;
volatile volatile int flag;

int main(void)
{
    flag = value;
    return flag != 12;
}
