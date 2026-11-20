// expect reject
struct Outer {
  struct Inner { mutable int value; };
  Inner elements[2];
};
template<Outer Value> struct Argument {};
Argument<Outer{{{1}, {2}}}> invalid;
