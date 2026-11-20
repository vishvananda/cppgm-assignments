namespace lights {
enum class Signal { go = 7, stop = 9 };
using Signals = Signal;
using enum Signals;
}

struct Panel {
    using enum lights::Signal;
    enum Extra { blank = 3 };
};

using Panel::go, Panel::stop;
using enum Panel::Extra;
static_assert(go == lights::go, "both names designate the same enumerator");
static_assert(Panel::stop == lights::Signal::stop, "member using-enum");
static_assert(stop == Panel::stop, "second using-declarator");
static_assert(blank == 3, "unscoped member enumeration");
