import 'package:counter/controller/item_suggest.dart';
import 'package:counter/secure/db.dart';
import 'package:counter/ui/_constant/theme/devcoop_colors.dart';
import 'package:counter/ui/_constant/theme/devcoop_text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelfCounterWidget extends StatefulWidget {
  const SelfCounterWidget({Key? key}) : super(key: key);

  @override
  State<SelfCounterWidget> createState() => _SelfCounterWidgetState();
}

class _SelfCounterWidgetState extends State<SelfCounterWidget> {
  final dbSecure = DbSecure();
  String suggestData = "";
  List<String> topList = [];

  @override
  void initState() {
    super.initState();
    getTopList((List<String> newList) {
      setState(() {
        topList = newList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 1.sw,
              margin: const EdgeInsets.only(left: 50),
              child: const Text(
                "인기상품 ♥︎",
                style: DevCoopTextStyle.bold_50,
              ),
            ),
            Expanded(
              // 이제 Column 내부에 있으므로 정상적으로 작동합니다.
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(topList.length, (index) {
                        return Container(
                          margin: const EdgeInsets.only(
                            left: 50,
                            top: 10,
                            right: 50,
                          ),
                          color: index % 2 == 0
                              ? DevCoopColors.primary
                              : Colors.white12,
                          child: ListTile(
                            shape: Border.all(
                              color: const Color(0xFFECECEC),
                              width: 2,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 10.0,
                            ),
                            title: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.white10,
                              ),
                              child: Text(
                                '${index + 1}등 ${topList[index]}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: DevCoopColors.black,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
