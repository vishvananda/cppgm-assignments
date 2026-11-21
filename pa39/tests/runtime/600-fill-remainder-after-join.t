// A join after an array fill takes the array's start from the fill and from
// two branches of the fill's remainder, which comes after the join in the
// layout, and null when the array is empty. Every transfer that reaches the
// join from behind carries the start that a forward transfer already carries.
unsigned* take(unsigned long count);
void reset();

struct span
{
	unsigned* first;
	unsigned* last;
};

span fill(unsigned long n, unsigned value)
{
	unsigned* p = nullptr;
	unsigned* q;
	if (n == 0)
		goto done;
	p = take(n);
	q = p;
	for (unsigned long k = 0; k + 4 <= n; k += 4, q += 4)
	{
		q[0] = value;
		q[1] = value;
		q[2] = value;
		q[3] = value;
	}
	if (q != p + n)
		goto rest;
done:
	return span{ p, p + n };
rest:
	*q++ = value;
	if (q == p + n)
		goto done;
	do
		*q++ = value;
	while (q != p + n);
	goto done;
}

int main()
{
	unsigned sum = 0;
	for (unsigned long n = 0; n < 12; ++n)
	{
		const span s = fill(n, n + 1);
		for (unsigned* p = s.first; p != s.last; ++p)
			sum += *p;
		reset();
	}
	return sum % 251;
}
