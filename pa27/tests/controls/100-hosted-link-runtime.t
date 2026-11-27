#ifndef _REENTRANT
#error The driver must apply -pthread while compiling each source.
#endif

int provider();

int main()
{
	try
	{
		throw provider();
	}
	catch (int value)
	{
		return value == 42 ? 0 : 1;
	}
}
