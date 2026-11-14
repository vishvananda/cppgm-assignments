struct Quad { long double value; };
struct Envelope { char tag; long double value; };
extern "C" int read_values(int, ...);
extern "C" int observe() {
  Quad singleton = {-0.0L};
  Envelope envelope = {11, 3.0L};
  __int128 wide = (static_cast<__int128>(1) << 95) + 33;
  long double explicit_source = 5.0L;
  return read_values(7, 5, 1.5L, static_cast<__float128>(explicit_source), 6,
                     wide, -2.25L, singleton, envelope, 19);
}
