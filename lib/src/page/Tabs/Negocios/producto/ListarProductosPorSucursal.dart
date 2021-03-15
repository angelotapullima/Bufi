import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/widgets/busquedas/widget/widgetBusqProduct.dart';
import 'package:bufi/src/widgets/widgetBienes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListarProductosPorSucursalPage extends StatefulWidget {
  final String idSucursal;

  const ListarProductosPorSucursalPage({Key key, @required this.idSucursal})
      : super(key: key);
  @override
  _ListarProductosPorSucursalPageState createState() =>
      _ListarProductosPorSucursalPageState();
}

class _ListarProductosPorSucursalPageState
    extends State<ListarProductosPorSucursalPage> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
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

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.idSucursal);
    final responsive = Responsive.of(context);

    final productoBloc = ProviderBloc.productos(context);
    productoBloc.listarProductosPorSucursal(widget.idSucursal);

    final sucursalBloc = ProviderBloc.sucursal(context);
    sucursalBloc.obtenerSucursalporId(widget.idSucursal);

    return Scaffold(
      body: StreamBuilder(
          stream: sucursalBloc.subsidiaryIdStream,
          builder:
              (context, AsyncSnapshot<List<SubsidiaryModel>> sucursalList) {
            if (sucursalList.hasData) {
              if (sucursalList.data.length > 0) {
                return SafeArea(
                  child: Column(
                    children: [
                      Container(
                        height: responsive.hp(5),
                        child: Stack(
                          children: [
                            BackButton(),
                            Container(
                              padding: EdgeInsets.only(
                                left: responsive.wp(10),
                              ),
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  '${sucursalList.data[0].subsidiaryName}',
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
                          Expanded(
                            child: BusquedaProductoWidget(responsive: responsive),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  icon: Icon(Icons.category), onPressed: () {}),
                              IconButton(
                                  icon: Icon(Icons.filter), onPressed: () {}),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: responsive.hp(.5),
                      ),
                      Expanded(
                        child: StreamBuilder(
                          stream: productoBloc.productoStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<ProductoModel>> snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data.length > 0) {
                                final bienes = snapshot.data;
                                return GridView.builder(
                                    controller: _scrollController,
                                    padding: EdgeInsets.only(top: 10),
                                    //controller: ScrollController(keepScrollOffset: false),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 0.73,
                                      crossAxisCount: 2,
                                    ),
                                    itemCount: bienes.length,
                                    itemBuilder: (context, index) {
                                      return BienesWidget(
                                        producto: snapshot.data[index],
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
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              }
            } else {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
          }),
    );
  }
}
