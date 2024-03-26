import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:ffi/ffi.dart' as ffi;
import 'package:ffi/ffi.dart';

import 'generated_bindings.dart';

const String _libName = 'kcp';

/// The dynamic library in which the symbols for [KcpBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

final NativeKCPBindings _bindings = NativeKCPBindings(_dylib);

class _KCPInitData {
  int conv;
  SendPort commandSendPort;
  SendPort outputDataSendPort;
  SendPort receiveDataSendPort;

  _KCPInitData({
    required this.conv,
    required this.commandSendPort,
    required this.outputDataSendPort,
    required this.receiveDataSendPort,
  });
}

class _KCPStopTaskCommand {}

class KCP {
  int _conv;

  final ReceivePort _commandReceivePort = ReceivePort();
  final ReceivePort _outputDataReceivePort = ReceivePort();
  final ReceivePort _receiveDataReceivePort = ReceivePort();

  final StreamController<List<int>> _outputStreamController = StreamController();
  final StreamController<List<int>> _receiveStreamController = StreamController();

  StreamSubscription<dynamic>? _commandReceivePortSubscription;
  StreamSubscription<dynamic>? _outputDataReceivePortSubscription;
  StreamSubscription<dynamic>? _receiveDataReceivePortSubscription;

  SendPort? _commandSendPort;
  SendPort? _inputDataSendPort;
  SendPort? _sendDataSendPort;

  KCP(this._conv) {
    _commandReceivePortSubscription = _commandReceivePort.listen((message) {
      //print('command message $message');

      if (message is List<SendPort>) {
        if (message.length == 3) {
          //print('upate send port');
          _commandSendPort = message[0];
          _inputDataSendPort = message[1];
          _sendDataSendPort = message[2];
        }
      }
    });

    _outputDataReceivePortSubscription = _outputDataReceivePort.listen((message) {
      //print('kcp output data ${message.length}');
      _outputStreamController.add(message);
    });

    _receiveDataReceivePortSubscription = _receiveDataReceivePort.listen((message) {
      //print('kcp receive data ${message.length}');
      _receiveStreamController.add(message);
    });

    _KCPInitData initData = _KCPInitData(
      conv: _conv,
      commandSendPort: _commandReceivePort.sendPort,
      outputDataSendPort: _outputDataReceivePort.sendPort,
      receiveDataSendPort: _receiveDataReceivePort.sendPort,
    );

    Isolate.spawn<_KCPInitData>(task, initData);
  }

  static void initKcpPlugin() {
    _bindings.kcp_native_initialize(NativeApi.initializeApiDLData);
  }

  static void task(_KCPInitData initData) async {
    //print('task run');

    bool isStop = false;

    ReceivePort commandReceivePort = ReceivePort();
    ReceivePort inputDataReceivePort = ReceivePort();
    ReceivePort sendDataReceivePort = ReceivePort();

    ReceivePort nativeReceivePort = ReceivePort();

    nativeReceivePort.listen((message) {
      //print('task kcp native native port output data ${message.length}');
      initData.outputDataSendPort.send(message);
    });

    Pointer<NativeKCP> nativeKcp = _bindings.kcp_native_create(initData.conv, nativeReceivePort.sendPort.nativePort);

    commandReceivePort.listen((message) {
      if (message is _KCPStopTaskCommand) {
        isStop = true;
        //print('task kcp stop command');
      }
    });

    inputDataReceivePort.listen((message) {
      if (message is List<int>) {
        ffi.using((ffi.Arena arena) {
          Pointer<Uint8> p = arena<Uint8>(message.length);
          for (int i = 0; i < message.length; i++) {
            p[i] = message[i];
          }
          _bindings.kcp_native_input(nativeKcp, p, message.length);
          //print('task kcp native input data ${message.length}');
        });
      }
    });

    sendDataReceivePort.listen((message) {
      if (message is List<int>) {
        ffi.using((ffi.Arena arena) {
          Pointer<Uint8> p = arena<Uint8>(message.length);
          for (int i = 0; i < message.length; i++) {
            p[i] = message[i];
          }
          _bindings.kcp_native_send(nativeKcp, p, message.length);
          //print('task kcp native send data ${message.length}');
        });
      }
    });

    List<SendPort> sendPortList = [
      commandReceivePort.sendPort,
      inputDataReceivePort.sendPort,
      sendDataReceivePort.sendPort,
    ];
    initData.commandSendPort.send(sendPortList);

    int bufferLength = 2 * 1024 * 1024;
    Pointer<Uint8> buffer = malloc.allocate(bufferLength);

    while (!isStop) {
      _bindings.kcp_native_update(nativeKcp, DateTime.now().millisecondsSinceEpoch);

      int receiveLength = 1;
      while (receiveLength > 0) {
        receiveLength = _bindings.kcp_native_receive(nativeKcp, buffer, bufferLength);

        if (receiveLength > 0) {
          List<int> data = [];
          for (int i = 0; i < receiveLength; i++) {
            data.add(buffer[i]);
          }
          initData.receiveDataSendPort.send(data);
          //print('task kcp receive data ${data.length}');
        }
      }

      // int waitDuration = _bindings.kcp_native_check(nativeKcp, DateTime.now().millisecondsSinceEpoch);
      // print('wait $waitDuration');
      await Future.delayed(const Duration(milliseconds: 30), () => 1);
    }

    malloc.free(buffer);

    commandReceivePort.close();
    inputDataReceivePort.close();
    sendDataReceivePort.close();
  }

  Stream<List<int>> get outputStream {
    return _outputStreamController.stream;
  }

  Stream<List<int>> get receiveStream {
    return _receiveStreamController.stream;
  }

  void inputData(List<int> data) {
    //print('kcp input data ${data.length}');
    _inputDataSendPort?.send(data);
  }

  void sendData(List<int> data) {
    //print('kcp send data ${data.length}');
    _sendDataSendPort?.send(data);
  }

  void close() {
    _commandReceivePortSubscription?.cancel();
    _outputDataReceivePortSubscription?.cancel();
    _receiveDataReceivePortSubscription?.cancel();

    _commandSendPort?.send(_KCPStopTaskCommand());
  }
}
