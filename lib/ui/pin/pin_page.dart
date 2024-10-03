import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:counter/controller/login.dart';
import 'package:counter/ui/_constant/component/button.dart';
import 'package:counter/ui/_constant/theme/devcoop_colors.dart';
import 'package:counter/ui/_constant/theme/devcoop_text_style.dart';
import 'package:counter/ui/payments/payments_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_pinFocus);
    });
  }

  void onNumberButtonPressed(int number) {
    String currentText = _pinController.text;

    if (number == 10) {
      _pinController.clear(); // C 버튼: 클리어
    } else if (number == 12) {
      if (currentText.isNotEmpty) {
        _pinController.text =
            currentText.substring(0, currentText.length - 1); // D 버튼: 삭제
      }
    } else {
      String newText =
          currentText + (number == 11 ? '0' : number.toString()); // 0 버튼
      _pinController.text = newText;
    }

    AssetsAudioPlayer.newPlayer().open(
      Audio('assets/audio/click.wav'),
      showNotification: true,
    );
  }

  void _handleSubmit() {
    final loginController = LoginController();
    loginController.login(
      context,
      widget.codeNumber,
      _pinController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => Scaffold(
        backgroundColor: const Color(0xFFF0F4F8), // 배경색
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 아이콘 사용
                  Container(
                    decoration: BoxDecoration(
                      color: DevCoopColors.primary.withOpacity(0.1), // 연한 배경
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(20),
                    child: const Icon(
                      Icons.pin, // 바코드 스캐너 아이콘
                      size: 60,
                      color: DevCoopColors.primary, // 아이콘 색상
                    ),
                  ),
                  const SizedBox(height: 20),

                  // PIN 입력 필드
                  // PIN 입력 필드
                  Container(
                    width: 0.5.sw, // 가로 길이 조정
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFEFEF),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      obscureText: true,
                      controller: _pinController,
                      focusNode: _pinFocus,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '핀 번호를 입력해주세요';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        _handleSubmit();
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        hintText: '핀 번호',
                        hintStyle: DevCoopTextStyle.medium_30
                            .copyWith(fontSize: 14, color: Colors.grey[600]),
                        border: InputBorder.none,
                      ),
                      maxLines: 1,
                      style: const TextStyle(fontSize: 16), // 텍스트 크기 줄임
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: 0.6.sw,
                    child: Column(
                      children: [
                        for (int i = 0; i < 4; i++) // 4행
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                            ), // 세로 간격 늘리기
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround, // 중앙 정렬
                              children: [
                                for (int j = 0; j < 3; j++) // 3열
                                  GestureDetector(
                                    onTap: () {
                                      int number = j + 1 + i * 3;
                                      onNumberButtonPressed(
                                          number == 11 ? 0 : number);
                                    },
                                    child: Container(
                                      width: 100, // 버튼 너비 조정
                                      height: 50, // 버튼 높이 조정
                                      decoration: BoxDecoration(
                                        color: (j + 1 + i * 3 == 10 ||
                                                j + 1 + i * 3 == 12)
                                            ? DevCoopColors.primary
                                            : const Color(0xFFD9D9D9),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        j + 1 + i * 3 == 10
                                            ? 'C'
                                            : (j + 1 + i * 3 == 11
                                                ? '0'
                                                : (j + 1 + i * 3 == 12
                                                    ? 'D'
                                                    : '${j + 1 + i * 3}')),
                                        style: const TextStyle(
                                          fontSize: 18, // 글자 크기 조정
                                          fontWeight: FontWeight.bold,
                                          color: DevCoopColors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 버튼을 수평으로 배치
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      mainTextButton(
                        text: '처음으로',
                        onTap: () {
                          Get.offAllNamed('/');
                        },
                        color: Colors.grey[300],
                        // width 매개변수를 제거하여 텍스트 길이에 따라 자동 조정
                      ),
                      const SizedBox(
                        width: 48,
                      ),
                      mainTextButton(
                        text: '확인',
                        onTap: () {
                          _handleSubmit();
                        },
                        // width 매개변수를 제거하여 텍스트 길이에 따라 자동 조정
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
