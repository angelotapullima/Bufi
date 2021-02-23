import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/PedidosModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PendientesEnvioPage extends StatelessWidget {
  const PendientesEnvioPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pedidoBloc = ProviderBloc.pedido(context);
    pedidoBloc.obtenerPedidosAll();

    return Scaffold(
      body: StreamBuilder(
          stream: pedidoBloc.pedidoStream,
          builder: (context, AsyncSnapshot<List<PedidosModel>> snapshot) {
           List<PedidosModel> listPedidos = snapshot.data;
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                return ListView.builder(
                  itemCount: listPedidos.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Text(listPedidos[index].deliveryName.toString());
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            } else {
              return Center(child: Text("No hay ningun dato"));
            }
          }),
    );
  }
}
