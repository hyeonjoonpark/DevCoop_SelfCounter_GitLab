import 'package:counter/provider/bottom_navigation_provider.dart';
import 'package:counter/ui/_constant/theme/devcoop_colors.dart';
import 'package:flutter/material.dart';

Widget bottomNavigationBarWidget(BottomNavigationProvider provider) {
  return BottomNavigationBar(
    items: const [
      BottomNavigationBarItem(
        icon: Icon(
          Icons.qr_code,
          size: 70,
        ),
        label: '결제하기',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.password,
          size: 70,
        ),
        label: '핀 변경',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.restaurant_menu,
          size: 70,
        ),
        label: '인기상품',
      ),
    ],
    onTap: (index) {
      provider.updateCurrentPage(index);
    },
    currentIndex: provider.currentPage, // current page
    selectedItemColor: DevCoopColors.primary,
  );
}
