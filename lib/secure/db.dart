class DbSecure {
  final String dbHost;

  DbSecure()
      : dbHost = const String.fromEnvironment('DB_HOST',
            defaultValue: 'localhost:8080');

  // DB_HOST getter 추가
  String get DB_HOST => dbHost;
}
