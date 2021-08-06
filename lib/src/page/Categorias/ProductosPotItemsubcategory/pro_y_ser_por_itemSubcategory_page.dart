import 'dart:async';
import 'dart:ui';

import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/bienesServiciosModel.dart';
import 'package:bufi/src/page/Categorias/ProductosPotItemsubcategory/filtro_proySer_porItesubcategory_bloc.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:bufi/src/widgets/busquedas/widgetBusqProAndSerPorItemSubcategoria.dart';
import 'package:bufi/src/widgets/widgetBienes.dart';
import 'package:bufi/src/widgets/widgetServicios.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/subjects.dart';
import 'package:shimmer/shimmer.dart';
import 'package:bufi/src/widgets/extentions.dart';

//Ahora vengo yo csmaree

class ProYSerPorItemSubcategoryPage extends StatefulWidget {
  final String idItem;
  final String nameItem;
  ProYSerPorItemSubcategoryPage({Key key, @required this.idItem, @required this.nameItem}) : super(key: key);

  @override
  _ProYSerPorItemSubcategoryPageState createState() => _ProYSerPorItemSubcategoryPageState();
}

class _ProYSerPorItemSubcategoryPageState extends State<ProYSerPorItemSubcategoryPage> with SingleTickerProviderStateMixin<ProYSerPorItemSubcategoryPage> {
  ScrollController _scrollControllerListview = ScrollController();
  ScrollController _scrollControllerGridview = ScrollController();

  AnimationController _animationController;
  StreamController<bool> isSidebarOpenedStreamController;
  Stream<bool> isSidebarOpenedStream;
  StreamSink<bool> isSidebarOpenedSink;
  final _animationDuration = const Duration(milliseconds: 100);

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;

    WidgetsBinding.instance.addPostFrameCallback((_) => {
          _scrollControllerListview.addListener(() {
            if (_scrollControllerListview.position.pixels + 100 > _scrollControllerListview.position.maxScrollExtent) {
              final itemSubcatBloc = ProviderBloc.itemSubcategoria(context);
              itemSubcatBloc.listarBienesServiciosXIdItemSubcategoria(widget.idItem);
            }
          }),
          _scrollControllerGridview.addListener(() {
            if (_scrollControllerGridview.position.pixels + 100 > _scrollControllerGridview.position.maxScrollExtent) {
              final itemSubcatBloc = ProviderBloc.itemSubcategoria(context);
              itemSubcatBloc.listarBienesServiciosXIdItemSubcategoria(widget.idItem);
            }
          })
        });

    super.initState();
  }

  @override
  void dispose() {
    _scrollControllerListview.dispose();
    _scrollControllerGridview.dispose();

    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedSink.close();

    super.dispose();
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted) {
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  ValueNotifier<bool> switchCambio = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    final Responsive responsive = new Responsive.of(context);
    final itemSubcatBloc = ProviderBloc.itemSubcategoria(context);
    itemSubcatBloc.listarBienesServiciosXIdItemSubcategoria(widget.idItem);
    return Scaffold(
        body: Stack(
      children: [
        SafeArea(
          child: ValueListenableBuilder(
              valueListenable: switchCambio,
              builder: (BuildContext context, bool data, Widget child) {
                return Column(
                  children: [
                    Container(
                      height: responsive.hp(5),
                      child: Stack(
                        children: [
                          BackButton(),
                          Container(
                            padding: EdgeInsets.only(
                              left: responsive.wp(10),
                            ),
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                widget.nameItem,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: responsive.wp(2),
                        ),
                        Expanded(
                          child: BusquedaProAndSerItemSubcategoriaWidget(responsive: responsive, idItemsubcategory: widget.idItem),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                icon: Icon(Icons.category),
                                onPressed: () {
                                  if (data) {
                                    switchCambio.value = false;
                                  } else {
                                    switchCambio.value = true;
                                  }
                                }),
                            IconButton(
                                icon: Icon(Icons.filter_list),
                                onPressed: () {
                                  onIconPressed();
                                }),
                          ],
                        ),
                      ],
                    ),
                    StreamBuilder(
                      stream: itemSubcatBloc.itemSubStream,
                      builder: (BuildContext context, AsyncSnapshot<List<BienesServiciosModel>> snapshotdd) {
                        if (snapshotdd.hasData) {
                          if (snapshotdd.data.length > 0) {
                            return (!data) ? _listaBienesServicios(snapshotdd.data, responsive) : _grilla(snapshotdd.data, responsive);
                          } else {
                            return StreamBuilder(
                                stream: itemSubcatBloc.cargandoItemsStream,
                                builder: (context, AsyncSnapshot<bool> snapshot) {
                                  bool _enabled = true;

                                  if (snapshot.hasData) {
                                    if (snapshot.data) {
                                      return Expanded(
                                        child: Shimmer.fromColors(
                                          baseColor: Colors.grey[300],
                                          highlightColor: Colors.grey[100],
                                          enabled: _enabled,
                                          child: ListView.builder(
                                            itemBuilder: (_, __) => Padding(
                                              padding: const EdgeInsets.only(bottom: 8.0),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 48.0,
                                                    height: 48.0,
                                                    color: Colors.white,
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Container(
                                                          width: double.infinity,
                                                          height: 8.0,
                                                          color: Colors.white,
                                                        ),
                                                        const Padding(
                                                          padding: EdgeInsets.symmetric(vertical: 2.0),
                                                        ),
                                                        Container(
                                                          width: double.infinity,
                                                          height: 8.0,
                                                          color: Colors.white,
                                                        ),
                                                        const Padding(
                                                          padding: EdgeInsets.symmetric(vertical: 2.0),
                                                        ),
                                                        Container(
                                                          width: 40.0,
                                                          height: 8.0,
                                                          color: Colors.white,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            itemCount: 6,
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Center(
                                        child: Text("No existen productos para mostrar"),
                                      );
                                    }
                                  } else {
                                    return Container();
                                  }
                                });
                          }
                        } else {
                          return Center(
                            child: Text("No existen productos para mostrar"),
                          );
                        }
                      },
                    ),
                  ],
                );
              }),
        ),
        StreamBuilder<bool>(
          initialData: false,
          stream: isSidebarOpenedStream,
          builder: (context, isSideBarOpenedAsync) {
            return AnimatedPositioned(
              duration: _animationDuration,
              top: 0,
              bottom: 0,
              left: isSideBarOpenedAsync.data ? 0 : responsive.wp(100),
              right: isSideBarOpenedAsync.data ? 0 : -responsive.wp(100),
              child: Container(
                decoration: BoxDecoration(),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        onIconPressed();
                      },
                      child: Container(
                        width: responsive.wp(40),
                        decoration: new BoxDecoration(
                          color: Colors.black.withOpacity(.1),
                        ),
                        child: ClipRRect(
                          child: new BackdropFilter(
                            filter: new ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                            child: new Container(
                              decoration: new BoxDecoration(
                                color: Colors.white.withOpacity(0.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: responsive.wp(60),
                      color: Colors.white,
                      child: FiltroPageTodosLosProductos(
                        iconPressed: onIconPressed,
                        idItemsubcategory: widget.idItem,
                        //productos: listProduct,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        )
      ],
    ));
  }

  Widget _grilla(List<BienesServiciosModel> data, Responsive responsive) {
    return Expanded(
      child: GridView.builder(
          controller: _scrollControllerGridview,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: .7),
          itemCount: data.length,
          itemBuilder: (context, index) {
            return ('${data[index].tipo}' == 'bienes') ? grillaBienes(responsive, data[index]) : grillaServicios(responsive, data[index]);
          }),
    );
  }

  Widget _listaBienesServicios(List<BienesServiciosModel> data, Responsive responsive) {
    return Expanded(
        child: ListView.builder(
      controller: _scrollControllerListview,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return ('${data[index].tipo}' == 'bienes')
            ? bienesWidget(responsive, data, index)
            //Servicios
            : _serviciosWidget(responsive, data, index);
      },
    ));
  }

  Widget _serviciosWidget(Responsive responsive, List<BienesServiciosModel> data, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "detalleServicio");
      },
      child: Container(
        color: Colors.white,
        height: responsive.hp(16),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        width: double.infinity,
        child: Row(
          children: [
            Container(
              width: responsive.wp(30),
              height: responsive.hp(20),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    child: CachedNetworkImage(
                      //cacheManager: CustomCacheManager(),
                      placeholder: (context, url) => Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Image(image: AssetImage('assets/loading.gif'), fit: BoxFit.fitWidth),
                      ),
                      imageUrl: '$apiBaseURL/${data[index].subsidiaryServiceImage}',
                      fit: BoxFit.cover,
                      //'assets/producto.jpg'
                      //'$apiBaseURL/${data[index].subsidiaryGoodImage}'
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      color: Colors.black.withOpacity(.5),
                      width: double.infinity,
                      //double.infinity,
                      child: Text(
                        '${data[index].subsidiaryServiceName}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(responsive.ip(.5)),
                      color: Colors.blue,
                      //double.infinity,
                      height: responsive.hp(3),
                      child: Text(
                        'Servicio',
                        style: TextStyle(color: Colors.white, fontSize: responsive.ip(1.5), fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
            //SizedBox(height: 50),
            Container(
              //color: Colors.red,
              width: responsive.wp(60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${data[index].subsidiaryServiceName}',
                    style: TextStyle(fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${data[index].subsidiaryServiceCurrency + data[index].subsidiaryServicePrice}',
                    style: TextStyle(fontSize: responsive.ip(2.5), color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${data[index].subsidiaryServiceDescription}',
                    style: TextStyle(fontSize: responsive.ip(1.8), fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    SizedBox(width: 5),
                    Text('${data[index].subsidiaryServiceRating}'),
                    SizedBox(width: 10),
                  ])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bienesWidget(Responsive responsive, List<BienesServiciosModel> data, int index) {
    return GestureDetector(
      onTap: () {
        irADetalleProducto(data[index], context);
      },
      child: Container(
        height: responsive.hp(16),
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        width: double.infinity,
        child: Row(
          children: [
            Container(
              width: responsive.wp(30),
              height: responsive.hp(16),
              child: Stack(
                children: [
                  Hero(
                    tag: data[index].idSubsidiarygood,
                    child: Container(
                      child: CachedNetworkImage(
                        //cacheManager: CustomCacheManager(),
                        placeholder: (context, url) => Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: Image(image: AssetImage('assets/loading.gif'), fit: BoxFit.cover),
                        ),
                        imageUrl: '$apiBaseURL/${data[index].subsidiaryGoodImage}',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      color: Colors.black.withOpacity(.5),
                      width: double.infinity,
                      //double.infinity,
                      child: Text(
                        '${data[index].subsidiaryGoodName}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(
                        responsive.ip(.5),
                      ),
                      color: Colors.red,
                      //double.infinity,
                      height: responsive.hp(3),
                      child: Text(
                        'Producto',
                        style: TextStyle(color: Colors.white, fontSize: responsive.ip(1.5), fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: responsive.wp(60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${data[index].subsidiaryGoodName}',
                    style: TextStyle(fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                  ),
                  //Text('${data[index].subsidiaryGoodMeasure}'),

                  Text(
                    '${data[index].subsidiaryGoodCurrency + data[index].subsidiaryGoodPrice}',
                    style: TextStyle(fontSize: responsive.ip(2.5), color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  Text('${data[index].subsidiaryGoodBrand}', style: TextStyle(fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    SizedBox(width: 5),
                    //Text('${data[index].subsidiaryGoodRating}'),
                    Text('bien'),
                    SizedBox(width: 10),
                  ])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FiltroPageTodosLosProductos extends StatefulWidget {
  const FiltroPageTodosLosProductos({
    Key key,
    @required this.iconPressed,
    @required this.idItemsubcategory,
  }) : super(key: key);

  final VoidCallback iconPressed;
  final String idItemsubcategory;

  @override
  _FiltroPageState createState() => _FiltroPageState();
}

class _FiltroPageState extends State<FiltroPageTodosLosProductos> {
  final bloc = FiltroProAndSerPorItemBloc();

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
              child: ContenidoFilterTodosLosProductos(iconPressed: widget.iconPressed, idItemsubcategory: widget.idItemsubcategory),
            ),
          ),
        ],
      ),
    );
  }
}

class ContenidoFilterTodosLosProductos extends StatefulWidget {
  ContenidoFilterTodosLosProductos({
    Key key,
    @required this.iconPressed,
    @required this.idItemsubcategory,
  }) : super(key: key);

  final VoidCallback iconPressed;
  final String idItemsubcategory;

  @override
  _ContenidoFilterState createState() => _ContenidoFilterState();
}

class _ContenidoFilterState extends State<ContenidoFilterTodosLosProductos> {
  final bloc = FiltroProAndSerPorItemBloc();

  @override
  void initState() {
    bloc.init(widget.idItemsubcategory);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final itemSubcatBloc = ProviderBloc.itemSubcategoria(context);

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
                    itemCount: bloc.tabsTipos.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: responsive.hp(1),
                          ),
                          child: Text(
                            'Tipos',
                            style: TextStyle(fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
                          ),
                        );
                      }

                      int i = index - 1;

                      return Row(
                        children: [
                          Checkbox(
                              value: bloc.tabsTipos[i].selected,
                              onChanged: (valor) {
                                bloc.onCategorySelectedTipo(i);
                              }),
                          Expanded(
                            child: Text('${bloc.tabsTipos[i].itemNombre}'),
                          ),
                        ],
                      );
                    }),
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
                            style: TextStyle(fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
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
                            style: TextStyle(fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
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
                            style: TextStyle(fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
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
                    style: TextStyle(color: Colors.white, fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
                  ).ripple(
                    () {
                      bool pase = true;
                      bool productos = false;
                      bool services = false;
                      final tashas = bloc.tallasFiltradas.toSet().toList();
                      final modeshos = bloc.modelosFiltradas.toSet().toList();
                      final marcash = bloc.marcasFiltradas.toSet().toList();
                      final tiposh = bloc.tiposFiltradas.toSet().toList();

                      for (var i = 0; i < tiposh.length; i++) {
                        if (tiposh[i] == 'Productos') {
                          productos = true;
                        }
                        if (tiposh[i] == 'Servicios') {
                          services = true;
                        }
                      }

                      if (tashas.length > 0) {
                        pase = true;
                        productos = true;
                      } else {
                        if (modeshos.length > 0) {
                          pase = true;
                          productos = true;
                        } else {
                          if (marcash.length > 0) {
                            pase = true;
                            productos = true;
                          } else {
                            if (tiposh.length > 0) {
                              pase = true;
                            } else {
                              pase = false;
                            }
                          }
                        }
                      }

                      if (pase) {
                        itemSubcatBloc.listarBienesServiciosXIdItemSubcategoriaFiltrado(widget.idItemsubcategory, productos, services, tashas, modeshos, marcash);
                      } else {
                        itemSubcatBloc.listarBienesServiciosXIdItemSubcategoria(widget.idItemsubcategory);
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
