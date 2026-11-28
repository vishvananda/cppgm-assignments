TARGET = cppgm
TARGET_ARGS = --emit-lowir -O0 -x c -std=c17
export CPPGM_APP_ARGS := $(TARGET_ARGS)
CXX ?= g++
CPPGM_HOST_CXX ?= $(CXX)
CPPGM_TEST_APP ?= ../dev/$(TARGET)
REF_TEST_APP ?= $(CPPGM_TEST_APP)-ref
NATIVE_REFERENCE_APP ?= ../dev/lowir2native-ref
LOWIR2NATIVE_APP ?= ../dev/lowir2native
TEST_DEPS ?= dev-shared-target
GENERAL_TEST_ROOT ?= tests/general
CONTROL_TEST_ROOT ?= tests/controls
ABI_TEST_ROOT ?= tests/abi
NATIVE_DRIVER_TESTS = 300-array-prototype-type-names 300-c-attributed-nested-declarators 300-variable-arrays 300-variable-array-exits \
	300-variable-array-multidimensional 300-variable-array-atomic-type 300-variable-array-function-pointer \
	300-variable-array-typeof 500-types-compatible-vla

.PHONY: all dev-shared-target test test-controls test-native-driver test-native-abi ref-test test-wasm clean
all: dev-shared-target

dev-shared-target:
	@if [ "$(CPPGM_SKIP_DEV_REBUILD)" != "1" ]; then $(MAKE) -C ../dev $(TARGET) lowir2native lowiropt CXX="$(CXX)" CPPGM_HOST_CXX="$(CPPGM_HOST_CXX)"; fi

CONTROLS_RUN = CPPGM_CONTROL_NATIVE_APP="$(NATIVE_REFERENCE_APP)" \
	perl ../scripts/run_all_tests_common.pl control_t $(CPPGM_TEST_APP) my "$(CONTROL_TEST_ROOT)" && \
	perl ../scripts/compare_results_common.pl control_t ref my "$(CONTROL_TEST_ROOT)"

test: $(TEST_DEPS)
	@scripts/run_all_tests.pl $(CPPGM_TEST_APP) my "$(GENERAL_TEST_ROOT)"
	@scripts/compare_results.pl ref my "$(GENERAL_TEST_ROOT)"
	@$(CONTROLS_RUN)

test-controls: $(TEST_DEPS)
	@$(CONTROLS_RUN)

test-native-driver: $(TEST_DEPS)
	@CPPGM_APP_ARGS= perl ../scripts/check_cppgm_native_programs.pl --levels=0,2 \
		"$(CPPGM_TEST_APP)" "$(GENERAL_TEST_ROOT)/100-c-filename.c" "$(LOWIR2NATIVE_APP)"
	@CPPGM_APP_ARGS= perl ../scripts/check_cppgm_native_programs.pl --levels=0,2 \
		"$(CPPGM_TEST_APP)" "$(CONTROL_TEST_ROOT)/300-c-trivial-auto-var-init.t" "$(LOWIR2NATIVE_APP)"
	@set -e; for test in $(NATIVE_DRIVER_TESTS); do \
		CPPGM_APP_ARGS="-x c -std=c17" perl ../scripts/check_cppgm_native_programs.pl --levels=0,2 \
			"$(CPPGM_TEST_APP)" "$(GENERAL_TEST_ROOT)/$$test.t" "$(LOWIR2NATIVE_APP)"; \
	done

ABI_RUN = CPPGM_APP_ARGS= perl ../scripts/run_cpphostinterop_tests_worker.pl
ABI_COMPARE = perl ../scripts/compare_results_common.pl link_program_t

test-native-abi: $(TEST_DEPS)
	@$(ABI_RUN) "$(CPPGM_TEST_APP)" my "$(ABI_TEST_ROOT)"
	@$(ABI_COMPARE) ref my "$(ABI_TEST_ROOT)"

ref-test:
	@$(REF_TEST_RUN)

REF_TEST_RUN = case "$(TEST)" in \
	"") scripts/run_all_tests.pl $(REF_TEST_APP) ref "$(GENERAL_TEST_ROOT)" && \
		$(ABI_RUN) "$(REF_TEST_APP)" ref "$(ABI_TEST_ROOT)" ;; \
	$(CONTROL_TEST_ROOT)/*) echo "$(TEST): focused LowIR predicate has no reference sidecar" ;; \
	$(ABI_TEST_ROOT)/*) $(ABI_RUN) "$(REF_TEST_APP)" ref "$(TEST)" ;; \
	*) scripts/run_all_tests.pl $(REF_TEST_APP) ref "$(TEST)" ;; \
esac

CHECK_RUN = case "$(TEST)" in \
	$(CONTROL_TEST_ROOT)/*) CPPGM_CONTROL_NATIVE_APP="$(NATIVE_REFERENCE_APP)" perl ../scripts/run_all_tests_common.pl control_t $(CPPGM_TEST_APP) check "$(TEST)" ;; \
	$(ABI_TEST_ROOT)/*) $(ABI_RUN) "$(CPPGM_TEST_APP)" check "$(TEST)" ;; \
	*) scripts/run_all_tests.pl $(CPPGM_TEST_APP) check "$(TEST)" ;; \
esac
CHECK_COMPARE = case "$(TEST)" in \
	$(CONTROL_TEST_ROOT)/*) perl ../scripts/compare_results_common.pl control_t ref check "$(TEST)" ;; \
	$(ABI_TEST_ROOT)/*) $(ABI_COMPARE) ref check "$(TEST)" ;; \
	*) scripts/compare_results.pl ref check "$(TEST)" ;; \
esac
include ../scripts/pa_run_check_targets.mk

# The same C source fixtures can also be lowered to Wasm. Expectations state
# results directly; this target does not compare against another C compiler.
test-wasm: $(TEST_DEPS)
	@CPPGM_WASM_CPPGM="$(CPPGM_TEST_APP)" perl ../scripts/run_all_tests_common.pl control_t $(LOWIR2NATIVE_APP) my.wasm "$(GENERAL_TEST_ROOT)"
	@perl ../scripts/compare_results_common.pl control_t ref my.wasm "$(GENERAL_TEST_ROOT)"

clean:
	@rm -f $(TARGET) $(TARGET)-debug
