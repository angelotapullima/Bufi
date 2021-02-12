import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/detalle_carrito.dart';
import 'package:bufi/src/widgets/widgetBienes.dart';
import 'package:flutter/material.dart';

class ListarProductosPorSucursal extends StatefulWidget {
  final String idSucursal;

  const ListarProductosPorSucursal({Key key, @required this.idSucursal})
      : super(key: key);
  @override
  _ListarProductosPorSucursalState createState() =>
      _ListarProductosPorSucursalState();
}

class _ListarProductosPorSucursalState
    extends State<ListarProductosPorSucursal> {
  @override
  Widget build(BuildContext context) {
    final productoBloc = ProviderBloc.productos(context);
    productoBloc.listarProductosPorSucursal(widget.idSucursal);

    return StreamBuilder(
      stream: productoBloc.productoStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          final bienes = snapshot.data;
          return GridView.builder(
              padding: EdgeInsets.only(top: 10),
              //controller: ScrollController(keepScrollOffset: false),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.7,
                crossAxisCount: 2,
              ),
              itemCount: bienes.length,
              itemBuilder: (context, index) {
                return BienesWidget(
                  producto: snapshot.data[index],
                );
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
