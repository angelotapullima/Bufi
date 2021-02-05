import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/carritoGeneralModel..dart';
import 'package:bufi/src/page/Tabs/Carrito/confirmacionPedido/confirmacion_pedido_bloc.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/customCacheManager.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmacionPedido extends StatefulWidget {
  final String idSubsidiary;
  const ConfirmacionPedido({Key key, @required this.idSubsidiary})
      : super(key: key);

  @override
  _ConfirmacionPedidoState createState() => _ConfirmacionPedidoState();
}

class _ConfirmacionPedidoState extends State<ConfirmacionPedido> {
  void llamada() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final carritoBloc = ProviderBloc.productosCarrito(context);
    carritoBloc.obtenerCarritoConfirmacion(widget.idSubsidiary);

    final provider = Provider.of<ConfirmPedidoBloc>(context, listen: false);

    return Scaffold(
      body: StreamBuilder(
          stream: carritoBloc.carritoSeleccionadoStream,
          builder: (BuildContext context,
              AsyncSnapshot<List<CarritoGeneralModel>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                List<CarritoGeneralModel> listcarrito = snapshot.data;

                return Scaffold(
                  backgroundColor: Colors.white,
                  body: SafeArea(
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
                                              fontSize: responsive.ip(2.5),
                                              fontWeight: FontWeight.bold),
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
                              itemCount: listcarrito.length + 1,
                              itemBuilder: (BuildContext context, int index) {
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
                                              fontSize: responsive.ip(2.5),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                int xxx = index - 1;

                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemCount:
                                      listcarrito[xxx].carrito.length + 2,
                                  itemBuilder: (BuildContext context, int i) {
                                    if (i == 0) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: responsive.hp(1),
                                        ),
                                        width: double.infinity,
                                        color: Colors.blueGrey[100],
                                        child: Row(
                                            //crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${listcarrito[xxx].nombre}',
                                                style: TextStyle(
                                                    color: Colors.blueGrey[700],
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),

                                              //Divider(),
                                            ]),
                                      );
                                    }

                                    if (i ==
                                        listcarrito[xxx].carrito.length + 1) {
                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: responsive.hp(2),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: responsive.wp(2),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Lugar de Entrega',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: responsive.ip(2),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      height: responsive.ip(4),
                                                      width: responsive.ip(4),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.blueGrey[50],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Icon(
                                                          Icons.pin_drop,
                                                          color: Colors.blue),
                                                    ),
                                                    SizedBox(
                                                      width: responsive.wp(2),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Alzamora 956',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    responsive
                                                                        .ip(
                                                                            1.6),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          Text(
                                                            'Altura de la esquina de vete a la ptmr con no jodas',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    responsive
                                                                        .ip(
                                                                            1.5),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: responsive.wp(2),
                                                    ),
                                                    Icon(Icons
                                                        .arrow_forward_ios_rounded)
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: responsive.hp(2),
                                          ),
                                          //Divider(),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: responsive.wp(2)),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Subtotal',
                                                      style: TextStyle(
                                                          fontSize: responsive
                                                              .ip(1.9),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      'S/. ${listcarrito[xxx].monto}',
                                                      style: TextStyle(
                                                          fontSize: responsive
                                                              .ip(1.8),
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Envio',
                                                      style: TextStyle(
                                                          fontSize:
                                                              responsive.ip(2),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      '0.0',
                                                      style: TextStyle(
                                                          fontSize:
                                                              responsive.ip(2),
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Total',
                                                      style: TextStyle(
                                                          fontSize: responsive
                                                              .ip(1.9),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      'S/. ${listcarrito[xxx].monto}',
                                                      style: TextStyle(
                                                          fontSize: responsive
                                                              .ip(2.3),
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),

                                          SizedBox(height: responsive.hp(5)),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: responsive.wp(2),
                                            ),
                                            width: double.infinity,
                                            height: responsive.hp(5),
                                            decoration: BoxDecoration(
                                              color: Colors.blue[400],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: responsive.wp(5),
                                                  ),
                                                  Text(
                                                    'Proceder a pagar',
                                                    style: TextStyle(
                                                      fontSize: responsive.ip(1.6),
                                                      fontWeight: FontWeight.w700,
                                                        color: Colors.white),
                                                  ),
                                                  Spacer(),
                                                  Icon(
                                                      Icons
                                                          .arrow_forward_ios_rounded,
                                                      color: Colors.white),
                                                  Icon(
                                                      Icons
                                                          .arrow_forward_ios_rounded,
                                                      color: Colors.white),
                                                  SizedBox(
                                                    width: responsive.wp(5),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                    int indd = i - 1;

                                    return Container(
                                      height: responsive.hp(6),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      width: double.infinity,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: responsive.wp(1.5),
                                          ),

                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Container(
                                              width: responsive.wp(15),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    height: responsive.hp(5),
                                                    width: responsive.wp(15),
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
                                                          '$apiBaseURL/${listcarrito[xxx].carrito[indd].image}',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: responsive.wp(2)),
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,

                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('${listcarrito[xxx].carrito[indd].nombre} ' +
                                                      '${listcarrito[xxx].carrito[indd].marca} x ' +
                                                      '${listcarrito[xxx].carrito[indd].cantidad}'),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: responsive.wp(2)),
                                          Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'S/. ' +
                                                      (double.parse(
                                                                  '${listcarrito[xxx].carrito[indd].cantidad}') *
                                                              double.parse(
                                                                  '${listcarrito[xxx].carrito[indd].precio}'))
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize:
                                                          responsive.ip(1.5),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: responsive.wp(2),
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
