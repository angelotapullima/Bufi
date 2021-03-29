

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class FiltroContinuoBloc with ChangeNotifier {
  
  List<CategoriaTab> tabsMarcas = [];
  List<CategoriaTab> tabsModelos = [];
  List<CategoriaTab> tabsTallas = [];

  List<String> tallasFiltradas = [];
  List<String> modelosFiltradas = [];
  List<String> marcasFiltradas = [];

  void init() async {

   /*  final listTallitas = List<String>();
    final listMarquitas = List<String>();
    final listModelitos = List<String>();

    final tallasDatos = await tallasDatabase.obtenerTallaProducto();
    final modelosDatos = await modelosDatabase.obtenerModeloProducto();
    final marcasDatos = await marcasDatabase.obtenerMarcaProducto();

    for (var i = 0; i < tallasDatos.length; i++) {
      listTallitas.add(tallasDatos[i].tallaProducto);
    }
    for (var i = 0; i < marcasDatos.length; i++) {
      listMarquitas.add(marcasDatos[i].marcaProducto);
    }
    for (var i = 0; i < modelosDatos.length; i++) {
      listModelitos.add(modelosDatos[i].modeloProducto);
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
        CategoriaTab(
            itemNombre: listModelitos2[i], selected: false),
      );
    }

    for (var i = 0; i < listTallitas2.length; i++) {
      tabsTallas.add(
        CategoriaTab(itemNombre: listTallitas2[i], selected: false),
      );
    }

    print(tabsMarcas.length);
  }

  void onCategorySelectedMarcas(int value) {
    final selected = tabsMarcas[value];

    print(tabsMarcas[value].itemNombre);
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
    } */

    notifyListeners();
  }

  void onCategorySelectedModelos(int value) {
    final selected = tabsModelos[value];

    print(tabsModelos[value].itemNombre);

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
    final selected = tabsTallas[value];

    print(tabsTallas[value].itemNombre);

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
