import 'package:counter/ui/_constant/theme/devcoop_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BarcodePage extends StatefulWidget {
  const BarcodePage({Key? key}) : super(key: key);

  @override
  State<BarcodePage> createState() => _BarcodePageState();
}

class _BarcodePageState extends State<BarcodePage> with WidgetsBindingObserver {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _codeNumberController = TextEditingController();
  final FocusNode _barcodeFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    _codeNumberController =
        TextEditingController(text: ''); // 새로운 TextEditingController 인스턴스 생성
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshContent();
    });
  }

  void _refreshContent() {
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _codeNumberController.text = '';
        FocusScope.of(context).requestFocus(_barcodeFocus);
      });
    });
  }

  @override
  void dispose() {
    _codeNumberController.dispose();
    _barcodeFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => Scaffold(
        backgroundColor: DevCoopColors.primaryLight, // 부드러운 회색 배경
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Container(
              width: 0.4.sw,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 아이콘 사용
                    Container(
                      decoration: BoxDecoration(
                        color: DevCoopColors.primary.withOpacity(0.1), // 연한 배경
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(20),
                      child: const Icon(
                        Icons.qr_code_scanner, // 바코드 스캐너 아이콘
                        size: 60,
                        color: DevCoopColors.primary, // 아이콘 색상
                      ),
                    ),
                    const SizedBox(height: 50),
                    // const Text(
                    //   '학생증 스캔',
                    //   style: TextStyle(
                    //     fontSize: 20,
                    //     fontWeight: FontWeight.bold,
                    //     color: Color(0xFF333333), // 어두운 텍스트
                    //   ),
                    //   textAlign: TextAlign.center,
                    // ),
                    // const SizedBox(height: 20),

                    Container(
                      width: 300,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white, // 텍스트 필드 배경을 흰색으로
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: DevCoopColors.primary,
                            width: 1), // 메인 색상으로 테두리
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        obscureText: true,
                        controller: _codeNumberController,
                        focusNode: _barcodeFocus,
                        decoration: const InputDecoration(
                          hintText: '학생증 번호 입력',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        onFieldSubmitted: (value) {
                          if (_formKey.currentState?.validate() ?? false) {
                            final codeNumber = _codeNumberController.text;
                            Get.offAllNamed("/pin", arguments: codeNumber);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 300,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DevCoopColors.primary, // 버튼 색상
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Get.offAllNamed("/pin/change");
                        },
                        child: const Text(
                          '비밀번호 변경',
                          style: TextStyle(
                            fontSize: 16,
                            color: DevCoopColors.white, // 버튼 텍스트 색상
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 지문 인식 버튼 추가
                    SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DevCoopColors.white, // 버튼 색상
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 50,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          // 지문 인식 로직 추가 필요
                          // 실제 지문 인식 코드를 여기에 구현
                          // 예시: Get.offAllNamed("/pin", arguments: codeNumber);
                        },
                        child: const Text(
                          '지문 인식',
                          style: TextStyle(
                            fontSize: 16,
                            color: DevCoopColors.primary, // 버튼 텍스트 색상
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      width: 300,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DevCoopColors.primary, // 버튼 색상
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState != null &&
                              _formKey.currentState!.validate()) {
                            final codeNumber = _codeNumberController.text;
                            Get.toNamed("/pin", arguments: codeNumber);
                          }
                        },
                        child: const Text(
                          '다음',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white, // 버튼 텍스트 색상
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
