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
            children: [],
          ),
          // 매점상품 리스트
        ],
      ),
    );
  }
}
