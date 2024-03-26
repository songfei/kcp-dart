#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#if _WIN32
#include <windows.h>
#else
#include <pthread.h>
#include <unistd.h>
#endif

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT
#endif

struct NativeKCP;

FFI_PLUGIN_EXPORT void kcp_native_initialize(void* dartApiData);

FFI_PLUGIN_EXPORT void kcp_native_terminate();

FFI_PLUGIN_EXPORT struct NativeKCP* kcp_native_create(uint32_t conv, int64_t native_port);

FFI_PLUGIN_EXPORT void kcp_native_destroy(struct NativeKCP* native_kcp);

FFI_PLUGIN_EXPORT void kcp_native_update(struct NativeKCP* native_kcp, int timestamp_millisencond);

FFI_PLUGIN_EXPORT int kcp_native_check(struct NativeKCP* native_kcp, int timestamp_millisencond);

FFI_PLUGIN_EXPORT void kcp_native_input(struct NativeKCP* native_kcp, uint8_t* data, int length);

FFI_PLUGIN_EXPORT int kcp_native_nodelay(struct NativeKCP* native_kcp, int nodelay, int interval, int resend, int nc);

FFI_PLUGIN_EXPORT int kcp_native_wndsize(struct NativeKCP* native_kcp, int sndwnd, int rcvwnd);

FFI_PLUGIN_EXPORT int kcp_native_receive(struct NativeKCP* native_kcp, uint8_t* data, int length);

FFI_PLUGIN_EXPORT int kcp_native_send(struct NativeKCP* native_kcp, uint8_t* data, int length);


// A very short-lived native function.
//
// For very short-lived functions, it is fine to call them on the main isolate.
// They will block the Dart execution while running the native function, so
// only do this for native functions which are guaranteed to be short-lived.
FFI_PLUGIN_EXPORT intptr_t sum(intptr_t a, intptr_t b);

// A longer lived native function, which occupies the thread calling it.
//
// Do not call these kind of native functions in the main isolate. They will
// block Dart execution. This will cause dropped frames in Flutter applications.
// Instead, call these native functions on a separate isolate.
FFI_PLUGIN_EXPORT intptr_t sum_long_running(intptr_t a, intptr_t b);

