import 'package:counter/secure/db.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> changePw(
  TextEditingController _idController,
  TextEditingController _pinController,
  BuildContext context,
) async {
  DbSecure dbSecure = DbSecure();

  String apiUrl = 'http://${dbSecure.DB_HOST}/kiosk/auth/pwchange';
  print(apiUrl);
  // 비밀번호 변경 로직 (http)
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json; charset=UTF-8',
      },
      body: {
        'codeNumber': _idController.text,
        'newPin': _pinController.text,
      },
    );

    if (response.statusCode == 200) {
      print('비밀번호 변경 성공');
    }
  } catch (e) {
    print(e);
  }
}
