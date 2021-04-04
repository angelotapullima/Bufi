import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/CompanySubsidiaryModel.dart';
import 'package:bufi/src/models/bienesServiciosModel.dart';
import 'package:bufi/src/models/categoriaModel.dart';
import 'package:bufi/src/models/itemSubcategoryModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/models/subsidiaryService.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/detalleProducto.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusquedaDeLaPtmr extends StatefulWidget {
  const BusquedaDeLaPtmr({Key key}) : super(key: key);

  @override
  _BusquedaDeLaPtmrState createState() => _BusquedaDeLaPtmrState(); 
}

class _BusquedaDeLaPtmrState extends State<BusquedaDeLaPtmr> {
  TextEditingController _controllerBusquedaAngelo = TextEditingController();

  final listOpciones = [
    ItemsBusqueda(titulo: 'Productos', index: 1),
    ItemsBusqueda(titulo: 'Servicios', index: 2),
    ItemsBusqueda(titulo: 'Negocios', index: 3),
    ItemsBusqueda(titulo: 'Sucursales', index: 4),
    ItemsBusqueda(titulo: 'Marcas', index: 5),
    ItemsBusqueda(titulo: 'Categorías', index: 6),
    ItemsBusqueda(titulo: 'Itemsubcategorías', index: 7),
  ];

  @override
  void dispose() {
    _controllerBusquedaAngelo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final selectorTabBusqueda = ProviderBloc.busquedaAngelo(context);
    final busquedaBloc = ProviderBloc.busqueda(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
          stream: selectorTabBusqueda.selectPageStream,
          builder: (context, _) {
            return SafeArea(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BackButton(),
                        Expanded(
                          child: TextField(
                              controller: _controllerBusquedaAngelo,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'Buscame papi',
                                hintStyle: TextStyle(
                                  fontSize: responsive.ip(1.6),
                                ),
                                /* border: OutlineInputBorder(
                              //borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                                
                              ),
                            ), */
                                filled: true,
                                contentPadding: EdgeInsets.all(16),
                              ),
                              onSubmitted: (value) {
                                print('$value');

                                busquedaBloc.obtenerBusquedaProducto('$value');
                                busquedaBloc.obtenerBusquedaServicio('$value');
                                busquedaBloc.obtenerBusquedaNegocio('$value');
                                busquedaBloc.obtenerBusquedaItemSubcategoria('$value');
                                busquedaBloc.obtenerBusquedaCategoria('$value');
                              }),
                        ),
                        IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              _controllerBusquedaAngelo.text = '';
                            }),
                        SizedBox(
                          width: responsive.wp(3),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            height: responsive.hp(5),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: listOpciones.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    selectorTabBusqueda.changePage(index);
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: responsive.hp(.8),
                                      ),
                                      Stack(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: responsive.wp(2.2),
                                            ),
                                            child: Container(
                                              height: responsive.hp(2.5),
                                              child: Center(
                                                child: Text(
                                                  ('${listOpciones[index].titulo} '),
                                                  style: TextStyle(
                                                      color: Colors.blue[900],
                                                      fontSize:
                                                          responsive.ip(1.4),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: responsive.hp(.5),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: responsive.ip(.4),
                                            backgroundColor:
                                                (selectorTabBusqueda.page ==
                                                        index)
                                                    ? Colors.blue[900]
                                                    : Colors.white,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            )),
                        Divider(),
                        Expanded(
                          child: (selectorTabBusqueda.page == 0)
                              ? ListaProductos()
                              : (selectorTabBusqueda.page == 1)
                                  ? ListaServicios()
                                  : (selectorTabBusqueda.page == 2)
                                      ? ListaNegocios()
                                      : (selectorTabBusqueda.page == 3)
                                          ? ListaNegocios()
                                          : (selectorTabBusqueda.page == 4)
                                              ? Container()
                                              : (selectorTabBusqueda.page == 5)
                                                  ? ListaCategorias()
                                                  : (selectorTabBusqueda.page ==
                                                          6)
                                                      ? ListaItemsubcategoria()
                                                      : Container(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}

class ListaProductos extends StatelessWidget {
  const ListaProductos({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final busquedaBloc = ProviderBloc.busqueda(context);
    //busquedaBloc.obtenerBusquedaProducto('$query');

    final responsive = Responsive.of(context);
    return StreamBuilder(
        stream: busquedaBloc.busquedaProductoStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<ProductoModel>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int i) {
                    return ListTile(
                      leading: FadeInImage(
                        placeholder: AssetImage('assets/no-image.png'),
                        image: NetworkImage(
                          '$apiBaseURL/${snapshot.data[i].productoImage}',
                        ),
                        width: responsive.wp(5),
                        fit: BoxFit.contain,
                      ),
                      title: Text('${snapshot.data[i].productoName}'),
                      subtitle: Text('${snapshot.data[i].productoCurrency}'),
                      onTap: () {
                        //close(context, null);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetalleProductos(
                              producto: snapshot.data[i],
                            ),
                          ),
                        );
                      },
                    );
                  });
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
        });
  }
}

class ListaServicios extends StatelessWidget {
  const ListaServicios({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    final busquedaBloc = ProviderBloc.busqueda(context);

    return StreamBuilder(
        stream: busquedaBloc.busquedaServicioStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<SubsidiaryServiceModel>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int i) {
                    return ListTile(
                      leading: FadeInImage(
                        placeholder: AssetImage('assets/no-image.png'),
                        image: NetworkImage(
                          '$apiBaseURL/${snapshot.data[i].subsidiaryServiceImage}',
                        ),
                        width: responsive.wp(5),
                        fit: BoxFit.contain,
                      ),
                      title: Text('${snapshot.data[i].subsidiaryServiceName}'),
                      subtitle: Text(
                          '${snapshot.data[i].subsidiaryServiceCurrency} ${snapshot.data[i].subsidiaryServicePrice}'),
                      onTap: () {
                        //close(context, null);

                        /* Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetalleProductos(
                        producto: servicios[i],
                      ),
                    ),
                  ); */
                      },
                    );
                  });
            } else {
              return Center(
                child: Text('No aye datos'),
              );
            }
          } else {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
        });
  }
}
/* 
class ListaSucursales extends StatelessWidget { 
  const ListaSucursales({Key key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    
    return ListView.builder(
        shrinkWrap: true,
        itemCount: sucursales.length,
        itemBuilder: (BuildContext context, int i) {
          return ListTile(
            /* leading: FadeInImage(
              placeholder: AssetImage('assets/no-image.png'),
              image: NetworkImage(
                '$apiBaseURL/${sucursales[i].subsidiaryName}',
              ),
              width: responsive.wp(5),
              fit: BoxFit.contain,
            ), */
            title: Text('${sucursales[i].subsidiaryName}'),
            subtitle: Text('${sucursales[i].subsidiaryAddress} '),
            onTap: () {
              //close(context, null);

              /* Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalleProductos(
                    producto: servicios[i],
                  ),
                ),
              ); */
            },
          );
        });
  }
} */

class ListaNegocios extends StatelessWidget {
  const ListaNegocios({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final busquedaBloc = ProviderBloc.busqueda(context);
    //busquedaBloc.obtenerBusquedaNegocio('$query');

    return StreamBuilder(
        stream: busquedaBloc.busquedaNegocioStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<CompanySubsidiaryModel>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int i) {
                    return ListTile(
                      /* leading: FadeInImage(
                  placeholder: AssetImage('assets/no-image.png'),
                  image: NetworkImage(
                    '$apiBaseURL/${companys[i].companyName}',
                  ),
                  width: responsive.wp(5),
                  fit: BoxFit.contain,
                ), */
                      title: Text('${snapshot.data[i].companyName}'),
                      subtitle: Text('${snapshot.data[i].cityName} '),
                      onTap: () {
                        //close(context, null);

                        /* Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetalleProductos(
                        producto: servicios[i],
                      ),
                    ),
                  ); */
                      },
                    );
                  });
            } else {
              return Center(
                child: Text('No aye datos'),
              );
            }
          } else {
            return Center(
              child: Text('No aye datos'),
            );
          }
        });
  }
}

class ListaItemsubcategoria extends StatelessWidget {
  const ListaItemsubcategoria({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final busquedaBloc = ProviderBloc.busqueda(context);

    final responsive = Responsive.of(context);

    return StreamBuilder(
      stream: busquedaBloc.busquedaItemSubcategoriaStream,
      builder: (BuildContext context,
          AsyncSnapshot<List<ItemSubCategoriaModel>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int i) {
                  return InkWell(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(3),
                        vertical: responsive.hp(1),
                      ),
                      child: Text(
                        '${snapshot.data[i].itemsubcategoryName}',
                        style: TextStyle(
                            fontSize: responsive.ip(1.8),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                });
          } else {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.wp(3),
                vertical: responsive.hp(1),
              ),
              child: Text("No hay resultados para la búsqueda"),
            );
          }
        } else {
          return Center(
            child: Text("Itemsubcategory"),
          );
        }
      },
    );
  }
}



class ListaCategorias extends StatelessWidget {
  const ListaCategorias({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final busquedaBloc = ProviderBloc.busqueda(context);

    final responsive = Responsive.of(context);

    return StreamBuilder(
      stream: busquedaBloc.busquedaCategoriaController,
      builder: (BuildContext context,
          AsyncSnapshot<List<CategoriaModel>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int i) {
                  return InkWell(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(3),
                        vertical: responsive.hp(1),
                      ),
                      child: Text(
                        '${snapshot.data[i].categoryName}',
                        style: TextStyle(
                            fontSize: responsive.ip(1.8),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                });
          } else {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.wp(3),
                vertical: responsive.hp(1),
              ),
              child: Text("No hay resultados para la búsqueda"),
            );
          }
        } else {
          return Center(
            child: Text("Category"),
          );
        }
      },
    );
  }
}






class ListaProductosYServiciosItemSubca extends StatelessWidget {
  const ListaProductosYServiciosItemSubca({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final busquedaBloc = ProviderBloc.busqueda(context);
    //busquedaBloc.obtenerBusquedaProducto('$query');

    final responsive = Responsive.of(context);
    return StreamBuilder(
        stream: busquedaBloc.busProySerPorIdItemsubController,
        builder: (BuildContext context,
            AsyncSnapshot<List<BienesServiciosModel>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int i) {
                    return ('${snapshot.data[i].tipo}' == 'producto')?ListTile(
                      leading: FadeInImage(
                        placeholder: AssetImage('assets/no-image.png'),
                        image: NetworkImage(
                          '$apiBaseURL/${snapshot.data[i].subsidiaryGoodImage}',
                        ),
                        width: responsive.wp(5),
                        fit: BoxFit.contain,
                      ),
                      title: Text('${snapshot.data[i].subsidiaryGoodName}'),
                      subtitle: Text('${snapshot.data[i].subsidiaryGoodCurrency}'),
                      onTap: () {
                        //close(context, null);

                        /* Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetalleProductos(
                              producto: snapshot.data[i],
                            ),
                          ),
                        ); */
                      },
                    ):ListTile(
                      leading: FadeInImage(
                        placeholder: AssetImage('assets/no-image.png'),
                        image: NetworkImage(
                          '$apiBaseURL/${snapshot.data[i].subsidiaryServiceImage}',
                        ),
                        width: responsive.wp(5),
                        fit: BoxFit.contain,
                      ),
                      title: Text('${snapshot.data[i].subsidiaryServiceName}'),
                      subtitle: Text('${snapshot.data[i].subsidiaryServiceCurrency}'),
                      onTap: () {
                        //close(context, null);

                        /* Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetalleProductos(
                              producto: snapshot.data[i],
                            ),
                          ),
                        ); */
                      },
                    );
                  });
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
        });
  }
}

class ItemsBusqueda {
  ItemsBusqueda({this.titulo, this.index, this.cantidad});

  String titulo;
  int index;
  String cantidad;
}
