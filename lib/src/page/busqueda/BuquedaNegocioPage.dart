import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/page/busqueda/buquedaGeneralHechoPorAngeloMasNaiki.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:flutter/material.dart';

class BusquedaNegocio extends StatefulWidget {
  const BusquedaNegocio({Key key}) : super(key: key);

  @override
  _BusquedaNegocioState createState() => _BusquedaNegocioState();
}

class _BusquedaNegocioState extends State<BusquedaNegocio> {
  TextEditingController _controllerBusquedaNegocio = TextEditingController();

  @override
  void dispose() {
    _controllerBusquedaNegocio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final busquedaBloc = ProviderBloc.busqueda(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
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
                          print('$value');

                          busquedaBloc.obtenerBusquedaNegocio(context,'$value');
                        }),
                  ),
                  IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        _controllerBusquedaNegocio.text = '';
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
      ),
    );
  }
}
