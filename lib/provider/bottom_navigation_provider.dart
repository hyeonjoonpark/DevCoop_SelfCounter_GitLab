import 'package:flutter/cupertino.dart';

class BottomNavigationProvider extends ChangeNotifier {
  int _index = 0;
  int get currentPage => _index;

  updateCurrentPage(int index) {
    _index = index;
    notifyListeners();
  }
}
