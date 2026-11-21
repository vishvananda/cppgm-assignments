// Placement prices a branch as the code it becomes: a conditional branch
// over a jump to an edge without moves is inverted into one taken branch,
// and a back edge's few register moves run before a branch whose other
// edge falls through. The scan over the balls below therefore keeps its
// test at the bottom, entered by falling into the body, rather than above
// the body with a jump into it.
struct Vec {
    double x, y, z;
};

struct Ball {
    Vec center;
    double radius;
    Vec color;
};

struct Maybe {
    double value;
    bool present;
};

static Maybe intersect(const Vec& dir, const Vec& c, double radius) {
    const double tca = c.x * dir.x + c.y * dir.y + c.z * dir.z;
    if (tca < 0.0)
        return {0, false};
    const double d2 = c.x * c.x + c.y * c.y + c.z * c.z - tca * tca;
    const double r2 = radius * radius;
    if (d2 > r2)
        return {0, false};
    const double t0 = tca - __builtin_sqrt(r2 - d2);
    if (t0 > 10000.0)
        return {0, false};
    return {t0, true};
}

extern "C" unsigned render(const Ball* scene, const Ball* end, int w, int h) {
    unsigned total = 0;
    for (int j = 0; j < h; j++)
        for (int i = 0; i < w; i++) {
            const Vec dir{(i - w / 2.0) / w, (j - h / 2.0) / h, 1.0};
            Maybe t{0, false};
            const Ball* hit = nullptr;
            for (const Ball* b = scene; b != end; ++b) {
                const Maybe m = intersect(dir, b->center, b->radius);
                if (m.present) {
                    t = m;
                    hit = b;
                    break;
                }
            }
            char pixel = ' ';
            if (hit && t.present)
                pixel = static_cast<char>((t.value > 2.5 ? 64 : 96) + (hit - scene));
            total += static_cast<unsigned char>(pixel);
        }
    return total;
}
