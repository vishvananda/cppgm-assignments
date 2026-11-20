// expect exit 0
struct Stop { const int* position; };
int comparisons;
int begin_calls;
int end_calls;

bool operator!=(const int* iterator, Stop stop) {
  ++comparisons;
  return iterator != stop.position;
}

struct Range {
  int values[3];

  const int* begin() const {
    ++begin_calls;
    return values;
  }

  Stop end() const {
    ++end_calls;
    return Stop{values + 3};
  }
};

int main() {
  int total = 0;
  for (int value : Range{{2, 3, 5}})
    total += value;
  return total == 10 && begin_calls == 1 && end_calls == 1 &&
    comparisons == 4 ? 0 : 1;
}
