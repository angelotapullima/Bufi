import 'package:bufi/src/api/pedidos/Pedido_api.dart';
import 'package:bufi/src/bloc/cuenta_bloc.dart';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/carritoGeneralModel..dart';
import 'package:bufi/src/models/cuentaModel.dart';
import 'package:bufi/src/page/Tabs/Carrito/confirmacionPedido/confirmacion_pedido_bloc.dart';
import 'package:bufi/src/page/Tabs/Carrito/confirmacionPedido/detalleCarritoFotoPage.dart';
import 'package:bufi/src/page/Tabs/Usuario/Pedidos/detallePedidoPage.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmacionPedido extends StatefulWidget {
  const ConfirmacionPedido({Key key}) : super(key: key);

  @override
  _ConfirmacionPedidoState createState() => _ConfirmacionPedidoState();
}

class _ConfirmacionPedidoState extends State<ConfirmacionPedido> {
  void llamada() {
    setState(() {});
  }

  String dp;
  String rt;
  String dt;
  bool dpEstatus = false;
  bool rtEstatus = false;
  bool dtEstatus = false;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final carritoBloc = ProviderBloc.productosCarrito(context);
    carritoBloc.obtenerCarritoConfirmacion();
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
                  stream: carritoBloc.carritoSeleccionadoStream,
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
                                            cuentaBloc: cuentaBloc);
                                      }

                                      int xxx = index - 1;
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: ClampingScrollPhysics(),
                                        itemCount: listCarritoSuperior[0]
                                                .car[xxx]
                                                .carrito
                                                .length +
                                            2,
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

                                          if (i ==
                                              listCarritoSuperior[0]
                                                      .car[xxx]
                                                      .carrito
                                                      .length +
                                                  1) {
                                            return Container(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Tipo de Entrega',
                                                    style: TextStyle(
                                                        fontSize:
                                                            responsive.ip(2),
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: responsive.hp(1),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            dp = '1';
                                                            rt = '0';
                                                            dt = '0';
                                                            dpEstatus = true;
                                                            rtEstatus = false;
                                                            dtEstatus = false;
                                                          });
                                                        },
                                                        child: _tipoEntrega(
                                                            'Delivery propio',
                                                            Icons
                                                                .delivery_dining,
                                                            responsive,
                                                            dpEstatus),
                                                      ),
                                                      SizedBox(
                                                        width: responsive.wp(5),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            dp = '0';
                                                            rt = '1';
                                                            dt = '0';
                                                            dpEstatus = false;
                                                            rtEstatus = true;
                                                            dtEstatus = false;
                                                          });
                                                        },
                                                        child: _tipoEntrega(
                                                            'Recoger en tienda',
                                                            Icons.store,
                                                            responsive,
                                                            rtEstatus),
                                                      ),
                                                      SizedBox(
                                                        width: responsive.wp(5),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            dp = '0';
                                                            rt = '0';
                                                            dt = '1';
                                                            dpEstatus = false;
                                                            rtEstatus = false;
                                                            dtEstatus = true;
                                                          });
                                                        },
                                                        child: _tipoEntrega(
                                                            'Delivery terceros',
                                                            Icons
                                                                .departure_board_outlined,
                                                            responsive,
                                                            dtEstatus),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: responsive.hp(1.5),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }

                                          int indd = i - 1;
                                          return Container(
                                            height: responsive.hp(16),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5),
                                            width: double.infinity,
                                            child: Column(
                                              children: [
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
                                                              child: Container(
                                                                height:
                                                                    responsive
                                                                        .hp(10),
                                                                width:
                                                                    responsive
                                                                        .wp(25),
                                                                child:
                                                                    CachedNetworkImage(
                                                                  placeholder: (context,
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
                                                                '${listCarritoSuperior[0].car[xxx].carrito[indd].modelo} '),
                                                            Text(
                                                                '${listCarritoSuperior[0].car[xxx].carrito[indd].talla} '),
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
                                                            Text(
                                                                'producto ofrecido por bufeoTec'),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: responsive.wp(2),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: responsive.hp(1),
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

  Widget _tipoEntrega(
      String titulo, IconData icon, Responsive responsive, bool status) {
    return Container(
        margin: EdgeInsets.all(1),
        decoration: BoxDecoration(
            color: (status) ? Colors.red : Colors.white10,
            borderRadius: BorderRadius.circular(5)),
        width: responsive.wp(20),
        child: Container(
          margin: EdgeInsets.all(1),
          width: responsive.wp(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: (status) ? Colors.white : Colors.black,
              ),
              Text(
                titulo,
                style: TextStyle(
                  color: (status) ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ));
  }
}

class ResumenPedido extends StatelessWidget {
  const ResumenPedido({
    Key key,
    @required this.responsive,
    @required this.listCarritoSuperior,
    @required this.cuentaBloc,
  }) : super(key: key);

  final Responsive responsive;
  final List<CarritoGeneralSuperior> listCarritoSuperior;
  final CuentaBloc cuentaBloc;

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
        Row(
          children: [
            SizedBox(
              width: responsive.wp(3),
            ),
            Text(
              'Saldo actual',
              style: TextStyle(
                  fontSize: responsive.ip(1.8), fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Container(
              width: responsive.wp(11),
              child: Image(
                image: AssetImage('assets/moneda.png'),
              ),
            ),
            StreamBuilder(
              stream: cuentaBloc.saldoStream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<CuentaModel>> snapshot) {
                int valorcito = 0;

                if (snapshot.hasData) {
                  if (snapshot.data.length > 0) {
                    valorcito =
                        double.parse(snapshot.data[0].cuentaSaldo).toInt();
                  }
                }

                return Container(
                  child: Text(
                    valorcito.toString(),
                    style: TextStyle(
                        fontSize: responsive.ip(1.8),
                        fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
            SizedBox(
              width: responsive.wp(3),
            ),
          ],
        ),
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
                  borrarCarrito(context, '0');
                  showToast(context, 'venta confirmada');
                  Navigator.pop(context);
                  //deleteProductoCarrito();

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
