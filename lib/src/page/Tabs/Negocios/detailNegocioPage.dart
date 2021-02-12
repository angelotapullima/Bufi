import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/CompanySubsidiaryModel.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TabMantenimientoPage extends StatefulWidget {
  TabMantenimientoPage({Key key}) : super(key: key);

  @override
  _TabMantenimientoPageState createState() =>
      _TabMantenimientoPageState();
}

class _TabMantenimientoPageState extends State<TabMantenimientoPage>
    with SingleTickerProviderStateMixin {
  TabController _controllerTab;
  @override
  void initState() {
    super.initState();
    _controllerTab = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    

    CompanySubsidiaryModel company = ModalRoute.of(context).settings.arguments;
    final detallenegocio = ProviderBloc.negocios(context);
    detallenegocio.obtenernegociosporID(company.idCompany);
    //final responsive = Responsive.of(context);
    return StreamBuilder(
        //stream: listarVehiculoBloc.vehiculoStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return Container(
                // height: responsive.hp(30),
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(
                     "eeee"
                    ),
                    //Text("Historial de Mantenimiento"),
                    bottom: TabBar(
                      //labelStyle:gridTitulo,
                      controller: _controllerTab,
                      tabs: [
                        Tab(
                          text: "Correctivo",
                          icon: Icon(FontAwesomeIcons.solidEdit, size: 20),
                        ),
                        Tab(
                          text: "Preventivo",
                          icon: Icon(FontAwesomeIcons.crosshairs, size: 20),
                        ),
                      ],
                    ),
                  ),
                  // drawer: MenuDrawer(),
                  body: TabBarView(
                    controller: _controllerTab,
                    children: [
                      // DetalleManteCorrectivoPage(),
                      // DetalleMantePreventivoPage(),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: Text(
                  'hay problemas',
                  style: TextStyle(
                      fontFamily: 'Syne', fontSize: 20, color: Colors.grey),
                ),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
