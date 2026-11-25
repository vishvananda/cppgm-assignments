#define TERMS a01 + a02 + a03 + a04 + a05 + a06 + a07 + a08 + a09 + a10 \
            + a11 + a12 + a13 + a14 + a15 + a16 + a17 + a18 + a19 + a20
#define WRAP(x) ( x )
#define TWICE(x) x , x
#define CALL(x) [ x ]
#define APPLY(x) CALL x
#define NAME_AT_END(x) x CALL
#define ADD_ARGS(x) x (after)
#define STR_RAW(x) #x
#define STR(x) STR_RAW(x)
#define JOIN_RAW(a, b) a ## b
#define JOIN(a, b) JOIN_RAW(a, b)

TWICE(WRAP(WRAP(WRAP(TERMS))))
WRAP(APPLY(WRAP(WRAP(TERMS))))
WRAP(ADD_ARGS(NAME_AT_END(WRAP(WRAP(TERMS)))))
STR(WRAP(WRAP(WRAP(TERMS))))
JOIN(prefix_, suffix WRAP(WRAP(TERMS)))
