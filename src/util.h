#ifndef NUBJS_UTIL_H_
#define NUBJS_UTIL_H_

#include "uv.h"

#include <stdlib.h>  // abort
#include <stdio.h>   // fprintf, fflush

namespace nubjs {

#define NUB_FULL_ASSERT(expression)                                           \
  do {                                                                        \
     if (!(expression)) {                                                     \
       fprintf(stderr,                                                        \
               "Assertion failed in %s on line %d: %s\n",                     \
               __FILE__,                                                      \
               __LINE__,                                                      \
               #expression);                                                  \
       fflush(stderr);                                                        \
       abort();                                                               \
     }                                                                        \
  } while (0)

#ifdef DEBUG
  #define ASSERT(expression)
  #define ASSERT_EQ(exp1, exp2)
  #define ASSERT_NE(exp1, exp2)
  #define ASSERT_LT(exp1, exp2)
  #define ASSERT_GT(exp1, exp2)
  #define ASSERT_LE(exp1, exp2)
  #define ASSERT_GE(exp1, exp2)
#else
  #define ASSERT(expression)  NUB_FULL_ASSERT(expression)
  #define ASSERT_EQ(exp1, exp2)  NUB_FULL_ASSERT((exp1) == (exp2))
  #define ASSERT_NE(exp1, exp2)  NUB_FULL_ASSERT((exp1) != (exp2))
  #define ASSERT_LT(exp1, exp2)  NUB_FULL_ASSERT((exp1) < (exp2))
  #define ASSERT_GT(exp1, exp2)  NUB_FULL_ASSERT((exp1) > (exp2))
  #define ASSERT_LE(exp1, exp2)  NUB_FULL_ASSERT((exp1) <= (exp2))
  #define ASSERT_GE(exp1, exp2)  NUB_FULL_ASSERT((exp1) >= (exp2))
#endif

#define CHECK(expression)     NUB_FULL_ASSERT(expression)
#define CHECK_EQ(exp1, exp2)  NUB_FULL_ASSERT((exp1) == (exp2))
#define CHECK_NE(exp1, exp2)  NUB_FULL_ASSERT((exp1) != (exp2))
#define CHECK_LT(exp1, exp2)  NUB_FULL_ASSERT((exp1) < (exp2))
#define CHECK_GT(exp1, exp2)  NUB_FULL_ASSERT((exp1) > (exp2))
#define CHECK_LE(exp1, exp2)  NUB_FULL_ASSERT((exp1) <= (exp2))
#define CHECK_GE(exp1, exp2)  NUB_FULL_ASSERT((exp1) >= (exp2))

#define UV_CHECK(expr)                                                        \
  do {                                                                        \
    int r = (expr);                                                           \
    if (0 != r) {                                                             \
      fprintf(stderr,                                                         \
              "Assertion failed in %s on line %d: %s == %s\n",                \
              __FILE__,                                                       \
              __LINE__,                                                       \
              #expr,                                                          \
              uv_err_name(r));                                                \
      fprintf(stderr, "UV_ERROR: %s\n", uv_strerror(r));                      \
      fflush(stderr);                                                         \
      abort();                                                                \
    }                                                                         \
  } while (0)


#define UNREACHABLE() abort()

}  // namespace nubjs

#endif  // NUBJS_UTIL_H_
