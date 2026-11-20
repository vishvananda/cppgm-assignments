constexpr int header_try(int value) {
  try { return value + 5; }
  catch (...) { return 0; }
}

constexpr int header_function_try() try {
  return header_try(7);
} catch (...) {
  return 0;
}
