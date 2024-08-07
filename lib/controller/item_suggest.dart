import 'dart:convert';

import 'package:counter/secure/db.dart';
import 'package:http/http.dart' as http;

Future<void> suggest(Function(String) onUpdate, String randomData) async {
  final dbSecure = DbSecure();
  try {
    final response = await http.get(
      Uri.parse('${dbSecure.DB_HOST}/kiosk/item/ai/suggest'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // 응답 본문을 UTF-8로 디코드
      final decodedBody = utf8.decode(response.bodyBytes);
      // JSON 디코드 대신 단순히 디코드된 문자열을 사용
      onUpdate(decodedBody);
    } else {
      throw Exception(response.statusCode);
    }
  } catch (e) {
    rethrow;
  }
}
