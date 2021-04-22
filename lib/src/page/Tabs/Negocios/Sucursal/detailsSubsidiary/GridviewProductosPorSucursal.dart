import 'dart:async';
import 'dart:ui';

import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/page/Tabs/Negocios/Sucursal/detailsSubsidiary/page_filtro_details_subsidiary.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/detalleProducto/detalleProducto.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/widgets/widgetBienes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class GridviewProductoPorSucursal extends StatefulWidget {
  const GridviewProductoPorSucursal({Key key, @required this.idSucursal})
      : super(key: key);
  final String idSucursal;

  @override
  _GridviewProductoPorSucursalState createState() =>
      _GridviewProductoPorSucursalState();
}

class _GridviewProductoPorSucursalState
    extends State<GridviewProductoPorSucursal>
    with SingleTickerProviderStateMixin<GridviewProductoPorSucursal> {
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
    super.initState();
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
    final productoBloc = ProviderBloc.productos(context);
    productoBloc.listarProductosPorSucursal(widget.idSucursal);

    final responsive = Responsive.of(context);

    return StreamBuilder(
      stream: productoBloc.productoStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return Stack(
              children: [
                SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: responsive.ip(.09),
                          ),
                          itemCount: snapshot.data.length,
                          padding: EdgeInsets.all(0),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(milliseconds: 100),
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return DetalleProductos(
                                        idProducto:
                                            snapshot.data[index].idProducto,
                                      );
                                      //return DetalleProductitos(productosData: productosData);
                                    },
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
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
                          },
                        ),
                      ),

                      //Container(child: Center(child: CircularProgressIndicator(),),)
                    ],
                  ),
                ),
                Positioned(
                  bottom: responsive.hp(3),
                  right: responsive.wp(5),
                  child: InkWell(
                    onTap: () {
                      onIconPressed();
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100)),
                        width: responsive.ip(8),
                        height: responsive.ip(8),
                        child: Icon(Icons.filter_list)),
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
                      left: isSideBarOpenedAsync.data ? 0 : responsive.wp(100),
                      right:
                          isSideBarOpenedAsync.data ? 0 : -responsive.wp(100),
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
            );
          } else {
            return Center(
              child: Text('sin productos'),
            );
          }
        } else {
          return Center(
            child: Text('sin controller'),
          );
        }
      },
    );
  }
}
