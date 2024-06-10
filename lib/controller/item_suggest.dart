import 'dart:convert';

import 'package:counter/controller/print.dart';
import 'package:counter/secure/db.dart';
import 'package:http/http.dart' as http;

Future<void> suggest(Function(String) onUpdate, String randomData) async {
  final dbSecure = DbSecure();
  try {
    final response = await http.get(
      Uri.parse('http://${dbSecure.DB_HOST}/kiosk/item/ai/suggest'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    printLog('Response status: ${response.statusCode}');
    printLog('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // 응답 본문을 UTF-8로 디코드
      final decodedBody = utf8.decode(response.bodyBytes);
      printLog('Decoded body: $decodedBody');
      // JSON 디코드 대신 단순히 디코드된 문자열을 사용
      onUpdate(decodedBody);
    } else {
      printLog('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    printLog('Error: $e');
  }
}
