// expect reject

struct Left { explicit Left(int); };
struct Right { explicit Right(int); };
struct Both : Left, Right {
  using Left::Left;
  using Right::Right;
};
Both value(17);
