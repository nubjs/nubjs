-include config.mk

BUILDTYPE ?= Release
PYTHON ?= python
DESTDIR ?=
SIGN ?=
PREFIX ?= /usr/local

# Determine EXEEXT
EXEEXT := $(shell $(PYTHON) -c \
		"import sys; print('.exe' if sys.platform == 'win32' else '')")

NUBJS ?= ./nubjs$(EXEEXT)
NUBJS_EXE = nubjs$(EXEEXT)
NUBJS_G_EXE = nubjs_g$(EXEEXT)

# Default to verbose builds.
# To do quiet/pretty builds, run `make V=` to set V to an empty string,
# or set the V environment variable to an empty string.
V ?= 1

# BUILDTYPE=Debug builds both release and debug builds. If you want to compile
# just the debug build, run `make -C out BUILDTYPE=Debug` instead.
ifeq ($(BUILDTYPE),Release)
all: out/Makefile $(NUBJS_EXE)
else
all: out/Makefile $(NUBJS_EXE) $(NUBJS_G_EXE)
endif

# The .PHONY is needed to ensure that we recursively use the out/Makefile
# to check for changes.
.PHONY: $(NUBJS_EXE) $(NUBJS_G_EXE)

$(NUBJS_EXE): config.gypi out/Makefile
	$(MAKE) -C out BUILDTYPE=Release V=$(V)
	ln -fs out/Release/$(NUBJS_EXE) $@

$(NUBJS_G_EXE): config.gypi out/Makefile
	$(MAKE) -C out BUILDTYPE=Debug V=$(V)
	ln -fs out/Debug/$(NUBJS_EXE) $@

out/Makefile: common.gypi deps/nub/nub.gyp deps/v8/build/toolchain.gypi deps/v8/build/features.gypi deps/v8/tools/gyp/v8.gyp nubjs.gyp config.gypi
	$(PYTHON) tools/gyp_node.py -f make

config.gypi: configure
	if [ -f $@ ]; then
		$(error Stale $@, please re-run ./configure)
	else
		$(error No $@, please run ./configure first)
	fi

clean:
	-rm -rf out/Makefile $(NUBJS_EXE) $(NUBJS_G_EXE) out/$(BUILDTYPE)/$(NUBJS_EXE)
	@if [ -d out ]; then find out/ -name '*.o' -o -name '*.a' | xargs rm -rf; fi

distclean:
	-rm -rf out
	-rm -f config.gypi
	-rm -f config.mk
	-rm -rf $(NUBJS_EXE) $(NUBJS_G_EXE)

CPPLINT_EXCLUDE ?=

CPPLINT_FILES = $(filter-out $(CPPLINT_EXCLUDE), $(wildcard src/*.cc src/*.h src/*.c tools/icu/*.h tools/icu/*.cc deps/debugger-agent/include/* deps/debugger-agent/src/*))

cpplint:
	@$(PYTHON) tools/cpplint.py $(CPPLINT_FILES)

lint: cpplint

.PHONY: lint cpplint clean distclean all
	
