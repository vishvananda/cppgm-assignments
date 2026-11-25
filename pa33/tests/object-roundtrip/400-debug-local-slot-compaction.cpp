int main()
{
	int removed = 4;
	volatile int survivor = removed + 3;
	return survivor != 7;
}
