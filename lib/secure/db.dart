import 'dart:io';

class DbSecure {
  final String dbHost;

  DbSecure._(this.dbHost);

  static Future<DbSecure> load() async {
    // --dart-define으로 전달된 환경 변수 읽기, 없으면 기본 값으로 설정
    const dbHost = String.fromEnvironment('DB_HOST', defaultValue: 'localhost:8080');
    return DbSecure._(dbHost);
  }

  // 기본 생성자: 기본 값으로 초기화
  DbSecure() : dbHost = String.fromEnvironment('DB_HOST', defaultValue: 'localhost:8080');

  String get DB_HOST => dbHost;
}

void main() async {
  final dbSecure = await DbSecure.load();

  // 환경 변수 값 로그 파일에 기록
  final logFile = File('db_host_log.txt');
  await logFile.writeAsString('DB_HOST: ${dbSecure.DB_HOST}\n', mode: FileMode.writeOnlyAppend);

  // 콘솔 출력
  print('DB_HOST: ${dbSecure.DB_HOST}');
}
