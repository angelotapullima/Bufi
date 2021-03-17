
import 'package:bufi/src/page/busqueda/itemSubcategoriaBusqPage.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:flutter/material.dart';


class BusquedaItemSubcategoriaWidget extends StatelessWidget {
  const BusquedaItemSubcategoriaWidget({
    Key key,
    @required this.responsive,
  }) : super(key: key);

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          onTap: () {
            showSearch(context: context, delegate: BusquedaItemSubcategoriaPage());
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
            height: responsive.hp(5),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(25)),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.search),
                  color: Colors.black,
                  onPressed: () {
                    showSearch(context: context, delegate: BusquedaItemSubcategoriaPage());
                  },
                ),
                Text(
                  'Buscar ItemSubcategoria',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        );
  }
}
