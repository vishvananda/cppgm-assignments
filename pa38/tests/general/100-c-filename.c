#if defined(__cplusplus) || __STDC_VERSION__ != 201710L || defined(__STRICT_ANSI__)
#error expected GNU C17 for a .c input
#endif

int main(void)
{
	int value = 7;
	void *opaque = &value;
	int *pointer = opaque;
	return *pointer != 7;
}
