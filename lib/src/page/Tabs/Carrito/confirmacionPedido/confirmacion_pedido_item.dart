import 'package:bufi/src/api/pedidos/Pedido_api.dart';
import 'package:bufi/src/bloc/cuenta_bloc.dart';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/carritoGeneralModel..dart';
import 'package:bufi/src/page/Tabs/Carrito/confirmacionPedido/confirmacion_pedido_bloc.dart';
import 'package:bufi/src/page/Tabs/Carrito/confirmacionPedido/detalleCarritoFotoPage.dart';
import 'package:bufi/src/page/Tabs/Usuario/Pedidos/detallePedidoPage.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/customCacheManager.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:bufi/src/widgets/cantidad_producto.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmacionItemPedido extends StatefulWidget {
  final String idProducto;
  const ConfirmacionItemPedido({Key key, @required this.idProducto})
      : super(key: key);

  @override
  _ConfirmacionItemPedidoState createState() => _ConfirmacionItemPedidoState();
}

class _ConfirmacionItemPedidoState extends State<ConfirmacionItemPedido> {
  void llamada() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final carritoBloc = ProviderBloc.productosCarrito(context);
    carritoBloc.confirmacionPedidoProducto(widget.idProducto);
    final cuentaBloc = ProviderBloc.cuenta(context);
    cuentaBloc.obtenerSaldo();

    final provider = Provider.of<ConfirmPedidoBloc>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: ValueListenableBuilder<bool>(
        valueListenable: provider.showCargando,
        builder: (_, value, __) {
          return Stack(
            children: [
              StreamBuilder(
                  stream: carritoBloc.carritoProductoStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<CarritoGeneralSuperior>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length > 0) {
                        List<CarritoGeneralSuperior> listCarritoSuperior =
                            snapshot.data;

                        return SafeArea(
                          child: Column(
                            children: [
                              ValueListenableBuilder<bool>(
                                valueListenable: provider.show,
                                builder: (_, value, __) {
                                  //Cuando se hace scroll
                                  return (value)
                                      ? Container(
                                          color: Colors.white,
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: responsive.wp(5),
                                            vertical: responsive.hp(1),
                                          ),
                                          child: Row(
                                            children: [
                                              BackButton(),
                                              Text(
                                                'Confirmación de pedido',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        responsive.ip(2.5),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          color: Colors.white,
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: responsive.wp(5),
                                            vertical: responsive.hp(1),
                                          ),
                                          child: Row(
                                            children: [
                                              //BackButton(),
                                              Text(
                                                'Confirmación de pedido',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        responsive.ip(2.5),
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                        );
                                },
                              ),
                              SizedBox(height: responsive.hp(2)),
                              Expanded(
                                child: ListView.builder(
                                    padding: EdgeInsets.all(0),
                                    controller: provider.controller,
                                    itemCount:
                                        listCarritoSuperior[0].car.length + 2,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (index == 0) {
                                        return Container(
                                          color: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: responsive.wp(5),
                                            vertical: responsive.hp(1),
                                          ),
                                          child: Row(
                                            children: [
                                              BackButton(),
                                              Text(
                                                'Confirmación de pedido',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        responsive.ip(2.5),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        );
                                      }

                                      if (index ==
                                          listCarritoSuperior[0].car.length +
                                              1) {
                                        return ResumenPedido(
                                          responsive: responsive,
                                          listCarritoSuperior:
                                              listCarritoSuperior,
                                          cuentaBloc: cuentaBloc,
                                          idproducto: widget.idProducto,
                                        );
                                      }

                                      int xxx = index - 1;

                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: ClampingScrollPhysics(),
                                        itemCount: listCarritoSuperior[0]
                                                .car[xxx]
                                                .carrito
                                                .length +
                                            1,
                                        itemBuilder:
                                            (BuildContext context, int i) {
                                          if (i == 0) {
                                            return Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: responsive.hp(1),
                                              ),
                                              width: double.infinity,
                                              color: Colors.blueGrey[50],
                                              child: Row(
                                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: responsive.wp(3),
                                                    ),

                                                    Icon(Icons.store),
                                                    SizedBox(
                                                      width: responsive.wp(2),
                                                    ),
                                                    Text(
                                                      '${listCarritoSuperior[0].car[xxx].nombreSucursal}',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .blueGrey[700],
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),

                                                    //Divider(),
                                                  ]),
                                            );
                                          }

                                          int indd = i - 1;

                                          return Container(
                                            height: responsive.hp(48),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5),
                                            width: double.infinity,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                    height: responsive.hp(2)),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: responsive.wp(1.5),
                                                    ),
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Container(
                                                        width:
                                                            responsive.wp(25),
                                                        child: Stack(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                print(
                                                                    "presionado");

                                                                Navigator.push(
                                                                  context,
                                                                  PageRouteBuilder(
                                                                    transitionDuration:
                                                                        const Duration(
                                                                            milliseconds:
                                                                                700),
                                                                    pageBuilder:
                                                                        (context,
                                                                            animation,
                                                                            secondaryAnimation) {
                                                                      return DetalleCarritoFotoPage(
                                                                          carritoData: listCarritoSuperior[0]
                                                                              .car[xxx]
                                                                              .carrito[indd]);
                                                                    },
                                                                    transitionsBuilder: (context,
                                                                        animation,
                                                                        secondaryAnimation,
                                                                        child) {
                                                                      return FadeTransition(
                                                                        opacity:
                                                                            animation,
                                                                        child:
                                                                            child,
                                                                      );
                                                                    },
                                                                  ),
                                                                );
                                                              },
                                                              child: Hero(
                                                                tag: 'imagen',
                                                                //'$apiBaseURL/${listCarritoSuperior[0].car[xxx].carrito[indd].image}',
                                                                child:
                                                                    Container(
                                                                  height:
                                                                      responsive
                                                                          .hp(10),
                                                                  width:
                                                                      responsive
                                                                          .wp(25),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    cacheManager:
                                                                        CustomCacheManager(),
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            Container(
                                                                      width: double
                                                                          .infinity,
                                                                      height: double
                                                                          .infinity,
                                                                      child: Image(
                                                                          image: AssetImage(
                                                                              'assets/loading.gif'),
                                                                          fit: BoxFit
                                                                              .fitWidth),
                                                                    ),
                                                                    imageUrl:
                                                                        '$apiBaseURL/${listCarritoSuperior[0].car[xxx].carrito[indd].image}',
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: responsive.wp(2),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text('${listCarritoSuperior[0].car[xxx].carrito[indd].nombre} ' +
                                                                '${listCarritoSuperior[0].car[xxx].carrito[indd].marca} x ' +
                                                                '${listCarritoSuperior[0].car[xxx].carrito[indd].cantidad}'),
                                                            Text(
                                                              '${listCarritoSuperior[0].car[xxx].carrito[indd].marca}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      600]),
                                                            ),
                                                            Text(
                                                              '${listCarritoSuperior[0].car[xxx].carrito[indd].modelo}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      600]),
                                                            ),
                                                            Text(
                                                              '${listCarritoSuperior[0].car[xxx].carrito[indd].talla}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      600]),
                                                            ),
                                                            SizedBox(
                                                                height:
                                                                    responsive
                                                                        .hp(1)),
                                                            Text(
                                                              'S/. ' +
                                                                  (double.parse(
                                                                              '${listCarritoSuperior[0].car[xxx].carrito[indd].cantidad}') *
                                                                          double.parse(
                                                                              '${listCarritoSuperior[0].car[xxx].carrito[indd].precio}'))
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      responsive
                                                                          .ip(
                                                                              1.8),
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(
                                                              height: responsive
                                                                  .hp(1),
                                                            ),
                                                            Text(
                                                                'producto ofrecido por bufeoTec'),
                                                          ],
                                                        ),
                                                      ),
                                                    ),

                                                    //  CantidadCarrito(
                                                    //     carrito:
                                                    //         listCarritoSuperior[0]
                                                    //             .car[xxx]
                                                    //             .carrito[indd],
                                                    //     llamada: llamada,
                                                    //     idSudsidiaryGood:
                                                    //         '${listCarritoSuperior[0].car[xxx].carrito[indd].idSubsidiaryGood}', marcaProducto: '${listCarritoSuperior[0].car[xxx].carrito[indd].marca}', modeloProducto: '${listCarritoSuperior[0].car[xxx].carrito[indd].modelo}', tallaProducto:'${listCarritoSuperior[0].car[xxx].carrito[indd].talla}',
                                                    //   ),
                                                    // SizedBox(
                                                    //   height: responsive.wp(2),
                                                    // )
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: responsive.hp(3)),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: responsive.ip(24)),
                                                  child: CantidadCarritoItem(
                                                    carrito:
                                                        listCarritoSuperior[0]
                                                            .car[xxx]
                                                            .carrito[indd],
                                                    llamada: llamada,
                                                    idSudsidiaryGood:
                                                        '${listCarritoSuperior[0].car[xxx].carrito[indd].idSubsidiaryGood}',
                                                    marcaProducto:
                                                        '${listCarritoSuperior[0].car[xxx].carrito[indd].marca}',
                                                    modeloProducto:
                                                        '${listCarritoSuperior[0].car[xxx].carrito[indd].modelo}',
                                                    tallaProducto:
                                                        '${listCarritoSuperior[0].car[xxx].carrito[indd].talla}',
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: responsive.hp(3)),
                                                Container(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        'Tipo de Entrega',
                                                        style: TextStyle(
                                                            fontSize: responsive
                                                                .ip(2),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            responsive.hp(1),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white10,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              width: responsive
                                                                  .wp(15),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(Icons
                                                                      .delivery_dining),
                                                                  Text(
                                                                    'Delivery propio',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  )
                                                                ],
                                                              )),
                                                          SizedBox(
                                                            width: responsive
                                                                .wp(5),
                                                          ),
                                                          Container(
                                                              width: responsive
                                                                  .wp(15),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(Icons
                                                                      .store),
                                                                  Text(
                                                                    'Recoger en tienda',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  )
                                                                ],
                                                              )),
                                                          SizedBox(
                                                            width: responsive
                                                                .wp(5),
                                                          ),
                                                          Container(
                                                              width: responsive
                                                                  .wp(15),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(Icons
                                                                      .departure_board_outlined),
                                                                  Text(
                                                                    'Delivery terceros',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  )
                                                                ],
                                                              )),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    }),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Center(
                          child: Text('No haz añadido nada'),
                        );
                      }
                    } else {
                      return Container();
                    }
                  }),
              (value)
                  ? Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: responsive.wp(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(10),
                        ),
                        width: double.infinity,
                        height: responsive.hp(13),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: responsive.wp(10),
                            vertical: responsive.wp(6),
                          ),
                          height: responsive.ip(4),
                          width: responsive.ip(4),
                          child: Image(
                              image: AssetImage('assets/loading.gif'),
                              fit: BoxFit.contain),
                        ),
                      ),
                    )
                  : Container()
            ],
          );
        },
      ),
    );
  }
}

class ResumenPedido extends StatelessWidget {
  const ResumenPedido({
    Key key,
    @required this.responsive,
    @required this.listCarritoSuperior,
    @required this.cuentaBloc,
    @required this.idproducto,
  }) : super(key: key);

  final Responsive responsive;
  final List<CarritoGeneralSuperior> listCarritoSuperior;
  final CuentaBloc cuentaBloc;
  final String idproducto;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ConfirmPedidoBloc>(context, listen: false);

    return Column(
      children: [
        SizedBox(
          height: responsive.hp(2),
        ),
        Container(
          height: responsive.hp(1.5),
          color: Colors.blueGrey[50],
        ),
        SizedBox(
          height: responsive.hp(2),
        ),
        Text(
          'Resumen del pedido ( ${listCarritoSuperior[0].cantidadArticulos} productos)',
          style: TextStyle(
              fontSize: responsive.ip(1.7), fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: responsive.hp(2),
        ),
        Row(
          children: [
            SizedBox(
              width: responsive.wp(3),
            ),
            Text(
              'Subtotal',
              style: TextStyle(
                  fontSize: responsive.ip(1.7), fontWeight: FontWeight.w500),
            ),
            Spacer(),
            Text(
              'S/. ${listCarritoSuperior[0].montoGeneral}',
              style: TextStyle(
                  fontSize: responsive.ip(1.7), fontWeight: FontWeight.w500),
            ),
            SizedBox(
              width: responsive.wp(3),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: responsive.wp(3),
            ),
            Text(
              'Envío',
              style: TextStyle(
                  fontSize: responsive.ip(1.7), fontWeight: FontWeight.w500),
            ),
            Spacer(),
            Text(
              'S/. 0.0',
              style: TextStyle(
                  fontSize: responsive.ip(1.7), fontWeight: FontWeight.w500),
            ),
            SizedBox(
              width: responsive.wp(3),
            ),
          ],
        ),
        Divider(),
        Row(
          children: [
            SizedBox(
              width: responsive.wp(3),
            ),
            Text(
              'Total',
              style: TextStyle(
                  fontSize: responsive.ip(1.8), fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Text(
              'S/. ${listCarritoSuperior[0].montoGeneral}',
              style: TextStyle(
                  fontSize: responsive.ip(1.8), fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: responsive.wp(3),
            ),
          ],
        ),
        SizedBox(
          height: responsive.hp(3),
        ),
        // Row(
        //   children: [
        //     SizedBox(
        //       width: responsive.wp(3),
        //     ),
        //     Text(
        //       'Saldo actual',
        //       style: TextStyle(
        //           fontSize: responsive.ip(1.8), fontWeight: FontWeight.bold),
        //     ),
        //     Spacer(),
        //     Container(
        //       width: responsive.wp(11),
        //       child: Image(
        //         image: AssetImage('assets/moneda.png'),
        //       ),
        //     ),
        //     StreamBuilder(
        //       stream: cuentaBloc.saldoStream,
        //       builder: (BuildContext context,
        //           AsyncSnapshot<List<CuentaModel>> snapshot) {
        //         int valorcito = 0;

        //         if (snapshot.hasData) {
        //           if (snapshot.data.length > 0) {
        //             valorcito =
        //                 double.parse(snapshot.data[0].cuentaSaldo).toInt();
        //           }
        //         }

        //         return Container(
        //           child: Text(
        //             valorcito.toString(),
        //             style: TextStyle(
        //                 fontSize: responsive.ip(1.8),
        //                 fontWeight: FontWeight.bold),
        //           ),
        //         );
        //       },
        //     ),
        //     SizedBox(
        //       width: responsive.wp(3),
        //     ),
        //   ],
        // ),

        SizedBox(
          height: responsive.hp(2),
        ),
        Container(
          color: Colors.blueGrey[50],
          padding: EdgeInsets.symmetric(
            horizontal: responsive.wp(3),
            vertical: responsive.hp(1),
          ),
          child: Text(
            'Al hacer click en PAGAR AHORA, confirma haber leído y aceptado los terminos y condiciones',
            style: TextStyle(
                fontSize: responsive.ip(1.4), fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          height: responsive.hp(1),
        ),
        Row(
          children: [
            Spacer(),
            GestureDetector(
              onTap: () async {
                provider.changeCargando();

                final pedidoApi = PedidoApi();

                final res = await pedidoApi.enviarPedido();

                print(res);

                if (res[0].respuestaApi == '1') {
                  final carritoBloc = ProviderBloc.productosCarrito(context);
                  carritoBloc.obtenerCarritoPorSucursal();
                  borrarCarrito(context, idproducto);
                  showToast(context, 'venta confirmada');

                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return TickectPedido(
                        idPedido: res[0].idPedido,
                      );
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = Offset(0.0, 1.0);
                      var end = Offset.zero;
                      var curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end).chain(
                        CurveTween(curve: curve),
                      );

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ));
                } else {
                  showToast(
                      context, 'Hubo un error por favor intente más tarde');
                }

                provider.changeCargando();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.wp(3),
                  vertical: responsive.hp(1),
                ),
                child: Text(
                  'Pagar   S/. ${listCarritoSuperior[0].montoGeneral}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: responsive.ip(1.8),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: responsive.wp(4),
            )
          ],
        ),
        SizedBox(
          height: responsive.hp(3),
        ),
      ],
    );
  }
}
