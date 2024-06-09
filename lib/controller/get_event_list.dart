import 'dart:convert';

import 'package:counter/Dto/event_item_response_dto.dart';
import 'package:counter/secure/db.dart';
import 'package:http/http.dart' as http;

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
