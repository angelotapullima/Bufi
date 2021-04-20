import 'dart:async';
import 'dart:ui';

import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/page/Tabs/Negocios/Sucursal/detailsSubsidiary/page_filtro_details_subsidiary.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/customCacheManager.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/widgets/busquedas/PorSucursal/widgetBusqProductXSucursal.dart';
import 'package:bufi/src/widgets/widgetBienes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class ListarProductosPorSucursalPage extends StatefulWidget {
  final String idSucursal;

  const ListarProductosPorSucursalPage({Key key, @required this.idSucursal})
      : super(key: key);
  @override
  _ListarProductosPorSucursalPageState createState() =>
      _ListarProductosPorSucursalPageState();
}

class _ListarProductosPorSucursalPageState
    extends State<ListarProductosPorSucursalPage>
    with SingleTickerProviderStateMixin<ListarProductosPorSucursalPage> {
  final _show = ValueNotifier<bool>(false);

  ScrollController _scrollController = ScrollController();

  AnimationController _animationController;
  StreamController<bool> isSidebarOpenedStreamController;
  Stream<bool> isSidebarOpenedStream;
  StreamSink<bool> isSidebarOpenedSink;
  final _animationDuration = const Duration(milliseconds: 100);

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => {
        _scrollController.addListener(() {
          if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
            print('pixels ${_scrollController.position.pixels}');
            print('maxScrool ${_scrollController.position.maxScrollExtent}');
            print('dentro');

            final productoBloc = ProviderBloc.productos(context);
            productoBloc.listarProductosPorSucursal(widget.idSucursal);
          }
        })
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();

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
    print(widget.idSucursal);
    final responsive = Responsive.of(context);

    final productoBloc = ProviderBloc.productos(context);
    productoBloc.listarProductosPorSucursal(widget.idSucursal);

    final sucursalBloc = ProviderBloc.sucursal(context);
    sucursalBloc.obtenerSucursalporId(widget.idSucursal);

    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder(
            stream: sucursalBloc.subsidiaryIdStream,
            builder:
                (context, AsyncSnapshot<List<SubsidiaryModel>> sucursalList) {
              if (sucursalList.hasData) {
                if (sucursalList.data.length > 0) {
                  return ValueListenableBuilder(
                    valueListenable: _show,
                    builder:
                        (BuildContext context, bool dataToque, Widget child) {
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
                                        '${sucursalList.data[0].subsidiaryName}',
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
                                Expanded(
                                  child: BusquedaProductoXsucursalWidget(
                                    responsive: responsive,
                                    idSucursal: widget.idSucursal,
                                    nameSucursal:
                                        '${sucursalList.data[0].subsidiaryName}',
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.category),
                                        onPressed: () {
                                          if (dataToque) {
                                            _show.value = false;
                                          } else {
                                            _show.value = true;
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
                              child: StreamBuilder(
                                stream: productoBloc.productoStream,
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<ProductoModel>>
                                        snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data.length > 0) {
                                      final bienes = snapshot.data;
                                      return (!dataToque)
                                          ? GridView.builder(
                                              controller: _scrollController,
                                              padding: EdgeInsets.only(top: 10),
                                              //controller: ScrollController(keepScrollOffset: false),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                childAspectRatio:
                                                    responsive.ip(.068),
                                                crossAxisCount: 2,
                                              ),
                                              itemCount: bienes.length,
                                              itemBuilder: (context, index) {
                                                return BienesWidget(
                                                  producto:
                                                      snapshot.data[index],
                                                );
                                              },
                                            )
                                          : ListView.builder(
                                              itemBuilder: (context, index) {
                                                return bienesWidget(responsive,
                                                    snapshot.data, index);
                                              },
                                              itemCount: snapshot.data.length,
                                            );
                                    } else {
                                      return Center(
                                        child: Text(
                                          "No tiene registrado ningún producto",
                                          style: TextStyle(
                                            fontSize: responsive.ip(2),
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    return Center(
                                      child: CupertinoActivityIndicator(),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
              } else {
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              }
            },
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
                        child: FiltroPageProductosPorSubsidiary(
                          iconPressed: onIconPressed,
                          idSubsidiary: widget.idSucursal,
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
