#ifndef SRC_JSTHREAD_H_
#define SRC_JSTHREAD_H_

#include "nub.h"
#include "v8.h"

namespace nubjs {

class JSThread {
  public:
    JSThread();

    inline v8::Isolate* isolate() const;
    inline nub_thread_t* thread() const;

  private:
    v8::Isolate* isolate_;
    nub_thread_t* thread_;
};

}  // namespace nubjs

#endif  // SRC_JSTHREAD_H_
