// A positive floating zero is stored from the zero register, and adjacent
// zero stores are a pair.
extern "C" {
struct Sums {
    double a, b, c, d;
};
void clear(Sums* s) {
    s->a = 0.0;
    s->b = 0.0;
    s->c = 0.0;
    s->d = 0.0;
}
void clear_floats(float* p) {
    p[0] = 0.0f;
    p[1] = 0.0f;
    p[3] = 0.0f;
}
void negative_zero(double* p, float* q) {
    p[0] = -0.0;
    q[0] = -0.0f;
}
}
