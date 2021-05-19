import 'package:flutter/material.dart';

class ConfirmacionTipoEntregaBlocBloc with ChangeNotifier {
  ValueNotifier<int> _show = ValueNotifier(0);
  ValueNotifier<int> get show => this._show;

  void changeIndex(int index) {
    _show.value = index;
    notifyListeners();
  }
}
