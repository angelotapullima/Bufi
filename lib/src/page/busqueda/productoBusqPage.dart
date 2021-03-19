import 'package:bufi/src/bloc/busqueda/busquedaBloc.dart';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/detalleProducto.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusquedaProductosPage extends SearchDelegate {
  BusquedaProductosPage({
    String hintText = 'Busqueda Productos',
  }) : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  @override
  List<Widget> buildActions(BuildContext context) {
    //Icono o acciones a la derecha, recibe una lista de widgets
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            print("click b");
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la Izquierda del AppBar
    return BackButton();
    /* IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    ); */
  }

  @override
  Widget buildResults(BuildContext context) {
    //Resultados que se mostraran una vez realizada la busqueda

    final busquedaBloc = ProviderBloc.busqueda(context);
    busquedaBloc.obtenerBusquedaProducto('$query');

    return streamProducto(busquedaBloc);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container(
        child: Center(
          child: Text('Búsqueda de productos'),
        ),
      );
    }

    //Sugerencias de busqueda
    final busquedaBloc = ProviderBloc.busqueda(context);
    busquedaBloc.obtenerBusquedaProducto('$query');

    if (query.isEmpty) {
      return Container(
        child: Text("Ingrese una palabra para realizar la búsqueda"),
      );
    } else {
      return streamProducto(busquedaBloc);
    }

    // return Container(child: Text("Sugerencias"));
  }

  StreamBuilder<List<ProductoModel>> streamProducto(BusquedaBloc busquedaBloc) {
    return StreamBuilder(
      stream: busquedaBloc.busquedaProductoStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        final resultBusqueda = snapshot.data;
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: resultBusqueda.length,
              itemBuilder: (BuildContext context, int index) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: resultBusqueda.length,
                    itemBuilder: (BuildContext context, int i) {
                      return ListTile(
                        leading: FadeInImage(
                          placeholder: AssetImage('assets/no-image.png'),
                          image: NetworkImage(
                            '$apiBaseURL/${resultBusqueda[index].productoImage}',
                          ),
                          width: 50,
                          fit: BoxFit.contain,
                        ),
                        title: Text('${resultBusqueda[index].productoName}'),
                        subtitle: Text(
                            '${resultBusqueda[index].productoCurrency} ${resultBusqueda[index].productoPrice}'),
                        onTap: () {
                          close(context, null);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalleProductos(
                                producto: resultBusqueda[index],
                              ),
                            ),
                          );
                        },
                      );
                    });
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

//  StreamBuilder<List<ProductoModel>> streamProducto2(
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
