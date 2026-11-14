#define FIRST(_$, second, ...) _$
#define JOIN_RAW(a, b) a ## b
#define JOIN(a, b) JOIN_RAW(a, b)
int source$ = 17;
int $target = 23;
int main() {
  return FIRST(source$, 0) + JOIN($, target) - 40;
}
