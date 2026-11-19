extern "C" int dispatch(int tag, int (*callback)(int), int x) {
    switch (tag) {
    case -201: return callback(x + 1);
    case 3:
    case 4:
    case 5: return callback(x + 2);
    case 9001: return callback(x + 3);
    default: return callback(x - 1);
    }
}
extern "C" int dense(long tag, int (*f)(int), int x) {
    switch (tag) {
    case -5: return f(x) + x;
    case -4: return f(x - 2) - x;
    case -2:
    case -1: return f(x) ^ x;
    case 0:  return f(x * x);
    case 1:  return f(x + 2) + 1;
    case 3:  return x - f(x);
    case 4:  return x | f(x+1);
    default: return f(x) + 13;
    }
}

extern "C" int classify_char(int c, int (*f)(int)) {
    switch (c) {
    case -1: return f(1);
    case 10: return f(2) + 2;
    case 9: case 11: case 12: case 13: case 32: case 47: return f(3) - 1;
    default: return f(c & 1) + 7;
    }
}

extern "C" int classify_span(const char* first, const char* last, int (*f)(int)) {
    switch (last - first) {
    case 3: if (*first == 'x') return f(3); ++first; [[fallthrough]];
    case 2: if (*first == 'x') return f(2); ++first; [[fallthrough]];
    case 1: if (*first == 'x') return f(1); [[fallthrough]];
    default: return f(0);
    }
}

struct Code { unsigned char kind, count, offset; };
extern "C" Code code_for(int n) {
    switch (n) {
    case -103: return {1, 0, 19};
    case -102: return {1, 1, 19};
    case -100: return {1, 2, 19};
    case -99: return {1, 3, 19};
    case -98: return {1, 4, 19};
    case -97: return {1, 5, 19};
    case 65530: return {7, 0, 251};
    case 65531: return {7, 1, 251};
    case 65532: return {7, 2, 251};
    case 65534: return {7, 3, 251};
    case 65535: return {7, 4, 251};
    case 65536: return {7, 5, 251};
    default: return {255, 6, 0};
    }
}
