import 'dart:async';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/detalleProducto.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/customCacheManager.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/widgets/widgetBienes.dart';
import 'package:bufi/src/widgets/busquedas/widgetBusqProduct.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

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
  final _animationDuration = const Duration(milliseconds: 200);

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
          SafeArea(
            bottom: false,
            child: Container(
              //height: responsive.hp(70),
              //color: Colors.red,
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
                            child: StreamBuilder(
                              stream: bienesBloc.bienesStream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<ProductoModel>> snapshot) {
                                if (snapshot.hasData) {
                                  final bienes = snapshot.data;
                                  return (!data)
                                      ? GridView.builder(
                                          // padding: EdgeInsets.only(top:18),

                                          controller: ScrollController(
                                              keepScrollOffset: false),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  childAspectRatio: 0.73),
                                          itemCount: bienes.length,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                    transitionDuration:
                                                        const Duration(
                                                            milliseconds: 100),
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
                                                producto: snapshot.data[index],
                                              ),
                                            );
                                          })
                                      : ListView.builder(
                                          itemBuilder: (context, index) {
                                            return bienesWidget(responsive,
                                                snapshot.data, index);
                                          },
                                          itemCount: bienes.length,
                                        );
                                } else {
                                  return Center(
                                    child: CupertinoActivityIndicator(),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ),
          StreamBuilder<bool>(
            initialData: false,
            stream: isSidebarOpenedStream,
            builder: (context, isSideBarOpenedAsync) {
              return AnimatedPositioned(
                duration: _animationDuration,
                top: 0,
                bottom: 0,
                left: isSideBarOpenedAsync.data ? 0 : responsive.wp(50),
                right: isSideBarOpenedAsync.data ? 0 : -responsive.wp(100),
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        width: responsive.wp(50),
                      ),
                      Container(
                        width: responsive.wp(50),
                        color: Colors.red,
                        child: SafeArea(
                          child: Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  onIconPressed();
                                },
                              ),
                            ],
                          ),
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
                        fontSize: responsive.ip(2.5),
                        fontWeight: FontWeight.bold),
                  ),
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
