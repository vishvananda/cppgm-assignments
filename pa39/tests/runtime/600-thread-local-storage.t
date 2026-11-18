thread_local int seed = 13;
thread_local int zero;
extern "C" int* tls_seed() { return &seed; }
extern "C" int* tls_zero() { return &zero; }
