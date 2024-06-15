class DbSecure {
  final String dbHost;

  DbSecure()
      : dbHost = const String.fromEnvironment('DB_HOST',
            defaultValue: 'localhost:8080');

  // DB_HOST getter 추가
  // ignore: non_constant_identifier_names
  String get DB_HOST => dbHost;
}
