{
  'variables': {
    'v8_use_snapshot%': 'true',
    'v8_enable_i18n_support': 'false',
    'nubjs_shared_libuv%': 'false',
    'nubjs_v8_options%': '',
    'nubjs_target_type%': 'executable',
    'library_files': [
      'lib/main.js',
    ],
  },

  'targets': [
    {
      'target_name': 'nubjs',
      'type': '<(nubjs_target_type)',

      'dependencies': [
        'nubjs_js2c#host',
        'deps/v8/tools/gyp/v8.gyp:v8',
        'deps/v8/tools/gyp/v8.gyp:v8_libplatform'
      ],

      'include_dirs': [
        'src',
        'deps/nub/deps/uv/src/ares',
        '<(SHARED_INTERMEDIATE_DIR)', # for nubjs_natives.h
        'deps/v8' # include/v8_platform.h
      ],

      'sources': [
        'src/main.cc',
        'src/nubjs.cc',
        # headers to make for a more pleasant IDE experience
        'src/dlist.h',
        'src/nubjs.h',
        'src/util.h',
        'src/version.h',
        'deps/v8/include/v8.h',
        'deps/v8/include/v8-debug.h',
        '<(SHARED_INTERMEDIATE_DIR)/nubjs_natives.h',
        # javascript files to make for an even more pleasant IDE experience
        '<@(library_files)',
        # nubjs.gyp is added to the project by default.
        'common.gypi',
      ],

      'defines': [
        'NUBJS_ARCH="<(target_arch)"',
        'NUBJS_PLATFORM="<(OS)"',
        'NUBJS_TAG="<(nubjs_tag)"',
        'NUBJS_V8_OPTIONS="<(nubjs_v8_options)"',
      ],

      'conditions': [
        # No nubjs_main.cc for anything except executable
        [ 'nubjs_target_type!="executable"', {
          'sources!': [
            'src/main.cc',
          ],
        }],

        [ 'nubjs_shared_libuv=="false"', {
          'dependencies': [
            'deps/nub/nub.gyp:libnub',
            'deps/nub/deps/uv/uv.gyp:libuv',
          ],
        }],

        [ 'OS=="mac"', {
          # linking Corefoundation is needed since certain OSX debugging tools
          # like Instruments require it for some features
          'libraries': [ '-framework CoreFoundation' ],
          'defines!': [
            'NODE_PLATFORM="mac"',
          ],
          'defines': [
            # we need to use nubjs's preferred "darwin" rather than gyp's preferred "mac"
            'NODE_PLATFORM="darwin"',
          ],
        }],
        [ 'OS=="freebsd"', {
          'libraries': [
            '-lutil',
            '-lkvm',
          ],
        }],
        [ 'OS=="solaris"', {
          'libraries': [
            '-lkstat',
            '-lumem',
          ],
          'defines!': [
            'NODE_PLATFORM="solaris"',
          ],
          'defines': [
            # we need to use nubjs's preferred "sunos"
            # rather than gyp's preferred "solaris"
            'NODE_PLATFORM="sunos"',
          ],
        }],
        [ 'OS=="freebsd" or OS=="linux"', {
          'ldflags': [ '-Wl,-z,noexecstack',
                       '-Wl,--whole-archive <(V8_BASE)',
                       '-Wl,--no-whole-archive' ]
        }],
        [ 'OS=="sunos"', {
          'ldflags': [ '-Wl,-M,/usr/lib/ld/map.noexstk' ],
        }],
      ],
    },
    {
      'target_name': 'nubjs_js2c',
      'type': 'none',
      'toolsets': ['host'],
      'actions': [
        {
          'action_name': 'nubjs_js2c',
          'inputs': [
            '<@(library_files)',
            './config.gypi',
          ],
          'outputs': [
            '<(SHARED_INTERMEDIATE_DIR)/nubjs_natives.h',
          ],
          'action': [
            '<(python)',
            'tools/js2c.py',
            '<@(_outputs)',
            '<@(_inputs)',
          ],
        },
      ],
    }, # end nubjs_js2c
  ] # end targets
}
