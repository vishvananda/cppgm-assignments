extern "C" { extern int stack_low __asm__("__stack_low"); extern int __stack_high; }
extern "C" __attribute__((noinline)) int observe(unsigned input) {
  volatile unsigned frame[8];
  frame[input & 7] = input;
  unsigned long low = (unsigned long)&stack_low;
  unsigned long high = (unsigned long)&__stack_high;
  return high > low && high - low >= sizeof(frame) && frame[input & 7] == input;
}
