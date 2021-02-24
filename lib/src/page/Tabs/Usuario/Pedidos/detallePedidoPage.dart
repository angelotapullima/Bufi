import 'package:bufi/src/models/PedidosModel.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/widgets/clipper_ticket.dart';
import 'package:flutter/material.dart';

class DetallePedido extends StatelessWidget {
  const DetallePedido({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    PedidosModel listPedidos = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Color(0xff303c59),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(
                  horizontal: responsive.wp(2),
                ),
                child: PhysicalShape(
                  color: Colors.white,
                  shadowColor: Colors.blue,
                  elevation: .5,
                  clipper: TicketClipper(),
                  child: Container(
                    height: 60,
                    child: Center(
                      child: Text(
                        'Detalle de Pedido',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: responsive.ip(1.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                margin: EdgeInsets.symmetric(
                  horizontal: responsive.wp(3.5),
                ),
                child: MySeparator(
                  color: Color(0xff303c59),
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(
                  horizontal: responsive.wp(2),
                ),
                child: PhysicalShape(
                  color: Colors.white,
                  shadowColor: Colors.blue,
                  elevation: .5,
                  clipper: ExtendedClipper(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: responsive.hp(2),
                      ),
                      // Container(
                      //   width: double.infinity,
                      //   margin: EdgeInsets.only(
                      //     left: responsive.wp(1.5),
                      //   ),
                      //   height: responsive.hp(12),
                      //   child: ClipRRect(
                      //     borderRadius: BorderRadius.circular(10),
                      //     child: Image(
                      //       image: AssetImage('assets/logo_bufeotec.png'),
                      //       fit: BoxFit.contain,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: responsive.hp(2),
                      ),
                      Text(
                        'pagos.codigo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: responsive.ip(6.5),
                        ),
                      ),
                      SizedBox(
                        height: responsive.hp(3),
                      ),
                      Divider(),
                      /* Container(
                        color: Colors.white,
                        margin: EdgeInsets.symmetric(
                          horizontal: responsive.wp(1.5),
                        ),
                        child: MySeparator(
                          color: Color(0xFF648BE7),
                        ),
                      ), */
                      SizedBox(
                        height: responsive.hp(1.5),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: responsive.wp(4),
                          ),
                          Text(
                            'Monto',
                            style: TextStyle(
                              fontSize: responsive.ip(2),
                            ),
                          ),
                          Spacer(),
                          Text(
                            'S/ ',
                            style: TextStyle(
                              fontSize: responsive.ip(2),
                            ),
                          ),
                          SizedBox(
                            width: responsive.wp(4),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: responsive.hp(1.5),
                      ),
                      Divider(),
                      SizedBox(
                        height: responsive.hp(1.5),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(3.5),
                        ),
                        child: Text(
                          'pagos.mensaje',
                          style: TextStyle(
                              fontSize: responsive.ip(1.7),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: responsive.hp(1.5),
                      ),
                      Divider(),
                      SizedBox(
                        height: responsive.hp(1.5),
                      ),
                      // (pagos.tipo == '1')
                      //     ? Container(
                      //         padding: EdgeInsets.all(10),
                      //         decoration: BoxDecoration(
                      //           color: Colors.red,
                      //           borderRadius: BorderRadius.circular(20),
                      //         ),
                      //         child: Text(
                      //           'Ver Agentes',
                      //           style: TextStyle(color: Colors.white),
                      //         ),
                      //       )
                      //     : GestureDetector(
                      //       onTap: (){
                      //         Navigator.pushNamed(context, 'subirVaucher');
                      //       },
                      //                                 child: Container(
                      //           padding: EdgeInsets.all(10),
                      //           decoration: BoxDecoration(
                      //             color: Colors.red,
                      //             borderRadius: BorderRadius.circular(20),
                      //           ),
                      //           child: Text(
                      //             'Subir vaucher',
                      //             style: TextStyle(color: Colors.white),
                      //           ),
                      //         ),
                      //     ),
                      SizedBox(
                        height: responsive.hp(4),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: responsive.hp(4.5),
            left: responsive.wp(2),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: CircleAvatar(
                radius: responsive.ip(1.8),
                backgroundColor: Colors.white,
                child: Icon(Icons.close),
              ),
            ),
          )
        ],
      ),
    );
  }
}
