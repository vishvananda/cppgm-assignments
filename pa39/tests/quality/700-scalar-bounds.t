// A minimum or maximum of two scalars is FCMP and FCSEL in either operand
// order, and a comparison left with no reader emits nothing. The bounds
// keep the operand that the C++ expression selects for NaN and signed zero.
template <class T> const T& min_of(const T& a, const T& b) { return (b < a) ? b : a; }
template <class T> const T& max_of(const T& a, const T& b) { return (a < b) ? b : a; }

extern "C" {
double lowest(double a, double b) { return min_of(a, b); }
double highest(double a, double b) { return max_of(a, b); }
double low_half(double x) { return min_of(0.5, x); }
double high_one(double x) { return max_of(1.0, x); }
float lowestf(float a, float b) { return min_of(a, b); }
float low_halff(float x) { return min_of(0.5f, x); }
double limit(double g, double e) { return 1.0 / max_of(g * g, e); }
double flux(double F_n, double A_n, double F_i, double A_i, double V_n, double V_i, double dt) {
    return -0.5 * dt * ((F_n * A_n * min_of(1.0, A_i / A_n) - F_i * A_i * min_of(1.0, A_n / A_i)) /
                        (V_n * min_of(0.5, V_i / V_n) + V_i * min_of(0.5, V_n / V_i)));
}
}
