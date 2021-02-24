import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/PedidosModel.dart';
import 'package:flutter/material.dart';

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
                  shrinkWrap: true,
                  itemCount: listPedidos.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: listPedidos[index].detallePedido.length+1,
                      itemBuilder: (BuildContext context, int i) {
                        if (i == 0) {
                          return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              width: double.infinity,
                              color: Colors.blueGrey[100],
                              child: Row(
                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      '${listPedidos[index].idPedido}',
                                      style: TextStyle(
                                          color: Colors.blueGrey[700],
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    //Divider(),
                                  ]));
                        }

                        int x = i - 1;
                        return Column(
                          children: [
                            Text(
                                listPedidos[index].detallePedido[x].cantidad),
                                 Text(
                                listPedidos[index].detallePedido[x].idProducto),
                            // Text(
                            //     listPedidos[index].listCompanySubsidiary[x].companyName)
                          ],
                        );
                      },
                    );
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
