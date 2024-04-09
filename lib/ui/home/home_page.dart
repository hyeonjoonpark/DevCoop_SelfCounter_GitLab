import 'package:counter/ui/_constant/theme/devcoop_text_style.dart';
import 'package:flutter/material.dart';
import 'package:counter/ui/components/navbar.dart';

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: navBar(context),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // 추천상품
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "오늘의 추천상품",
                  style: DevCoopTextStyle.bold_30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
