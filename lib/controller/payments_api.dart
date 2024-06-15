import 'package:counter/dto/item_response_dto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<http.Response> executePaymentRequest(
  String apiUrl,
  String token,
  String savedCodeNumber,
  String savedStudentName,
  int totalPrice,
  List<ItemResponseDto> items,
) async {
  return await http.post(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(<String, dynamic>{
      "userPointRequest": {
        "codeNumber": savedCodeNumber,
        "totalPrice": totalPrice,
      },
      "payLogRequest": {
        "codeNumber": savedCodeNumber,
        "innerPoint": totalPrice,
        "studentName": savedStudentName,
      },
      "kioskRequest": {
        "items": [
          for (var item in items)
            {
              "itemName": item.itemName,
              "dcmSaleAmt": item.itemPrice,
              "saleQty": item.quantity,
            }
        ],
        "userId": savedCodeNumber,
      }
    }),
  );
}
