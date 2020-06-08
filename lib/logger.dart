import 'dart:io';

///
///@Author: coku
///@Email:coku_lwp@126.com
///@Date: 2020/6/5 11:15
////

///
/// ILogger
///
///
abstract class ILogger {
  static const String _default = '###Logger###';

  ///verbose
  static const String V = 'v';

  ///debug
  static const String D = 'd';

  ///warning
  static const String W = 'w';

  ///error
  static const String E = 'e';

  void v(String tag, Object o);

  void d(String tag, Object o);

  void w(String tag, Object o);

  void e(String tag, Object o, {StackTrace stackTrace});
}

class FileLogger extends ILogger {
  File _file;

  final String dire;
  final String fileName;

  final bool asynchronous;

  FileLogger({this.dire, this.fileName, this.asynchronous = false}) {
    try {
      _file = File('$dire$fileName');
      if (!_file.existsSync()) {
        _file.createSync(recursive: true);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void d(String tag, Object o) {
    _writeLog(tag, ILogger.D, o);
  }

  @override
  void e(String tag, Object o, {StackTrace stackTrace}) {
    _writeLog(tag, ILogger.E, o);
  }

  @override
  void w(String tag, Object o) {
    _writeLog(tag, ILogger.W, o);
  }

  @override
  void v(String tag, Object o) {
    _writeLog(tag, ILogger.V, o);
  }

  File get file => _file;

  String get dir => dir;

  String get name => fileName;

  String get path => file.path;

  void _writeLog(String tag, String level, Object o) {
    if (asynchronous) {
      Future(() {
        _write(tag, level, o);
      });
    } else {
      _write(tag, level, o);
    }
  }

  void _write(String tag, String level, Object o, {StackTrace stackTrace}) {
    StringBuffer sb = StringBuffer();
    sb.write('${DateTime.now()} ');
    sb.write(tag ?? ILogger._default);
    sb.write(' $level : ');
    sb.write(o);

    if (stackTrace != null) {
      sb.write(
          '\n************************  Error Log StackTrace Start ************************\n\n');
      sb.write('${stackTrace.toString()}\n');
      sb.write(
          '************************ Error Log StackTrace End ************************\n');
    }

    sb.write('\n');
    try {
      //防止用户在没杀掉进程的情况下把缓存文件清了，报错
      _file.writeAsStringSync(sb.toString(), mode: FileMode.append);
    } catch (e) {
      print(e);
    }
  }
}

class VerboseLogger extends FileLogger {
  VerboseLogger(String dir, String fileName, {bool asynchronous})
      : super(dire: dir, fileName: fileName, asynchronous: asynchronous);

  @override
  void e(String tag, Object o, {StackTrace stackTrace}) {}

  @override
  void d(String tag, Object o) {}

  @override
  void w(String tag, Object o) {}
}

class DebugLogger extends FileLogger {
  DebugLogger(String dir, String fileName, {bool asynchronous})
      : super(dire: dir, fileName: fileName, asynchronous: asynchronous);

  @override
  void e(String tag, Object o, {StackTrace stackTrace}) {}

  @override
  void v(String tag, Object o) {}

  @override
  void w(String tag, Object o) {}
}

class ErrorLogger extends FileLogger {
  ErrorLogger(String dir, String fileName, {bool asynchronous})
      : super(dire: dir, fileName: fileName, asynchronous: asynchronous);

  @override
  void d(String tag, Object o) {}

  @override
  void v(String tag, Object o) {}

  @override
  void w(String tag, Object o) {}
}

class WarnLogger extends FileLogger {
  WarnLogger(String dir, String fileName, {bool asynchronous})
      : super(dire: dir, fileName: fileName, asynchronous: asynchronous);

  @override
  void v(String tag, Object o) {}

  @override
  void d(String tag, Object o) {}

  @override
  void e(String tag, Object o, {StackTrace stackTrace}) {}
}

class PrintLogger extends ILogger {
  final bool debug;

  PrintLogger(this.debug);

  @override
  void d(String tag, Object o) {
    _println(tag, ILogger.D, o);
  }

  @override
  void e(String tag, Object o, {StackTrace stackTrace}) {
    _println(tag, ILogger.E, o);
  }

  @override
  void v(String tag, Object o) {
    _println(tag, ILogger.V, o);
  }

  @override
  void w(String tag, Object o) {
    _println(tag, ILogger.W, o);
  }

  void _println(String tag, String level, Object o, {StackTrace stackTrace}) {
    if (debug) {
      StringBuffer sb = StringBuffer();
      sb.write('${DateTime.now()} ');
      sb.write(tag ?? ILogger._default);
      sb.write(' $level : ');
      sb.write(o);
      if (stackTrace != null) {
        sb.write(
            '\n************************  Error Log StackTrace Start ************************\n\n');
        sb.write('${stackTrace.toString()}\n');
        sb.write(
            '************************ Error Log StackTrace End ************************\n\n');
      }
      print(sb.toString());
    }
  }
}
