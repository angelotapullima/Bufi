import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/ListarProductosPorSucursal.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/widgets/widgetBienes.dart';
import 'package:bufi/src/widgets/widgetServicios.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget detailsBienesServicios(
    BuildContext context, SubsidiaryModel subsidiary, Responsive responsive) {
  return Column(
    children: [
      //cabecera("PRODUCTOS",responsive, context, subsidiary),
      SizedBox(height: 20),

      cabecera(
          "PRODUCTOS", responsive, context, subsidiary, 'listarProductoAll'),
      _listProductos(context, responsive, subsidiary),

      cabecera("SERVICIOS", responsive, context, subsidiary,
          'listarServiciosXsucursal'),
      _listServicios(context, responsive, subsidiary),
    ],
  );
}

Widget cabecera(String titulo, Responsive responsive, BuildContext context,
    SubsidiaryModel subsidiary, String ruta) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        titulo,
        style: TextStyle(
            color: Colors.black,
            fontSize: responsive.ip(2.7),
            fontWeight: FontWeight.bold),
      ),
      InkWell(
        child: Text("Ver mas", style: TextStyle(fontSize: 20)),
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (context, animation, secondaryAnimation) {
                return ListarProductosPorSucursal(
                    idSucursal: subsidiary.idSubsidiary);
                //return DetalleProductitos(productosData: productosData);
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          );
        },
      ),
    ],
  );
}

//
Widget _listProductos(
    BuildContext context, Responsive responsive, SubsidiaryModel subsidiary) {
  final listarProductos = ProviderBloc.productos(context);
  listarProductos.listarProductosPorSucursal(subsidiary.idSubsidiary);

  return Container(
    padding: EdgeInsets.only(
      left: responsive.wp(2),
      right: responsive.wp(2),
      bottom: responsive.hp(2),
    ),
    height: responsive.hp(35),
    child: StreamBuilder(
      stream: listarProductos.productoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return bienesWidget(
                      context, snapshot.data[index], responsive);
                });
          } else {
            return Center(child: Text('No tiene productos registrados'));
          }
        } else {
          return Center(child: CupertinoActivityIndicator());
        }
      },
    ),
  );
}

//
Widget _listServicios(
    BuildContext context, Responsive responsive, SubsidiaryModel subsidiary) {
  final listarServicios = ProviderBloc.listarServicios(context);
  listarServicios.listarServiciosPorSucursal(subsidiary.idSubsidiary);

  return Container(
    padding: EdgeInsets.only(
      left: responsive.wp(2),
      right: responsive.wp(2),
      bottom: responsive.hp(2),
    ),
    height: responsive.hp(35),
    child: StreamBuilder(
      stream: listarServicios.serviciostream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return serviceWidget(
                      context, snapshot.data[index], responsive);
                });
          } else {
            return Center(child: Text('No tiene Servicios registrados'));
          }
        } else {
          return Center(child: CupertinoActivityIndicator());
        }
      },
    ),
  );
}
