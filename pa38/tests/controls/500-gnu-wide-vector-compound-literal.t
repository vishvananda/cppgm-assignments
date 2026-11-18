// expect exit 0
typedef int v8si __attribute__((vector_size(32)));
typedef int v16si __attribute__((vector_size(64)));

int main(void)
{
  int next = 1;
  v8si a = (v8si){next++, next++, 3, 4, 5, 6, 7, 8};
  v8si b = __builtin_ia32_pshufd256(a, 0x1b);
  v16si c = (v16si){10, 20, 30, 40};
  v16si d = __builtin_ia32_pshufd512_mask(c, 0x1b, c, 5);
  v16si e = __builtin_ia32_pternlogd512_mask(c, d, (v16si){3}, 0x96, 1);
  return next != 3 || b[0] != 4 || b[3] != 1 || b[4] != 8 || b[7] != 5
    || d[0] != 40 || d[1] != 20 || d[2] != 20 || d[3] != 40 || d[15] != 0
    || e[0] != (10 ^ 40 ^ 3) || e[1] != 20;
}
