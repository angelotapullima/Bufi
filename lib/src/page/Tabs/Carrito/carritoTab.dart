import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/carritoGeneralModel..dart';
import 'package:bufi/src/page/Tabs/Carrito/carrito_bloc.dart';
import 'package:bufi/src/page/Tabs/Carrito/confirmacionPedido/confirmacion_pedido.dart';
import 'package:bufi/src/page/Tabs/iniciar_sesion.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/customCacheManager.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:bufi/src/widgets/cantidad_producto.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
              AsyncSnapshot<List<CarritoGeneralSuperior>> snapshot) {
            if (snapshot.hasData) {
              List<CarritoGeneralSuperior> listCarritoSuperior = snapshot.data;

              if (listCarritoSuperior.length > 0) {
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
                                        'Mi cesta',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: responsive.ip(3),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          final preferences = Preferences();
                                          if (preferences.personName == null) {
                                            showBarModalBottomSheet(
                                              expand: true,
                                              context: context,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder: (context) =>
                                                  ModalLogin(),
                                            );
                                          } else {
                                            double monto = double.parse(
                                                listCarritoSuperior[0]
                                                    .montoGeneral);

                                            if (monto > 0) {
                                              Navigator.of(context)
                                                  .push(PageRouteBuilder(
                                                pageBuilder: (context,
                                                    animation,
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

                                                  var tween = Tween(
                                                          begin: begin,
                                                          end: end)
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
                                            } else {
                                              showToast(context,
                                                  'Por favor seleccione productos para confirmar el pago');
                                            }
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: responsive.wp(3),
                                            vertical: responsive.hp(.5),
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.red),
                                          child: Text(
                                            'Pagar S/ ${listCarritoSuperior[0].montoGeneral}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: responsive.ip(1.5),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
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
                                      Text(
                                        'Mi cesta',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: responsive.ip(2.5),
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                );
                        },
                      ),
                      Expanded(
                        child: ListView.builder(
                            padding: EdgeInsets.all(0),
                            controller: provider.controller,
                            itemCount: listCarritoSuperior[0].car.length + 1,
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
                                        'Mi cesta',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: responsive.ip(3),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          final preferences = Preferences();
                                          if (preferences.personName == null) {
                                            showBarModalBottomSheet(
                                              expand: true,
                                              context: context,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder: (context) =>
                                                  ModalLogin(),
                                            );
                                          } else {
                                            double monto = double.parse(
                                                listCarritoSuperior[0]
                                                    .montoGeneral);

                                            if (monto > 0) {
                                              Navigator.of(context)
                                                  .push(PageRouteBuilder(
                                                pageBuilder: (context,
                                                    animation,
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

                                                  var tween = Tween(
                                                          begin: begin,
                                                          end: end)
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
                                            } else {
                                              showToast(context,
                                                  'Por favor seleccione productos para confirmar el pago');
                                            }
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: responsive.wp(3),
                                              vertical: responsive.hp(.5)),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.red),
                                          child: Text(
                                            'Pagar S/ ${listCarritoSuperior[0].montoGeneral}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: responsive.ip(1.5),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              int xxx = index - 1;
                              return ListView.builder(
                                padding: EdgeInsets.all(0),
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: listCarritoSuperior[0]
                                        .car[xxx]
                                        .carrito
                                        .length +
                                    1,
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
                                      color: Colors.grey[100],
                                      child: Row(
                                          //crossAxisAlignment: CrossAxisAlignment.center,

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
                                                  color: Colors.blueGrey[700],
                                                  fontSize: responsive.ip(1.8),
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Spacer(),
                                            Text(
                                              'S/. ${listCarritoSuperior[0].car[xxx].monto}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: responsive.ip(1.7),
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
                                          listCarritoSuperior[0]
                                              .car[xxx]
                                              .carrito[indd]
                                              .precio) *
                                      double.parse(listCarritoSuperior[0]
                                          .car[xxx]
                                          .carrito[indd]
                                          .cantidad);

                                  //Borrar con swipe
                                  return Dismissible(
                                    key: UniqueKey(),
                                    background: Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: responsive.wp(1),
                                      ),
                                      color: Colors.red[400],
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Icon(Icons.delete,
                                                  color: Colors.white)),
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: Icon(Icons.delete,
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                    direction: DismissDirection.horizontal,
                                    onDismissed: (direction) {
                                      agregarAlCarritoContador(
                                          context,
                                          '${listCarritoSuperior[0].car[xxx].carrito[indd].idSubsidiaryGood}',
                                          '${listCarritoSuperior[0].car[xxx].carrito[indd].talla}',
                                          '${listCarritoSuperior[0].car[xxx].carrito[indd].modelo}',
                                          '${listCarritoSuperior[0].car[xxx].carrito[indd].marca}',
                                          0);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        //horizontal: responsive.wp(3),
                                        vertical: responsive.hp(.5),
                                      ),
                                      height: responsive.hp(27),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: responsive.wp(3),
                                            ),
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    if ('${listCarritoSuperior[0].car[xxx].carrito[indd].estadoSeleccionado}' ==
                                                        '0') {
                                                      cambiarEstadoCarrito(
                                                          context,
                                                          '${listCarritoSuperior[0].car[xxx].carrito[indd].idSubsidiaryGood}',
                                                          '${listCarritoSuperior[0].car[xxx].carrito[indd].talla}',
                                                          '${listCarritoSuperior[0].car[xxx].carrito[indd].modelo}',
                                                          '${listCarritoSuperior[0].car[xxx].carrito[indd].marca}',
                                                          '1');
                                                    } else {
                                                      cambiarEstadoCarrito(
                                                          context,
                                                          '${listCarritoSuperior[0].car[xxx].carrito[indd].idSubsidiaryGood}',
                                                          '${listCarritoSuperior[0].car[xxx].carrito[indd].talla}',
                                                          '${listCarritoSuperior[0].car[xxx].carrito[indd].modelo}',
                                                          '${listCarritoSuperior[0].car[xxx].carrito[indd].marca}',
                                                          '0');
                                                    }
                                                  },

                                                  //Seleccionador
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
                                                        ('${listCarritoSuperior[0].car[xxx].carrito[indd].estadoSeleccionado}' ==
                                                                '0')
                                                            ? Container(
                                                                child: Center(
                                                                  child:
                                                                      CircleAvatar(
                                                                    radius: 7,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                  ),
                                                                ),
                                                              )
                                                            : Container()
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                                //imagen del producto
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Container(
                                                    color: Colors.blue,
                                                    height: responsive.hp(10),
                                                    width: responsive.wp(17),
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
                                                            fit: BoxFit
                                                                .fitWidth),
                                                      ),
                                                      imageUrl:
                                                          '$apiBaseURL/${listCarritoSuperior[0].car[xxx].carrito[indd].image}',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                //SizedBo(x(height: 50),
                                                SizedBox(
                                                  width: responsive.wp(5),
                                                ),
                                                //Datos del producto
                                                Expanded(
                                                  child: Container(
                                                    //width: responsive.wp(50),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${listCarritoSuperior[0].car[xxx].carrito[indd].nombre}',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  responsive
                                                                      .ip(1.5),
                                                              color: Colors
                                                                  .grey[800]),
                                                        ),
                                                        Text(
                                                          '${listCarritoSuperior[0].car[xxx].carrito[indd].marca}',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey[600]),
                                                        ),
                                                        Text(
                                                          '${listCarritoSuperior[0].car[xxx].carrito[indd].modelo}',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey[600]),
                                                        ),
                                                        Text(
                                                          '${listCarritoSuperior[0].car[xxx].carrito[indd].talla}',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey[600]),
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              responsive.hp(1),
                                                        ),
                                                        Text(
                                                          '${listCarritoSuperior[0].car[xxx].carrito[indd].moneda}${listCarritoSuperior[0].car[xxx].carrito[indd].precio}  X  Und',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.black,
                                                            fontSize: responsive
                                                                .ip(1.5),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                                Container(
                                                  width: responsive.ip(2.3),
                                                  height: responsive.ip(2.3),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          width: 2,
                                                          color: Colors.grey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100)),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      agregarAlCarritoContador(
                                                          context,
                                                          '${listCarritoSuperior[0].car[xxx].carrito[indd].idSubsidiaryGood}',
                                                          '${listCarritoSuperior[0].car[xxx].carrito[indd].talla}',
                                                          '${listCarritoSuperior[0].car[xxx].carrito[indd].modelo}',
                                                          '${listCarritoSuperior[0].car[xxx].carrito[indd].marca}',
                                                          0);
                                                    },
                                                    child: CircleAvatar(
                                                      radius:
                                                          responsive.ip(1.5),
                                                      backgroundColor:
                                                          Colors.white,
                                                      child: Icon(
                                                        Icons.close_rounded,
                                                        color: Colors.grey,
                                                        size:
                                                            responsive.ip(1.5),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: responsive.wp(3),
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: responsive.wp(3),
                                                ),
                                                CantidadCarrito(
                                                  carrito:
                                                      listCarritoSuperior[0]
                                                          .car[xxx]
                                                          .carrito[indd],
                                                  llamada: llamada,
                                                  idSudsidiaryGood:
                                                      '${listCarritoSuperior[0].car[xxx].carrito[indd].idSubsidiaryGood}',
                                                  tallaProducto:
                                                      '${listCarritoSuperior[0].car[xxx].carrito[indd].talla}',
                                                  modeloProducto:
                                                      '${listCarritoSuperior[0].car[xxx].carrito[indd].modelo}',
                                                  marcaProducto:
                                                      '${listCarritoSuperior[0].car[xxx].carrito[indd].marca}',
                                                ),
                                                Spacer(),
                                                Text(
                                                  'S/. $precioFinal',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        responsive.ip(1.7),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                              height: responsive.hp(1),
                                              color: Colors.grey[300])
                                        ],
                                      ),
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
