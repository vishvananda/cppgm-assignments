static int match(unsigned value) {
  switch (value) { case -1: return 1; case -2: return 2; default: return 3; }
}
static int narrow(unsigned char value) {
  switch (value) { case -1: return 4; case 255: return 5; default: return 6; }
}
int main(void) {
  return match(~0u) != 1 || match(~0u-1) != 2 || match(1) != 3 || narrow(255) != 5;
}
