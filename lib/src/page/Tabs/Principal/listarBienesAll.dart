import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/detalleProducto.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/widgets/busquedaWidget.dart';
import 'package:bufi/src/widgets/widgetBienes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListarBienesAll extends StatefulWidget {
  @override
  _ListarBienesAllState createState() => _ListarBienesAllState();
}

class _ListarBienesAllState extends State<ListarBienesAll> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    final bienesBloc = ProviderBloc.bienesServicios(context);
    //llamar a la funcion del bloc para bienes
    bienesBloc.obtenerBienesAllPorCiudad();

    return Scaffold(
        body: SafeArea(
      bottom: false,
      child: Container(
        //height: responsive.hp(70),
        //color: Colors.red,
        child: Column(
          children: [
            Container(
              height: responsive.hp(5),
              child: Stack(
                children: [
                  BackButton(),
                  Container(
                    padding: EdgeInsets.only(left: responsive.wp(10)),
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'Todos los productos ',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: responsive.ip(2.5),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: responsive.wp(2),
                ),
                Expanded(child: BusquedaWidget(responsive: responsive)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(icon: Icon(Icons.category), onPressed: () {}),
                    IconButton(
                        icon: Icon(Icons.filter),
                        onPressed: () {
                          /* if (data) {
                                            switchFiltro.value = false;
                                          } else {
                                            switchFiltro.value = true;
                                          } */
                        }),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: responsive.hp(.5),
            ),
            Expanded(
              child: Container(
                //color: Colors.blue,
                child: StreamBuilder(
                  stream: bienesBloc.bienesStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ProductoModel>> snapshot) {
                    if (snapshot.hasData) {
                      final bienes = snapshot.data;
                      return GridView.builder(
                          // padding: EdgeInsets.only(top:18),

                          controller: ScrollController(keepScrollOffset: false),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, childAspectRatio: 0.89),
                          itemCount: bienes.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(milliseconds: 100),
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return DetalleProductos(
                                          producto: snapshot.data[index]);
                                      //return DetalleProductitos(productosData: productosData);
                                    },
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: BienesWidget(
                                producto: snapshot.data[index],
                              ),
                            );
                          });
                    } else {
                      return Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
