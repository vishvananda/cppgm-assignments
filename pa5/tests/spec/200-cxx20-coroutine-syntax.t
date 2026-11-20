struct task {};
int operator co_await(task);

task sequence(int value) {
  co_yield value + 1;
  (void) (co_await value);
  co_return {value};
}

task empty() {
  co_return;
}
