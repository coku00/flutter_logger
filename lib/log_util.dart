import 'dart:io';

import 'package:flutterlogger/logger.dart';

////
///@Author: coku
///@Email:coku_lwp@126.com
///@Date: 2020/6/5 11:15
////
class LogUtil {
  static const String _TAG_DEFAULT = "###LogUtil###";

  static final Map<String, ILogger> _loggers = {};

  static String tagDefault = _TAG_DEFAULT;

  static void initTag({String tag = _TAG_DEFAULT}) {
    tag = tag;
  }

  static void addLogger(ILogger logger) {
    Type type = logger.runtimeType;
    if (logger == null || _loggers[type.toString()] != null) {
      return;
    }
    _loggers[type.toString()] = logger;
  }

  static void removeLogger(ILogger logger) {
    if (logger == null) {
      return;
    }
    Type type = logger.runtimeType;
    _loggers.remove(type.toString());
  }

  ///error 日志默认打印堆栈信息
  static void e(Object object,
      {String tag, bool printTrace = true, StackTrace stackTrace}) {
    StackTrace current = stackTrace;
    if (stackTrace == null) {
      current = printTrace ? StackTrace.current : null;
    }
    _loggers.forEach((String key, ILogger value) {
      value.e(tag, object, stackTrace: current);
    });
  }

  static void v(Object object, {String tag}) {
    _loggers.forEach((String key, ILogger value) {
      value.v(tag, object);
    });
  }

  static void d(Object object, {String tag}) {
    _loggers.forEach((String key, ILogger value) {
      value.d(tag, object);
    });
  }

  static Map<String, File> logFiles() {
    Map<String, File> map = {};

    if (_loggers != null && _loggers.isNotEmpty) {
      _loggers.forEach((String name, ILogger logger) {
        if (logger is FileLogger) {
          FileLogger fileLogger = logger;
          map[name] = fileLogger.file;
        }
      });
    }
    return map;
  }
}
