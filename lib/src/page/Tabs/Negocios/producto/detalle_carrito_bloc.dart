import 'package:flutter/material.dart';

enum ScreenState { normal, cart }

class DetailsCartBloc with ChangeNotifier {
  ScreenState screenState = ScreenState.normal;

  void changeToNormal() {
    screenState = ScreenState.normal;
    notifyListeners();
  }

  void changeToCart() {
    screenState = ScreenState.cart;
    notifyListeners();
  }
}
