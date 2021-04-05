

import 'package:bufi/src/page/busqueda/busquedaProductosPorSucursal.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:flutter/material.dart';

class BusquedaProductoXsucursalWidget extends StatelessWidget {
  const BusquedaProductoXsucursalWidget({
    Key key,
    @required this.responsive,
    @required this.idSucursal,
    @required this.nameSucursal,
  }) : super(key: key);

  final Responsive responsive;
  final String idSucursal;
  final String nameSucursal;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
      
      

      Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return BusquedaProductosPorSucursal(
              nameSucursal: nameSucursal,
                idSubsidiary: idSucursal);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(0.0, 1.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ));

      },
      child: Container(
        // padding: EdgeInsets.symmetric(
        //   horizontal: responsive.wp(10),
        // ),
        width:responsive.wp(80) ,
        height: responsive.hp(5),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.search),
              color: Colors.black,
              onPressed: () {
               /*  showSearch(
                    context: context,
                    delegate: BusquedaProductosXSucursalPage(
                        idSucursal: idSucursal)); */
              },
            ),
            Text(
              'Buscar productos o servicios',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
