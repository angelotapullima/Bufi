import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/bienesServiciosModel.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/detalle_carrito.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/widgets/widgetBienes.dart';
import 'package:bufi/src/widgets/widgetServicios.dart';
import 'package:flutter/material.dart';




//esta vista es la que se muestra con los paneles negro y blanco luego de agregar los productos al carrito
class ListarProductosPorSucursalCarrito extends StatefulWidget {
  final String idSucursal;

  const ListarProductosPorSucursalCarrito({Key key, @required this.idSucursal})
      : super(key: key);

  @override
  _ListarProductosPorSucursalCarritoState createState() =>
      _ListarProductosPorSucursalCarritoState();
}

class _ListarProductosPorSucursalCarritoState
    extends State<ListarProductosPorSucursalCarrito> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final productoBloc = ProviderBloc.productos(context);
    productoBloc.listarProductosPorSucursalCarrito(widget.idSucursal);
   
   

    return StreamBuilder(
      stream: productoBloc.productoSubsidiaryCarritoStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<BienesServiciosModel>> snapshot) {
        if (snapshot.hasData) {
          final bienes = snapshot.data;
          return GridView.builder(
              padding: EdgeInsets.only(top: cartPanel),
              controller: ScrollController(keepScrollOffset: false),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.7,
                crossAxisCount: 2,
              ),
              itemCount: bienes.length,
              itemBuilder: (context, index) {
               return ('${bienes[index].tipo}' == 'bienes')
                ? grillaBienes(responsive, bienes[index])
                : grillaServicios(responsive, bienes[index]);
              });
        } else {
          return Center(child: Text("dataaaaa")
              // CupertinoActivityIndicator(),
              );
        }
      },
    );
  }
}
