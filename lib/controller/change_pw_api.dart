import 'dart:convert';

import 'package:counter/secure/db.dart';
import 'package:counter/ui/_constant/component/button.dart';
import 'package:counter/ui/_constant/theme/devcoop_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

Future<void> changePw(
  TextEditingController _idController,
  TextEditingController _pinController,
  TextEditingController _newPinController,
  BuildContext context,
) async {
  final dbSecure = Provider.of<DbSecure>(context, listen: false);

  // 비밀번호 변경 로직 (http)
  try {
    Map<String, String> requestBody = {
      'codeNumber': _idController.text,
      'pin': _pinController.text,
      'newPin': _newPinController.text,
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
    } else {
      print('비밀번호 변경 실패: ${response.statusCode}');
      // 실패 팝업창 띄우기
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              '비밀번호 변경 실패',
              style: DevCoopTextStyle.bold_30,
            ),
            content: const Text(
              '비밀번호 변경에 실패했습니다.',
              style: DevCoopTextStyle.bold_30,
            ),
            actions: <Widget>[
              mainTextButton(
                text: "확인",
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  } catch (e) {
    print(e);
    // 예외 처리 팝업창 띄우기
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '오류',
            style: DevCoopTextStyle.bold_30,
          ),
          content: const Text(
            '비밀번호 변경 중 오류가 발생했습니다.',
            style: DevCoopTextStyle.bold_30,
          ),
          actions: <Widget>[
            mainTextButton(
              text: "확인",
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
