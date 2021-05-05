import 'dart:io';
import 'dart:typed_data';

import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/PedidosModel.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ticket_widget/flutter_ticket_widget.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class TickectPedido extends StatefulWidget {
  final String idPedido;
  const TickectPedido({Key key, @required this.idPedido}) : super(key: key);

  @override
  _TickectPedidoState createState() => _TickectPedidoState();
}

class _TickectPedidoState extends State<TickectPedido> {
  File _imageFile;
  ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    final pedidoBloc = ProviderBloc.pedido(context);
    pedidoBloc.obtenerPedidoPorId(widget.idPedido);
    return Scaffold(
      backgroundColor: Color(0xff303c59),
      body: StreamBuilder(
          stream: pedidoBloc.pedidoPorIdStream,
          builder: (context, AsyncSnapshot<List<PedidosModel>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                var fecha = obtenerFechaHora(snapshot.data[0].deliveryDatetime);
                return Stack(
                  children: [
                    Screenshot(
                      controller: screenshotController,
                      child: SafeArea(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: responsive.hp(1),
                            horizontal: responsive.wp(2),
                          ),
                          child: FlutterTicketWidget(
                            width: double.infinity,
                            height: double.infinity,
                            isCornerRounded: true,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: responsive.hp(1),
                                    ),
                                    child: Center(
                                      child: Image(
                                        width: responsive.ip(8),
                                        height: responsive.ip(8),
                                        image: AssetImage(
                                            'assets/logo_bufeotec.png'),
                                        fit: BoxFit.contain,
                                      ), /* Text(
                          'Comprobante de Pago',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: responsive.ip(2.5),
                              fontWeight: FontWeight.bold),
                        ), */
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      'Comprobante de Pago',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: responsive.ip(2.5),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: responsive.hp(2.5),
                                      left: responsive.wp(5),
                                      right: responsive.wp(5),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        ticketDetailsWidget(
                                            'Fecha',
                                            '$fecha',
                                            'Cliente',
                                            '${snapshot.data[0].deliveryName} ',
                                            responsive),
                                        SizedBox(
                                          height: responsive.hp(1.5),
                                        ),
                                        ticketDetailsWidget(
                                            'Dirección',
                                            '${snapshot.data[0].deliveryAddress}',
                                            'Tipo de entrega',
                                            '${snapshot.data[0].listCompanySubsidiary[0].companyDeliveryPropio}',
                                            responsive),
                                        SizedBox(
                                          height: responsive.hp(1.15),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: responsive.hp(1.5),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: responsive.wp(5)),
                                    child: Text(
                                        'Datos de la empresa que realiza la venta'),
                                  ),
                                  SizedBox(
                                    height: responsive.hp(1),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: responsive.wp(5)),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.store),
                                            SizedBox(
                                              width: responsive.wp(2),
                                            ),
                                            Text(
                                              '${snapshot.data[0].listCompanySubsidiary[0].subsidiaryName}',
                                              style: TextStyle(
                                                  fontSize: responsive.ip(2),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.pin_drop),
                                            SizedBox(
                                              width: responsive.wp(2),
                                            ),
                                            Text(
                                                '${snapshot.data[0].listCompanySubsidiary[0].subsidiaryAddress}'),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.phone),
                                            SizedBox(
                                              width: responsive.wp(2),
                                            ),
                                            Text(
                                                '${snapshot.data[0].listCompanySubsidiary[0].subsidiaryCellphone} - ${snapshot.data[0].listCompanySubsidiary[0].subsidiaryCellphone2}'),
                                          ],
                                        ),
                                        ('${snapshot.data[0].listCompanySubsidiary[0].subsidiaryEmail}' ==
                                                'null')
                                            ? Row(
                                                children: [
                                                  Icon(Icons.email),
                                                  SizedBox(
                                                    width: responsive.wp(2),
                                                  ),
                                                  Text(
                                                      '${snapshot.data[0].listCompanySubsidiary[0].subsidiaryEmail}')
                                                ],
                                              )
                                            : Container()
                                      ],
                                    ),
                                  ),
                                  Divider(),
                                  Center(
                                    child: Text(
                                      'Productos',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: responsive.ip(2.5),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Divider(),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: responsive.hp(2),
                                        left: responsive.wp(10),
                                        right: responsive.wp(10)),
                                    child: Column(
                                      children: [
                                        ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: snapshot
                                              .data[0].detallePedido.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                        "${snapshot.data[0].detallePedido[index].listProducto[0].productoName} ${snapshot.data[0].detallePedido[index].listProducto[0].productoBrand} x ${snapshot.data[0].detallePedido[index].cantidad}"),
                                                    Text(
                                                        "Modelo: ${snapshot.data[0].detallePedido[index].listProducto[0].productoModel} "),
                                                    Text(
                                                        "Tamaño: ${snapshot.data[0].detallePedido[index].listProducto[0].productoSize}"),
                                                    Text(
                                                        "Tipo: ${snapshot.data[0].detallePedido[index].listProducto[0].productoType}"),
                                                    SizedBox(
                                                      height: responsive.hp(.5),
                                                    )
                                                  ],
                                                ),
                                                Spacer(),
                                                Text(
                                                  'S/. ' +
                                                      (double.parse(
                                                                  '${snapshot.data[0].detallePedido[index].cantidad}') *
                                                              double.parse(
                                                                  '${snapshot.data[0].detallePedido[index].listProducto[0].productoPrice}'))
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize:
                                                          responsive.ip(1.8),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          height: responsive.hp(1),
                                        ),
                                        Divider(),
                                        Row(
                                          children: [
                                            Text("Subtotal"),
                                            Spacer(),
                                            Text(
                                                'S/ ${snapshot.data[0].deliveryTotalOrden}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        responsive.ip(1.8),
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                        SizedBox(
                                          height: responsive.hp(1),
                                        ),
                                        Row(
                                          children: [
                                            Text("Envío"),
                                            Spacer(),
                                            Text('S/ 0.00',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        responsive.ip(1.8),
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                        Divider(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Total',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: responsive.ip(2),
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Spacer(),
                                            Text(
                                                'S/ ${snapshot.data[0].deliveryTotalOrden}',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize:
                                                        responsive.ip(2.5),
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: responsive.hp(8),
                      left: responsive.wp(6),
                      child: Container(
                        width: responsive.ip(5),
                        height: responsive.ip(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey[200],
                        ),
                        child: Center(child: BackButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'home');
                          },
                        )),
                      ),
                    ),
                    Positioned(
                      top: responsive.hp(8.5),
                      right: responsive.wp(4),
                      child: GestureDetector(
                        child: Container(
                            width: responsive.ip(5),
                            height: responsive.ip(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.grey[200],
                            ),
                            child: Icon(Icons.share)),
                        onTap: () async {
                          takeScreenshotandShare();
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              }
            } else {
              return Center(
                child: Center(
                  child: Text("No se encuentra información"),
                ),
              );
            }
          }),
    );
  }

  takeScreenshotandShare() async {
    _imageFile = null;
    screenshotController
        .capture(delay: Duration(milliseconds: 10), pixelRatio: 2.0)
        .then((File image) async {
      setState(() {
        _imageFile = image;
      });

      await ImageGallerySaver.saveImage(image.readAsBytesSync());
      // Save image to gallery,  Needs plugin  https://pub.dev/packages/image_gallery_saver
      print("File Saved to Gallery");

      final directory = (await getApplicationDocumentsDirectory()).path;
      Uint8List pngBytes = _imageFile.readAsBytesSync();
      File imgFile = new File('$directory/screenshot.png');
      imgFile.writeAsBytes(pngBytes);
      print("File Saved to Gallery");
      await Share.file('Anupam', 'screenshot.png', pngBytes, 'image/png');
    }).catchError((onError) {
      print(onError);
    });
  }

  Widget ticketDetailsWidget(String cabecera1, String dato1, String cabecera2,
      String dato2, Responsive responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Container(
              width: responsive.wp(42),
              child: Text(
                cabecera1,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(
              width: responsive.wp(2),
            ),
            Container(
              width: responsive.wp(42),
              child: Text(
                cabecera2,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: responsive.wp(42),
              child: Text(
                dato1,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              width: responsive.wp(2),
            ),
            (dato2 != 'null')
                ? Container(
                    width: responsive.wp(42),
                    child: Text(
                      dato2,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  )
                : Container()
          ],
        )
      ],
    );
  }
}
