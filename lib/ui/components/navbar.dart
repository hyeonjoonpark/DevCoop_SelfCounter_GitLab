import 'package:counter/ui/_constant/theme/devcoop_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:counter/ui/_constant/theme/devcoop_colors.dart';

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

List<Widget> navBarData = [
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
];

void _showPopupMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return ListView.builder(
        itemCount: 10, // 리스트 아이템의 개수
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: navBarData[index],
            onTap: () => Navigator.pop(context), // 아이템 선택 시 모달 닫기
          );
        },
      );
    },
  );
}

PreferredSizeWidget? navBar(BuildContext context) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(50),
    child: AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "BSM 셀프계산대",
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
          IconButton(
            onPressed: () {
              _showPopupMenu(context);
            },
            icon: const Icon(
              Icons.menu,
              size: 50,
            ),
          )
        ],
      ),
    ),
  );
}
