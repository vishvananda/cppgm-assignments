struct Source { enum Values { accepted }; };
struct Receiver {
    using Source::Values;
};
