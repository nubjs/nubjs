#ifndef SRC_JSTHREAD_INL_H_
#define SRC_JSTHREAD_INL_H_

#include "jsthread.h"
#include "nubjs.h"
#include "v8.h"

namespace nubjs {

inline v8::Isolate* JSThread::isolate() const {
  return isolate_;
}


inline nub_thread_t* JSThread::thread() const {
  return thread_;
}

}  // namespace nubjs

#endif  // SRC_JSTHREAD_INL_H_
