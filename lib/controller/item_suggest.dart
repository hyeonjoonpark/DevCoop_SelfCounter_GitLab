import 'dart:convert';

import 'package:counter/Dto/event_item_response_dto.dart';
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

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // 응답 본문을 UTF-8로 디코드
      final decodedBody = utf8.decode(response.bodyBytes);
      print('Decoded body: $decodedBody');
      // JSON 디코드 대신 단순히 디코드된 문자열을 사용
      onUpdate(decodedBody);
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

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

Future<void> getEventList(Function(List<EventItemResponseDto>) onUpdate) async {
  final dbSecure = DbSecure();
  try {
    final response = await http.get(
      Uri.parse('http://${dbSecure.DB_HOST}/kiosk/event-item/get-item'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonList = json.decode(decodedBody);
      print("JSON List: $jsonList");

      List<EventItemResponseDto> itemList =
          jsonList.map((item) => EventItemResponseDto.fromJson(item)).toList();

      onUpdate(itemList);
    } else {
      print('Server Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Failed to load event list: $e');
  }
}
