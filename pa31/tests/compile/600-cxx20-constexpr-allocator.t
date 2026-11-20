// N4861 [expr.const], [allocator.members], and [specialized.construct]

#include <memory>

struct Item {
  int value;
  int& total;
  constexpr Item(int value, int& total) : value(value), total(total) {}
  constexpr ~Item() { total += value; }
};

constexpr int use_storage() {
  int result = 0;
  std::allocator<Item> allocator;
  Item* storage = allocator.allocate(3);
  Item* item = std::construct_at(storage + 1, 12, result);
  std::destroy_at(item);
  item = std::construct_at(storage + 1, 30, result);
  std::destroy_at(item);
  allocator.deallocate(storage, 3);
  return result;
}

static_assert(use_storage() == 42);
