struct Pair
{
  unsigned long first;
  unsigned long second;
};

extern "C" void copy_pair(Pair *dst, const Pair *src);
extern "C" void clear_pair(Pair *dst);
extern "C" unsigned long sum_pair(unsigned long first, ...);
