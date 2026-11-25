static const unsigned char lengths[] = { 4, 2, 6 };

extern "C" __attribute__((cold, noinline)) unsigned int total_length()
{
  unsigned int total = 1;
  for (int i = 0; i < sizeof lengths; ++i)
    total += lengths[i];
  return total;
}

int main()
{
  return total_length() != 13;
}
