import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../_constant/theme/devcoop_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckStudent extends StatefulWidget {
  const CheckStudent({Key? key}) : super(key: key);

  @override
  State<CheckStudent> createState() => _CheckStudentState();
}

class _CheckStudentState extends State<CheckStudent> {
  String savedStudentName = '';
  int savedPoint = 0;
  String savedCodeNumber = '';

  @override
  void initState() {
    super.initState();
    loadUserData();

    // Delayed navigation after 5 seconds
    Future.delayed(const Duration(seconds: 3), () {
      navigateToNextPage();
    });
  }

  void navigateToNextPage() {
    Get.toNamed('/payments');
  }

  Future<void> loadUserData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final String loadedStudentName = prefs.getString('userName') ?? '';
      final int loadedPoint = prefs.getInt('userPoint') ?? 0;
      final String loadedCodeNumber = prefs.getString('userCode') ?? '';

      // if (loadedCodeNumber != null && loadedCodeNumber.isNotEmpty) {

      setState(() {
        savedStudentName = loadedStudentName;
        savedPoint = loadedPoint;
        savedCodeNumber = loadedCodeNumber;
      });
      // }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 24),
              child: Text(
                '$savedStudentName 학생 \n 잔액 $savedPoint원 조회되었습니다',
                textAlign: TextAlign.center,
                style: GoogleFonts.nanumGothic(
                  fontSize: 30,
                  color: DevCoopColors.black,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 32),
              child: Image.asset(
                'assets/images/accept.png',
                width: 200,
                height: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
