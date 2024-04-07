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
              const SizedBox(
                height: 100,
              ),
              const Text("원하시는 서비스를 선택해주세요", style: DevCoopTextStyle.bold_30),
              const SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.offAllNamed('/barcode');
                    },
                    child: Container(
                      width: 350,
                      height: 500,
                      color: DevCoopColors.primary,
                      child: const Center(
                          child: Column(
                        children: [
                          SizedBox(
                            height: 70,
                          ),
                          Icon(
                            Icons.qr_code_scanner_rounded,
                            size: 250,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            '셀프계산대 계산하기',
                            style: DevCoopTextStyle.bold_30,
                          ),
                        ],
                      )),
                    ),
                  ),
                  const SizedBox(
                    width: 400,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.offAllNamed('/pin/change');
                    },
                    child: Container(
                      width: 350,
                      height: 500,
                      color: DevCoopColors.primary,
                      child: const Center(
                          child: Column(
                        children: [
                          SizedBox(
                            height: 70,
                          ),
                          Icon(
                            Icons.password,
                            size: 250,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            '비밀번호 변경하기',
                            style: DevCoopTextStyle.bold_30,
                          ),
                        ],
                      )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
