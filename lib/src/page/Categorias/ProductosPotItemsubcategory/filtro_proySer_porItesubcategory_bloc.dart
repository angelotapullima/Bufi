import 'package:bufi/src/database/producto_bd.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class FiltroProAndSerPorItemBloc with ChangeNotifier {
  final productoDatabase = ProductoDatabase();

  List<CategoriaTab> tabsMarcas = [];
  List<CategoriaTab> tabsModelos = [];
  List<CategoriaTab> tabsTallas = [];
  List<CategoriaTab> tabsTipos = [];

  List<String> tallasFiltradas = [];
  List<String> modelosFiltradas = [];
  List<String> marcasFiltradas = [];
  List<String> tiposFiltradas = [];

  void init(String idItemsubcategory) async {
    final productos =
        await productoDatabase.consultarProductoPorIdItemsub(idItemsubcategory);

    final List<String> listTallitas = [];
    final List<String> listMarquitas = [];
    final List<String> listModelitos = [];

    for (var i = 0; i < productos.length; i++) {
      listTallitas.add(productos[i].productoSize);
      listMarquitas.add(productos[i].productoBrand);
      listModelitos.add(productos[i].productoModel);
    }

    final listTallitas2 = listTallitas.toSet().toList();
    final listMarquitas2 = listMarquitas.toSet().toList();
    final listModelitos2 = listModelitos.toSet().toList();

    for (var i = 0; i < listMarquitas2.length; i++) {
      tabsMarcas.add(
        CategoriaTab(itemNombre: listMarquitas2[i], selected: false),
      );
    }

    for (var i = 0; i < listModelitos2.length; i++) {
      tabsModelos.add(
        CategoriaTab(itemNombre: listModelitos2[i], selected: false),
      );
    }

    for (var i = 0; i < listTallitas2.length; i++) {
      tabsTallas.add(
        CategoriaTab(itemNombre: listTallitas2[i], selected: false),
      );
    }

    tabsTipos.add(CategoriaTab(itemNombre: 'Productos', selected: false));
    tabsTipos.add(CategoriaTab(itemNombre: 'Servicios', selected: false));
  }

  void onCategorySelectedMarcas(int value) {
    marcasFiltradas.clear();
    final selected = tabsMarcas[value];
    for (var i = 0; i < tabsMarcas.length; i++) {
      bool ctv;
      bool algo;

      //if (!condition) {
      if (selected.itemNombre == tabsMarcas[i].itemNombre) {
        algo = selected.selected;

        if (algo) {
          ctv = false;
        } else {
          ctv = true;
        }
      } else {
        ctv = tabsMarcas[i].selected;
      }

      tabsMarcas[i] = tabsMarcas[i].copyWith(ctv);
    }

    for (var i = 0; i < tabsMarcas.length; i++) {
      if (tabsMarcas[i].selected) {
        marcasFiltradas.add(tabsMarcas[i].itemNombre);
      }
    }

    notifyListeners();
  }

  void onCategorySelectedModelos(int value) {
    modelosFiltradas.clear();
    final selected = tabsModelos[value];

    for (var i = 0; i < tabsModelos.length; i++) {
      bool ctv;
      bool algo;

      //if (!condition) {
      if (selected.itemNombre == tabsModelos[i].itemNombre) {
        algo = selected.selected;

        if (algo) {
          ctv = false;
        } else {
          ctv = true;
        }
      } else {
        ctv = tabsModelos[i].selected;
      }

      tabsModelos[i] = tabsModelos[i].copyWith(ctv);
    }

    for (var i = 0; i < tabsModelos.length; i++) {
      if (tabsModelos[i].selected) {
        modelosFiltradas.add(tabsModelos[i].itemNombre);
      }
    }

    notifyListeners();
  }

  void onCategorySelectedTallas(int value) {
    tallasFiltradas.clear();
    final selected = tabsTallas[value];

    for (var i = 0; i < tabsTallas.length; i++) {
      bool ctv;
      bool algo;
      //if (!condition) {
      if (selected.itemNombre == tabsTallas[i].itemNombre) {
        algo = selected.selected;

        if (algo) {
          ctv = false;
        } else {
          ctv = true;
        }
      } else {
        ctv = tabsTallas[i].selected;
      }

      tabsTallas[i] = tabsTallas[i].copyWith(ctv);
    }

    for (var i = 0; i < tabsTallas.length; i++) {
      if (tabsTallas[i].selected) {
        tallasFiltradas.add(tabsTallas[i].itemNombre);
      }
    }
    notifyListeners();
  }

  void onCategorySelectedTipo(int value) {
    tiposFiltradas.clear();
    final selected = tabsTipos[value];

    for (var i = 0; i < tabsTipos.length; i++) {
      bool ctv;
      bool algo;
      //if (!condition) {
      if (selected.itemNombre == tabsTipos[i].itemNombre) {
        algo = selected.selected;

        if (algo) {
          ctv = false;
        } else {
          ctv = true;
        }
      } else {
        ctv = tabsTipos[i].selected;
      }

      tabsTipos[i] = tabsTipos[i].copyWith(ctv);
    }

    for (var i = 0; i < tabsTipos.length; i++) {
      if (tabsTipos[i].selected) {
        tiposFiltradas.add(tabsTipos[i].itemNombre);
      }
    }
    notifyListeners();
  }
}

class CategoriaTab {
  final String itemNombre;
  final bool selected;

  CategoriaTab copyWith(bool selected) => CategoriaTab(
        itemNombre: itemNombre,
        selected: selected,
      );

  CategoriaTab({@required this.itemNombre, @required this.selected});
}
