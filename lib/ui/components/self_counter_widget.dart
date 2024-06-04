import 'package:counter/controller/item_suggest.dart';
import 'package:counter/secure/db.dart';
import 'package:counter/ui/_constant/theme/devcoop_colors.dart';
import 'package:flutter/material.dart';
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
  List<String> eventItemList = [];
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

    getEventList((List<String> newList) {
      setState(() {
        eventItemList = newList;
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
                "학생들이 가장 많이 구매한 상품은 무엇일까?",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 50, right: 50),
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
                          margin: const EdgeInsets.all(10),
                          color: index % 2 == 0
                              ? DevCoopColors.primary
                              : DevCoopColors.white,
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
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    topList[index].split(",")[1],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black,
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
            Container(
              width: 1.sw,
              padding: EdgeInsets.only(left: 12.w, top: 30.h),
              child: const Text(
                "이벤트 상품을 확인해보세요",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),

            /*
            * TODO : 이벤트 상품 리스트 결제 페이지로 이동
            * 상품 리스트 클릭 시 장바구니에 추가되도록 구현
            */

            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: Column(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 1.sw,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5, // 한 행에 배치될 아이템 개수
                        crossAxisSpacing: 10, // 아이템 간의 가로 간격
                        mainAxisSpacing: 10, // 아이템 간의 세로 간격
                        childAspectRatio: 2, // 아이템의 가로 대 세로 비율
                      ),
                      itemCount: eventItemList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: index % 2 == 0
                              ? DevCoopColors.primary
                              : DevCoopColors.transparent,
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
                              child: Text(
                                eventItemList[index],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
