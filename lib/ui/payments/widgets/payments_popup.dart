import 'package:counter/ui/_constant/theme/devcoop_colors.dart';
import 'package:counter/ui/_constant/theme/devcoop_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> removeUserData() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('codeNumber');
    prefs.remove('pin');
    prefs.remove('point');
    prefs.remove('studentName');
  } catch (e) {
    print(e);
  }
}

void navigateToNextPage() {
  // Use Navigator to push a new page
  Get.offAllNamed('/');
}

AlertDialog paymentsPopUp(BuildContext context, String message) {
  // Delayed navigation after 3 seconds
  Future.delayed(const Duration(seconds: 3), () {
    removeUserData();
    navigateToNextPage();
  });

  return AlertDialog(
    content: Container(
      width: 520,
      constraints: BoxConstraints(
        maxHeight:
            MediaQuery.of(context).size.height * 0.7, // 최대 높이를 화면의 70%로 설정
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                message,
                style: DevCoopTextStyle.light_40.copyWith(
                  color: DevCoopColors.black,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "잠시후에 처음화면으로 돌아갑니다",
            style: DevCoopTextStyle.medium_30.copyWith(
              color: DevCoopColors.black,
            ),
          ),
        ],
      ),
    ),
  );
}
