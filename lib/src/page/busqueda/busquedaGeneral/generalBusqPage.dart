import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/busquedaModel.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/detalleProducto.dart';
import 'package:bufi/src/page/busqueda/busquedaGeneral/tabGeneral.dart';
import 'package:bufi/src/page/busqueda/busquedaGeneral/tabNegocio.dart';
import 'package:bufi/src/page/busqueda/busquedaGeneral/tabProducto.dart';
import 'package:bufi/src/page/busqueda/busquedaGeneral/tabServicios.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusquedaGeneral extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    //Icono o acciones a la derecha, recibe una lista de widgets
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            print("click");
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //Iconos que van a la izquierda
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //Resultados que se mostraran una vez realizada la busqueda

    final busquedaGeneralBloc = ProviderBloc.busquedaGeneral(context);
    busquedaGeneralBloc.obtenerResultadosBusquedaPorQuery('$query');
    //Container(child: Text("Resultados"));
    return StreamBuilder(
      stream: busquedaGeneralBloc.busquedaGeneralStream,
      builder: (BuildContext context,
          AsyncSnapshot<List<BusquedaGeneralModel>> snapshot) {
        if (snapshot.hasData) {
          final resultBusqueda = snapshot.data;

          if (snapshot.data.length > 0) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: resultBusqueda.length,
              itemBuilder: (BuildContext context, int index) {
                return
                    //bienesWidget(context, snapshot.data[index], responsive);
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: resultBusqueda[index].listProducto.length,
                        itemBuilder: (BuildContext context, int i) {
                          return ListTile(
                            leading: FadeInImage(
                              placeholder: AssetImage('assets/no-image.png'),
                              image: NetworkImage(
                                '$apiBaseURL/${resultBusqueda[index].listProducto[i].productoImage}',
                              ),
                              width: 50,
                              fit: BoxFit.contain,
                            ),
                            title: Text(
                                '${resultBusqueda[index].listProducto[i].productoName}'),
                            subtitle: Text(
                                '${resultBusqueda[index].listProducto[i].productoCurrency}'),
                            onTap: () {
                              close(context, null);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetalleProductos(
                                            producto: resultBusqueda[index]
                                                .listProducto[i],
                                          )));
                            },
                          );
                        });
              },
            );
          } else {
            return Text("No hay resultados para la búsqueda");
          }
        } else {
          return Center(child: CupertinoActivityIndicator());
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //Sugerencias de busqueda

    final busquedaGeneralBloc = ProviderBloc.busquedaGeneral(context);
    busquedaGeneralBloc.obtenerResultadosBusquedaPorQuery('$query');
    if (query.isEmpty) {
      return Container(
        child: Text("Ingrese una palabra para realizar la búsqueda"),
      );
    } 
    // else {
    //   return StreamBuilder(
    //     stream: busquedaGeneralBloc.busquedaGeneralStream,
    //     builder: (BuildContext context,
    //         AsyncSnapshot<List<BusquedaGeneralModel>> snapshot) {
    //       if (snapshot.hasData) {
    //         final resultBusqueda = snapshot.data;
    //         if (snapshot.data.length > 0) {
    //           return ListView.builder(
    //             shrinkWrap: true,
    //             itemCount: resultBusqueda.length,
    //             itemBuilder: (BuildContext context, int index) {
    //               return Scaffold(
    //                   appBar: AppBar(
    //                 title: Text(
    //                   "jjjjj",
                      
    //                 ),
    //                 //Text("Historial de Mantenimiento"),
    //                 bottom: TabBar(
    //                   //labelStyle:gridTitulo,
    //                   controller: _controllerTab,
    //                   tabs: [
    //                     Tab(
    //                       text: "Correctivo",
    //                       icon: Icon(FontAwesomeIcons.solidEdit, size: 20),
    //                     ),
    //                     Tab(
    //                       text: "Preventivo",
    //                       icon: Icon(FontAwesomeIcons.crosshairs, size: 20),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               // drawer: MenuDrawer(),
    //               body: TabBarView(
    //                 controller: _controllerTab,
    //                 children: [
    //                   DetalleManteCorrectivoPage(),
    //                   DetalleMantePreventivoPage(),
    //                 ],
    //               ),


    //                     //               child: ListView.builder(
    //                     // shrinkWrap: true,
    //                     // itemCount: resultBusqueda[index].listProducto.length,
    //                     // itemBuilder: (BuildContext context, int i) {
    //                     //   return
    //                     //       //DetalleBusquedaGeneral();
    //                     //       _buildDatosArticulo(
    //                     //           resultBusqueda, index, i, context);
    //                     // }),
    //               );
    //             },
    //           );
    //         } else {
    //           return Text("No hay resultados para la búsqueda");
    //         }
    //       } else {
    //         return Center(child: CupertinoActivityIndicator());
    //       }
    //     },
    //   );
    // }

    // return Container(child: Text("Sugerencias"));
  }

  Widget _buildDatosArticulo(List<BusquedaGeneralModel> resultBusqueda,
      int index, int i, BuildContext context) {
    return ListTile(
      leading: FadeInImage(
        placeholder: AssetImage('assets/no-image.png'),
        image: NetworkImage(
          '$apiBaseURL/${resultBusqueda[index].listProducto[i].productoImage}',
        ),
        width: 50,
        fit: BoxFit.contain,
      ),
      title: Text('${resultBusqueda[index].listProducto[i].productoName}'),
      subtitle: Text('${resultBusqueda[index].listProducto[i].productoCurrency}'
          '${resultBusqueda[index].listProducto[i].productoPrice}'),
      onTap: () {
        close(context, null);

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetalleProductos(
                    producto: resultBusqueda[index].listProducto[i],
                  )),
        );
      },
    );
  }
}

class DetalleBusquedaGeneral extends StatefulWidget {
  const DetalleBusquedaGeneral({Key key}) : super(key: key);

  @override
  _DetalleBusquedaGeneralState createState() => _DetalleBusquedaGeneralState();
}

class _DetalleBusquedaGeneralState extends State<DetalleBusquedaGeneral>
    with SingleTickerProviderStateMixin {
  //Controlador del Tab
  TabController _controllerTab;

  @override
  void initState() {
    super.initState();
    _controllerTab = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    // final SubsidiaryModel subsidiary =
    //     ModalRoute.of(context).settings.arguments;
    //final subsidiary = ModalRoute.of(context).settings.arguments;

    // final subsidiaryBloc = ProviderBloc.listarsucursalPorId(context);
    // subsidiaryBloc.obtenerSucursalporId(subsidiary.idSubsidiary);
    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: StreamBuilder(
            //stream: subsidiaryBloc.subsidiaryIdStream,
            builder: (context, snapshot) {
          return _crearAppbar(responsive);
        }),
      ),
      //floatingActionButton: _buttonFloating(context, subsidiary, responsive),
    );
  }

  Widget _crearAppbar(Responsive responsive) {
    return NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              elevation: 5.0,
              backgroundColor: Colors.black,
              expandedHeight: responsive.hp(30),
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Container(
                  height: responsive.hp(8),
                  child: Text(
                    'hhhh',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.ip(2.3),
                    ),
                  ),
                ),
                background: Stack(
                  children: [
                    Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: Colors.white),
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            //si pecacheManager: CustomCacheManager(),
                            placeholder: (context, url) => Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: Image(
                                  image: AssetImage('assets/jar-loading.gif'),
                                  fit: BoxFit.cover),
                            ),
                            errorWidget: (context, url, error) => Container(
                                width: double.infinity,
                                height: double.infinity,
                                child: Center(child: Icon(Icons.error))),
                            //imageUrl: '$apiBaseURL/${companyModel.companyImage}',
                            imageUrl:
                                'https://i.pinimg.com/564x/23/8f/6b/238f6b5ea5ab93832c281b42d3a1a853.jpg',
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: double.infinity,
                            width: double.infinity,
                            color: Colors.black.withOpacity(.1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottom: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.red,
                labelStyle: TextStyle(
                    fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
                controller: _controllerTab,
                tabs: [
                  Tab(
                    text: "Principal",
                  ),
                  Tab(
                    text: "Productos",
                  ),
                  Tab(
                    text: "Servicios",
                  ),
                  Tab(
                    text: "Negocios",
                  ),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _controllerTab,
          children: [
            TabGeneralPage(),
            TabProductoPage(),
            TabServiciosPage(),
            TabNegocioPage(),
          ],
        ));
  }
}
