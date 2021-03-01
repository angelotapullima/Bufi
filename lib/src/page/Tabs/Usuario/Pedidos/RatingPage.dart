import 'dart:io';

import 'package:bufi/src/api/pedidos/Pedido_api.dart';
import 'package:bufi/src/models/PedidosModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';



class RatingProductosPage extends StatefulWidget {
  RatingProductosPage({Key key}) : super(key: key);

  @override
  _RatingProductosPageState createState() => _RatingProductosPageState();
}

class _RatingProductosPageState extends State<RatingProductosPage> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final PedidosModel pedido = ModalRoute.of(context).settings.arguments;

  TextEditingController comentarioController = TextEditingController();
  File foto;
  
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Valorar",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(
              top: responsive.ip(4),
              left: responsive.ip(2),
              right: responsive.ip(2)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Califica el producto",
                  style: TextStyle(fontSize: responsive.ip(2)),
                ),

                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     IconButton(icon: Icon(Icons.star), onPressed: () {}),
                //     IconButton(icon: Icon(Icons.star), onPressed: () {}),
                //     IconButton(icon: Icon(Icons.star), onPressed: () {}),
                //     IconButton(icon: Icon(Icons.star), onPressed: () {}),
                //     IconButton(icon: Icon(Icons.star), onPressed: () {}),
                //   ],
                // ),
                SizedBox(height: responsive.hp(2)),
                Text("Puedes dejarnos un comentario (100 caracteres)",
                    style: TextStyle(fontSize: responsive.ip(2))),
                SizedBox(height: responsive.hp(1)),
                Container(
                  decoration: BoxDecoration(border: Border.all()),
                  child: TextField(
                    controller: comentarioController,
                    keyboardType: TextInputType.text,
                    maxLines: 3,
                  ),
                ),
                SizedBox(height: responsive.hp(4)),
                Row(
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.camera_alt_rounded,
                        ),
                        onPressed: () {}),
                    RaisedButton(
                      onPressed: () {},
                      child: Text("Subir Fotos"),
                    )
                  ],
                ),
                SizedBox(height: responsive.hp(2)),
                // Text("Calificación detallada",
                //     style: TextStyle(fontSize: responsive.ip(2.2))),
                // Divider(),
                // SizedBox(height: responsive.hp(2)),
                // Text("¿Qué tan precisa fue la descripción del producto?",
                //     style: TextStyle(fontSize: responsive.ip(2))),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     IconButton(icon: Icon(Icons.star), onPressed: () {}),
                //     IconButton(icon: Icon(Icons.star), onPressed: () {}),
                //     IconButton(icon: Icon(Icons.star), onPressed: () {}),
                //     IconButton(icon: Icon(Icons.star), onPressed: () {}),
                //     IconButton(icon: Icon(Icons.star), onPressed: () {}),
                //   ],
                // ),
                // Text("¿Qué tan rápido envió el vendedor el artículo?",
                //     style: TextStyle(fontSize: responsive.ip(2))),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     IconButton(icon: Icon(Icons.star), onPressed: () {}),
                //     IconButton(icon: Icon(Icons.star), onPressed: () {}),
                //     IconButton(icon: Icon(Icons.star), onPressed: () {}),
                //     IconButton(icon: Icon(Icons.star), onPressed: () {}),
                //     IconButton(icon: Icon(Icons.star), onPressed: () {}),
                //   ],
                // ),
                // Text("¿Está satisfecho con la comunicación con el vendedor?",
                //     style: TextStyle(fontSize: responsive.ip(2))),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     IconButton(
                //         icon: Icon(
                //           Icons.star,
                //           color: Colors.yellow,
                //         ),
                //         onPressed: () {}),
                //     IconButton(icon: Icon(Icons.star), onPressed: () {}),
                //     IconButton(icon: Icon(Icons.star), onPressed: () {}),
                //     IconButton(icon: Icon(Icons.star), onPressed: () {}),
                //     IconButton(icon: Icon(Icons.star), onPressed: () {}),
                //   ],
                // ),
                SizedBox(height: responsive.hp(2)),
                Center(
                  child: SizedBox(
                    width: responsive.wp(80),
                    child: RaisedButton(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      color: Colors.red,
                      onPressed: () {
                        final pedidoApi= PedidoApi();
                        final producModel= ProductoModel();
                        final pedidoModel= PedidosModel();
                       
                        final code= pedidoApi.valoracion(foto, producModel, pedidoModel, comentarioController);
                        if (code==1) {
                          
                          
                        }
                        
                      },
                      child: Text("Calificar",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: responsive.ip(2.2))),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
