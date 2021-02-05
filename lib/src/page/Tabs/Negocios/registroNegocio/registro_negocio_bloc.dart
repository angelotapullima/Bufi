


import 'package:flutter/material.dart';


enum RegistroState { normal, scrool }

class RegistroNegocioBlocListener with ChangeNotifier {
  RegistroState screenState = RegistroState.normal;
  ScrollController _controller = ScrollController();
  ScrollController get controller => this._controller;
  
  ValueNotifier<bool> _show = ValueNotifier(false);
  ValueNotifier<bool> get show => this._show;



  RegistroNegocioBlocListener() {
    _init();
  } 
  void _init() {
    _controller.addListener(_listener);
  }

  void _listener() {
    print(controller.offset);

    if (controller.offset > 50) {
      changeToScrool();
      _show.value = true;
    } else if (controller.offset < 40) {
      changeToNormal();

      _show.value = false;
    }
  }
  
  @override
  void dispose() {
    _controller?.removeListener(_listener);
    _controller?.dispose();
    super.dispose();
  }

  void changeToNormal() {
    screenState = RegistroState.normal;
    notifyListeners();
  }

  void changeToScrool() {
    screenState = RegistroState.scrool;
    notifyListeners();
  }
}


