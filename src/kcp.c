#include <dart_api_dl.h>
#include "kcp.h"
#include "ikcp.h"



// A very short-lived native function.
//
// For very short-lived functions, it is fine to call them on the main isolate.
// They will block the Dart execution while running the native function, so
// only do this for native functions which are guaranteed to be short-lived.
 intptr_t sum(intptr_t a, intptr_t b) { return a + b + b; }

// A longer-lived native function, which occupies the thread calling it.
//
// Do not call these kind of native functions in the main isolate. They will
// block Dart execution. This will cause dropped frames in Flutter applications.
// Instead, call these native functions on a separate isolate.
 intptr_t sum_long_running(intptr_t a, intptr_t b) {
  // Simulate work.
#if _WIN32
  Sleep(5000);
#else
  usleep(5000 * 1000);
#endif
  return a + b;
}

struct NativeKCP {
    ikcpcb * kcp;
    int64_t native_port;
};

static void post_c_object_finish_call_back(void* isolate_callback_data, void* peer) {
    if(peer != NULL) {
        free(peer);
    }
}

void kcp_native_initialize(void* dartApiData)
{
    Dart_InitializeApiDL(dartApiData);
}

void kcp_native_terminate()
{

}

int kcp_native_udp_output(const char *buf, int len, ikcpcb *kcp, void *user)
{
  struct NativeKCP* native_kcp = (struct NativeKCP*)user;

  Dart_CObject dart_object;
  dart_object.type = Dart_CObject_kExternalTypedData;
  dart_object.value.as_external_typed_data.type = Dart_TypedData_kUint8;

  dart_object.value.as_external_typed_data.length = len;
  dart_object.value.as_external_typed_data.data = (uint8_t*)malloc(len);
  memcpy(dart_object.value.as_external_typed_data.data, buf, len);

  dart_object.value.as_external_typed_data.peer = dart_object.value.as_external_typed_data.data;
  dart_object.value.as_external_typed_data.callback = post_c_object_finish_call_back;

  Dart_PostCObject_DL(native_kcp->native_port, &dart_object);
  return 0;
}

struct NativeKCP* kcp_native_create(uint32_t conv, int64_t native_port)
{
    struct NativeKCP* native_kcp = (struct NativeKCP*)malloc(sizeof(struct NativeKCP));

    native_kcp->kcp = ikcp_create(conv, native_kcp);

    native_kcp->kcp->output = kcp_native_udp_output;
    native_kcp->native_port = native_port;

    return native_kcp;
}

void kcp_native_destroy(struct NativeKCP* native_kcp)
{
    if(native_kcp) {
        ikcp_release(native_kcp->kcp);
        free(native_kcp);
    }
}

void kcp_native_update(struct NativeKCP* native_kcp, int timestamp_millisecond)
{
    ikcp_update(native_kcp->kcp, timestamp_millisecond);
}

int kcp_native_check(struct NativeKCP* native_kcp, int timestamp_millisencond)
{
    return ikcp_check(native_kcp->kcp, timestamp_millisencond);
}

void kcp_native_input(struct NativeKCP* native_kcp, uint8_t* data, int length)
{
    ikcp_input(native_kcp->kcp, (const char*)data, length);
}

int kcp_native_nodelay(struct NativeKCP* native_kcp, int nodelay, int interval, int resend, int nc)
{
    return ikcp_nodelay(native_kcp->kcp, nodelay, interval, resend, nc);
}

int kcp_native_wndsize(struct NativeKCP* native_kcp, int sndwnd, int rcvwnd)
{
    return ikcp_wndsize(native_kcp->kcp, sndwnd, rcvwnd);
}

int kcp_native_receive(struct NativeKCP* native_kcp, uint8_t* data, int length)
{
    return ikcp_recv(native_kcp->kcp, (char*)data, length);
}

int kcp_native_send(struct NativeKCP* native_kcp, uint8_t* data, int length)
{
    return ikcp_send(native_kcp->kcp, (char*)data, length);
}