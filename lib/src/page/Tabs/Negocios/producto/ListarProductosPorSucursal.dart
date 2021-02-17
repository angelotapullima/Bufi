import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/widgets/widgetBienes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListarProductosPorSucursalPage extends StatefulWidget {
  final String idSucursal;

  const ListarProductosPorSucursalPage({Key key, @required this.idSucursal})
      : super(key: key);
  @override
  _ListarProductosPorSucursalPageState createState() =>
      _ListarProductosPorSucursalPageState();
}

class _ListarProductosPorSucursalPageState
    extends State<ListarProductosPorSucursalPage> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    
    final productoBloc = ProviderBloc.productos(context);
    productoBloc.listarProductosPorSucursal(widget.idSucursal);

    return StreamBuilder(
      stream: productoBloc.productoStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            final bienes = snapshot.data;
            return GridView.builder(
                padding: EdgeInsets.only(top: 10),
                //controller: ScrollController(keepScrollOffset: false),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.89,
                  crossAxisCount: 2,
                ),
                itemCount: bienes.length,
                itemBuilder: (context, index) {
                  return BienesWidget(
                    producto: snapshot.data[index],
                  );
                });
          } else {
            return Center(child: Text("No tiene registrado ningún producto", style: TextStyle(fontSize: responsive.ip(2)),));
          }
        } else {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }
      },
    );
  }
}
