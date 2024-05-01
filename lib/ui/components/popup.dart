import 'package:counter/ui/_constant/theme/devcoop_text_style.dart';
import 'package:counter/ui/components/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

AlertDialog popUp(BuildContext context, String message) {
  return AlertDialog(
    title: const Text(
      'message',
      style: DevCoopTextStyle.bold_40,
    ),
    actions: <Widget>[
      buildCustomButton(
        text: "확인",
        icon: Icons.logout,
        onPressed: () {
          Get.offAndToNamed("/");
        },
      )
    ],
  );
}
