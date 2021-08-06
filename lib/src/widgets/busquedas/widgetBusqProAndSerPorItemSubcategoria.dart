import 'package:bufi/src/page/busqueda/busProYSerPorIdtemSub.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:flutter/material.dart';

class BusquedaProAndSerItemSubcategoriaWidget extends StatelessWidget {
  const BusquedaProAndSerItemSubcategoriaWidget({
    Key key,
    @required this.responsive,
    @required this.idItemsubcategory,
  }) : super(key: key);

  final Responsive responsive;
  final String idItemsubcategory;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return BusquedaDeProYSerPorIdItemsubcat(idItemsubcategory: idItemsubcategory);
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
        //BusquedaDeProYSerPorIdItemsubcat
        //showSearch(context: context, delegate: BusquedaItemSubcategoriaPage());
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
        height: responsive.hp(5),
        decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(25)),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.search),
              color: Colors.black,
              onPressed: () {
                //showSearch(context: context, delegate: BusquedaItemSubcategoriaPage());
              },
            ),
            Text(
              'Buscar Familia',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
