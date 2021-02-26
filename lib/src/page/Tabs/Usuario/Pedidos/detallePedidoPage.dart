import 'package:bufi/src/models/PedidosModel.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ticket_widget/flutter_ticket_widget.dart';

class TickectPedido extends StatelessWidget {
  const TickectPedido({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final PedidosModel pedido = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Color(0xff303c59),
      body: Stack(
        children: [
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
                          image: AssetImage('assets/logo_bufeotec.png'),
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
                              '${pedido.deliveryDatetime}',
                              'Cliente',
                              '${pedido.deliveryName} ',
                              responsive),
                          SizedBox(
                            height: responsive.hp(1.5),
                          ),
                          ticketDetailsWidget(
                              'Dirección',
                              '${pedido.deliveryAddress}',
                              'Tipo de entrega',
                              '${pedido.listCompanySubsidiary[0].companyDeliveryPropio}',
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
                      padding:
                          EdgeInsets.symmetric(horizontal: responsive.wp(5)),
                      child: Text('Datos de la empresa que realiza la venta'),
                    ),
                    SizedBox(
                      height: responsive.hp(1),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: responsive.wp(5)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.store),
                              SizedBox(
                                width: responsive.wp(2),
                              ),
                              Text(
                                '${pedido.listCompanySubsidiary[0].subsidiaryName}',
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
                                  '${pedido.listCompanySubsidiary[0].subsidiaryAddress}'),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.phone),
                              SizedBox(
                                width: responsive.wp(2),
                              ),
                              Text(
                                  '${pedido.listCompanySubsidiary[0].subsidiaryCellphone} - ${pedido.listCompanySubsidiary[0].subsidiaryCellphone2}'),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.email),
                              SizedBox(
                                width: responsive.wp(2),
                              ),
                              Text(
                                  '${pedido.listCompanySubsidiary[0].subsidiaryEmail} - ${pedido.listCompanySubsidiary[0].subsidiaryCellphone2}'),
                            ],
                          ),
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
                            itemCount: pedido.detallePedido.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                          "${pedido.detallePedido[index].listProducto[0].productoName} x ${pedido.detallePedido[index].cantidad}"),
                                      Text(
                                          "${pedido.detallePedido[index].listProducto[0].productoCharacteristics}  "),
                                      SizedBox(
                                        height: responsive.hp(.5),
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  Text(
                                    'S/. ' +
                                        (double.parse(
                                                    '${pedido.detallePedido[index].cantidad}') *
                                                double.parse(
                                                    '${pedido.detallePedido[index].listProducto[0].productoPrice}'))
                                            .toString(),
                                    style: TextStyle(
                                        fontSize: responsive.ip(1.8),
                                        fontWeight: FontWeight.bold),
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

                             Text('S/ ${pedido.deliveryTotalOrden}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: responsive.ip(1.8),
                                      fontWeight: FontWeight.bold)),
                            ],
                          ), SizedBox(
                            height: responsive.hp(1),
                          ),
                          Row(
                            children: [
                              Text("Envío"),
                              Spacer(),

                             Text('S/ 0.00',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: responsive.ip(1.8),
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: responsive.ip(2),
                                      fontWeight: FontWeight.bold)),
                              Spacer(),
                              Text('S/ ${pedido.deliveryTotalOrden}',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: responsive.ip(2.5),
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: responsive.hp(8),
            left: responsive.wp(6),
            child: GestureDetector(
              child: Container(
                width: responsive.ip(5),
                height: responsive.ip(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey[200],
                ),
                child: Center(child: BackButton()),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
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
            Container(
              width: responsive.wp(42),
              child: Text(
                dato2,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
