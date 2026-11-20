namespace A { int pick(int); }
namespace B { int pick(int); }

using A::pick;
using B::pick;

int ambiguous() { return pick(1); }
