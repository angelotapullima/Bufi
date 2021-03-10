import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/detalleProducto.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/widgets/busquedaWidget.dart';
import 'package:bufi/src/widgets/widgetBienes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GridviewProductoPorSucursal extends StatelessWidget {
  final String idSucursal;
  const GridviewProductoPorSucursal({Key key, @required this.idSucursal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    final productoBloc = ProviderBloc.productos(context);
    productoBloc.listarProductosPorSucursal(idSucursal);
    return Column(
      children: [
        SizedBox(
          height: responsive.hp(2),
        ),
        // Row(
        //   children: [
        //     SizedBox(
        //       width: responsive.wp(2),
        //     ),
        //     Expanded(
        //       child: BusquedaWidget(responsive: responsive),
        //     ),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.end,
        //       children: [
        //         IconButton(icon: Icon(Icons.category), onPressed: () {}),
        //         IconButton(icon: Icon(Icons.filter), onPressed: () {}),
        //       ],
        //     ),
        //   ],
        // ),
        // SizedBox(
        //   height: responsive.hp(.5),
        // ),
        Expanded(
          child: StreamBuilder(
            stream: productoBloc.productoStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<ProductoModel>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  final bienes = snapshot.data;
                  return GridView.builder(
                      padding: EdgeInsets.only(top: 10),
                      //controller: ScrollController(keepScrollOffset: false),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.73,
                        crossAxisCount: 2,
                      ),
                      itemCount: bienes.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {

                             Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration:
                                    const Duration(milliseconds: 100),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return DetalleProductos(
                                      producto: snapshot.data[index]);
                                  //return DetalleProductitos(productosData: productosData);
                                },
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: BienesWidget(
                            producto: snapshot.data[index],
                          ),
                        );
                      });
                } else {
                  return Center(
                      child: Text(
                    "No tiene registrado ningún producto",
                    style: TextStyle(fontSize: responsive.ip(2)),
                  ));
                }
              } else {
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
