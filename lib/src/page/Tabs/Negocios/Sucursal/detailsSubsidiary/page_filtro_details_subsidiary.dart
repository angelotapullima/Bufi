import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:bufi/src/widgets/extentions.dart';

class FiltroPageProductosPorSubsidiary extends StatefulWidget {
  const FiltroPageProductosPorSubsidiary({
    Key key,
    @required this.iconPressed,
    @required this.idSubsidiary,
  }) : super(key: key);

  final VoidCallback iconPressed;
  final String idSubsidiary;

  @override
  _FiltroPageProductosPorSubsidiaryState createState() =>
      _FiltroPageProductosPorSubsidiaryState();
}

class _FiltroPageProductosPorSubsidiaryState
    extends State<FiltroPageProductosPorSubsidiary> {
  final bloc = FiltroProductosPorIdSubsidiaryBloc();

  final logger = Logger();

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: Icon(Icons.close),
            iconSize: responsive.ip(3),
            onPressed: () {
              widget.iconPressed();
            },
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.wp(3),
              ),
              child: ContenidoFilterProductosPorIdSubsidiary(
                  iconPressed: widget.iconPressed,
                  idSubsidiary: widget.idSubsidiary),
            ),
          ),
        ],
      ),
    );
  }
}

class ContenidoFilterProductosPorIdSubsidiary extends StatefulWidget {
  ContenidoFilterProductosPorIdSubsidiary({
    Key key,
    @required this.iconPressed,
    @required this.idSubsidiary,
  }) : super(key: key);

  final VoidCallback iconPressed;
  final String idSubsidiary;

  @override
  _ContenidoFilterState createState() => _ContenidoFilterState();
}

class _ContenidoFilterState
    extends State<ContenidoFilterProductosPorIdSubsidiary> {
  final bloc = FiltroProductosPorIdSubsidiaryBloc();

  @override
  void initState() {
    bloc.init(widget.idSubsidiary);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productoBloc = ProviderBloc.productos(context);

    final responsive = Responsive.of(context);
    return AnimatedBuilder(
      animation: bloc,
      builder: (_, __) => Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: bloc.tabsMarcas.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: responsive.hp(1),
                          ),
                          child: Text(
                            'Marcas',
                            style: TextStyle(
                                fontSize: responsive.ip(2),
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      }

                      int i = index - 1;

                      return Row(
                        children: [
                          Checkbox(
                              value: bloc.tabsMarcas[i].selected,
                              onChanged: (valor) {
                                bloc.onCategorySelectedMarcas(i);
                              }),
                          Expanded(
                            child: Text('${bloc.tabsMarcas[i].itemNombre}'),
                          ),
                        ],
                      );
                    }),
                ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: bloc.tabsModelos.length + 1,
                    itemBuilder: (context, indexx) {
                      if (indexx == 0) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: responsive.hp(1),
                            top: responsive.hp(1.5),
                          ),
                          child: Text(
                            'Modelos',
                            style: TextStyle(
                                fontSize: responsive.ip(2),
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      }

                      int x = indexx - 1;

                      return Row(
                        children: [
                          Checkbox(
                              value: bloc.tabsModelos[x].selected,
                              onChanged: (valor) {
                                bloc.onCategorySelectedModelos(x);
                              }),
                          Text('${bloc.tabsModelos[x].itemNombre}'),
                        ],
                      );
                    }),
                ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: bloc.tabsTallas.length + 1,
                    itemBuilder: (context, indexe) {
                      if (indexe == 0) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: responsive.hp(1),
                            top: responsive.hp(1.5),
                          ),
                          child: Text(
                            'Tallas',
                            style: TextStyle(
                                fontSize: responsive.ip(2),
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      }

                      int e = indexe - 1;

                      return Row(
                        children: [
                          Checkbox(
                              value: bloc.tabsTallas[e].selected,
                              onChanged: (valor) {
                                bloc.onCategorySelectedTallas(e);
                              }),
                          Text('${bloc.tabsTallas[e].itemNombre}'),
                        ],
                      );
                    }),
                SizedBox(
                  height: responsive.hp(2),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(7),
                    vertical: responsive.hp(1),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Filtrar',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: responsive.ip(2),
                        fontWeight: FontWeight.bold),
                  ).ripple(
                    () {
                      bool pase = true;
                      final tashas = bloc.tallasFiltradas.toSet().toList();
                      final modeshos = bloc.modelosFiltradas.toSet().toList();
                      final marcash = bloc.marcasFiltradas.toSet().toList();

                      if (tashas.length > 0) {
                        pase = true;
                      } else {
                        if (modeshos.length > 0) {
                          pase = true;
                        } else {
                          if (marcash.length > 0) {
                            pase = true;
                          } else {
                            pase = false;
                          }
                        }
                      }

                      if (pase) {
                        productoBloc.listarProductosPorSucursalFiltrado(
                            tashas, modeshos, marcash);
                      } else {
                        productoBloc
                            .listarProductosPorSucursal(widget.idSubsidiary);
                      }

                      widget.iconPressed();
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class FiltroProductosPorIdSubsidiaryBloc with ChangeNotifier {
  final productoDatabase = ProductoDatabase();

  List<CategoriaTab> tabsMarcas = [];
  List<CategoriaTab> tabsModelos = [];
  List<CategoriaTab> tabsTallas = [];

  List<String> tallasFiltradas = [];
  List<String> modelosFiltradas = [];
  List<String> marcasFiltradas = [];

  void init(String idItemsubcategory) async {
    final productos = await productoDatabase
        .obtenerProductosPorIdSubsidiary(idItemsubcategory);

    final listTallitas = List<String>();
    final listMarquitas = List<String>();
    final listModelitos = List<String>();

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
  }

  void onCategorySelectedMarcas(int value) {
    marcasFiltradas.clear();
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
    }

    notifyListeners();
  }

  void onCategorySelectedModelos(int value) {
    modelosFiltradas.clear();
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
    tallasFiltradas.clear();
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
