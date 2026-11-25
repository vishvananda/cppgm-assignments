#include "c-universal-escape-system.h"

int main(void)
{
    return escaped_quote[0] != '"' || escaped_quote[1] != 0;
}
