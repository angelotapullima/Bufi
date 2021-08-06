import 'package:bufi/src/models/carritoModel.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DetalleCarritoFotoPage extends StatelessWidget {
  const DetalleCarritoFotoPage({Key key, this.carritoData}) : super(key: key);
  final CarritoModel carritoData;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Scaffold(
      // appBar: AppBar(
      //   title:  Text('Flippers Page'),
      // ),
      body: Container(
          color: Colors.black,
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.all(responsive.ip(4)),
            child: Center(
              child: Hero(
                tag: 'imagen',
                child: Container(
                  height: responsive.hp(70),
                  width: responsive.wp(90),
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image(image: AssetImage('assets/loading.gif'), fit: BoxFit.fitWidth),
                    ),
                    imageUrl: '$apiBaseURL/${carritoData.image}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
