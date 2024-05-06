import 'package:counter/ui/_constant/theme/devcoop_colors.dart';
import 'package:counter/ui/_constant/theme/devcoop_text_style.dart';
import 'package:flutter/material.dart';

Widget buildCustomButton({
  required String text,
  required IconData icon,
  required VoidCallback onPressed,
}) {
  return ElevatedButton.icon(
    onPressed: onPressed,
    icon: Icon(icon, size: 50),
    label: Text(text, style: DevCoopTextStyle.bold_30),
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: DevCoopColors.primary, // 버튼 텍스트 색상
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      elevation: 5.0,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      textStyle: DevCoopTextStyle.bold_30.copyWith(color: Colors.white),
    ),
  );
}
