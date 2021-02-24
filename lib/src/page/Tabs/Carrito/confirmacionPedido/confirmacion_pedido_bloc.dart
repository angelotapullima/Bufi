import 'package:flutter/material.dart';


enum ConfirMPedidoState { normal, scrool }

class ConfirmPedidoBloc with ChangeNotifier {
  ConfirMPedidoState screenState = ConfirMPedidoState.normal;
  ScrollController _controller = ScrollController();
  ScrollController get controller => this._controller;
  
  ValueNotifier<bool> _show = ValueNotifier(false);
  ValueNotifier<bool> get show => this._show;



  ValueNotifier<bool> _cargando = ValueNotifier(false);
  ValueNotifier<bool> get showCargando => this._cargando;



  ConfirmPedidoBloc() {
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
    /* if (_controller.position.userScrollDirection == ScrollDirection.reverse) {
      print(controller.offset);
    } else if (_controller.position.userScrollDirection == ScrollDirection.forward) {
      print(controller.position.outOfRange);
    } */
  }




  void changeCargando() {

     if (_cargando.value) {
        _cargando.value = false;
      } else {
        _cargando.value = true;
      }


    /* if (_show.value) {

      print('true');

      if (_cargando.value) {
        _cargando.value = false;
      } else {
        _cargando.value = true;
      }
      _show.value=false;
    }else{
       if (_cargando.value) {
        _cargando.value = false;
      } else {
        _cargando.value = true;
      }

    } */
  } 

  @override
  void dispose() {
    _controller?.removeListener(_listener);
    _controller?.dispose();
    super.dispose();
  }

  void changeToNormal() {
    screenState = ConfirMPedidoState.normal;
    notifyListeners();
  }

  void changeToScrool() {
    screenState = ConfirMPedidoState.scrool;
    notifyListeners();
  }
}
