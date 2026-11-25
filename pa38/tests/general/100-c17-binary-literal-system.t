#include "100-c17-binary-literal-system.inc/system.h"
#if PROJECT_BINARY != 42
#error wrong preprocessing value
#endif
int main(void) { return in_header() != PROJECT_BINARY; }
