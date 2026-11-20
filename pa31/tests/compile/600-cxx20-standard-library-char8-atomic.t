#include <atomic>
static_assert(std::atomic<char8_t>::is_always_lock_free == (ATOMIC_CHAR_LOCK_FREE == 2));
int main() {
  std::atomic<char8_t> value(u8'a');
  return value.exchange(u8'b') != u8'a' || value.load() != u8'b';
}
