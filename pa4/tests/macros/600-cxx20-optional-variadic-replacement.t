#define EMPTY
#define CALL(x, ...) function(x __VA_OPT__(,) __VA_ARGS__)
CALL(1)
CALL(2, EMPTY)
CALL(3, 4, 5)

#define PARTS(...) __VA_OPT__(first (second)) __VA_OPT__(third)
PARTS()
PARTS(1)

#define PREFIX(...) base ## __VA_OPT__(suffix)
PREFIX()
PREFIX(EMPTY)
PREFIX(1)

#define EDGE(x, ...) __VA_OPT__(prefix x ## x) ## suffix
EDGE(, 1)
EDGE(item, 1)

#define EDGES(x, ...) left ## __VA_OPT__(x center x) ## right
EDGES(, 1)
EDGES(EMPTY, 1)

#define LABEL(x, ...) #__VA_OPT__(x ## x x ## x)
LABEL(word)
LABEL(, 1)
LABEL(word, 1)

#define OPEN() (
#define HANDLER(x) [x]
#define INVOKE(open, ...) __VA_OPT__(HANDLER open 7) )
INVOKE(OPEN(), 1)
