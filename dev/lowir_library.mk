# Independently built PIC objects keep library flags out of normal tool and
# self-host objects. Public C symbols are the only exports: the link names
# them, so the exports are the same when cppgm compiles the objects (it accepts
# the visibility options and does not apply them). The host compiler links the
# shared library, under its own name: a client finds it on its run path.
LOWIR_LIBRARY_OBJDIR = $(OBJ)/lowir-library
LOWIR_LIBRARY_TOOLCHAIN_STAMP = .lowir-library-toolchain
LOWIR_LIBRARY_FLAGS = $(CC_FLAGS) -pthread -fPIC -fvisibility=hidden -fvisibility-inlines-hidden
LOWIR_LIBRARY_OBJS = $(addprefix $(LOWIR_LIBRARY_OBJDIR)/,$(addsuffix .o,$(FRONTEND_LIBRARY_SOURCE_IDS_lowir_library))) $(LOWIR_LIBRARY_OBJDIR)/boundary.o
LOWIR_LIBRARY_SHARED = libcppgm_lowir.$(if $(filter Darwin,$(shell uname -s)),dylib,so)
LOWIR_LIBRARY_EXPORTS = $(LOWIR_LIBRARY_OBJDIR)/exports
# CXX is the host compiler when no other is named.
LOWIR_LIBRARY_LINKER = $(if $(CPPGM_HOST_CXX),$(CPPGM_HOST_CXX),$(CXX))
LOWIR_LIBRARY_LINK = $(if $(filter Darwin,$(shell uname -s)),-dynamiclib -install_name @rpath/$(LOWIR_LIBRARY_SHARED) -Wl$(COMMA)-exported_symbols_list$(COMMA)$(LOWIR_LIBRARY_EXPORTS),-shared -Wl$(COMMA)-soname$(COMMA)$(LOWIR_LIBRARY_SHARED) -Wl$(COMMA)-z$(COMMA)defs -Wl$(COMMA)--version-script=$(LOWIR_LIBRARY_EXPORTS))
COMMA := ,

.PHONY: lowir-library clean-lowir-library
lowir-library: libcppgm_lowir.a $(LOWIR_LIBRARY_SHARED)

libcppgm_lowir.a: $(LOWIR_LIBRARY_OBJS) $(LOWIR_LIBRARY_TOOLCHAIN_STAMP)
	$(call quiet,AR,$@)
	$(Q)$(AR) rcs $@.tmp $(LOWIR_LIBRARY_OBJS)
	$(Q)mv -f $@.tmp $@

$(LOWIR_LIBRARY_SHARED): $(LOWIR_LIBRARY_OBJS) $(LOWIR_LIBRARY_EXPORTS) $(LOWIR_LIBRARY_TOOLCHAIN_STAMP)
	$(call quiet,LINK,$@)
	$(Q)$(LOWIR_LIBRARY_LINKER) $(CC_FLAGS) -pthread $(LOWIR_LIBRARY_LINK) -o $@.tmp $(LOWIR_LIBRARY_OBJS)
	$(Q)mv -f $@.tmp $@

# The exported names, in the form of the platform's linker: a version script, or a Mach-O symbol list.
$(LOWIR_LIBRARY_EXPORTS): $(LOWIR_LIBRARY_OBJDIR)/.config
	@mkdir -p $(@D)
	@printf '%s\n' $(if $(filter Darwin,$(shell uname -s)),'_cppgm_lowir_*','{ global: cppgm_lowir_*; local: *; };') > $@

# Libraries share output paths across isolated object roots. Remember the
# selected root as well as flags so returning to an older cell relinks it.
$(LOWIR_LIBRARY_TOOLCHAIN_STAMP): FORCE
	@printf '%s\n%s\n%s\n%s\n' '$(CXX)' '$(LOWIR_LIBRARY_LINKER)' '$(LOWIR_LIBRARY_FLAGS)' '$(abspath $(LOWIR_LIBRARY_OBJDIR))' > $@.tmp
	@if ! cmp -s $@.tmp $@ 2>/dev/null; then mv -f $@.tmp $@; else rm -f $@.tmp; fi

$(LOWIR_LIBRARY_OBJDIR)/.config: FORCE
	@mkdir -p $(@D)
	@printf '%s\n%s\n' '$(CXX)' '$(LOWIR_LIBRARY_FLAGS)' > $@.tmp
	@if ! cmp -s $@.tmp $@ 2>/dev/null; then mv -f $@.tmp $@; else rm -f $@.tmp; fi

$(LOWIR_LIBRARY_OBJDIR)/%.o: $(SRC)/%.cpp $(LOWIR_LIBRARY_OBJDIR)/.config
	@mkdir -p $(@D)
	$(call quiet,CXX,$@)
	$(Q)$(CXX) $(LOWIR_LIBRARY_FLAGS) $(INC) -c -MMD -MP -o $@ $<

$(LOWIR_LIBRARY_OBJDIR)/boundary.o: lowir_library.cpp $(LOWIR_LIBRARY_OBJDIR)/.config
	@mkdir -p $(@D)
	$(call quiet,CXX,$@)
	$(Q)$(CXX) $(LOWIR_LIBRARY_FLAGS) $(INC) -c -MMD -MP -o $@ $<

clean-lowir-library:
	rm -f libcppgm_lowir.a libcppgm_lowir.so libcppgm_lowir.dylib $(LOWIR_LIBRARY_TOOLCHAIN_STAMP)
	rm -rf $(LOWIR_LIBRARY_OBJDIR)

-include $(LOWIR_LIBRARY_OBJS:.o=.d)

.PHONY: test-lowir-library
test-lowir-library: lowir-library cppgm
	$(Q)cd .. && CC="$(CC)" CPPGM_HOST_CXX="$(CPPGM_HOST_CXX)" CPPGM_STDLIB_FLAGS="$(CPPGM_STDLIB_FLAGS)" python3 scripts/test_lowir_library.py

clean: clean-lowir-library
