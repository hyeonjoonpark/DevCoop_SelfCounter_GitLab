import 'package:flutter/material.dart';

PreferredSizeWidget? footer() {
  return PreferredSize(
    preferredSize: const Size.fromHeight(200),
    child: BottomAppBar(
      height: 240,
      child: Image.asset("assets/images/footer.png", fit: BoxFit.fill),
    ),
  );
}
