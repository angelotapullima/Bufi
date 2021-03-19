import 'package:bufi/src/bloc/busqueda/busquedaBloc.dart';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/subsidiaryService.dart';
import 'package:bufi/src/page/Tabs/Negocios/servicios/detalleServicio.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusquedaServiciosPage extends SearchDelegate {

   BusquedaServiciosPage({
    String hintText = 'Busqueda Servicios',
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
    busquedaBloc.obtenerBusquedaServicio('$query');

    return streamServicio(busquedaBloc);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //Sugerencias de busqueda
    final busquedaBloc = ProviderBloc.busqueda(context);
    busquedaBloc.obtenerBusquedaServicio('$query');

    if (query.isEmpty) {
      return Center(
        child: Text("Ingrese una palabra para realizar la búsqueda"),
      );
    } else {
      return streamServicio(busquedaBloc);
    }

    // return Container(child: Text("Sugerencias"));
  }

  StreamBuilder<List<SubsidiaryServiceModel>> streamServicio(
      BusquedaBloc busquedaBloc) {
    return StreamBuilder(
      stream: busquedaBloc.busquedaServicioStream,
      builder: (BuildContext context,
          AsyncSnapshot<List<SubsidiaryServiceModel>> snapshot) {
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
                        leading: FadeInImage(
                          placeholder: AssetImage('assets/no-image.png'),
                          image: NetworkImage(
                            '$apiBaseURL/${resultBusqueda[index].subsidiaryServiceImage}',
                          ),
                          width: 50,
                          fit: BoxFit.contain,
                        ),
                        title: Text(
                            '${resultBusqueda[index].subsidiaryServiceName}'),
                        subtitle: Text(
                            '${resultBusqueda[index].subsidiaryServiceCurrency} ${resultBusqueda[index].subsidiaryServicePrice}'),
                        onTap: () {
                          close(context, null);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalleServicio(
                                servicio: resultBusqueda[index],
                              ),
                            ),
                          );
                        },
                      );
                    });
              },
            );
          } else {
            return Center(child: Text("No hay resultados para la búsqueda"));
          }
        } else {
          return Center(child: CupertinoActivityIndicator());
        }
      },
    );
  }
}
