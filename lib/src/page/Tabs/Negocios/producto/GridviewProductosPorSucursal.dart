import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/detalleProducto.dart';
import 'package:bufi/src/widgets/widgetBienes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GridviewProductoPorSucursal extends StatefulWidget {
  final List<ProductoModel> productos;
  const GridviewProductoPorSucursal({Key key, @required this.productos})
      : super(key: key);

  @override
  _GridviewProductoPorSucursalState createState() =>
      _GridviewProductoPorSucursalState();
}

class _GridviewProductoPorSucursalState
    extends State<GridviewProductoPorSucursal> {
  
  
  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.86,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 100),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return DetalleProductos(producto: widget.productos[index]);
                    //return DetalleProductitos(productosData: productosData);
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                ),
              );
            },
            child: BienesWidget(
              producto: widget.productos[index],
            ),
          );
        },
        childCount: widget.productos.length,
      ),
    );
  }
}
