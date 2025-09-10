import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  // 单例模式，全局唯一
  static final AppLogger _instance = AppLogger._internal();

  factory AppLogger() => _instance;

  late Logger _logger;

  AppLogger._internal() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0, // 调用栈显示行数
        errorMethodCount: 5,
        lineLength: 80,
        colors: true, // 彩色输出
        printEmojis: true,
        printTime: true,
      ),
      level: kReleaseMode ? Level.warning : Level.debug, // 根据环境调整日志级别
    );
  }

  Logger get logger => _logger;

  // 简单封装，方便调用
  void d(String message) => _logger.d(message);
  void i(String message) => _logger.i(message);
  void w(String message) => _logger.w(message);
  void e(String message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
}

// 全局快捷访问
final AppLogger appLogger = AppLogger();
