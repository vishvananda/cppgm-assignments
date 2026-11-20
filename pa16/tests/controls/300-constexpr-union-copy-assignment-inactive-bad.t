// A member that was active before union copy assignment is inactive afterward. expect reject
union Choice {
  unsigned first;
  long second;
  constexpr Choice(unsigned v) : first(v) {}
  constexpr Choice(long v) : second(v) {}
};

constexpr unsigned inactive_after_copy() {
  Choice old_value(4u);
  Choice new_value(7L);
  old_value = new_value;
  return old_value.first;
}
constexpr unsigned invalid = inactive_after_copy();
