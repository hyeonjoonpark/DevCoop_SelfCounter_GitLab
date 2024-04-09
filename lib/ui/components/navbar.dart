import 'package:counter/ui/_constant/theme/devcoop_text_style.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget? navBar() {
  return PreferredSize(
    preferredSize: Size.fromHeight(100),
    child: AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "BSM 셀프계산대",
            style: DevCoopTextStyle.bold_30,
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.menu,
              size: 40,
            ),
          )
        ],
      ),
    ),
  );
}
