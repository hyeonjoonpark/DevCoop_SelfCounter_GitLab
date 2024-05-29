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
  String? randomData = "랜덤으로 추천하는 상품을 확인해보세요";
  bool isClick = false;

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
        body: ListView(
          children: [
            Container(
              width: 1.sw,
              padding: EdgeInsets.only(left: 12.w, top: 30.h),
              child: const Text(
                "인기상품 알아보기",
                style: DevCoopTextStyle.bold_30,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: Expanded(
                // 이제 Column 내부에 있으므로 정상적으로 작동합니다.
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: 1.sw,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFECECEC),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(topList.length, (index) {
                          return Container(
                            margin: const EdgeInsets.only(
                                left: 10, top: 10, right: 10, bottom: 10),
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
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${index + 1}등 ${topList[index].split(",")[0]}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: DevCoopColors.black,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      topList[index].split(",")[1],
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: DevCoopColors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
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
