// expect exit 0
struct Member {
  int values[2];
};
Member source = {{3, 5}};

struct Initializer {
  operator const Member&() const { return source; }
};

struct Object {
  Member member;
  int tail;
};

int main() {
  Object converted = {(Initializer{}), 7};
  Object flattened = {11, 13, 17};
  return converted.member.values[0] != 3 || converted.member.values[1] != 5 ||
         converted.tail != 7 || flattened.member.values[1] != 13 || flattened.tail != 17;
}
