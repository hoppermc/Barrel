import 'dart:io';

import 'package:console/console.dart';

class FallbackSizedStdioConsoleAdapter extends ConsoleAdapter {

  bool unsizedTerminal = false;

  @override
  int get columns {
    if (unsizedTerminal) return 80;
    try {
      return stdout.terminalColumns;
    } catch(_) {
      unsizedTerminal = true;
      return 80;
    }
  }
  @override
  int get rows{
    if (unsizedTerminal) return 24;
    try {
      return stdout.terminalLines;
    } catch(_) {
      unsizedTerminal = true;
      return 24;
    }
  }

  @override
  String read() => stdin.readLineSync()!;

  @override
  Stream<List<int>> byteStream() => stdin;

  @override
  void write(String? data) {
    stdout.write(data);
  }

  @override
  void writeln(String? data) {
    stdout.writeln(data);
  }

  @override
  set echoMode(bool value) {
    stdin.echoMode = value;
  }

  @override
  bool get echoMode => stdin.echoMode;

  @override
  set lineMode(bool value) {
    stdin.lineMode = value;
  }

  @override
  bool get lineMode => stdin.lineMode;

  @override
  int readByte() => stdin.readByteSync();
}
