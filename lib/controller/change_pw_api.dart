import 'dart:convert';

import 'package:counter/secure/db.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

Future<void> changePw(
  TextEditingController _idController,
  TextEditingController _pinController,
  BuildContext context,
) async {
  DbSecure dbSecure = DbSecure();

  // 비밀번호 변경 로직 (http)
  try {
    Map<String, String> requestBody = {
      'codeNumber': _idController.text,
      'pin': _pinController.text,
    };

    String jsonData = json.encode(requestBody);
    print(jsonData);

    String apiUrl = 'http://${dbSecure.DB_HOST}/kiosk/auth/pwChange';
    print(apiUrl);

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonData,
    );

    if (response.statusCode == 200) {
      print('비밀번호 변경 성공');
      Get.offAndToNamed("/home");
    }
  } catch (e) {
    print(e);
  }
}
