import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:counter/secure/db.dart';

Future<void> getTopList(Function(List<String>) onUpdate) async {
  final dbSecure = DbSecure();
  try {
    final response = await http.get(
      Uri.parse('http://${dbSecure.DB_HOST}/kiosk/item/top/list'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // 응답 본문을 UTF-8로 디코드
      final decodedBody = utf8.decode(response.bodyBytes);
      print('Decoded body: $decodedBody');
      try {
        List<String> topList = List<String>.from(json.decode(decodedBody));
        onUpdate(topList);
      } catch (e) {
        print('JSON decode error: $e');
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
