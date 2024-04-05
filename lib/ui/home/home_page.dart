import 'package:counter/ui/_constant/theme/devcoop_text_style.dart';
import 'package:flutter/material.dart';
import 'package:counter/ui/_constant/theme/devcoop_colors.dart';
import 'package:get/get.dart';

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Get.offAllNamed('/barcode');
        },
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Image.asset(
                "assets/images/Ocount.png",
                width: 500,
                height: 200,
              ),
              SizedBox(
                height: 100,
              ),
              Text(
                '부산소마고 매점 셀프계산대',
                style: DevCoopTextStyle.bold_50.copyWith(
                  color: DevCoopColors.black,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '지금 바로 시작해보세요!',
                style: DevCoopTextStyle.bold_50.copyWith(
                  color: DevCoopColors.black,
                ),
              ),
              Text(
                "오늘 4/5일은 김규봉 선생님의 생신이십니다",
                style: DevCoopTextStyle.bold_50.copyWith(
                  color: DevCoopColors.black,
                ),
              ),
              Text(
                "모두 축하해주세요!",
                style: DevCoopTextStyle.bold_50.copyWith(
                  color: DevCoopColors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
