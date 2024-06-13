import 'dart:convert';

import 'package:counter/secure/db.dart';
import 'package:counter/ui/_constant/component/button.dart';
import 'package:counter/ui/_constant/theme/devcoop_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

Future<void> changePw(
  TextEditingController idController,
  TextEditingController pinController,
  TextEditingController newPinController,
  BuildContext context,
) async {
  DbSecure dbSecure = DbSecure();

  // 비밀번호 변경 로직 (http)
  try {
    Map<String, String> requestBody = {
      'codeNumber': idController.text,
      'pin': pinController.text,
      'newPin': newPinController.text,
    };

    String jsonData = json.encode(requestBody);

    String apiUrl = 'http://${dbSecure.DB_HOST}/kiosk/auth/pwChange';

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonData,
    );

    if (response.statusCode == 200) {
      // 성공 팝업창 띄우기
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              '비밀번호 변경 성공',
              style: DevCoopTextStyle.bold_30,
            ),
            content: const Text(
              '비밀번호가 변경되었습니다.',
              style: DevCoopTextStyle.bold_30,
            ),
            actions: <Widget>[
              mainTextButton(
                text: "확인",
                onTap: () {
                  Get.offAndToNamed("/");
                },
              ),
            ],
          );
        },
      );
    }
  } catch (e) {
    rethrow;
  }
}
