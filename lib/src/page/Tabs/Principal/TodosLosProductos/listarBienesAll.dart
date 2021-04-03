import 'dart:async';
import 'dart:ui';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/detalleProducto.dart';
import 'package:bufi/src/page/Tabs/Principal/TodosLosProductos/bloc_interno_todos_los_productos.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/customCacheManager.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/widgets/widgetBienes.dart';
import 'package:bufi/src/widgets/busquedas/widgetBusqProduct.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/subjects.dart';
import 'package:bufi/src/widgets/extentions.dart';

class ListarBienesAll extends StatefulWidget {
  @override
  _ListarBienesAllState createState() => _ListarBienesAllState();
}

class _ListarBienesAllState extends State<ListarBienesAll>
    with SingleTickerProviderStateMixin<ListarBienesAll> {
  ValueNotifier<bool> switchCambio = ValueNotifier(false);

  AnimationController _animationController;
  StreamController<bool> isSidebarOpenedStreamController;
  Stream<bool> isSidebarOpenedStream;
  StreamSink<bool> isSidebarOpenedSink;
  final _animationDuration = const Duration(milliseconds: 100);

  final bloc = FiltroContinuoBloc();
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
  }

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    final bienesBloc = ProviderBloc.bienesServicios(context);
    //llamar a la funcion del bloc para bienes
    bienesBloc.obtenerBienesAllPorCiudad();

    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder(
              stream: bienesBloc.bienesStream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<ProductoModel>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length > 0) {
                    final listProduct = snapshot.data;
                    return SafeArea(
                      bottom: false,
                      child: Container(
                        //height: responsive.hp(70),
                        //color: Colors.red,
                        child: ValueListenableBuilder(
                            valueListenable: switchCambio,
                            builder: (BuildContext context, bool data,
                                Widget child) {
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
                                              'Todos los productos ',
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: responsive.ip(2.5),
                                                  fontWeight: FontWeight.bold),
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
                                      //Busqueda
                                      Expanded(
                                        child: BusquedaProductoWidget(
                                            responsive: responsive),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: responsive.hp(.5),
                                  ),
                                  Expanded(
                                    child: Container(
                                      //color: Colors.blue,
                                      child: (!data)
                                          ? GridView.builder(
                                              // padding: EdgeInsets.only(top:18),

                                              controller: ScrollController(
                                                  keepScrollOffset: false),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2,
                                                      childAspectRatio: 0.7),
                                              itemCount: listProduct.length,
                                              itemBuilder: (context, index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                        transitionDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    100),
                                                        pageBuilder: (context,
                                                            animation,
                                                            secondaryAnimation) {
                                                          return DetalleProductos(
                                                              producto: snapshot
                                                                  .data[index]);
                                                          //return DetalleProductitos(productosData: productosData);
                                                        },
                                                        transitionsBuilder:
                                                            (context,
                                                                animation,
                                                                secondaryAnimation,
                                                                child) {
                                                          return FadeTransition(
                                                            opacity: animation,
                                                            child: child,
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: BienesWidget(
                                                    producto:
                                                        snapshot.data[index],
                                                  ),
                                                );
                                              })
                                          : ListView.builder(
                                              itemBuilder: (context, index) {
                                                return bienesWidget(responsive,
                                                    snapshot.data, index);
                                              },
                                              itemCount: listProduct.length,
                                            ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                    );
                  } else {
                    return SafeArea(
                      child: Column(
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
                                      'Todos los productos ',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: responsive.ip(2.5),
                                          fontWeight: FontWeight.bold),
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
                              //Busqueda
                              Expanded(
                                child: BusquedaProductoWidget(
                                    responsive: responsive),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      icon: Icon(Icons.category),
                                      onPressed: () {}),
                                  IconButton(
                                    icon: Icon(Icons.filter_list),
                                    onPressed: () {
                                      onIconPressed();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: responsive.hp(.5),
                          ),
                          Expanded(
                            child: Container(
                                //color: Colors.blue,

                                ),
                          ),
                        ],
                      ),
                    );
                  }
                } else {
                  return Center(
                    child: CupertinoActivityIndicator(
                      radius: 10,
                    ),
                  );
                }
              }),
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
                              filter: new ImageFilter.blur(
                                  sigmaX: 5.0, sigmaY: 5.0),
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
                        child: FiltroPage(
                          iconPressed: onIconPressed,
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
      ),
    );
  }

  Widget bienesWidget(
      Responsive responsive, List<ProductoModel> data, int index) {
    return GestureDetector(
      onTap: () {
        //irADetalleProducto(data[index], context);
      },
      child: Container(
        height: responsive.hp(18),
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
                    tag: data[index].idProducto,
                    child: Container(
                      child: CachedNetworkImage(
                        cacheManager: CustomCacheManager(),
                        placeholder: (context, url) => Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: Image(
                              image: AssetImage('assets/loading.gif'),
                              fit: BoxFit.cover),
                        ),
                        imageUrl: '$apiBaseURL/${data[index].productoImage}',
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
                        '${data[index].productoName}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: responsive.ip(2),
                            fontWeight: FontWeight.bold),
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
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: responsive.ip(1.5),
                            fontWeight: FontWeight.bold),
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
                    '${data[index].productoName}',
                    style: TextStyle(
                        fontSize: responsive.ip(2.5),
                        fontWeight: FontWeight.bold),
                  ),
                  //Text('${data[index].subsidiaryGoodMeasure}'),

                  Text(
                    '${data[index].productoCurrency + data[index].productoPrice}',
                    style: TextStyle(
                        fontSize: responsive.ip(2.5),
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${data[index].productoBrand}',
                    style: TextStyle(
                        fontSize: responsive.ip(1.5),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${data[index].productoSize}',
                    style: TextStyle(
                        fontSize: responsive.ip(1.5),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${data[index].productoModel}',
                    style: TextStyle(
                        fontSize: responsive.ip(1.5),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 2),
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

class FiltroPage extends StatefulWidget {
  const FiltroPage({
    Key key,
    @required this.iconPressed,
  }) : super(key: key);

  final VoidCallback iconPressed;

  @override
  _FiltroPageState createState() => _FiltroPageState();
}

class _FiltroPageState extends State<FiltroPage> {
  final bloc = FiltroContinuoBloc();

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
              child: ContenidoFilter(
                iconPressed: widget.iconPressed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContenidoFilter extends StatefulWidget {
  ContenidoFilter({
    Key key,
    @required this.iconPressed,
  }) : super(key: key);

  final VoidCallback iconPressed;

  @override
  _ContenidoFilterState createState() => _ContenidoFilterState();
}

class _ContenidoFilterState extends State<ContenidoFilter> {
  final bloc = FiltroContinuoBloc();

  @override
  void initState() {
    bloc.init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bienesBloc = ProviderBloc.bienesServicios(context);

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
                        bienesBloc.obtenerBienesAllPorCiudadFiltrado(
                            tashas, modeshos, marcash);
                      } else {
                        bienesBloc.obtenerBienesAllPorCiudad();
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
