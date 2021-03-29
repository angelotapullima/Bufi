import 'package:bufi/src/bloc/busqueda/busquedaBloc.dart';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/itemSubcategoryModel.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusquedaItemSubcategoriaPage extends SearchDelegate {
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

    final busquedaBloc = ProviderBloc.busqueda(context);
    busquedaBloc.obtenerBusquedaItemSubcategoria('$query');

    return streamItemSubcategoria(busquedaBloc);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //Sugerencias de busqueda
    final busquedaBloc = ProviderBloc.busqueda(context);
    busquedaBloc.obtenerBusquedaItemSubcategoria('$query');

    if (query.isEmpty) {
      return Container(
        child: Text("Ingrese una palabra para realizar la búsqueda"),
      );
    } else {
      return streamItemSubcategoria(busquedaBloc);
    }

    // return Container(child: Text("Sugerencias"));
  }

  StreamBuilder<List<ItemSubCategoriaModel>> streamItemSubcategoria(
      BusquedaBloc busquedaBloc) {
    return StreamBuilder(
      stream: busquedaBloc.busquedaItemSubcategoriaStream,
      builder: (BuildContext context,
          AsyncSnapshot<List<ItemSubCategoriaModel>> snapshot) {
        if (snapshot.hasData) {
          final resultBusqueda = snapshot.data;
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
                        /* leading: FadeInImage(
                          placeholder: AssetImage('assets/no-image.png'),
                          image: NetworkImage(
                            '$apiBaseURL/${resultBusqueda[i].}',
                          ),
                          width: 50,
                          fit: BoxFit.contain,
                        ), */
                        title: Text(
                            '${resultBusqueda[i].itemsubcategoryName}'),
                        subtitle: Text(
                            '${resultBusqueda[i].idItemsubcategory}'),
                        onTap: () {
                          close(context, null);

                          /* Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalleProductos(
                                producto: resultBusqueda[index].listProducto[i],
                              ),
                            ),
                          ); */
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
}
