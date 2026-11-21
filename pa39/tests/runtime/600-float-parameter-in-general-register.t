// The float parameter a7 arrives in v7 and stays live across calls to a leaf
// while nine floats hold the SIMD registers that leaf preserves, so it takes a
// general register. That register must not be x7, where the integer parameter
// b7 arrives: the prologue moves a7 before it reads b7.
static __attribute__((noinline)) unsigned long leaf(unsigned long x) { return x * 3 + 1; }
extern "C" __attribute__((noinline)) unsigned long other(unsigned long x) { return x ^ 0x1234; }

__attribute__((noinline)) unsigned long f(float a0, float a1, float a2, float a3, float a4, float a5, float a6,
	float a7, long b0, long b1, long b2, long b3, long b4, long b5, long b6, long b7, const float* p)
{
	float c0 = p[0], c1 = p[1], c2 = p[2], c3 = p[3], c4 = p[4], c5 = p[5], c6 = p[6], c7 = p[7], c8 = p[8];
	unsigned long s = 5;
	for (int i = 0; i < 40; ++i)
	{
		s += leaf(s + i);
		c0 += p[(i + 1) & 15];
		c1 *= 0.999f;
		c2 += c0;
		c3 -= c1;
		c4 += c2 * 0.5f;
		c5 += c3;
		c6 -= c4;
		c7 += c5;
		c8 += c6;
	}
	s += (unsigned long)(long)(a7 * 2.0f);
	s += other(s);
	return s + (unsigned long)b7 * 7 + (unsigned long)(long)(c0 + c1 + c2 + c3 + c4 + c5 + c6 + c7 + c8);
}

int main()
{
	static float p[16];
	for (int i = 0; i < 16; ++i)
		p[i] = (float)(i % 5) * 0.25f;
	unsigned long r = f(1, 2, 3, 4, 5, 6, 7, 8.5f, 10, 20, 30, 40, 50, 60, 70, 300000, p);
	return (int)(r % 251);
}
