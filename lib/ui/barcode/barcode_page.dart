import 'package:counter/ui/_constant/component/button.dart';
import 'package:counter/ui/_constant/theme/devcoop_text_style.dart';
import 'package:counter/ui/_constant/theme/devcoop_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// TODO : 디자인 갈아엎어야 함

/**
 * TODO :
 * 1. 학생증 바코드 스캔페이지 디자인 UI/UX 수정
 * 2. 바코드 입력창에 입력이 안되는 문제 해결
 */

class BarcodePage extends StatefulWidget {
  const BarcodePage({Key? key}) : super(key: key);

  @override
  State<BarcodePage> createState() => _BarcodePageState();
}

class _BarcodePageState extends State<BarcodePage> {
  final TextEditingController _codeNumberController =
      TextEditingController(text: '');
  final FocusNode _barcodeFocus = FocusNode();

  void _setActiveController(TextEditingController controller) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 90,
        ),
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              "학생증의 바코드를\n리더기로 스캔해주세요.",
              style: DevCoopTextStyle.bold_40.copyWith(
                color: DevCoopColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 90,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            // width: 160,
                            child: Text(
                              '학생증 번호',
                              style: DevCoopTextStyle.medium_30.copyWith(
                                color: DevCoopColors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _setActiveController(_codeNumberController);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 34,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFFECECEC),
                                  borderRadius: BorderRadius.circular(
                                    20,
                                  ),
                                ),
                                child: TextField(
                                  controller: _codeNumberController,
                                  focusNode: _barcodeFocus,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                    hintText: '학생증을 리더기에 스캔해주세요',
                                    hintStyle: DevCoopTextStyle.medium_30
                                        .copyWith(fontSize: 15),
                                    border: InputBorder.none,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          mainTextButton(
                            text: '처음으로',
                            onTap: () {
                              Get.toNamed('/home');
                            },
                          ),
                          mainTextButton(
                            text: '다음으로',
                            onTap: () {
                              Get.toNamed("/pin",
                                  arguments: _codeNumberController.text);
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
