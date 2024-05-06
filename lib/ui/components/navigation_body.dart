import 'package:counter/provider/bottom_navigation_provider.dart';
import 'package:counter/ui/_constant/theme/devcoop_colors.dart';
import 'package:counter/ui/barcode/barcode_page.dart';
import 'package:counter/ui/pin/pin_change.dart';
import 'package:flutter/cupertino.dart';

Widget navigationBody(BottomNavigationProvider provider) {
  return provider.currentPage == 0
      ? const BarcodePage()
      : provider.currentPage == 1
          ? const PinChange()
          : const Center(
              child: Text(
                "준비 중",
                style: TextStyle(
                  color: DevCoopColors.primary,
                  fontSize: 70,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
}
