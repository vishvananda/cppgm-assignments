namespace codec {
struct Stream { int value; };
int inflateEnd(Stream *stream) { return stream->value; }
}
struct Reader {
  codec::Stream stream;
  int finish();
};
int Reader::finish() { return inflateEnd(&stream); }
int main() {
  Reader reader = {{17}};
  return reader.finish() - 17;
}
