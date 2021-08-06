import 'package:flutter/material.dart';

enum PageDetailsSucursal { informacion, productos, servicios }

class DetailSubsidiaryBloc with ChangeNotifier {
  ScrollController controller = ScrollController();

  ValueNotifier<PageDetailsSucursal> _page = ValueNotifier(PageDetailsSucursal.informacion);
  ValueNotifier<PageDetailsSucursal> get page => this._page;

  ValueNotifier<bool> ocultarSafeArea = ValueNotifier(true);
  ValueNotifier<bool> get ocultarSafeAreaStream => this.ocultarSafeArea;

  BuildContext context;

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
