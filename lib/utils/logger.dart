import 'dart:developer';

class LogColor {
  static const black = "\x1B[30m";
  static const red = "\x1B[31m";
  static const green = "\x1B[32m";
  static const yellow = "\x1B[33m";
  static const blue = "\x1B[34m";
  static const magenta = "\x1B[35m";
  static const cyan = "\x1B[36m";
  static const white = "\x1B[37m";
  static const lightGrey = " \x1B[37;1m";
  static const darkGrey = "\x1B[90m";
}

class AppLogger {
  static const showLog = true;

  /// Log a message at level [Level.verbose].
  static void v(dynamic message, {dynamic error, StackTrace? stackTrace, String? functionName}) {
    if (!showLog) return;
    log(
      LogColor.magenta + message.toString() + LogColor.magenta,
      error: error,
      stackTrace: stackTrace,
      name: "${LogColor.white}${functionName ?? ""}${LogColor.white}",
    );
  }

  /// Log a message at level [Level.debug].
  static void d(dynamic message, {dynamic error, StackTrace? stackTrace, String? functionName}) {
    if (!showLog) return;
    log(
      LogColor.green + message.toString() + LogColor.green,
      error: error,
      stackTrace: stackTrace,
      name: "${LogColor.white}${functionName ?? ""}${LogColor.white}",
    );
  }

  /// Log a message at level [Level.info].
  static void i(dynamic message, {dynamic error, StackTrace? stackTrace, String? functionName}) {
    if (!showLog) return;
    log(
      LogColor.cyan + message.toString() + LogColor.cyan,
      error: error,
      stackTrace: stackTrace,
      name: "${LogColor.white}${functionName ?? ""}${LogColor.white}",
    );
  }

  /// Log a message at level [Level.warning].
  static void w(dynamic message, {dynamic error, StackTrace? stackTrace, String? functionName}) {
    if (!showLog) return;
    log(
      LogColor.yellow + message.toString() + LogColor.yellow,
      error: error,
      stackTrace: stackTrace,
      name: "${LogColor.white}${functionName ?? ""}${LogColor.white}",
    );
  }

  /// Log a message at level [Level.error].
  static void e(dynamic message, {dynamic error, StackTrace? stackTrace, String? functionName}) {
    if (!showLog) return;
    log(
      LogColor.red + message.toString() + LogColor.red,
      error: error != null ? LogColor.red + error.toString() + LogColor.red : null,
      stackTrace: stackTrace,
      name: "${LogColor.white}${functionName ?? ""}${LogColor.white}",
    );
  }

  /// Log a message at level [Level.Custom].
  static void custom(
    dynamic message, {
    String color = "",
    dynamic error,
    StackTrace? stackTrace,
    String? functionName,
  }) {
    if (!showLog) return;
    log(
      color + message.toString() + color,
      error: error,
      stackTrace: stackTrace,
      name: "${LogColor.white}${functionName ?? ""}${LogColor.white}",
    );
  }
}
