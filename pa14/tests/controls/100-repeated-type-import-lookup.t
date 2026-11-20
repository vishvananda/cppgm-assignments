// expect exit 0
// N4140 [dcl.typedef], [namespace.udecl], and [temp.res]

namespace shared {
struct Record { int value; };
enum class Status { ready = 2 };
}

namespace api {
using shared::Record;
using Status = shared::Status;

template<class T>
struct Handler {
  Record record;
  Status status;
};
}

namespace api {
using Record = shared::Record;
using shared::Status;
}

int main() {
  api::Handler<int> handler{{40}, shared::Status::ready};
  return handler.record.value + static_cast<int>(handler.status) != 42;
}
