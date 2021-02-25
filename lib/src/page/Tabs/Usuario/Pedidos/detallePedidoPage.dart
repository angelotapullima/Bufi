import 'package:bufi/src/models/PedidosModel.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ticket_widget/flutter_ticket_widget.dart';
import 'package:bufi/src/utils/utils.dart' as utils;

class DetallePedido extends StatelessWidget {
  const DetallePedido({Key key}) : super(key: key);

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
                  vertical: responsive.hp(2), horizontal: responsive.wp(3)),
              child: FlutterTicketWidget(
                width: double.infinity,
                height: double.infinity,
                isCornerRounded: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        top: responsive.hp(3),
                      ),
                      child: Center(
                        child: Text(
                          'Comprobante de Pago',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: responsive.ip(2.5),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(
                    //     top: responsive.hp(1),
                    //   ),
                    //   child: Center(
                    //     child: Text(
                    //       '${pedido.listCompanySubsidiary[0].subsidiaryName}',
                    //       style: TextStyle(
                    //           color: Colors.black,
                    //           fontSize: responsive.ip(2.7),
                    //           fontWeight: FontWeight.bold),
                    //     ),
                    //   ),
                    // ),
                    Padding(
                     padding: EdgeInsets.only(
                        top: responsive.hp(2),
                        left:responsive.ip(2) ),
                        
                      child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width:responsive.wp(40),
                            height: responsive.hp(4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              border:
                                  Border.all(width: 1.0, color: Colors.red),
                            ),
                            child: Center(
                              child: Text(
                                'Pedido N° ${pedido.idPedido}',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: responsive.ip(2.2)),
                              ),
                            ),
                          ),
                          SizedBox(width: responsive.wp(20)),
                          Row(
                            children: <Widget>[
                              Column(
                                children: [
                                  Text(
                                    '${pedido.listCompanySubsidiary[0].subsidiaryName}',
                                    style: TextStyle(
                                        color: Colors.black,
                                         fontSize: responsive.ip(2),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Image(
                                width: responsive.wp(10),
                                height: responsive.hp(5),
                                image: AssetImage('assets/logo_bufeotec.png'),
                                fit: BoxFit.contain,
                              ),
                                ],
                                
                              ),
                              
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: responsive.hp(2.5),
                        left: responsive.wp(10),
                        right: responsive.wp(10),
                      ),
                      child: Column(
                        children: <Widget>[
                          ticketDetailsWidget('Fecha',
                              '${pedido.deliveryDatetime}', responsive),
                          SizedBox(height: responsive.hp(1.5)),
                          ticketDetailsWidget(
                              'Cliente', '${pedido.deliveryName}', responsive),
                          SizedBox(
                            height: responsive.hp(1.5),
                          ),
                          ticketDetailsWidget('Dirección',
                              '${pedido.deliveryAddress}', responsive),
                          SizedBox(
                            height: responsive.hp(1.5),
                          ),
                          ticketDetailsWidget(
                              'Tipo de entrega',
                              '${pedido.listCompanySubsidiary[0].companyDeliveryPropio}',
                              responsive),
                          SizedBox(
                            height: responsive.hp(1.5),
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
                                  Expanded(
                                    child: Text(
                                        "${pedido.detallePedido[index].cantidad}"),
                                  ),
                                  Expanded(
                                    child: Text(
                                        "${pedido.detallePedido[index].listProducto[0].productoName}"),
                                  ),
                                  Expanded(
                                    child: Text(
                                        "${pedido.detallePedido[index].listProducto[0].productoPrice}"),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'S/. ' +
                                          (double.parse(
                                                      '${pedido.detallePedido[index].cantidad}') *
                                                  double.parse(
                                                      '${pedido.detallePedido[index].listProducto[0].productoPrice}'))
                                              .toString(),
                                      style: TextStyle(
                                          fontSize: responsive.ip(1.8),

                                          //color: Colors.red,

                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(height: responsive.hp(3)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text('Total',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: responsive.ip(2.5),
                                        fontWeight: FontWeight.bold)),
                              ),
                              // SizedBox(
                              //   width: responsive.wp(30),
                              // ),
                              Expanded(
                                child: Text('S/ ${pedido.deliveryTotalOrden}',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: responsive.ip(2.5),
                                        fontWeight: FontWeight.bold)),
                              ),
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
            left: responsive.wp(8),
            child: GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[100],
                ),
                child: Icon(Icons.arrow_back, color: Colors.black),
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

  Widget ticketDetailsWidget(
      String firstTitle, String firstDesc, Responsive responsive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              firstTitle,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: responsive.hp(1)),
              child: Text(
                firstDesc,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  // ListView products(
  //     Responsive responsive, List<ProductoServer> productos, String totalex) {
  //   var totalito = utils.format(double.parse(totalex));
  //   final total = Container(
  //       margin: EdgeInsets.symmetric(vertical: responsive.hp(1)),
  //       child: Column(
  //         children: <Widget>[
  //           Divider(),
  //           Row(
  //             children: <Widget>[
  //               Expanded(
  //                 child: Text('Total',
  //                     style: TextStyle(
  //                         color: Colors.red,
  //                         fontSize: responsive.ip(2.5),
  //                         fontWeight: FontWeight.bold)),
  //               ),
  //               SizedBox(
  //                 width: responsive.wp(5),
  //               ),
  //               Text('S/ $totalito',
  //                   style: TextStyle(
  //                       color: Colors.red,
  //                       fontSize: responsive.ip(2.5),
  //                       fontWeight: FontWeight.bold)),
  //             ],
  //           ),
  //         ],
  //       ));
  //   return ListView.builder(
  //     itemCount: productos.length + 1,
  //     scrollDirection: Axis.vertical,
  //     shrinkWrap: true,
  //     physics: ScrollPhysics(),
  //     itemBuilder: (context, i) {
  //       if (i == productos.length) {
  //         return total;
  //       }
  //       return Padding(
  //         padding: EdgeInsets.symmetric(vertical: responsive.hp(.5)),
  //         child: Row(
  //           children: <Widget>[
  //             Expanded(
  //               child: Text(
  //                 '${productos[i].productoNombre} x ${productos[i].detalleCantidad}',
  //                 style: TextStyle(fontSize: responsive.ip(2)),
  //               ),
  //             ),
  //             SizedBox(
  //               width: responsive.wp(5),
  //             ),
  //             Text(
  //               'S/.${productos[i].detallePrecioTotal}',
  //               style: TextStyle(
  //                   fontSize: responsive.ip(2),
  //                   color: Colors.redAccent,
  //                   fontWeight: FontWeight.bold),
  //             )
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  //     // Stack(
  //   children: [
  //     Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Container(
  //           width: double.infinity,
  //           margin: EdgeInsets.symmetric(
  //             horizontal: responsive.wp(2),
  //           ),
  //           child: PhysicalShape(
  //             color: Colors.white,
  //             shadowColor: Colors.blue,
  //             elevation: .5,
  //             clipper: TicketClipper(),
  //             child: Container(
  //               height: 60,
  //               child: Center(
  //                 child: Text(
  //                   'Detalle de Pedido',
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: responsive.ip(1.5),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //         Container(
  //           color: Colors.white,
  //           margin: EdgeInsets.symmetric(
  //             horizontal: responsive.wp(3.5),
  //           ),
  //           child: MySeparator(
  //             color: Color(0xff303c59),
  //           ),
  //         ),
  //         Container(
  //           width: double.infinity,
  //           margin: EdgeInsets.symmetric(
  //             horizontal: responsive.wp(2),
  //           ),
  //           child: PhysicalShape(
  //             color: Colors.white,
  //             shadowColor: Colors.blue,
  //             elevation: .5,
  //             clipper: ExtendedClipper(),
  //             child: Column(
  //               children: [
  //                 SizedBox(
  //                   height: responsive.hp(2),
  //                 ),
  //                 // Container(
  //                 //   width: double.infinity,
  //                 //   margin: EdgeInsets.only(
  //                 //     left: responsive.wp(1.5),
  //                 //   ),
  //                 //   height: responsive.hp(12),
  //                 //   child: ClipRRect(
  //                 //     borderRadius: BorderRadius.circular(10),
  //                 //     child: Image(
  //                 //       image: AssetImage('assets/logo_bufeotec.png'),
  //                 //       fit: BoxFit.contain,
  //                 //     ),
  //                 //   ),
  //                 // ),
  //                 SizedBox(
  //                   height: responsive.hp(2),
  //                 ),
  //                 Text(
  //                   'pagos.codigo',
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                     fontSize: responsive.ip(6.5),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: responsive.hp(3),
  //                 ),
  //                 Divider(),
  //                 /* Container(
  //                   color: Colors.white,
  //                   margin: EdgeInsets.symmetric(
  //                     horizontal: responsive.wp(1.5),
  //                   ),
  //                   child: MySeparator(
  //                     color: Color(0xFF648BE7),
  //                   ),
  //                 ), */
  //                 SizedBox(
  //                   height: responsive.hp(1.5),
  //                 ),
  //                 Row(
  //                   children: [
  //                     SizedBox(
  //                       width: responsive.wp(4),
  //                     ),
  //                     Text(
  //                       'Monto',
  //                       style: TextStyle(
  //                         fontSize: responsive.ip(2),
  //                       ),
  //                     ),
  //                     Spacer(),
  //                     Text(
  //                       'S/ ',
  //                       style: TextStyle(
  //                         fontSize: responsive.ip(2),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: responsive.wp(4),
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(
  //                   height: responsive.hp(1.5),
  //                 ),
  //                 Divider(),
  //                 SizedBox(
  //                   height: responsive.hp(1.5),
  //                 ),
  //                 Padding(
  //                   padding: EdgeInsets.symmetric(
  //                     horizontal: responsive.wp(3.5),
  //                   ),
  //                   child: Text(
  //                     'pagos.mensaje',
  //                     style: TextStyle(
  //                         fontSize: responsive.ip(1.7),
  //                         fontWeight: FontWeight.bold),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: responsive.hp(1.5),
  //                 ),
  //                 Divider(),
  //                 SizedBox(
  //                   height: responsive.hp(1.5),
  //                 ),
  //                 // (pagos.tipo == '1')
  //                 //     ? Container(
  //                 //         padding: EdgeInsets.all(10),
  //                 //         decoration: BoxDecoration(
  //                 //           color: Colors.red,
  //                 //           borderRadius: BorderRadius.circular(20),
  //                 //         ),
  //                 //         child: Text(
  //                 //           'Ver Agentes',
  //                 //           style: TextStyle(color: Colors.white),
  //                 //         ),
  //                 //       )
  //                 //     : GestureDetector(
  //                 //       onTap: (){
  //                 //         Navigator.pushNamed(context, 'subirVaucher');
  //                 //       },
  //                 //                                 child: Container(
  //                 //           padding: EdgeInsets.all(10),
  //                 //           decoration: BoxDecoration(
  //                 //             color: Colors.red,
  //                 //             borderRadius: BorderRadius.circular(20),
  //                 //           ),
  //                 //           child: Text(
  //                 //             'Subir vaucher',
  //                 //             style: TextStyle(color: Colors.white),
  //                 //           ),
  //                 //         ),
  //                 //     ),
  //                 SizedBox(
  //                   height: responsive.hp(4),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //     Positioned(
  //       top: responsive.hp(4.5),
  //       left: responsive.wp(2),
  //       child: GestureDetector(
  //         onTap: () {
  //           Navigator.pop(context);
  //         },
  //         child: CircleAvatar(
  //           radius: responsive.ip(1.8),
  //           backgroundColor: Colors.white,
  //           child: Icon(Icons.close),
  //         ),
  //       ),
  //     )
  //   ],
  // ),

}
