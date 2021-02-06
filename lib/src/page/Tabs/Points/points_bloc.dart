

import 'package:flutter/material.dart';


enum PointState { normal, scrool }

class PointsBlocListener with ChangeNotifier {
  PointState screenState = PointState.normal;
  ScrollController _controller = ScrollController();
  ScrollController get controller => this._controller;

  ValueNotifier<bool> _show = ValueNotifier(false);
  ValueNotifier<bool> get show => this._show;




  PointsBlocListener() {
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
      print('pasamos 80');
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
    screenState = PointState.normal;
    notifyListeners();
  }

  void changeToScrool() {
    screenState = PointState.scrool;
    notifyListeners();
  }
}
