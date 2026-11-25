#define HEADER < c-include-leading.h >
#if !__has_include(HEADER)
#error computed angle probe lost the leading space
#endif
#include HEADER

int main(void) {
    return lead_value != 23;
}
