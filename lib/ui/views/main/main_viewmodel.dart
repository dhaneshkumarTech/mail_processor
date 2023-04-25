import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class MainViewModel extends BaseViewModel {
  final pageController = PageController();

  int currentIndex = 0;

  void setIndex(int index) {
    currentIndex = index;
    pageController.jumpToPage(index);
    notifyListeners();
  }
}
