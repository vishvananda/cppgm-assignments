extern "C" void unused();
extern "C" void unused_weak() __attribute__((weak));
extern "C" int live();

extern "C" int f(int x)
{
	if (x - x)
	{
		unused();
		unused_weak();
	}
	return 3;
}

int main(int argc, char**)
{
	return f(argc) + live();
}
