import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:counter/ui/_constant/theme/devcoop_colors.dart';
import 'package:counter/ui/_constant/theme/devcoop_text_style.dart';
import 'package:counter/ui/components/navbar.dart';

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: navBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCustomButton(
                text: "결제하러 가기",
                icon: Icons.payment,
                onPressed: () {
                  Get.offAndToNamed("/barcode");
                },
              ),
              const SizedBox(height: 20),
              _buildCustomButton(
                text: "비밀번호 변경",
                icon: Icons.lock_open,
                onPressed: () {
                  Get.offAndToNamed("/pin/change");
                },
              ),
              const SizedBox(height: 20),
              _buildCustomButton(
                text: "문의하러 가기",
                icon: Icons.question_answer,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(
            height: 90,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 100),
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
}
