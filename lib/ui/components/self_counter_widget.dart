import 'dart:convert';

import 'package:counter/controller/item_suggest.dart';
import 'package:counter/secure/db.dart';
import 'package:counter/ui/_constant/theme/devcoop_colors.dart';
import 'package:counter/ui/_constant/theme/devcoop_text_style.dart';
import 'package:counter/ui/components/button.dart';
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
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 1.sw,
              margin: const EdgeInsets.only(left: 50),
              child: const Text(
                "많은 학생들이 좋아하는 상품을 알아보아요",
                style: DevCoopTextStyle.bold_50,
              ),
            ),
            SizedBox(
              height: 0.05.sh,
            ),
            Container(
              width: 1.sw,
              margin: const EdgeInsets.only(left: 50),
              child: const Text(
                "학생들이 가장 많이 구매한 상품을 알 수 있어요",
                style: DevCoopTextStyle.bold_30,
              ),
            ),
            Expanded(
              // 이제 Column 내부에 있으므로 정상적으로 작동합니다.
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
                              )),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 0.05.sh,
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 50),
              child: const Text(
                "무엇을 먹을지 고민일 때는 랜덤으로 돌려보세요",
                style: DevCoopTextStyle.bold_50,
              ),
            ),
            SizedBox(
              height: 0.05.sh,
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 50),
              child: Text(
                isClick ? "랜덤상품은 바로 ~~~ $randomData" : "랜덤으로 추천하는 상품을 확인해보세요",
                style: DevCoopTextStyle.bold_30,
              ),
            ),
            SizedBox(
              height: 0.05.sh,
            ),
            Container(
              margin: const EdgeInsets.only(left: 50, right: 50),
              child: buildCustomButton(
                text: "랜덤뽑기",
                icon: Icons.food_bank,
                onPressed: () {
                  suggest(
                      (p0) => setState(() {
                            randomData = p0;
                            isClick = true;
                          }),
                      randomData!);
                },
              ),
            ),
            SizedBox(
              height: 0.05.sh,
            ),
          ],
        ),
      ),
    );
  }
}
