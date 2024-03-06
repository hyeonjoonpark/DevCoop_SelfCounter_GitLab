import 'package:counter/controller/number_click.dart';
import 'package:counter/ui/_constant/component/button.dart';
import 'package:counter/ui/_constant/theme/devcoop_text_style.dart';
import 'package:counter/ui/_constant/theme/devcoop_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PinPage extends StatefulWidget {
  final String codeNumber;
  PinPage({Key? key, required this.codeNumber}) : super(key: key);

  @override
  _PinPageState createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  get FilteringTextInputFormatter => null;

  final TextEditingController _codeNumberController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _barcodeFocus = FocusNode();
  TextEditingController? _activeController;

  @override
  Widget build(BuildContext context) {
    // 변경: 바코드 입력 창이 포커싱되지 않도록 수정
    if (_activeController != _codeNumberController) {
      FocusScope.of(context).requestFocus(_barcodeFocus);
    }

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
                    children: [
                      for (int i = 0; i < 4; i++) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            for (int j = 0; j < 3; j++) ...[
                              GestureDetector(
                                onTap: () {
                                  int _number = j + 1 + i * 3;
                                  onNumberButtonPressed(
                                      _number == 11 ? 0 : _number,
                                      _pinController);
                                },
                                child: Container(
                                  width: 95,
                                  height: 95,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: (j + 1 + i * 3 == 10 ||
                                            j + 1 + i * 3 == 12)
                                        ? DevCoopColors.primary
                                        : const Color(0xFFD9D9D9),
                                  ),
                                  child: Text(
                                    '${j + 1 + i * 3 == 10 ? 'Clear' : (j + 1 + i * 3 == 11 ? '0' : (j + 1 + i * 3 == 12 ? 'Del' : j + 1 + i * 3))}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: DevCoopColors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (i < 3) ...[
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 160,
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
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(
                                        '[0-9]',
                                      ),
                                    ),
                                  ],
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
                            onTap: () {},
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

  void _setActiveController(TextEditingController controller) {
    setState(() {
      _activeController = controller;
    });
  }
}
