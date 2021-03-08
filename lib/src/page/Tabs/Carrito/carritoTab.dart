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
                                        'Cesta',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: responsive.ip(3),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Spacer(),
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
                                      vertical: responsive.hp(1)),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Cesta',
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
                                        'Cesta',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: responsive.ip(3),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          double monto = double.parse(
                                              listCarritoSuperior[0]
                                                  .montoGeneral);

                                          if (monto > 0) {
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

                                                var tween = Tween(
                                                        begin: begin, end: end)
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
                                      color: Colors.blue[50],
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
                                          '${listCarritoSuperior[0].car[xxx].carrito[indd].idSubsidiaryGood}', '${listCarritoSuperior[0].car[xxx].carrito[indd].talla}','${listCarritoSuperior[0].car[xxx].carrito[indd].modelo}','${listCarritoSuperior[0].car[xxx].carrito[indd].marca}',
                                          0);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: responsive.wp(3),
                                      ),
                                      height: responsive.hp(25),
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
                                                    '${listCarritoSuperior[0].car[xxx].carrito[indd].marca}', '1'
                                                    );
                                              } else {
                                                cambiarEstadoCarrito(
                                                    context,
                                                    '${listCarritoSuperior[0].car[xxx].carrito[indd].idSubsidiaryGood}',
                                                    
                                                    '${listCarritoSuperior[0].car[xxx].carrito[indd].talla}',
                                                    '${listCarritoSuperior[0].car[xxx].carrito[indd].modelo}',
                                                    '${listCarritoSuperior[0].car[xxx].carrito[indd].marca}', '0');
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
                                                  ('${listCarritoSuperior[0].car[xxx].carrito[indd].estadoSeleccionado}' ==
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
                                                    height: responsive.hp(15),
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
                                                            fit: BoxFit
                                                                .fitWidth),
                                                      ),
                                                      imageUrl:
                                                          '$apiBaseURL/${listCarritoSuperior[0].car[xxx].carrito[indd].image}',
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
                                                        '${listCarritoSuperior[0].car[xxx].carrito[indd].nombre}',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          //SizedBox(height: 50),
                                          Expanded(
                                            child: Container(
                                              //width: responsive.wp(50),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text('${listCarritoSuperior[0].car[xxx].carrito[indd].nombre}' +
                                                      ' ' +
                                                      '${listCarritoSuperior[0].car[xxx].carrito[indd].marca}'),

                                                  Text('ee ${listCarritoSuperior[0].car[xxx].carrito[indd].talla}'),
                                                  
                                                   Text('mm ${listCarritoSuperior[0].car[xxx].carrito[indd].modelo}'),
                                                  Text(
                                                    '${listCarritoSuperior[0].car[xxx].carrito[indd].moneda}' +
                                                        ' ' +
                                                        '$precioFinal',
                                                    style: TextStyle(
                                                        fontSize:
                                                            responsive.ip(2)),
                                                  ),
                                                  Text(
                                                      '${listCarritoSuperior[0].car[xxx].carrito[indd].nombre}'),
                                                  CantidadCarrito(
                                                    carrito:
                                                        listCarritoSuperior[0]
                                                            .car[xxx]
                                                            .carrito[indd],
                                                    llamada: llamada,
                                                    idSudsidiaryGood:
                                                        '${listCarritoSuperior[0].car[xxx].carrito[indd].idSubsidiaryGood}', marcaProducto:'${listCarritoSuperior[0].car[xxx].carrito[indd].marca}', modeloProducto: '${listCarritoSuperior[0].car[xxx].carrito[indd].modelo}', tallaProducto: '${listCarritoSuperior[0].car[xxx].carrito[indd].talla}',
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          
                                          //Cerrar carrito
                                          Container(
                                            width: responsive.wp(6),
                                            child: GestureDetector(
                                              onTap: () {
                                                agregarAlCarritoContador(
                                          context,
                                          '${listCarritoSuperior[0].car[xxx].carrito[indd].idSubsidiaryGood}', '${listCarritoSuperior[0].car[xxx].carrito[indd].talla}','${listCarritoSuperior[0].car[xxx].carrito[indd].modelo}','${listCarritoSuperior[0].car[xxx].carrito[indd].marca}',
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
