import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:counter/secure/db.dart';
import 'package:counter/ui/_constant/component/button.dart';
import 'package:counter/ui/_constant/theme/devcoop_text_style.dart';
import 'package:counter/ui/_constant/theme/devcoop_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../controller/login.dart';
import 'package:get/get.dart';

class PinPage extends StatefulWidget {
  final String codeNumber;
  const PinPage({Key? key, required this.codeNumber}) : super(key: key);

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocus = FocusNode();
  final dbSecure = DbSecure();

  void _setActiveController(TextEditingController controller) {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // 화면이 나타난 후에 포커스를 지정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_pinFocus);
    });
  }

  void onNumberButtonPressed(
      int number, TextEditingController activeController) {
    String currentText = activeController.text;

    if (number == 10) {
      activeController.clear();
    } else if (number == 12) {
      // Del button
      if (currentText.isNotEmpty) {
        String newText = currentText.substring(0, currentText.length - 1);
        activeController.text = newText;
      }
    } else {
      // 숫자 버튼 (0 포함)
      String newText = currentText + (number == 11 ? '0' : number.toString());
      activeController.text = newText;
    }
  }

  void _handleSubmit() {
    LoginController loginController = LoginController();
    loginController.login(
      context,
      widget.codeNumber,
      _pinController.text,
    );
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "핀 번호를 입력해주세요",
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
                                    // 숫자버튼 클릭하면 소리나도록
                                    int number = j + 1 + i * 3;
                                    onNumberButtonPressed(
                                      number == 11 ? 0 : number,
                                      _pinController,
                                    );
                                    AssetsAudioPlayer.newPlayer().open(
                                      Audio('assets/audio/click.wav'),
                                      showNotification: true,
                                    );
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
                                '핀 번호',
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
                                  _setActiveController(_pinController);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 34,
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFECECEC),
                                    borderRadius: BorderRadius.circular(
                                      20,
                                    ),
                                  ),
                                  child: TextFormField(
                                    obscureText: true,
                                    // TextField 대신 TextFormField을 사용합니다.
                                    controller: _pinController,
                                    focusNode: _pinFocus,
                                    validator: (value) {
                                      // 여기에 validator 추가
                                      if (value == null || value.isEmpty) {
                                        return '핀 번호를 입력해주세요';
                                      }
                                      return null;
                                    },
                                    onFieldSubmitted: (value) {
                                      _handleSubmit(); // 엔터를 눌렀을 때 호출되는 함수
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      isDense: true,
                                      hintText: '자신의 핀번호를 입력해주세요',
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
                                Get.offAllNamed('/');
                              },
                            ),
                            mainTextButton(
                              text: '확인',
                              onTap: () {
                                _handleSubmit(); // 확인 버튼 클릭 시 호출되는 함수
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
      ),
    );
  }
}
