CXX ?= $(which clang++)
CC ?= $(which clang)

BUILDTYPE ?= Release

NUB_DIR ?= deps/nub
NUB_BUILD = $(NUB_DIR)/out/$(BUILDTYPE)
NUB_FLAGS = -fno-omit-frame-pointer
NUB_IDIR = $(NUB_DIR)/include

V8_BUILDTYPE = $(shell echo $(BUILDTYPE) | tr A-Z a-z)
V8_DIR ?= deps/v8
V8_BUILD = $(V8_DIR)/out/x64.$(V8_BUILDTYPE)/obj.target/tools/gyp
V8_IDIR = $(V8_DIR)/include

CFLAGS = -pthread -fno-omit-frame-pointer -Wall -g -fstrict-aliasing -std=c++0x

ifeq ($(BUILDTYPE), Release)
	CFLAGS += -O3
	OUTFILE = nubjs
else
	CFLAGS += -O0
	OUTFILE = nubjs_g
endif

DEPS = $(NUB_BUILD)/libuv.a \
       $(NUB_BUILD)/libnub.a \
       $(V8_BUILD)/libv8_base.a \
       $(V8_BUILD)/libv8_libplatform.a \
       $(V8_BUILD)/libv8_libbase.a \
       $(V8_BUILD)/libv8_snapshot.a

BUILDFILES = src/main.cc \
             src/nubjs.cc \
             $(DEPS)

INCLUDES = -I$(NUB_IDIR) \
           -I$(NUB_DIR)/deps/fuq \
           -I$(NUB_DIR)/deps/uv/include \
           -I$(V8_IDIR) \
           -I$(V8_DIR)

all:
	$(CXX) $(CFLAGS) -o $(OUTFILE) $(BUILDFILES) $(INCLUDES)

.PHONY: libnub.a v8 clean

libnub.a:
	@cd $(NUB_DIR); \
		./build.sh; \
		BUILDTYPE=$(BUILDTYPE) CFLAGS=$(NUB_FLAGS) make -C out -j8

v8:
	@ if [ ! -d $(V8_DIR)/build/gyp ]; then \
		mkdir -p $(V8_DIR)/build/gyp; \
		cd $(V8_DIR)/build/gyp; \
		wget https://chromium.googlesource.com/external/gyp.git/+archive/4a9b712d5cb4a5ba7a9950128a7219569caf7263.tar.gz; \
		tar xvf 4a9b712d5cb4a5ba7a9950128a7219569caf7263.tar.gz; \
		rm 4a9b712d5cb4a5ba7a9950128a7219569caf7263.tar.gz; \
	fi
	@ if [ ! -d $(V8_DIR)/buildtools ]; then \
		mkdir -p $(V8_DIR)/buildtools; \
		cd $(V8_DIR)/buildtools; \
		wget https://chromium.googlesource.com/chromium/buildtools.git/+archive/d4dd4f79f60bf019625b3a1436979b0a42c892df.tar.gz; \
		tar xvf d4dd4f79f60bf019625b3a1436979b0a42c892df.tar.gz; \
		rm d4dd4f79f60bf019625b3a1436979b0a42c892df.tar.gz; \
	fi
	@ if [ ! -d $(V8_DIR)/testing/gmock ]; then \
		mkdir -p $(V8_DIR)/testing/gmock; \
		cd $(V8_DIR)/testing/gmock; \
		wget https://chromium.googlesource.com/external/googlemock.git/+archive/29763965ab52f24565299976b936d1265cb6a271.tar.gz; \
		tar xvf 29763965ab52f24565299976b936d1265cb6a271.tar.gz; \
		rm 29763965ab52f24565299976b936d1265cb6a271.tar.gz; \
	fi
	@ if [ ! -d $(V8_DIR)/testing/gtest ]; then \
		mkdir -p $(V8_DIR)/testing/gtest; \
		cd $(V8_DIR)/testing/gtest; \
		wget https://chromium.googlesource.com/external/googletest.git/+archive/be1868139ffe0ccd0e8e3b37292b84c821d9c8ad.tar.gz; \
		tar xvf be1868139ffe0ccd0e8e3b37292b84c821d9c8ad.tar.gz; \
		rm be1868139ffe0ccd0e8e3b37292b84c821d9c8ad.tar.gz; \
	fi
	@ if [ ! -d $(V8_DIR)/third_party/icu ]; then \
		mkdir -p $(V8_DIR)/third_party/icu; \
		cd $(V8_DIR)/third_party/icu; \
		wget https://chromium.googlesource.com/chromium/deps/icu.git/+archive/eda9e75b1fa17f57ffa369ee3543a2301b68d0a9.tar.gz; \
		tar xvf eda9e75b1fa17f57ffa369ee3543a2301b68d0a9.tar.gz; \
		rm eda9e75b1fa17f57ffa369ee3543a2301b68d0a9.tar.gz; \
	fi
	@ if [ ! -d $(V8_DIR)/tools/clang ]; then \
		mkdir -p $(V8_DIR)/tools/clang; \
		cd $(V8_DIR)/tools/clang; \
		wget https://chromium.googlesource.com/chromium/src/tools/clang.git/+archive/ed79fd57317ab9f09ce52a5e1c7424eebb80a73e.tar.gz; \
		tar xvf ed79fd57317ab9f09ce52a5e1c7424eebb80a73e.tar.gz; \
		rm ed79fd57317ab9f09ce52a5e1c7424eebb80a73e.tar.gz; \
	fi
	@ if [ ! -d $(V8_DIR)/buildtools/clang_format/script ]; then \
		mkdir -p $(V8_DIR)/buildtools/clang_format/script; \
		cd $(V8_DIR)/buildtools/clang_format/script; \
		wget https://chromium.googlesource.com/chromium/llvm-project/cfe/tools/clang-format.git/+archive/81edd558fea5dd7855d67a1dc61db34ae8c1fd63.tar.gz; \
		tar xvf 81edd558fea5dd7855d67a1dc61db34ae8c1fd63.tar.gz; \
		rm 81edd558fea5dd7855d67a1dc61db34ae8c1fd63.tar.gz; \
	fi
	@ if [ ! -d $(V8_DIR)/buildtools/third_party/libc++/trunk ]; then \
		mkdir -p $(V8_DIR)/buildtools/third_party/libc++/trunk; \
		cd $(V8_DIR)/buildtools/third_party/libc++/trunk; \
		wget https://chromium.googlesource.com/chromium/llvm-project/libcxx.git/+archive/48198f9110397fff47fe7c37cbfa296be7d44d3d.tar.gz; \
		tar xvf 48198f9110397fff47fe7c37cbfa296be7d44d3d.tar.gz; \
		rm 48198f9110397fff47fe7c37cbfa296be7d44d3d.tar.gz; \
	fi
	@ if [ ! -d $(V8_DIR)/buildtools/third_party/libc++abi/trunk ]; then \
		mkdir -p $(V8_DIR)/buildtools/third_party/libc++abi/trunk; \
		cd $(V8_DIR)/buildtools/third_party/libc++abi/trunk; \
		wget https://chromium.googlesource.com/chromium/llvm-project/libcxxabi.git/+archive/4ad1009ab3a59fa7a6896d74d5e4de5885697f95.tar.gz; \
		tar xvf 4ad1009ab3a59fa7a6896d74d5e4de5885697f95.tar.gz; \
		rm 4ad1009ab3a59fa7a6896d74d5e4de5885697f95.tar.gz; \
	fi
	@cd $(V8_DIR); \
		make x64.$(V8_BUILDTYPE) -j8 i18nsupport=off


clean:
	@for i in `ls`; do \
		if [ -x $$i ] && [ ! -d $$i ]; then \
		rm $$i; \
		fi; \
		done
	@rm -rf $(NUB_DIR)/out
	@rm -rf $(V8_DIR)/out
