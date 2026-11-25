#define NUMBER 0x1p??/ 	+3
#define ADD 1\ 	+2
#if ADD != 3
#error wrong macro value
#endif
#if 0
// Hide the following #endif. \ 	#endif
#endif
int main(void) { return NUMBER != 8.0; }
