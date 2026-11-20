// N4861 [expr.const], [vector], and [alg.sort]

#include <algorithm>
#include <vector>

constexpr int sorted_sum() {
  std::vector<int> values{4, 1, 3};
  std::sort(values.begin(), values.end());
  values.push_back(values.front() + values.back());
  return values[1] * 10 + values.back();
}

static_assert(sorted_sum() == 35);
