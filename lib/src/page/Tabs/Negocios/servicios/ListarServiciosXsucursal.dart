import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/subsidiaryService.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/widgets/widgetServicios.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListarServiciosXSucursal extends StatefulWidget {
  @override
  _ListarServiciosXSucursalState createState() => _ListarServiciosXSucursalState();
}

class _ListarServiciosXSucursalState extends State<ListarServiciosXSucursal> {
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;

    final responsive = Responsive.of(context);
    final listarServicios = ProviderBloc.listarServicios(context);
    listarServicios.listarServiciosPorSucursal(id);

    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "SERVICIOS",
                  //style: Theme.of(context).textTheme.title,
                ),
              ),
              StreamBuilder(
                stream: listarServicios.serviciostream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<SubsidiaryServiceModel>> snapshot) {
                  if (snapshot.hasData) {
                    final servicios = snapshot.data;
                    return GridView.builder(
                        padding: EdgeInsets.only(top: 18),
                        controller: ScrollController(keepScrollOffset: false),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: servicios.length,
                        itemBuilder: (context, index) {
                          return serviceWidget(
                              context, snapshot.data[index], responsive);
                        });
                  } else {
                    return Center(child: CupertinoActivityIndicator()
                        // CupertinoActivityIndicator(),
                        );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    )
        //   Container(
        //  child: Center(child: Text("Bienessssss"))
        );
  }
}
