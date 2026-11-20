// N4861 [expr.const] and [allocator.members]

#include <memory>

constexpr int read_unconstructed() {
  std::allocator<int> allocator;
  int* storage = allocator.allocate(2);
  std::construct_at(storage, 42);
  int result = storage[1];
  std::destroy_at(storage);
  allocator.deallocate(storage, 2);
  return result;
}

static_assert(read_unconstructed() == 42);
