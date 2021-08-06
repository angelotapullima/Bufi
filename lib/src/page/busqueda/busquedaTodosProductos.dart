import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/historialModel.dart';
import 'package:bufi/src/page/Tabs/Negocios/servicios/detalleServicio.dart';
import 'package:bufi/src/page/busqueda/buquedaGeneralHechoPorAngeloMasNaiki.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:flutter/material.dart';

class BusquedaTodosProductos extends StatefulWidget {
  const BusquedaTodosProductos({Key key}) : super(key: key);

  @override
  _BusquedaTodosProductosState createState() => _BusquedaTodosProductosState();
}

class _BusquedaTodosProductosState extends State<BusquedaTodosProductos> {
  TextEditingController _controllerBusquedaProducto = TextEditingController();
  bool expandFlag = false;

  @override
  void dispose() {
    _controllerBusquedaProducto.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final busquedaBloc = ProviderBloc.busqueda(context);
      busquedaBloc.obtenerBusquedaProducto(context, '');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final busquedaBloc = ProviderBloc.busqueda(context);
    final searchBloc = ProviderBloc.searHistory(context);
    searchBloc.obtenerAllHistorial('pro');

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
                          controller: _controllerBusquedaProducto,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Buscar Productos',
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
                              busquedaBloc.obtenerBusquedaProducto(context, '$value');
                              agregarHistorial(context, value, 'pro');
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
                            if (_controllerBusquedaProducto.text.length >= 0 && _controllerBusquedaProducto.text != ' ') {
                              setState(() {
                                expandFlag = false;
                              });
                              busquedaBloc.obtenerBusquedaNegocio(context, '${_controllerBusquedaProducto.text}');
                              agregarHistorial(context, _controllerBusquedaProducto.text, 'pro');
                            } else {
                              setState(() {
                                expandFlag = true;
                              });
                            }
                          }),
                      IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            _controllerBusquedaProducto.text = '';
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
                  child: ListaProductos(),
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
                                      _controllerBusquedaProducto.text = snapshot.data[i].historial;
                                      if (_controllerBusquedaProducto.text.length >= 0 && _controllerBusquedaProducto.text != ' ') {
                                        setState(() {
                                          expandFlag = false;
                                        });
                                        busquedaBloc.obtenerBusquedaNegocio(context, '${_controllerBusquedaProducto.text}');
                                        agregarHistorial(context, _controllerBusquedaProducto.text, 'pro');
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
                                                eliminarHistorial(context, snapshot.data[i].historial, 'pro');
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
