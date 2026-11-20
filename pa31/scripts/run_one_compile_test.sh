#!/bin/bash

set -e

if [ -f "${2%.t}.env" ]; then
  set -a
  . "${2%.t}.env"
  set +a
fi

compile_timeout="${CPPGM_BUILD_TEST_TIMEOUT_SEC:-45}"

app_args=()
if [ -n "${CPPGM_APP_ARGS:-}" ]; then
  read -r -a app_args <<< "$CPPGM_APP_ARGS"
fi

test_args=()
if [ -f "${2%.t}.system-includes" ]; then
  while IFS= read -r system_include_dir; do
    if [ -n "$system_include_dir" ]; then
      test_args+=("-isystem" "$system_include_dir")
    fi
  done < "${2%.t}.system-includes"
fi
if [ -f "${2%.t}.no-exceptions" ]; then
  test_args+=("-fno-exceptions")
fi
if [ -f "${2%.t}.cxx-standard" ] || [ -f "${2%.t}.c-standard" ]; then
  source_args=$(perl -I../scripts -MCppgmBatchWorker -e \
    'print "$_\n" for CppgmBatchWorker::source_args_for($ARGV[0]);' "$2")
  while IFS= read -r arg; do
    if [ -n "$arg" ]; then test_args+=("$arg"); fi
  done <<< "$source_args"
fi

obj="$3.o"
rm -f "$obj"

: > "$3"
if command -v timeout >/dev/null 2>&1; then
  timeout "$compile_timeout" ./"$1" "${app_args[@]}" "${test_args[@]}" -c -o "$obj" "$2" &> "$3.stdout"
else
  perl -e '
    use strict;
    use warnings;

    my $timeout = shift @ARGV;
    my $pid = fork();
    die "fork failed: $!" unless defined($pid);
    if ($pid == 0) {
      exec @ARGV;
      die "exec failed: $!";
    }

    my $timed_out = 0;
    local $SIG{ALRM} = sub {
      $timed_out = 1;
      kill q(TERM), $pid;
    };
    alarm($timeout);
    waitpid($pid, 0);
    alarm(0);

    if ($timed_out) {
      waitpid($pid, 0);
      exit 124;
    }

    exit(($? & 127) == 0 ? ($? >> 8) : (128 + ($? & 127)));
  ' "$compile_timeout" ./"$1" "${app_args[@]}" "${test_args[@]}" -c -o "$obj" "$2" &> "$3.stdout"
fi
rm -f "$obj"
