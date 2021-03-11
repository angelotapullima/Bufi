import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/detalleProducto.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/widgets/widgetBienes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GridviewProductoPorSucursal extends StatefulWidget {
  final String idSucursal;
  const GridviewProductoPorSucursal({Key key, @required this.idSucursal})
      : super(key: key);

  @override
  _GridviewProductoPorSucursalState createState() => _GridviewProductoPorSucursalState();
}

class _GridviewProductoPorSucursalState extends State<GridviewProductoPorSucursal> {

   ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {


       WidgetsBinding.instance.addPostFrameCallback((_) => {
          _scrollController.addListener(() {
            if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent) {
              print('pixels ${_scrollController.position.pixels}');
              print('maxScrool ${_scrollController.position.maxScrollExtent}');
              print('dentro');

              final productoBloc = ProviderBloc.productos(context);
              productoBloc.listarProductosPorSucursal(widget.idSucursal);
            }
          })
        });


        
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    final productoBloc = ProviderBloc.productos(context);
    productoBloc.listarProductosPorSucursal(widget.idSucursal);

    print(widget.idSucursal);
    return StreamBuilder(
      stream: productoBloc.productoStream,
      builder: (BuildContext context,
          AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            final bienes = snapshot.data;
            return GridView.builder(
              controller: _scrollController,
              physics: ClampingScrollPhysics(),
                padding: EdgeInsets.only(top: 10),
                //controller: ScrollController(keepScrollOffset: false),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.73,
                  crossAxisCount: 2,
                ),
                itemCount: bienes.length,
                itemBuilder: (context, index) {
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
                });
          } else {
            return Center(
                child: Text(
              "No tiene registrado ningún producto",
              style: TextStyle(fontSize: responsive.ip(2)),
            ));
          }
        } else {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }
      },
    );
  }
}
