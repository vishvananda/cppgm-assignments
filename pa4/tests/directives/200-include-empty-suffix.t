#define EMPTY
#define DISCARD(x)
#include "include-empty-suffix.h" EMPTY
#include <./include-empty-suffix.h> DISCARD(ignored)
