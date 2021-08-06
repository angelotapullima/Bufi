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
import 'package:share/share.dart';

class TickectPedido extends StatefulWidget {
  final String idPedido;
  const TickectPedido({Key key, @required this.idPedido}) : super(key: key);

  @override
  _TickectPedidoState createState() => _TickectPedidoState();
}

class _TickectPedidoState extends State<TickectPedido> {
  Uint8List _imageFile;
  List<String> imagePaths = [];
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
                  SafeArea(
                    child: SingleChildScrollView(
                      child: Screenshot(
                        controller: screenshotController,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: responsive.hp(1),
                            horizontal: responsive.wp(2),
                          ),
                          child: VistaDatosPedido(
                            fecha: fecha,
                            pedidos: snapshot.data,
                            activarScrool: false,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: responsive.hp(1),
                        horizontal: responsive.wp(2),
                      ),
                      child: FlutterTicketWidget(
                        width: double.infinity,
                        height: double.infinity,
                        isCornerRounded: true,
                        child: VistaDatosPedido(
                          fecha: fecha,
                          pedidos: snapshot.data,
                          activarScrool: true,
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
                          Navigator.pop(context);
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
        },
      ),
    );
  }

  takeScreenshotandShare() async {
    _imageFile = null;
    screenshotController.capture(delay: Duration(milliseconds: 10), pixelRatio: 2.0).then((Uint8List image) async {
      setState(() {
        _imageFile = image;
      });

      await ImageGallerySaver.saveImage(image);
      // Save image to gallery,  Needs plugin  https://pub.dev/packages/image_gallery_saver

      final directory = (await getApplicationDocumentsDirectory()).path;
      Uint8List pngBytes = _imageFile;
      File imgFile = new File('$directory/screenshot.png');
      imgFile.writeAsBytes(pngBytes);
      imagePaths.add(imgFile.path);
      final RenderBox box = context.findRenderObject() as RenderBox;
      await Share.shareFiles(imagePaths, text: '', subject: '', sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
      //await Share.shareFiles('Anupam', 'screenshot.png', pngBytes, 'image/png');
    }).catchError((onError) {
      print(onError);
    });
  }
}

class VistaDatosPedido extends StatefulWidget {
  const VistaDatosPedido({Key key, @required this.pedidos, @required this.fecha, @required this.activarScrool}) : super(key: key);

  final List<PedidosModel> pedidos;
  final String fecha;
  final bool activarScrool;

  @override
  _VistaDatosPedidoState createState() => _VistaDatosPedidoState();
}

class _VistaDatosPedidoState extends State<VistaDatosPedido> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return ListView.builder(
      padding: EdgeInsets.only(
        top: responsive.hp(2),
        bottom: responsive.hp(10),
      ),
      shrinkWrap: true,
      physics: (!widget.activarScrool) ? NeverScrollableScrollPhysics() : BouncingScrollPhysics(),
      itemCount: widget.pedidos[0].detallePedido.length + 2,
      itemBuilder: (context, index2) {
        if (index2 == 0) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: responsive.hp(1),
                ),
                child: Center(
                  child: Image(
                    width: responsive.ip(8),
                    height: responsive.ip(8),
                    image: AssetImage('assets/logo_bufeotec.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Comprobante de Pago',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
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
                    ticketDetailsWidget('Fecha', '${widget.fecha}', 'Cliente', '${widget.pedidos[0].deliveryName} ', responsive),
                    SizedBox(
                      height: responsive.hp(1.5),
                    ),
                    ticketDetailsWidget(
                        'Dirección', '${widget.pedidos[0].deliveryAddress}', 'Tipo de entrega', '${widget.pedidos[0].listCompanySubsidiary[0].companyDeliveryPropio}', responsive),
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
                padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
                child: Text('Datos de la empresa que realiza la venta'),
              ),
              SizedBox(
                height: responsive.hp(1),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.wp(5),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.store),
                        SizedBox(
                          width: responsive.wp(2),
                        ),
                        Text(
                          '${widget.pedidos[0].listCompanySubsidiary[0].subsidiaryName}',
                          style: TextStyle(fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.pin_drop),
                        SizedBox(
                          width: responsive.wp(2),
                        ),
                        Text('${widget.pedidos[0].listCompanySubsidiary[0].subsidiaryAddress}'),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.phone),
                        SizedBox(
                          width: responsive.wp(2),
                        ),
                        Text('${widget.pedidos[0].listCompanySubsidiary[0].subsidiaryCellphone} - ${widget.pedidos[0].listCompanySubsidiary[0].subsidiaryCellphone2}'),
                      ],
                    ),
                    ('${widget.pedidos[0].listCompanySubsidiary[0].subsidiaryEmail}' == 'null')
                        ? Row(
                            children: [
                              Icon(Icons.email),
                              SizedBox(
                                width: responsive.wp(2),
                              ),
                              Text('${widget.pedidos[0].listCompanySubsidiary[0].subsidiaryEmail}')
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
                  style: TextStyle(color: Colors.black, fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                ),
              ),
              Divider(),
            ],
          );
        }

        int index = index2 - 1;
        if (index == widget.pedidos[0].detallePedido.length) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.wp(4),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: responsive.hp(5),
                ),
                Divider(),
                Row(
                  children: [
                    Text("Subtotal"),
                    Spacer(),
                    Text(
                      'S/ ${widget.pedidos[0].deliveryTotalOrden}',
                      style: TextStyle(color: Colors.black, fontSize: responsive.ip(1.8), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: responsive.hp(1),
                ),
                Row(
                  children: [
                    Text("Envío"),
                    Spacer(),
                    Text(
                      'S/ ${widget.pedidos[0].deliveryPrice}',
                      style: TextStyle(color: Colors.black, fontSize: responsive.ip(1.8), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(color: Colors.red, fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(
                      'S/ ${widget.pedidos[0].deliveryTotalOrden}',
                      style: TextStyle(color: Colors.red, fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: responsive.hp(.5),
            horizontal: responsive.wp(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "${widget.pedidos[0].detallePedido[index].listProducto[0].productoName} ${widget.pedidos[0].detallePedido[index].listProducto[0].productoBrand} x ${widget.pedidos[0].detallePedido[index].cantidad}"),
                    Text("Modelo: ${widget.pedidos[0].detallePedido[index].listProducto[0].productoModel} "),
                    Text("Tamaño: ${widget.pedidos[0].detallePedido[index].listProducto[0].productoSize}"),
                    Text("Tipo: ${widget.pedidos[0].detallePedido[index].listProducto[0].productoType}"),
                    SizedBox(
                      height: responsive.hp(.5),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: responsive.wp(3),
              ),
              Text(
                'S/. ' +
                    (double.parse('${widget.pedidos[0].detallePedido[index].cantidad}') * double.parse('${widget.pedidos[0].detallePedido[index].listProducto[0].productoPrice}'))
                        .toString(),
                style: TextStyle(fontSize: responsive.ip(1.8), fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget ticketDetailsWidget(String cabecera1, String dato1, String cabecera2, String dato2, Responsive responsive) {
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
