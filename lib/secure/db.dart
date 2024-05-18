import 'dart:io';

class DbSecure {
  final String dbHost;

  DbSecure._(this.dbHost);

  static Future<DbSecure> load() async {
    // 환경 변수 읽기, 없으면 기본 값으로 설정
    String dbHost = Platform.environment['DB_HOST'] ?? 'localhost';
    return DbSecure._(dbHost);
  }

  String get DB_HOST => dbHost;
}