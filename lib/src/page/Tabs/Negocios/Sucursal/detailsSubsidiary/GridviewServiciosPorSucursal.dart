import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/subsidiaryService.dart';
import 'package:bufi/src/widgets/widgetServicios.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GridviewServiciosPorSucursal extends StatefulWidget {
  final String idSucursal;
  const GridviewServiciosPorSucursal({Key key, @required this.idSucursal}) : super(key: key);

  @override
  _GridviewProductoPorSucursalState createState() => _GridviewProductoPorSucursalState();
}

class _GridviewProductoPorSucursalState extends State<GridviewServiciosPorSucursal> {
  @override
  Widget build(BuildContext context) {
    final serviciosBloc = ProviderBloc.servi(context);
    serviciosBloc.listarServiciosPorSucursal(widget.idSucursal);

    return StreamBuilder(
      stream: serviciosBloc.serviciostream,
      builder: (BuildContext context, AsyncSnapshot<List<SubsidiaryServiceModel>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: .7),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      /* Navigator.push(
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
                        ); */
                    },
                    child: ServiciosWidget(serviceData: snapshot.data[index]),
                  );
                });
          } else {
            return Center(
              child: Text("No cuenta con ningún servicio por el momento"),
            );
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
