#define PASTE(a,b) a ## b
#define ORDER <=>
PASTE(<=,>) ORDER
#define same(x) x
same(<=>)
