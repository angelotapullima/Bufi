import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/PedidosModel.dart';
import 'package:bufi/src/page/Tabs/Usuario/Pedidos/detallePedidoPage.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PedidosPage extends StatelessWidget {
  PedidosPage();

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final pedidoBloc = ProviderBloc.pedido(context);
    String idEstado = '99';
    pedidoBloc.obtenerPedidosPorIdEstado(idEstado);

    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          title: Text(
            "Pendientes de Envío",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white),
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
                      itemCount: listPedidos[index].detallePedido.length + 1,
                      itemBuilder: (BuildContext context, int i) {
                        if (i == 0) {
                          return _cabeceraPedido(responsive, listPedidos, index);
                        }

                        int x = i - 1;
                        return (listPedidos[index].detallePedido[x].listProducto.length > 0)
                            ? _datosProducto(context, responsive, listPedidos, index, x)
                            : Text("No existe ningún producto pedido");
                      },
                    );
                  },
                );
              } else {
                return Center(
                  child: Text("No hay ningun dato"),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Widget _datosProducto(BuildContext context, Responsive responsive, List<PedidosModel> listPedidos, int index, int x) {
    var fecha = obtenerFechaHora(listPedidos[index].deliveryDatetime);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return TickectPedido(
              idPedido: listPedidos[index].idPedido,
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(0.0, 1.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ));
      },
      child: Container(
        color: Colors.white,
        height: responsive.hp(15),
        margin: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
        padding: EdgeInsets.symmetric(vertical: 5),
        width: double.infinity,
        child: Row(
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
                        placeholder: (context, url) => Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: Image(image: AssetImage('assets/loading.gif'), fit: BoxFit.fitWidth),
                        ),
                        imageUrl: '$apiBaseURL/${listPedidos[index].detallePedido[x].listProducto[0].productoImage}',
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
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${listPedidos[index].detallePedido[x].listProducto[0].productoName} ' +
                        '${listPedidos[index].detallePedido[x].listProducto[0].productoBrand} x ' +
                        '${listPedidos[index].detallePedido[x].listProducto[0].productoModel}'),
                    Text(
                      '${listPedidos[index].detallePedido[x].cantidad}' 'UN',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'S/. ' +
                          (double.parse('${listPedidos[index].detallePedido[x].cantidad}') * double.parse('${listPedidos[index].detallePedido[x].listProducto[0].productoPrice}'))
                              .toString(),
                      style: TextStyle(fontSize: responsive.ip(1.8), color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    Text('$fecha'),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: responsive.wp(2),
            )
          ],
        ),
      ),
    );
  }

  Widget _cabeceraPedido(Responsive responsive, List<PedidosModel> listPedidos, int index) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: responsive.hp(1),
      ),
      width: double.infinity,
      color: Colors.blueGrey[100],
      child: Padding(
        padding: EdgeInsets.only(
          left: responsive.wp(2),
        ),
        child: Row(
            //crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Pedido N° ${listPedidos[index].idPedido}',
                style: TextStyle(color: Colors.black, fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
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
                width: responsive.wp(4),
              )
            ]),
      ),
    );
  }
}
