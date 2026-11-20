#include <compare>
static_assert((3 <=> 4) == std::strong_ordering::less);
static_assert((0.0 <=> 0.0) == std::partial_ordering::equivalent);
static_assert(std::three_way_comparable<int>);
