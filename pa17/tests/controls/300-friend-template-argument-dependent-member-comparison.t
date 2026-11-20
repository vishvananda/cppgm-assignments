// expect exit 0
template<class L> struct Deferred
{
    L left;
    template<class R> friend bool operator==(Deferred&& d, R)
    {
        return d.left == 0;
    }
};

namespace user
{
    struct NullArgument { NullArgument(NullArgument*) {} };
    struct Value
    {
        int data;
        friend bool operator==(Value value, NullArgument) { return value.data == 42; }
    };
}

int main()
{
    user::Value value{42};
    return !(Deferred<user::Value&>{value} == 1);
}
