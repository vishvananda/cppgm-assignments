// Vector loops whose lanes are widened, narrowed, shifted into an
// accumulator, halved, loaded or stored eight bytes at a time: SXTL, UXTL,
// SADDW, UADDW, SSRA, USRA, SHADD of lanes whose sum cannot overflow, a
// single SQXTN for a vector packed with itself, and LDR D or STR D for an
// eight-byte lane transfer. wrap's sum can overflow and keeps ADD and SSHR. train and dot_product are
// PAQ8p's. The inputs reach the saturation bounds, the lane extremes and
// lengths that leave a scalar tail.
extern "C" {
void train(short *t, short *w, int n, int err) {
  n=(n+7)&-8;
  for (int i=0; i<n; ++i) {
    int wt=w[i]+(((t[i]*err*2>>16)+1)>>1);
    if (wt<-32768) wt=-32768;
    if (wt>32767) wt=32767;
    w[i]=wt;
  }
}
int dot_product(short *t, short *w, int n) {
  int sum=0;
  n=(n+7)&-8;
  for (int i=0; i<n; i+=2)
    sum+=(t[i]*w[i]+t[i+1]*w[i+1]) >> 8;
  return sum;
}
void widen8(short* d, const signed char* s, int n) { for (int i = 0; i < n; ++i) d[i] = s[i]; }
void widen8u(short* d, const unsigned char* s, int n) { for (int i = 0; i < n; ++i) d[i] = s[i]; }
void widen16(int* d, const short* s, int n) { for (int i = 0; i < n; ++i) d[i] = s[i]; }
void widen16u(int* d, const unsigned short* s, int n) { for (int i = 0; i < n; ++i) d[i] = s[i]; }
void addw16(int* d, const short* s, int n) { for (int i = 0; i < n; ++i) d[i] += s[i]; }
void addw16u(int* d, const unsigned short* s, int n) { for (int i = 0; i < n; ++i) d[i] += s[i]; }
int sum16(const short* s, int n) { int t = 0; for (int i = 0; i < n; ++i) t += s[i]; return t; }
unsigned sum16u(const unsigned short* s, int n) { unsigned t = 0; for (int i = 0; i < n; ++i) t += s[i]; return t; }
int sra_sum(const int* s, int n) { int t = 0; for (int i = 0; i < n; ++i) t += s[i] >> 3; return t; }
unsigned srl_sum(const unsigned* s, int n) { unsigned t = 0; for (int i = 0; i < n; ++i) t += s[i] >> 5; return t; }
void halve(int* d, const int* a, int n) { for (int i = 0; i < n; ++i) d[i] = ((a[i] >> 1) + 1000) >> 1; }
void halve2(int* d, const int* a, const int* b, int n) {
  for (int i = 0; i < n; ++i) d[i] = ((a[i] >> 1) + (b[i] >> 2)) >> 1;
}
void wrap(int* d, const int* a, const int* b, int n) {
  for (int i = 0; i < n; ++i) d[i] = (int)((unsigned)a[i] + (unsigned)b[i]) >> 1;
}
void narrow32(short* d, const int* s, int n) {
  for (int i = 0; i < n; ++i) { int v = s[i]; d[i] = v > 32767 ? 32767 : v < -32768 ? -32768 : v; }
}
}
