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

void main() {
  // 테스트를 위해 DB_HOST 값을 출력
  final dbSecure = DbSecure();
  print('DB_HOST: ${dbSecure.DB_HOST}');
}
