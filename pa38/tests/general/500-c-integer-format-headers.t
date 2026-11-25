#include <inttypes.h>

#define CHECK_FORMAT(name) typedef char check_##name[sizeof("%" name) >= 3 ? 1 : -1]

CHECK_FORMAT(PRId8);
CHECK_FORMAT(SCNi16);
CHECK_FORMAT(PRId32);
CHECK_FORMAT(SCNo64);
CHECK_FORMAT(SCNuLEAST16);
CHECK_FORMAT(PRIXFAST8);
CHECK_FORMAT(PRIxPTR);
CHECK_FORMAT(PRIdMAX);
CHECK_FORMAT(SCNdMAX);

int main(void)
{
    return 0;
}
