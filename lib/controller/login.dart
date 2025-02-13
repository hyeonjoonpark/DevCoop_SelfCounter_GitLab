import 'dart:convert';
import 'package:counter/controller/save_user_info.dart';
import 'package:counter/secure/db.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginController {
  final dbSecure = DbSecure();
  Future<void> login(
      BuildContext context, String userCode, String userPin) async {
    Map<String, String> requestBody = {
      'userCode': userCode,
      'userPin': userPin
    };

    String jsonData = json.encode(requestBody);

    String apiUrl = '${dbSecure.DB_HOST}/kiosk/auth/signIn';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonData,
      );

      if (response.statusCode != 200) {
        Get.snackbar("Error", "학생증 번호 또는 핀 번호가 잘못되었습니다",
            colorText: Colors.white,
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2));
        return;
      }

      if (response.statusCode == 200) {
        // 응답 본문을 UTF-8로 디코딩
        Map<String, dynamic> responseBody = json
            .decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

        String token = responseBody['token'] ?? '';
        String userName = responseBody['userName'] ?? '';

        int userPoint = responseBody['userPoint'] ?? 0;

        saveUserData(token, userCode, userPoint, userName);

        Get.offAllNamed('/check');
      }
    } catch (e) {
      rethrow;
    }
  }
}
