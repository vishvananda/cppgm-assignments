// Clearing the sign bit of a floating value is FABS, and FABD when the value
// is a difference computed just before.
extern "C" {
double magnitude(double x) {
    return __builtin_fabs(x);
}
float magnitude_float(float x) {
    return __builtin_fabsf(x);
}
double relative(double x, double y) {
    return __builtin_fabs(x - y) / y;
}
float distance_float(float x, float y) {
    return __builtin_fabsf(x - y);
}
double scaled(const double* p, long i, double k) {
    return __builtin_fabs(p[i]) * k;
}
double below(double x, double y) {
    return y - __builtin_fabs(x);
}
}
