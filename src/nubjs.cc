#include "nubjs.h"
#include "util.h"
#include "nub.h"
#include "uv.h"
#include "v8.h"
#include "libplatform/libplatform.h"

namespace nubjs {

using v8::Context;
using v8::HandleScope;
using v8::Isolate;
using v8::Local;
using v8::Locker;
using v8::Locker;
using v8::Platform;
using v8::Script;
using v8::String;
using v8::V8;
using v8::Value;

// TODO(trevnorris): This should live in a more generic environment area that
// encapsulates parameters for the application and each thread.
typedef struct {
  int argc;
  char** argv;
} args_info_t;


static void main_routine(nub_thread_t* thread,
                         nub_work_t* work,
                         void* arg) {
  Isolate* isolate = Isolate::New();
  //args_info_t* args_info = static_cast<args_info_t*>(arg);

  // TODO(trevnorris): This will need to be done on every thread, so generalize
  // it. Only difference here is that this thread will use arg_info_t.
  {
    Locker locker(isolate);
    Isolate::Scope isolate_scope(isolate);
    HandleScope handle_scope(isolate);
    Local<Context> context = Context::New(isolate);
    Context::Scope context_scope(context);
    // TODO(trevnorris): Load the initial script

    /*
    Local<String> source = String::NewFromUtf8(isolate, "'Hello' + ', World!'");
    Local<Script> script = Script::Compile(source);
    Local<Value> result = script->Run();
    String::Utf8Value utf8(result);
    printf("%s\n", *utf8);
    */
  }

  // TODO(trevnorris): This will need to be kept alive until the script
  // completes. This means there may need to be some sort of mechanism that
  // alerts a thread to when it contains no more active handles.
  isolate->Dispose();
  nub_thread_dispose(thread, nullptr);
}


int Run(int argc, char** argv) {
  // TODO(trevnorris): There should be an encapsulation of the execution
  // environment that can propagate with the thread. This will make it easier
  // to ensure all resources are cleaned up when the thread is brought down.

  nub_loop_t main_loop;
  nub_thread_t main_v8_thread;
  nub_work_t main_work;
  Platform* platform;
  args_info_t args_info;

  CHECK_GT(argc, 0);
  argv = uv_setup_args(argc, argv);
  args_info.argc = argc;
  args_info.argv = argv;

  // V8 only requires these are done once per process.
  V8::InitializeICU();
  platform = v8::platform::CreateDefaultPlatform();
  V8::InitializePlatform(platform);
  V8::Initialize();

  // Start running the main routine and the initial script.
  nub_work_init(&main_work, main_routine, &args_info);
  nub_loop_init(&main_loop);
  UV_CHECK(nub_thread_create(&main_loop, &main_v8_thread));
  nub_thread_enqueue(&main_v8_thread, &main_work);
  UV_CHECK(nub_loop_run(&main_loop, UV_RUN_DEFAULT));
  CHECK(!uv_loop_alive(&main_loop.uvloop));
  nub_loop_dispose(&main_loop);

  // Cleanup after ourselves.
  V8::Dispose();
  V8::ShutdownPlatform();
  delete platform;

  return 0;
}

}  // namespace nubjs
