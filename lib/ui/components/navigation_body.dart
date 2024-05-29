import 'package:counter/provider/bottom_navigation_provider.dart';
import 'package:counter/ui/barcode/barcode_page.dart';
import 'package:counter/ui/components/self_counter_widget.dart';
import 'package:counter/ui/pin/pin_change.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget navigationBody(BottomNavigationProvider provider) {
  return provider.currentPage == 0
      ? const BarcodePage()
      : provider.currentPage == 1
          ? const PinChange()
          : const SelfCounterWidget();
}
