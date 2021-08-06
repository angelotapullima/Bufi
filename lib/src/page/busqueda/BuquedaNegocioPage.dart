import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/historialModel.dart';
import 'package:bufi/src/page/Tabs/Negocios/servicios/detalleServicio.dart';
import 'package:bufi/src/page/busqueda/buquedaGeneralHechoPorAngeloMasNaiki.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:flutter/material.dart';

class BusquedaNegocio extends StatefulWidget {
  const BusquedaNegocio({Key key}) : super(key: key);

  @override
  _BusquedaNegocioState createState() => _BusquedaNegocioState();
}

class _BusquedaNegocioState extends State<BusquedaNegocio> {
  TextEditingController _controllerBusquedaNegocio = TextEditingController();
  bool expandFlag = false;

  @override
  void dispose() {
    _controllerBusquedaNegocio.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final busquedaBloc = ProviderBloc.busqueda(context);
      busquedaBloc.obtenerBusquedaNegocio(context, '');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final busquedaBloc = ProviderBloc.busqueda(context);
    final searchBloc = ProviderBloc.searHistory(context);
    searchBloc.obtenerAllHistorial('company');

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
                          controller: _controllerBusquedaNegocio,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Buscar negocio',
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
                              busquedaBloc.obtenerBusquedaNegocio(context, '$value');
                              agregarHistorial(context, value, 'company');
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
                            if (_controllerBusquedaNegocio.text.length >= 0 && _controllerBusquedaNegocio.text != ' ') {
                              setState(() {
                                expandFlag = false;
                              });
                              busquedaBloc.obtenerBusquedaNegocio(context, '${_controllerBusquedaNegocio.text}');
                              agregarHistorial(context, _controllerBusquedaNegocio.text, 'company');
                            } else {
                              setState(() {
                                expandFlag = true;
                              });
                            }
                          }),
                      IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            _controllerBusquedaNegocio.text = '';
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
                  child: ListaNegocios(),
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
                                      _controllerBusquedaNegocio.text = snapshot.data[i].historial;
                                      if (_controllerBusquedaNegocio.text.length >= 0 && _controllerBusquedaNegocio.text != ' ') {
                                        setState(() {
                                          expandFlag = false;
                                        });
                                        busquedaBloc.obtenerBusquedaNegocio(context, '${_controllerBusquedaNegocio.text}');
                                        agregarHistorial(context, _controllerBusquedaNegocio.text, 'company');
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
                                                eliminarHistorial(context, snapshot.data[i].historial, 'company');
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
