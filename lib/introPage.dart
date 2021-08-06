import 'dart:ui';

import 'package:bufi/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ExampleHorizontal extends StatefulWidget {
  @override
  _ExampleHorizontalState createState() => _ExampleHorizontalState();
}

class _ExampleHorizontalState extends State<ExampleHorizontal> {
  List<String> images = [
    "http://vendeenamazon.net/wp-content/uploads/2018/02/comprarparavender.png",
    "http://www.lanuevacronica.com/imagenes/articulos/4534-compras-online.jpg",
    // "assets/producto.jpg",
    // "assets/empresa.jpg",
    // "assets/producto.jpg"
  ];

  List<String> mensaje = [
    "Bienvenido a Bufi, la app de compras y ventas más grande de la ciudad",
    "Aquí encontrarás los productos y servicios que necesites a cualquier hora del día",
    "Inicia Sesión para más opciones o solo entra a echar un vistazo"
  ];
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Scaffold(
        /* appBar: AppBar(
          title: Text("Intro"),
          backgroundColor: Colors.transparent,
        ), */
        body: Swiper(
      itemBuilder: (BuildContext context, int index) {
        return Stack(
          children: [contenedor(responsive, index), _mensajeTexto(responsive, mensaje[index])],
        );

        // Image.network(
        //   images[index],
        //   fit: BoxFit.fill,
        // );
      },

      //indicatorLayout: PageIndicatorLayout.COLOR,

      //autoplay: true,

      itemCount: mensaje.length,
      //images.length,

      pagination: SwiperPagination(),

      control: SwiperControl(),
    ));
  }

  Widget _mensajeTexto(Responsive responsive, mensaje) {
    return Positioned(
        bottom: responsive.hp(10),
        left: responsive.ip(8),
        child: Container(
          width: responsive.wp(80),
          child: Text(
            mensaje,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ));
  }

  Widget contenedor(Responsive responsive, int index) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.yellow, Colors.orange, Colors.red, Colors.red],
        ),

        //borderRadius: BorderRadius.circular(15)
      ),
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.symmetric(
                horizontal: responsive.ip(1.5),
                vertical: responsive.ip(0.5),
              ),
              width: double.infinity,
              height: responsive.ip(8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Text("Inicia sesión")),
          ClipRRect(
              child: Container(
            width: responsive.wp(20),
            height: responsive.hp(20),
            child: Text("Ingresar como invitado"),
          )),
        ],
      ),
    );
  }
}
