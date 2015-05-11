#ifndef SRC_VERSION_H_
#define SRC_VERSION_H_

#define NUBJS_MAJOR_VERSION 0
#define NUBJS_MINOR_VERSION 1
#define NUBJS_PATCH_VERSION 0

#define NUBJS_VERSION_IS_RELEASE 0

#ifndef NUBJS_STRINGIFY
#define NUBJS_STRINGIFY(n) NUBJS_STRINGIFY_HELPER(n)
#define NUBJS_STRINGIFY_HELPER(n) #n
#endif

#if NUBJS_VERSION_IS_RELEASE
# ifndef NUBJS_TAG
#  define NUBJS_TAG ""
# endif
# define NUBJS_VERSION_STRING  NUBJS_STRINGIFY(NUBJS_MAJOR_VERSION) "." \
                               NUBJS_STRINGIFY(NUBJS_MINOR_VERSION) "." \
                               NUBJS_STRINGIFY(NUBJS_PATCH_VERSION)     \
                               NUBJS_TAG
#else
# ifndef NUBJS_TAG
#  define NUBJS_TAG "-rc1"
# endif
# define NUBJS_VERSION_STRING  NUBJS_STRINGIFY(NUBJS_MAJOR_VERSION) "." \
                               NUBJS_STRINGIFY(NUBJS_MINOR_VERSION) "." \
                               NUBJS_STRINGIFY(NUBJS_PATCH_VERSION)     \
                               NUBJS_TAG
#endif

#define NUBJS_VERSION NUBJS_VERSION_STRING


#define NUBJS_VERSION_AT_LEAST(major, minor, patch) \
  (( (major) < NUBJS_MAJOR_VERSION) \
  || ((major) == NUBJS_MAJOR_VERSION && (minor) < NUBJS_MINOR_VERSION) \
  || ((major) == NUBJS_MAJOR_VERSION && \
      (minor) == NUBJS_MINOR_VERSION && (patch) <= NUBJS_PATCH_VERSION))

#define NUBJS_MODULE_VERSION 1

#endif  /* SRC_VERSION_H_ */
