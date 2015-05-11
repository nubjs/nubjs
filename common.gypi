{
  'variables': {
    'asan%': 0,
    'werror': '',                     # Turn off -Werror in V8 build.
    'visibility%': 'hidden',          # V8's visibility setting
    'target_arch%': 'ia32',           # set v8's target architecture
    'host_arch%': 'ia32',             # set v8's host architecture
    'want_separate_host_toolset%': 0, # V8 should not build target and host
    'library%': 'static_library',     # allow override to 'shared_library' for DLL/.so builds
    'component%': 'static_library',   # NB. these names match with what V8 expects
    'python%': 'python',

    'nubjs_tag%': '',
    'uv_library%': 'static_library',

    # Default to -O0 for debug builds.
    'v8_optimized_debug%': 0,

    # Enable disassembler for `--print-code` v8 options
    'v8_enable_disassembler': 1,

    # Don't bake anything extra into the snapshot.
    'v8_use_external_startup_data%': 0,

    'conditions': [
      ['OS == "win"', {
        'os_posix': 0,
        'v8_postmortem_support%': 'false',
      }, {
        'os_posix': 1,
        'v8_postmortem_support%': 'true',
      }],
      ['GENERATOR == "ninja" or OS== "mac"', {
        'OBJ_DIR': '<(PRODUCT_DIR)/obj',
        'V8_BASE': '<(PRODUCT_DIR)/libv8_base.a',
      }, {
        'OBJ_DIR': '<(PRODUCT_DIR)/obj.target',
        'V8_BASE': '<(PRODUCT_DIR)/obj.target/deps/v8/tools/gyp/libv8_base.a',
      }],
      ['OS=="mac"', {
        'clang%': 1,
      }, {
        'clang%': 0,
      }],
    ],
  },

  'target_defaults': {
    'default_configuration': 'Release',
    'configurations': {
      'Debug': {
        'variables': {
          'v8_enable_handle_zapping%': 1,
        },
        'defines': [ 'DEBUG', '_DEBUG' ],
        'cflags': [ '-g', '-O0' ],
      },
      'Release': {
        'variables': {
          'v8_enable_handle_zapping%': 0,
        },
        'cflags': [ '-O3', '-ffunction-sections', '-fdata-sections' ],
        'conditions': [
          ['OS=="solaris"', {
            # pull in V8's postmortem metadata
            'ldflags': [ '-Wl,-z,allextract' ]
          }],
          ['OS!="mac" and OS!="win"', {
            'cflags': [ '-fno-omit-frame-pointer' ],
          }],
        ],
      }
    },
    # Forcibly disable -Werror.  We support a wide range of compilers, it's
    # simply not feasible to squelch all warnings, never mind that the
    # libraries in deps/ are not under our control.
    'cflags!': ['-Werror'],
    'conditions': [
      ['asan != 0', {
        'cflags+': [
          '-fno-omit-frame-pointer',
          '-fsanitize=address',
          '-w',  # http://crbug.com/162783
        ],
        'cflags_cc+': [ '-gline-tables-only' ],
        'cflags!': [ '-fomit-frame-pointer' ],
        'ldflags': [ '-fsanitize=address' ],
      }],
      [ 'OS in "linux freebsd openbsd solaris"', {
        'cflags': [ '-pthread', ],
        'ldflags': [ '-pthread' ],
      }],
      [ 'OS in "linux freebsd openbsd solaris android"', {
        'cflags': [ '-Wall', '-Wextra', '-Wno-unused-parameter', ],
        'cflags_cc': [ '-fno-rtti', '-fno-exceptions', '-std=gnu++0x' ],
        'ldflags': [ '-rdynamic' ],
        'target_conditions': [
          ['_type=="static_library"', {
            'standalone_static_library': 1, # disable thin archive which needs binutils >= 2.19
          }],
        ],
        'conditions': [
          [ 'target_arch=="ia32"', {
            'cflags': [ '-m32' ],
            'ldflags': [ '-m32' ],
          }],
          [ 'target_arch=="x32"', {
            'cflags': [ '-mx32' ],
            'ldflags': [ '-mx32' ],
          }],
          [ 'target_arch=="x64"', {
            'cflags': [ '-m64' ],
            'ldflags': [ '-m64' ],
          }],
          [ 'OS=="solaris"', {
            'cflags': [ '-pthreads' ],
            'ldflags': [ '-pthreads' ],
            'cflags!': [ '-pthread' ],
            'ldflags!': [ '-pthread' ],
          }],
        ],
      }],
      [ 'OS=="android"', {
        'defines': ['_GLIBCXX_USE_C99_MATH'],
        'libraries': [ '-llog' ],
      }],
      ['OS=="freebsd" and node_use_dtrace=="true"', {
        'libraries': [ '-lelf' ],
      }],
      ['OS=="freebsd"', {
        'ldflags': [
          '-Wl,--export-dynamic',
        ],
      }]
    ],
  }
}
