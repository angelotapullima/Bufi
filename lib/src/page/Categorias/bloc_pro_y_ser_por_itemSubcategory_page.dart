



import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:flutter/material.dart';


class BsPorItemSubcategory with ChangeNotifier {
  
  ScrollController _controller = ScrollController();
  ScrollController get controller => this._controller;

  ValueNotifier<bool> _show = ValueNotifier(false);
  ValueNotifier<bool> get showNegocios => this._show;

  ValueNotifier<bool> _vistaFiltro = ValueNotifier(false);
  ValueNotifier<bool> get showFiltro => this._vistaFiltro;

  BuildContext context;

  BsPorItemSubcategory({this.context}) {
    _init();
  }
  void _init() {
    _controller.addListener(_listener);

  }

  void _listener() {
    print(controller.offset);


    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      print('pixels ${_controller.position.pixels}');
      print('maxScrool ${_controller.position.maxScrollExtent}');
      print('dentro');
 
      final negociosBloc = ProviderBloc.negocios(context);
      negociosBloc.listarnegocios();
    }

    

  /*   if (controller.offset > 50) {
      changeToScrool();
      _show.value = true;
      print('pasamos 80');
    } else if (controller.offset < 40) {
      changeToNormal();

      _show.value = false;
    } */
  }

  void lptmr() {
    if (_show.value) {
      print('true');

      if (_vistaFiltro.value) {
        _vistaFiltro.value = false;
      } else {
        _vistaFiltro.value = true;
      }
      _show.value = false;
    } else {
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
  
}
