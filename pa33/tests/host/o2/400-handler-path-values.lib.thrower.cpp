typedef unsigned long U;
extern "C" U maythrow(U x)
{
	if (x % 13 == 5)
		throw static_cast<int>(x & 255);
	return x + 11;
}
