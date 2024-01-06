import 'package:flutter/material.dart';

import '../../viewmodel/auth.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  BaseState(){
    pageController = PageController();
  }
  ThemeData get themeData => Theme.of(context);
  
  int _currentIndex = 0;
  int get currentIndex =>_currentIndex;
  set currentIndex(int itemIndex){
    this._currentIndex = itemIndex;
  }
  String get userId => Auth().currentUser!.uid;
  PageController? pageController;
  changeCurrentIndex(int itemIndex) => currentIndex = itemIndex;
  double dynamicHeight(double value) => MediaQuery.sizeOf(context).height * value;
  double dynamicWidth(double value) => MediaQuery.sizeOf(context).width * value;
}
