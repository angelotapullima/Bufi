import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/subsidiaryService.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/widgets/widgetServicios.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListarServiciosXSucursalPage extends StatefulWidget {
  final String idSucursal;
  const ListarServiciosXSucursalPage({Key key, @required this.idSucursal})
      : super(key: key);
  @override
  _ListarServiciosXSucursalPageState createState() =>
      _ListarServiciosXSucursalPageState();
}

class _ListarServiciosXSucursalPageState
    extends State<ListarServiciosXSucursalPage> {
  @override
  Widget build(BuildContext context) {
    //final id = ModalRoute.of(context).settings.arguments;

    final responsive = Responsive.of(context);
    final listarServicios = ProviderBloc.servi(context);
    listarServicios.listarServiciosPorSucursal(widget.idSucursal);

    return StreamBuilder(
      stream: listarServicios.serviciostream,
      builder: (BuildContext context,
          AsyncSnapshot<List<SubsidiaryServiceModel>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            final servicios = snapshot.data;
            return GridView.builder(
                padding: EdgeInsets.only(top: 10),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio:  0.73,
                    mainAxisSpacing: 3),
                itemCount: servicios.length,
                itemBuilder: (context, index) {
                  return ServiciosWidget(
                            serviceData:snapshot.data[index]);
                });
          } else {
            return Center(child: Text("No tiene registrado ningún servicio", style: TextStyle(fontSize: responsive.ip(2)),));
          }
        }else {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }
      },
    );
  }
}
