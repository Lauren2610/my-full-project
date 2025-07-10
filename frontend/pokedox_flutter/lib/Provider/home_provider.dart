import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  int selectedIndex = 0;
  bool isDisposed = false;

  PageController pageController = PageController(initialPage: 0);

  void onPageChange(int index) {
    selectedIndex = index;
    safeChangeNotifier();
  }

  void safeChangeNotifier() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}
