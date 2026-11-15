struct Incomplete;
int safe() noexcept;
int throwing();
int test() {
  return requires { typename Incomplete; } + requires(int a[3]) { a[0]; } + requires { { safe() } noexcept; }
       + requires { { throwing() } noexcept; };
}
