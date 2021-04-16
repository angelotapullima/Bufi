import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/detalleProducto/detalleProducto.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/widgets/widgetBienes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GridviewProductoPorSucursal extends StatefulWidget {
  final String idSucursal;
  const GridviewProductoPorSucursal({Key key, @required this.idSucursal})
      : super(key: key);

  @override
  _GridviewProductoPorSucursalState createState() =>
      _GridviewProductoPorSucursalState();
}

class _GridviewProductoPorSucursalState
    extends State<GridviewProductoPorSucursal> {
  @override
  Widget build(BuildContext context) {
    final productoBloc = ProviderBloc.productos(context);
    productoBloc.listarProductosPorSucursal(widget.idSucursal);

    final responsive = Responsive.of(context);

    return StreamBuilder(
        stream: productoBloc.productoStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<ProductoModel>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return SafeArea(
                top: false,
                child: Column(
                  children: [
                    Container(
                      height: responsive.hp(5),
                      color: Colors.red,
                      child: Row(
                        children: [
                          Spacer(),
                          /* IconButton(
                                          icon: Icon(Icons.category), onPressed: () {}), */
                          IconButton(
                            icon: Icon(Icons.filter_list),
                            onPressed: () {
                              //iconPressed();
                            },
                          ),
                          SizedBox(
                            width: responsive.wp(5),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: .7),
                          itemCount: snapshot.data.length,
                          padding: EdgeInsets.all(0),
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
                                child:
                                    BienesWidget(producto: snapshot.data[index]));
                          }),
                    ),
                  
                  //Container(child: Center(child: CircularProgressIndicator(),),)
                  ],
                ),
              );
              /* return SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 100),
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
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
                  },
                  childCount: snapshot.data.length,
                ),
              );
            */
            } else {
              return Center(
                child: Text('sin productos'),
              );
            }
          } else {
            return Center(
              child: Text('sin controller'),
            );
          }
        });
  }
}
