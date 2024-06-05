import 'dart:convert';

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

// Future<void> getEventList(Function(List<String>) onUpdate) async {
//   final dbSecure = DbSecure(); // DbSecure 인스턴스 생성. DB 연결 정보 보유
//   try {
//     // API 호출
//     final response = await http.get(
//       Uri.parse('http://${dbSecure.DB_HOST}/kiosk/event-item/get-item'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//     );

//     if (response.statusCode == 200) {
//       // 응답 본문을 UTF-8로 디코드하여 JSON으로 파싱
//       final decodedBody = utf8.decode(response.bodyBytes);
//       List<dynamic> jsonList = json.decode(decodedBody);

//       // itemName만 추출하여 리스트 생성
//       List<String> itemList =
//           jsonList.map((item) => item['itemName'].toString()).toList();

//       // 콜백을 통해 itemList 반환
//       onUpdate(itemList);
//     } else {
//       // 오류 처리: 상태 코드가 200이 아닌 경우
//       print('Server Error: ${response.statusCode}');
//     }
//   } catch (e) {
//     // 예외 처리: HTTP 요청 실패
//     print('Failed to load event list: $e');
//   }
// }

Future<void> getEventList(Function(List<String>) onUpdate) async {
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

      List<String> itemNameList =
          jsonList.map((item) => item['itemName'].toString()).toList();

      onUpdate(itemNameList);
    } else {
      print('Server Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Failed to load event list: $e');
  }
}
