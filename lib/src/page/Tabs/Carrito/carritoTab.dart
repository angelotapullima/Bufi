import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/carritoGeneralModel..dart';
import 'package:bufi/src/page/Tabs/Carrito/carrito_bloc.dart';
import 'package:bufi/src/page/Tabs/Carrito/confirmacionPedido/confirmacion_pedido.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/customCacheManager.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:bufi/src/widgets/cantidad_producto.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class CarritoPage extends StatefulWidget {
  @override
  _CarritoPageState createState() => _CarritoPageState();
}

class _CarritoPageState extends State<CarritoPage> {
  void llamada() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final carritoBloc = ProviderBloc.productosCarrito(context);
    carritoBloc.obtenerCarritoPorSucursal();

    final provider = Provider.of<CarritoBlocListener>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
          stream: carritoBloc.carritoGeneralStream,
          builder: (BuildContext context,
              AsyncSnapshot<List<CarritoGeneralModel>> snapshot) {
            if (snapshot.hasData) {
              List<CarritoGeneralModel> listcarrito = snapshot.data;

              if (listcarrito.length > 0) {
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
                                        Text(
                                          'Carrito',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: responsive.ip(3),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        /* Spacer(),
                                        Text(
                                          'S/ ${listcarrito[0].monto}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: responsive.ip(1.8),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: responsive.wp(2),
                                        ),
                                        GestureDetector(
                                          onTap: () {


                                            Navigator.of(context)
                                                .push(PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                  secondaryAnimation) {
                                                return ConfirmacionPedido();
                                              },
                                              transitionsBuilder: (context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child) {
                                                var begin = Offset(0.0, 1.0);
                                                var end = Offset.zero;
                                                var curve = Curves.ease;

                                                var tween =
                                                    Tween(begin: begin, end: end)
                                                        .chain(
                                                  CurveTween(curve: curve),
                                                );

                                                return SlideTransition(
                                                  position:
                                                      animation.drive(tween),
                                                  child: child,
                                                );
                                              },
                                            ));
                                          },
                                          child: Container(
                                            width: responsive.wp(17),
                                            height: responsive.hp(3.5),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Pagar',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        )
                                       */
                                      ],
                                    ),
                                  )
                                : Container(
                                    color: Colors.white,
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: responsive.wp(5),
                                        vertical: responsive.hp(1)),
                                    child: Text(
                                      'Carrito',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: responsive.ip(2.5),
                                          fontWeight: FontWeight.w700),
                                    ),
                                  );
                          },
                        ),
                        Expanded(
                          child: ListView.builder(
                              padding: EdgeInsets.all(0),
                              controller: provider.controller,
                              itemCount: listcarrito.length + 1,
                              itemBuilder: (BuildContext context, int index) {
                                if (index == 0) {
                                  return Container(
                                    color: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: responsive.wp(5),
                                      // vertical: responsive.hp(1),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Carrito',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: responsive.ip(3),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(),
                                        /*  Text(
                                          'S/ ${listcarrito[index].monto}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: responsive.ip(1.8),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: responsive.wp(2),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            print('ubhfo');

                                            Navigator.of(context)
                                                .push(PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                  secondaryAnimation) {
                                                return ConfirmacionPedido();
                                              },
                                              transitionsBuilder: (context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child) {
                                                var begin = Offset(0.0, 1.0);
                                                var end = Offset.zero;
                                                var curve = Curves.ease;

                                                var tween =
                                                    Tween(begin: begin, end: end)
                                                        .chain(
                                                  CurveTween(curve: curve),
                                                );

                                                return SlideTransition(
                                                  position:
                                                      animation.drive(tween),
                                                  child: child,
                                                );
                                              },
                                            ));
                                          },
                                          child: Container(
                                            width: responsive.wp(17),
                                            height: responsive.hp(3.5),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Pagar',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        )
                                       */
                                      ],
                                    ),
                                  );
                                }

                                int xxx = index - 1;
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemCount: listcarrito[xxx].carrito.length + 1,
                                  itemBuilder: (BuildContext context, int i) {
                                    double paaa = responsive.hp(5);

                                    if (xxx == 0) {
                                      paaa = 0.0;
                                    }
                                    if (i == 0) {
                                      return Container(
                                        margin: EdgeInsets.only(
                                          top: paaa,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: responsive.hp(1),
                                        ),
                                        width: double.infinity,
                                        color: Colors.blueGrey[50],
                                        child: Row(
                                            //crossAxisAlignment: CrossAxisAlignment.center,

                                            children: [
                                              SizedBox(
                                                width: responsive.wp(3),
                                              ),
                                              Text(
                                                '${listcarrito[xxx].nombre}',
                                                style: TextStyle(
                                                    color: Colors.blueGrey[700],
                                                    fontSize: responsive.ip(1.8),
                                                    fontWeight: FontWeight.w700),
                                              ),
                                              Spacer(),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .push(PageRouteBuilder(
                                                    pageBuilder: (context,
                                                        animation,
                                                        secondaryAnimation) {
                                                      return ConfirmacionPedido(
                                                        idSubsidiary:
                                                            '${listcarrito[xxx].idSubsidiary}',
                                                      );
                                                    },
                                                    transitionsBuilder: (context,
                                                        animation,
                                                        secondaryAnimation,
                                                        child) {
                                                      var begin =
                                                          Offset(0.0, 1.0);
                                                      var end = Offset.zero;
                                                      var curve = Curves.ease;

                                                      var tween = Tween(
                                                              begin: begin,
                                                              end: end)
                                                          .chain(
                                                        CurveTween(curve: curve),
                                                      );

                                                      return SlideTransition(
                                                        position: animation
                                                            .drive(tween),
                                                        child: child,
                                                      );
                                                    },
                                                  ));
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          responsive.wp(3),
                                                      vertical:
                                                          responsive.hp(.5)),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: Colors.red),
                                                  child: Text(
                                                    'Pagar S/ ${listcarrito[xxx].monto}',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            responsive.ip(1.5),
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: responsive.wp(3),
                                              ),
                                              //Divider(),
                                            ]),
                                      );
                                    }
                                    int indd = i - 1;
                                    var precioFinal = double.parse(
                                            listcarrito[xxx]
                                                .carrito[indd]
                                                .precio) *
                                        double.parse(snapshot
                                            .data[xxx].carrito[indd].cantidad);
                                    return Container(
                                      height: responsive.hp(14),
                                      padding: EdgeInsets.symmetric(vertical: 5),
                                      width: double.infinity,
                                      child: Row(
                                        children: [
                                          /* SizedBox(
                                            width: responsive.wp(1.5),
                                          ), */
                                          GestureDetector(
                                            onTap: () {
                                              if ('${listcarrito[xxx].carrito[indd].estadoSeleccionado}' ==
                                                  '0') {
                                                cambiarEstadoCarrito(
                                                    context,
                                                    '${listcarrito[xxx].carrito[indd].idSubsidiaryGood}',
                                                    '1');
                                              } else {
                                                cambiarEstadoCarrito(
                                                    context,
                                                    '${listcarrito[xxx].carrito[indd].idSubsidiaryGood}',
                                                    '0');
                                              }
                                            },
                                            child: Container(
                                              width: responsive.wp(8),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    child: Center(
                                                      child: CircleAvatar(
                                                        radius: 10,
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                  ('${listcarrito[xxx].carrito[indd].estadoSeleccionado}' ==
                                                          '0')
                                                      ? Container(
                                                          child: Center(
                                                            child: CircleAvatar(
                                                              radius: 7,
                                                              backgroundColor:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        )
                                                      : Container()
                                                ],
                                              ),
                                            ),
                                          ),

                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Container(
                                              width: responsive.wp(35),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    height: responsive.hp(16),
                                                    width: responsive.wp(40),
                                                    child: CachedNetworkImage(
                                                      cacheManager:
                                                          CustomCacheManager(),
                                                      placeholder:
                                                          (context, url) =>
                                                              Container(
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        child: Image(
                                                            image: AssetImage(
                                                                'assets/loading.gif'),
                                                            fit: BoxFit.fitWidth),
                                                      ),
                                                      imageUrl:
                                                          '$apiBaseURL/${listcarrito[xxx].carrito[indd].image}',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: 0,
                                                    right: 0,
                                                    bottom: 0,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  responsive
                                                                      .wp(1)),
                                                      color: Colors.black
                                                          .withOpacity(.5),
                                                      width: double.infinity,
                                                      //double.infinity,
                                                      height: responsive.hp(3),
                                                      child: Text(
                                                        '${listcarrito[xxx].carrito[indd].nombre}',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          //SizedBox(height: 50),
                                          Container(
                                            width: responsive.wp(50),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text('${listcarrito[xxx].carrito[indd].nombre}' +
                                                    ' ' +
                                                    '${listcarrito[xxx].carrito[indd].marca}'),
                                                Text(
                                                  '${listcarrito[xxx].carrito[indd].moneda}' +
                                                      ' ' +
                                                      '$precioFinal',
                                                  style: TextStyle(
                                                      fontSize: responsive.ip(2)),
                                                ),
                                                Text(
                                                    '${listcarrito[xxx].carrito[indd].nombre}'),
                                                CantidadCarrito(
                                                  carrito: listcarrito[xxx]
                                                      .carrito[indd],
                                                  llamada: llamada,
                                                  idSudsidiaryGood:
                                                      '${listcarrito[xxx].carrito[indd].idSubsidiaryGood}',
                                                ),
                                              ],
                                            ),
                                          ),

                                          Container(
                                            width: responsive.wp(6),
                                            child: GestureDetector(
                                              onTap: () {
                                                agregarAlCarritoContador(
                                                    context,
                                                    '${listcarrito[xxx].carrito[indd].idSubsidiaryGood}',
                                                    0);
                                              },
                                              child: CircleAvatar(
                                                radius: 15,
                                                backgroundColor: Colors.grey,
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          )
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
    );
  }
}
