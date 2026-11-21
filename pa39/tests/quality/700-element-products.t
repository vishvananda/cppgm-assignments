// A floating-point broadcast whose only reader is the next instruction, a
// multiply, is FMUL by element.
extern "C" {
struct Body {
    double x, y, vx, vy;
};
void pull(Body* a, const Body* b, double dt) {
    double dx = a->x - b->x, dy = a->y - b->y;
    double mag = dt / (dx * dx + dy * dy);
    a->vx -= dx * mag;
    a->vy -= dy * mag;
}
void push(Body* a, const Body* b, double dt) {
    double dx = a->x - b->x, dy = a->y - b->y;
    double mag = dt / (dx * dx + dy * dy);
    a->vx += mag * dx;
    a->vy += mag * dy;
}
}
