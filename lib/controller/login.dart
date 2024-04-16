import 'dart:convert';
import 'package:counter/controller/save_user_info.dart';
import 'package:counter/secure/db.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginController {
  final dbSecure = DbSecure();
  Future<void> login(
      BuildContext context, String codeNumber, String pin) async {
    print(codeNumber);
    print(pin);
    Map<String, String> requestBody = {'codeNumber': codeNumber, 'pin': pin};

    String jsonData = json.encode(requestBody);
    print(jsonData);

    String apiUrl = 'http://${dbSecure.DB_HOST}/kiosk/auth/signIn';
    print(apiUrl);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonData,
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode != 200) {
        Get.snackbar("Error", "Invalid code number or pin",
            backgroundColor: Colors.red, duration: const Duration(seconds: 2));
        return;
      }

      if (response.statusCode == 200) {
        print("로그인 성공");

        // 응답 본문을 UTF-8로 디코딩
        Map<String, dynamic> responseBody = json
            .decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

        print("responseBody = $responseBody");

        String token = responseBody['token'] ?? '';
        String studentName = responseBody['studentName'] ?? '';
        int studentNumber = responseBody['studentNumber'] ?? 0;
        int point = responseBody['point'] ?? 0;

        Object result =
            saveUserData(token, codeNumber, studentNumber, point, studentName);

        print(result);
        print("저장성공");

        Get.offAllNamed('/check');
      }
    } catch (e) {
      print("Exception caught: $e");
    }
  }
}
