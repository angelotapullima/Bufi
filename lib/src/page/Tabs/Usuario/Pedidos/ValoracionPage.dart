import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/PedidosModel.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/customCacheManager.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PendientesValoracionPage extends StatelessWidget {
  PendientesValoracionPage();

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final pedidoBloc = ProviderBloc.pedido(context);
    String idEstado = '5';
     pedidoBloc.obtenerPedidosEnviados(idEstado);
    //pedidoBloc.obtenerPedidosPorIdEstado(idEstado);

    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Pendientes de Valoración",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white),
      body: StreamBuilder(
         // stream: pedidoBloc.pedidoStream,
           stream: pedidoBloc.pedidosEnviadoStream,
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
                      itemCount: listPedidos[index].detallePedido.length + 1,
                      itemBuilder: (BuildContext context, int i) {
                        if (i == 0) {
                          return _cabeceraPedido(
                              responsive, listPedidos, index);
                        }

                        int x = i - 1;
                        return (listPedidos[index]
                                    .detallePedido[x]
                                    .listProducto
                                    .length >
                                0)
                            ? _datosProducto(
                                context, responsive, listPedidos, index, x)
                            : Text("No existe ningún producto pedido");
                      },
                    );
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            } else {
              return Center(
                child: Text("No hay ningun dato"),
              );
            }
          }),
    );
  }

  Widget _datosProducto(BuildContext context, Responsive responsive,
      List<PedidosModel> listPedidos, int index, int x) {
    return GestureDetector(
      onTap: () {
        //Navigator.pushNamed(context, 'detallePedido', arguments: listPedidos[index] );
      },
      child: Container(
        color: Colors.grey[200],
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: Colors.white,
            height: responsive.hp(25),
            margin: EdgeInsets.symmetric(
                horizontal: responsive.wp(2), vertical: responsive.hp(1)),
            padding: EdgeInsets.symmetric(vertical: 10),
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: responsive.wp(1.5),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: responsive.wp(25),
                        child: Stack(
                          children: [
                            Container(
                              height: responsive.hp(10),
                              width: responsive.wp(25),
                              child: CachedNetworkImage(
                                cacheManager: CustomCacheManager(),
                                placeholder: (context, url) => Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Image(
                                      image: AssetImage('assets/loading.gif'),
                                      fit: BoxFit.fitWidth),
                                ),
                                imageUrl:
                                    '$apiBaseURL/${listPedidos[index].detallePedido[x].listProducto[0].productoImage}',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: responsive.wp(2),
                    ),
                    _descripcionProducto(listPedidos, index, x, responsive),
                    // SizedBox(
                    //   width: responsive.wp(2),
                    // )
                  ],
                ),
                SizedBox(
                  height: responsive.hp(4),
                ),
                _buttonCalificar(responsive, context, listPedidos, index),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonCalificar(Responsive responsive, BuildContext context,
      List<PedidosModel> listPedidos, int index) {
    return SizedBox(
      width: responsive.wp(60),
      child: ElevatedButton(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(3),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0))),
            backgroundColor: MaterialStateProperty.all(Colors.red)),
        child: Text("Calificar",
            style:
                TextStyle(color: Colors.white, fontSize: responsive.ip(2.2))),
        onPressed: () {
          Navigator.pushNamed(context, 'ratingProductos',
              arguments: listPedidos[index]);
        },
      ),
    );
  }

  Widget _descripcionProducto(
      List<PedidosModel> listPedidos, int index, int x, Responsive responsive) {
    return Expanded(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${listPedidos[index].detallePedido[x].listProducto[0].productoName} ' +
                '${listPedidos[index].detallePedido[x].listProducto[0].productoBrand} x ' +
                '${listPedidos[index].detallePedido[x].listProducto[0].productoModel}'),
            Text('size: ${listPedidos[index].detallePedido[x].listProducto[0].productoSize}'),
            Text('x ${listPedidos[index].detallePedido[x].cantidad} UN'),
            Text(
              'S/. ' +
                  (double.parse(
                              '${listPedidos[index].detallePedido[x].cantidad}') *
                          double.parse(
                              '${listPedidos[index].detallePedido[x].listProducto[0].productoPrice}'))
                      .toString(),
              style: TextStyle(
                  fontSize: responsive.ip(1.8),
                  color: Colors.red,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cabeceraPedido(
      Responsive responsive, List<PedidosModel> listPedidos, int index) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: responsive.hp(1),
      ),
      width: double.infinity,
      color: Colors.blueGrey[100],
      child: Padding(
        padding: EdgeInsets.only(left: responsive.wp(2)),
        child: Row(
            //crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Pedido N° ${listPedidos[index].idPedido}',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: responsive.ip(2),
                    fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Text(
                '${listPedidos[index].listCompanySubsidiary[0].subsidiaryName}',
                style: TextStyle(
                  color: Colors.blueGrey[700],
                  fontSize: responsive.ip(1.8),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: responsive.wp(3),
              )
            ]),
      ),
    );
  }
}
