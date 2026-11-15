#define JOIN_(a,b) a##b
#define JOIN(a,b) JOIN_(a,b)
#define TEXT_(x) #x
#define TEXT(x) TEXT_(x)
#define ID_DEBUG_NEW new(0)
#define new ID_DEBUG_NEW
#if !defined(new)
#error missing keyword macro
#endif
new int(42);
JOIN(n,ew) int(17);
TEXT(new)
#undef new
#ifdef new
#error keyword macro not removed
#endif
new int(23);
#define delete release
JOIN(del,ete)(pointer);
TEXT(delete)
#undef delete
delete pointer;
