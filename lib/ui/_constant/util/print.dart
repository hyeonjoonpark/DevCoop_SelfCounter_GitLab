import 'dart:io';
import 'package:logging/logging.dart';

void setupLogging() {
  // Logger 초기화
  Logger.root.level = Level.ALL; // 모든 레벨의 로그를 출력할 수 있도록 설정
  Logger.root.onRecord.listen((LogRecord record) {
    final logMessage =
        '${record.level.name}: ${record.time}: ${record.message}\n';
    _writeLogToFile(logMessage);
  });
}

void _writeLogToFile(String message) {
  final logFile = File('app.log'); // 로그 파일 경로 설정
  logFile.writeAsStringSync(message,
      mode: FileMode.append, flush: true); // 로그 파일에 기록
}

void printLog(dynamic message) {
  final Logger log = Logger('MyLogger'); // 로거 인스턴스 생성
  log.info(message); // info 레벨로 로그 출력
}

void main() {
  setupLogging(); // 로깅 설정 초기화
  printLog('This is a log message'); // 로그 메시지 출력
}
