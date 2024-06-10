import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:counter/ui/_constant/util/print.dart';
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
    printLog(e);
  }
}

void navigateToNextPage() {
  Get.offAllNamed('/');
}

AlertDialog paymentsPopUp(BuildContext context, String message, bool isError) {
  // Delayed navigation after 3 seconds
  Future.delayed(const Duration(seconds: 3), () {
    removeUserData();

    // Start the player as soon as the app is displayed.

    navigateToNextPage();
    AssetsAudioPlayer.newPlayer().open(
      Audio('assets/audio/finish.wav'),
      showNotification: true,
      autoStart: true,
    );
  });
  // 결재 성공, 실패 여부 바로 확인할 수 있게 하기
  return AlertDialog(
    content: Container(
      width: 520,
      constraints: const BoxConstraints(maxHeight: 320),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isError ? "결재 실패" : "결재 성공",
            style: DevCoopTextStyle.bold_40.copyWith(
              color: isError ? DevCoopColors.error : DevCoopColors.success,
              fontSize: 30,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                message,
                style: DevCoopTextStyle.light_40.copyWith(
                  color: DevCoopColors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
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
