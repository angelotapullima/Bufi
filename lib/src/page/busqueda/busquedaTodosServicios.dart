import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/historialModel.dart';
import 'package:bufi/src/page/Tabs/Negocios/servicios/detalleServicio.dart';
import 'package:bufi/src/page/busqueda/buquedaGeneralHechoPorAngeloMasNaiki.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:flutter/material.dart';

class BusquedaTodosServicios extends StatefulWidget {
  const BusquedaTodosServicios({Key key}) : super(key: key);

  @override
  _BusquedaTodosServiciosState createState() => _BusquedaTodosServiciosState();
}

class _BusquedaTodosServiciosState extends State<BusquedaTodosServicios> {
  TextEditingController _controllerBuscarServicios = TextEditingController();
  bool expandFlag = false;

  @override
  void dispose() {
    _controllerBuscarServicios.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final busquedaBloc = ProviderBloc.busqueda(context);
      busquedaBloc.obtenerBusquedaServicio(context, '');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final busquedaBloc = ProviderBloc.busqueda(context);
    final searchBloc = ProviderBloc.searHistory(context);
    searchBloc.obtenerAllHistorial('ser');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BackButton(),
                      Expanded(
                        child: TextField(
                          controller: _controllerBuscarServicios,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Buscar Servicios',
                            hintStyle: TextStyle(
                              fontSize: responsive.ip(1.6),
                            ),
                            filled: true,
                            contentPadding: EdgeInsets.all(16),
                          ),
                          onSubmitted: (value) {
                            setState(() {
                              expandFlag = false;
                            });
                            if (value.length >= 0 && value != ' ') {
                              busquedaBloc.obtenerBusquedaServicio(context, '$value');
                              agregarHistorial(context, value, 'ser');
                            }
                          },
                          onTap: () {
                            setState(() {
                              expandFlag = true;
                            });
                          },
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            if (_controllerBuscarServicios.text.length >= 0 && _controllerBuscarServicios.text != ' ') {
                              setState(() {
                                expandFlag = false;
                              });
                              busquedaBloc.obtenerBusquedaServicio(context, '${_controllerBuscarServicios.text}');
                              agregarHistorial(context, _controllerBuscarServicios.text, 'ser');
                            } else {
                              setState(() {
                                expandFlag = true;
                              });
                            }
                          }),
                      IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            _controllerBuscarServicios.text = '';
                            setState(() {
                              expandFlag = true;
                            });
                          }),
                      SizedBox(
                        width: responsive.wp(3),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListaServicios(),
                )
              ],
            ),
            Positioned(
              top: responsive.hp(5),
              child: ExpandableContainer(
                expanded: expandFlag,
                expandedHeight: 10,
                child: StreamBuilder(
                    stream: searchBloc.historyStream,
                    builder: (context, AsyncSnapshot<List<HistorialModel>> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.length > 0) {
                          return Container(
                            height: double.infinity,
                            color: Colors.white,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int i) {
                                  return GestureDetector(
                                    onTap: () {
                                      _controllerBuscarServicios.text = snapshot.data[i].historial;
                                      if (_controllerBuscarServicios.text.length >= 0 && _controllerBuscarServicios.text != ' ') {
                                        setState(() {
                                          expandFlag = false;
                                        });
                                        busquedaBloc.obtenerBusquedaServicio(context, '${_controllerBuscarServicios.text}');
                                        agregarHistorial(context, _controllerBuscarServicios.text, 'ser');
                                      } else {
                                        setState(() {
                                          expandFlag = true;
                                        });
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(responsive.ip(1)),
                                      child: Row(
                                        children: [
                                          Text('${snapshot.data[i].historial}', style: TextStyle(fontSize: responsive.ip(2))),
                                          Spacer(),
                                          IconButton(
                                              icon: Icon(Icons.close),
                                              onPressed: () {
                                                eliminarHistorial(context, snapshot.data[i].historial, 'ser');
                                              }),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        return Container();
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
