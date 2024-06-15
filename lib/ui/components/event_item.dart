import 'package:counter/ui/_constant/theme/devcoop_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

AlertDialog showEventItems(List<String> eventItemList) {
  return AlertDialog(
    content: Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 50, right: 50),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            alignment: Alignment.centerLeft,
            width: 1.sw,
            // decoration: BoxDecoration(
            //   border: Border.all(
            //     color: const Color(0xFFECECEC),
            //     width: 2,
            //   ),
            // ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                    title: SizedBox(
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
  );
}
