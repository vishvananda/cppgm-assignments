include ../scripts/test_run_id.mk
TARGET = cppgm
CPPGM_TEST_APP ?= ../dev/$(TARGET)
CPPGM_HOST_CXX ?= $(CXX)
TEST_DEPS ?= dev-shared-target
TEST ?= tests

.PHONY: all test check ref-test dev-shared-target clean
all: dev-shared-target

dev-shared-target:
	@if [ "$(CPPGM_SKIP_DEV_REBUILD)" != "1" ]; then $(MAKE) -C ../dev $(TARGET) CXX="$(CXX)" CPPGM_HOST_CXX="$(CPPGM_HOST_CXX)"; fi

test: $(TEST_DEPS)
	@perl ../scripts/run_all_tests_common.pl control_t "$(CPPGM_TEST_APP)" my "$(TEST)"
	@perl ../scripts/compare_results_common.pl control_t ref my "$(TEST)"

ref-test:
	@echo "PA40 controls state their expected results in .i386-expect sidecars."

clean:
	@:

CHECK_RUN = perl ../scripts/run_all_tests_common.pl control_t "$(CPPGM_TEST_APP)" check "$(TEST)"
CHECK_COMPARE = perl ../scripts/compare_results_common.pl control_t ref check "$(TEST)"
include ../scripts/pa_run_check_targets.mk
