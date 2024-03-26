// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint
import 'dart:ffi' as ffi;

/// kcp header
class NativeKCPBindings {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  NativeKCPBindings(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  NativeKCPBindings.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  void kcp_native_initialize(
    ffi.Pointer<ffi.Void> dartApiData,
  ) {
    return _kcp_native_initialize(
      dartApiData,
    );
  }

  late final _kcp_native_initializePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>(
          'kcp_native_initialize');
  late final _kcp_native_initialize = _kcp_native_initializePtr
      .asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  void kcp_native_terminate() {
    return _kcp_native_terminate();
  }

  late final _kcp_native_terminatePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function()>>('kcp_native_terminate');
  late final _kcp_native_terminate =
      _kcp_native_terminatePtr.asFunction<void Function()>();

  ffi.Pointer<NativeKCP> kcp_native_create(
    int conv,
    int native_port,
  ) {
    return _kcp_native_create(
      conv,
      native_port,
    );
  }

  late final _kcp_native_createPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<NativeKCP> Function(
              ffi.Uint32, ffi.Int64)>>('kcp_native_create');
  late final _kcp_native_create = _kcp_native_createPtr
      .asFunction<ffi.Pointer<NativeKCP> Function(int, int)>();

  void kcp_native_destroy(
    ffi.Pointer<NativeKCP> native_kcp,
  ) {
    return _kcp_native_destroy(
      native_kcp,
    );
  }

  late final _kcp_native_destroyPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<NativeKCP>)>>(
          'kcp_native_destroy');
  late final _kcp_native_destroy = _kcp_native_destroyPtr
      .asFunction<void Function(ffi.Pointer<NativeKCP>)>();

  void kcp_native_update(
    ffi.Pointer<NativeKCP> native_kcp,
    int timestamp_millisencond,
  ) {
    return _kcp_native_update(
      native_kcp,
      timestamp_millisencond,
    );
  }

  late final _kcp_native_updatePtr = _lookup<
          ffi
          .NativeFunction<ffi.Void Function(ffi.Pointer<NativeKCP>, ffi.Int)>>(
      'kcp_native_update');
  late final _kcp_native_update = _kcp_native_updatePtr
      .asFunction<void Function(ffi.Pointer<NativeKCP>, int)>();

  int kcp_native_check(
    ffi.Pointer<NativeKCP> native_kcp,
    int timestamp_millisencond,
  ) {
    return _kcp_native_check(
      native_kcp,
      timestamp_millisencond,
    );
  }

  late final _kcp_native_checkPtr = _lookup<
          ffi
          .NativeFunction<ffi.Int Function(ffi.Pointer<NativeKCP>, ffi.Int)>>(
      'kcp_native_check');
  late final _kcp_native_check = _kcp_native_checkPtr
      .asFunction<int Function(ffi.Pointer<NativeKCP>, int)>();

  void kcp_native_input(
    ffi.Pointer<NativeKCP> native_kcp,
    ffi.Pointer<ffi.Uint8> data,
    int length,
  ) {
    return _kcp_native_input(
      native_kcp,
      data,
      length,
    );
  }

  late final _kcp_native_inputPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Pointer<NativeKCP>, ffi.Pointer<ffi.Uint8>,
              ffi.Int)>>('kcp_native_input');
  late final _kcp_native_input = _kcp_native_inputPtr.asFunction<
      void Function(ffi.Pointer<NativeKCP>, ffi.Pointer<ffi.Uint8>, int)>();

  int kcp_native_nodelay(
    ffi.Pointer<NativeKCP> native_kcp,
    int nodelay,
    int interval,
    int resend,
    int nc,
  ) {
    return _kcp_native_nodelay(
      native_kcp,
      nodelay,
      interval,
      resend,
      nc,
    );
  }

  late final _kcp_native_nodelayPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Pointer<NativeKCP>, ffi.Int, ffi.Int, ffi.Int,
              ffi.Int)>>('kcp_native_nodelay');
  late final _kcp_native_nodelay = _kcp_native_nodelayPtr
      .asFunction<int Function(ffi.Pointer<NativeKCP>, int, int, int, int)>();

  int kcp_native_wndsize(
    ffi.Pointer<NativeKCP> native_kcp,
    int sndwnd,
    int rcvwnd,
  ) {
    return _kcp_native_wndsize(
      native_kcp,
      sndwnd,
      rcvwnd,
    );
  }

  late final _kcp_native_wndsizePtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(
              ffi.Pointer<NativeKCP>, ffi.Int, ffi.Int)>>('kcp_native_wndsize');
  late final _kcp_native_wndsize = _kcp_native_wndsizePtr
      .asFunction<int Function(ffi.Pointer<NativeKCP>, int, int)>();

  int kcp_native_receive(
    ffi.Pointer<NativeKCP> native_kcp,
    ffi.Pointer<ffi.Uint8> data,
    int length,
  ) {
    return _kcp_native_receive(
      native_kcp,
      data,
      length,
    );
  }

  late final _kcp_native_receivePtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Pointer<NativeKCP>, ffi.Pointer<ffi.Uint8>,
              ffi.Int)>>('kcp_native_receive');
  late final _kcp_native_receive = _kcp_native_receivePtr.asFunction<
      int Function(ffi.Pointer<NativeKCP>, ffi.Pointer<ffi.Uint8>, int)>();

  int kcp_native_send(
    ffi.Pointer<NativeKCP> native_kcp,
    ffi.Pointer<ffi.Uint8> data,
    int length,
  ) {
    return _kcp_native_send(
      native_kcp,
      data,
      length,
    );
  }

  late final _kcp_native_sendPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Pointer<NativeKCP>, ffi.Pointer<ffi.Uint8>,
              ffi.Int)>>('kcp_native_send');
  late final _kcp_native_send = _kcp_native_sendPtr.asFunction<
      int Function(ffi.Pointer<NativeKCP>, ffi.Pointer<ffi.Uint8>, int)>();

  int sum(
    int a,
    int b,
  ) {
    return _sum(
      a,
      b,
    );
  }

  late final _sumPtr =
      _lookup<ffi.NativeFunction<ffi.IntPtr Function(ffi.IntPtr, ffi.IntPtr)>>(
          'sum');
  late final _sum = _sumPtr.asFunction<int Function(int, int)>();

  int sum_long_running(
    int a,
    int b,
  ) {
    return _sum_long_running(
      a,
      b,
    );
  }

  late final _sum_long_runningPtr =
      _lookup<ffi.NativeFunction<ffi.IntPtr Function(ffi.IntPtr, ffi.IntPtr)>>(
          'sum_long_running');
  late final _sum_long_running =
      _sum_long_runningPtr.asFunction<int Function(int, int)>();
}

final class NativeKCP extends ffi.Opaque {}