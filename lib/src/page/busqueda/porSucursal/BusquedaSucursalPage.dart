import 'package:bufi/src/bloc/busqueda/BusqXSucursalBloc.dart';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/busquedaModel.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/detalleProducto.dart';
import 'package:bufi/src/page/Tabs/Negocios/servicios/detalleServicio.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusquedaProductosXSucursalPage extends SearchDelegate {
  final String idSucursal;

  BusquedaProductosXSucursalPage({@required this.idSucursal});

  @override
  List<Widget> buildActions(BuildContext context) {
    //Icono o acciones a la derecha, recibe una lista de widgets
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            print("click");
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //Iconos que van a la izquierda
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //Resultados que se mostraran una vez realizada la busqueda

    final busquedaBloc = ProviderBloc.busquedaXSucursal(context);
    busquedaBloc.obtenerResultadoBusquedaXSucursal(idSucursal, '$query');

    return streamArticulos(busquedaBloc);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //Sugerencias de busqueda
    final busquedaBloc = ProviderBloc.busquedaXSucursal(context);
    busquedaBloc.obtenerResultadoBusquedaXSucursal(idSucursal, '$query');

    if (query.isEmpty) {
      return Container(
        child: Text("Ingrese una palabra para realizar la búsqueda"),
      );
    } else {
      return streamArticulos(busquedaBloc);
    }

    // return Container(child: Text("Sugerencias"));
  }

  StreamBuilder<List<BusquedaPorSucursalModel>> streamArticulos(
      BusquedaXSucursalBloc busquedaBloc) {
    return StreamBuilder(
      stream: busquedaBloc.busquedaXSucursalStream,
      builder: (BuildContext context,
          AsyncSnapshot<List<BusquedaPorSucursalModel>> snapshot) {
        final resultBusqueda = snapshot.data;
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: resultBusqueda.length,
              itemBuilder: (BuildContext context, int index) {
                return ((snapshot.data[index].listProducto.length) > 0)
                    ? listProducto(resultBusqueda, index)
                    : ((snapshot.data[index].listServicios.length) > 0)
                        ? listServicio(resultBusqueda, index)
                        : Text("No se encontró ningún resultado");
              },
            );
          } else {
            return Text("No hay resultados para la búsqueda");
          }
        } else {
          return Center(child: CupertinoActivityIndicator());
        }
      },
    );
  }

  Widget listProducto(
      List<BusquedaPorSucursalModel> resultBusqueda, int index) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: resultBusqueda[index].listProducto.length,
        itemBuilder: (BuildContext context, int i) {
          return ListTile(
            leading: FadeInImage(
              placeholder: AssetImage('assets/no-image.png'),
              image: NetworkImage(
                '$apiBaseURL/${resultBusqueda[index].listProducto[i].productoImage}',
              ),
              width: 50,
              fit: BoxFit.contain,
            ),
            title:
                Text('${resultBusqueda[index].listProducto[i].productoName}'),
            subtitle: Text(
                '${resultBusqueda[index].listProducto[i].productoCurrency}'),
            onTap: () {
              close(context, null);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetalleProductos(
                            producto: resultBusqueda[index].listProducto[i],
                          )));
            },
          );
        });
  }

  Widget listServicio(
      List<BusquedaPorSucursalModel> resultBusqueda, int index) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: resultBusqueda[index].listServicios.length,
        itemBuilder: (BuildContext context, int i) {
          return ListTile(
            leading: FadeInImage(
              placeholder: AssetImage('assets/no-image.png'),
              image: NetworkImage(
                '$apiBaseURL/${resultBusqueda[index].listServicios[i].subsidiaryServiceImage}',
              ),
              width: 50,
              fit: BoxFit.contain,
            ),
            title: Text(
                '${resultBusqueda[index].listServicios[i].subsidiaryServiceName}'),
            subtitle: Text(
                '${resultBusqueda[index].listServicios[i].subsidiaryServiceCurrency}'),
            onTap: () {
              close(context, null);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetalleServicio(
                            servicio: resultBusqueda[index].listServicios[i],
                          )));
            },
          );
        });
  }

//  StreamBuilder<List<ProductoModel>> streamArticulos2(
//       BusquedaBloc busquedaBloc) {
//     return StreamBuilder(
//       stream: busquedaBloc.busquedaProductoStream2,
//       builder: (BuildContext context,
//           AsyncSnapshot<List<ProductoModel>> snapshot) {
//         final listProducto = snapshot.data;
//         if (snapshot.hasData) {
//           if (snapshot.data.length > 0) {

//                 return ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: listProducto.length,
//                     itemBuilder: (BuildContext context, int i) {
//                       return ListTile(
//                         leading: FadeInImage(
//                           placeholder: AssetImage('assets/no-image.png'),
//                           image: NetworkImage(
//                             '$apiBaseURL/${listProducto[i].productoImage}',
//                           ),
//                           width: 50,
//                           fit: BoxFit.contain,
//                         ),
//                         title: Text(
//                             '${listProducto[i].productoName}'),
//                         subtitle: Text(
//                             '${listProducto[i].productoCurrency}'),
//                         onTap: () {
//                           close(context, null);

//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => DetalleProductos(
//                                         producto: listProducto[i],
//                                       )));
//                         },
//                       );
//                     });

//           } else {
//             return Text("No hay resultados para la búsqueda");
//           }
//         } else {
//           return Center(child: CupertinoActivityIndicator());
//         }
//       },
//     );
//   }

}
