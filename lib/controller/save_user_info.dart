import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserData(
    String accessToken, String userCode, int userPoint, String userName) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('accessToken', accessToken);
    prefs.setString('userCode', userCode);
    prefs.setInt('userPoint', userPoint);
    prefs.setString('userName', userName);
  } catch (e) {
    rethrow;
  }
}
