TARGET = cppgm
CXX ?= g++
CPPGM_HOST_CXX ?= $(CXX)
CPPGM_TEST_APP ?= ../dev/$(TARGET)
REF_TEST_APP ?= $(CPPGM_TEST_APP)-ref
TEST_DEPS ?= dev-shared-target
TEST_ROOT = tests

.PHONY: all test test-quality ref-test dev-shared-target clean
all: dev-shared-target

dev-shared-target:
	@if [ "$(CPPGM_SKIP_DEV_REBUILD)" != "1" ]; then $(MAKE) -C ../dev cppgm lowiropt lowir2native CXX="$(CXX)" CPPGM_HOST_CXX="$(CPPGM_HOST_CXX)"; fi

test-quality: TEST_ROOT = tests/quality

test test-quality: $(TEST_DEPS)
	@perl ../scripts/run_all_tests_common.pl control_t $(CPPGM_TEST_APP) my $(TEST_ROOT)
	@perl ../scripts/compare_results_common.pl control_t ref my $(TEST_ROOT)

ref-test: $(TEST_DEPS)
	@perl ../scripts/run_all_tests_common.pl control_t $(REF_TEST_APP) ref "$(if $(TEST),$(TEST),tests)"
	@perl ../scripts/compare_results_common.pl control_t ref ref "$(if $(TEST),$(TEST),tests)"

CHECK_RUN = perl ../scripts/run_all_tests_common.pl control_t $(CPPGM_TEST_APP) check "$(TEST)"
CHECK_COMPARE = perl ../scripts/compare_results_common.pl control_t ref check "$(TEST)"
TARGET_ARGS = --target=aarch64-linux-gnu
include ../scripts/pa_run_check_targets.mk

clean:
	@:
