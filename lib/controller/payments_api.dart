import 'package:counter/Dto/item_response_dto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<http.Response> executePaymentRequest(
    String apiUrl,
    String token,
    String savedCodeNumber,
    String savedStudentName,
    int totalPrice,
    ItemResponseDto item) async {
  return await http.post(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(<String, dynamic>{
      "userPointRequest": {
        "codeNumber": savedCodeNumber,
        "totalPrice": totalPrice
      },
      "payLogRequest": {
        "codeNumber": savedCodeNumber,
        "innerPoint": totalPrice,
        "studentName": savedStudentName,
      },
      "kioskRequest": {
        "dcmSaleAmt": item.itemPrice,
        "userId": savedCodeNumber,
        "itemName": item.itemName,
        "saleQty": item.quantity
      }
    }),
  );
}
