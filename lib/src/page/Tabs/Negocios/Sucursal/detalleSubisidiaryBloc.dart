



import 'package:flutter/material.dart';


enum PageDetailsSucursal { informacion, productos,servicios }

class DetailSubsidiaryBloc with ChangeNotifier { 

  ValueNotifier<PageDetailsSucursal> _page = ValueNotifier(PageDetailsSucursal.informacion);
  ValueNotifier<PageDetailsSucursal> get page => this._page;


  /* 
  ScrollController _controller = ScrollController();
  ScrollController get controller => this._controller;
  
 
 */
/* 
  ValueNotifier<bool> _vistaFiltro = ValueNotifier(false);
  ValueNotifier<bool> get showFiltrod => this._vistaFiltro; */

  DetailSubsidiaryBloc() {
    print('init');
     
  }  
  
  @override
  void dispose() { 
    super.dispose();
  }

  void changeToInformation() { 
    _page.value = PageDetailsSucursal.informacion;
    notifyListeners();
  }

  void changeToProductos() { 
    _page.value = PageDetailsSucursal.productos;
    notifyListeners();
  }


  void changeToServicios() { 
    _page.value = PageDetailsSucursal.servicios;
    notifyListeners();
  }
}
