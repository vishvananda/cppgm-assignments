struct outer {
  struct nested {
    using tag = int;
    static const int value = 4;
  };
};

outer object{};
void take(decltype(object)::nested::tag*, decltype(object)::nested::tag&);
int multiplier = 3;
int product(decltype(object)::nested::value * multiplier);
