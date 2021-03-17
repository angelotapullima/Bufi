import 'package:bufi/src/page/busqueda/porSucursal/BusquedaSucursalPage.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:flutter/material.dart';

class BusquedaProductoXsucursalWidget extends StatelessWidget {
  const BusquedaProductoXsucursalWidget({
    Key key,
    @required this.responsive, 
    @required this.idSucursal,
  }) : super(key: key);

  final Responsive responsive;
  final String idSucursal;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showSearch(
            context: context, delegate: BusquedaProductosXSucursalPage(idSucursal: idSucursal));
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.wp(2),
        ),
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
                showSearch(
                    context: context,
                    delegate: BusquedaProductosXSucursalPage(idSucursal: idSucursal));
              },
            ),
            Text(
              'Buscar Producto o servicio',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
