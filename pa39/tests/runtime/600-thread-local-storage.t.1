#ifdef __APPLE__
typedef void* thread_id;
#else
typedef unsigned long thread_id;
#endif
extern "C" int pthread_create(thread_id*, const void*, void* (*)(void*), void*);
extern "C" int pthread_join(thread_id, void**);
extern "C" int* tls_seed();
extern "C" int* tls_zero();
extern thread_local int seed, zero;
int main_result;
void* worker(void* main_address) {
    if (tls_seed() == main_address || tls_seed() != &seed || tls_zero() != &zero) return 0;
    if (seed != 13 || zero != 0) return 0;
    seed = 101;
    zero = 92;
    return &main_result;
}
int main() {
    if (*tls_seed() != 13 || *tls_zero() != 0) return 1;
    seed = 21;
    zero = 72;
    thread_id id;
    void* result = 0;
    if (pthread_create(&id, 0, worker, tls_seed()) || pthread_join(id, &result)) return 2;
    return result == &main_result && *tls_seed() == 21 && *tls_zero() == 72 ? 39 : 3;
}
