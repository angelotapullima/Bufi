import 'package:flutter/material.dart';

enum NegocioState { normal, scrool }

class NegociosBlocListener with ChangeNotifier {
  NegocioState screenState = NegocioState.normal;
  ScrollController _controller = ScrollController();
  ScrollController get controller => this._controller;

  ValueNotifier<bool> _show = ValueNotifier(false);
  ValueNotifier<bool> get showNegocios => this._show;

  ValueNotifier<bool> _vistaFiltro = ValueNotifier(false);
  ValueNotifier<bool> get showFiltro => this._vistaFiltro;

  NegociosBlocListener() {
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

  void lptmr() {
    if (_show.value) {
      print('true');

      if (_vistaFiltro.value) {
        _vistaFiltro.value = false;
      } else {
        _vistaFiltro.value = true;
      }
      _show.value=false;
    }else{
       if (_vistaFiltro.value) {
        _vistaFiltro.value = false;
      } else {
        _vistaFiltro.value = true;
      }

    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_listener);
    _controller?.dispose();
    super.dispose();
  }

  void changeToNormal() {
    screenState = NegocioState.normal;
    notifyListeners();
  }

  void changeToScrool() {
    screenState = NegocioState.scrool;
    notifyListeners();
  }
}
