import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/CompanySubsidiaryModel.dart';
import 'package:bufi/src/models/bienesServiciosModel.dart';
import 'package:bufi/src/models/categoriaModel.dart';
import 'package:bufi/src/models/itemSubcategoryModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/models/subcategoryModel.dart';
import 'package:bufi/src/models/subsidiaryService.dart';
import 'package:bufi/src/page/Categorias/ProductosPotItemsubcategory/pro_y_ser_por_itemSubcategory_page.dart';
import 'package:bufi/src/page/Categorias/itemSubcategory_por_idSubcategory_page.dart';
import 'package:bufi/src/page/Categorias/subcategory_por_idCategory_page.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/detalleProducto/detalleProducto.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
    ItemsBusqueda(titulo: 'Marcas', index: 4),
    ItemsBusqueda(titulo: 'Categorías', index: 5),
    ItemsBusqueda(titulo: 'Subcategorías', index: 6),
    ItemsBusqueda(titulo: 'Familia', index: 7),
  ];

  @override
  void dispose() {
    _controllerBusquedaAngelo.dispose();
    _controllerBusquedaAngelo.text = '';
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final busquedaBloc = ProviderBloc.busqueda(context);
      busquedaBloc.obtenerBusquedaProducto('');
      busquedaBloc.obtenerBusquedaServicio('');
      busquedaBloc.obtenerBusquedaNegocio('');
      busquedaBloc.obtenerBusquedaItemSubcategoria('');
      busquedaBloc.obtenerBusquedaCategoria('');
      busquedaBloc.obtenerBusquedaSubcategoria('');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Primera vez');
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
                                hintText: 'Buscar en Bufi',
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
                                busquedaBloc
                                    .obtenerBusquedaItemSubcategoria('$value');
                                busquedaBloc.obtenerBusquedaCategoria('$value');
                                busquedaBloc
                                    .obtenerBusquedaSubcategoria('$value');
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
                                          ? Container()
                                          : (selectorTabBusqueda.page == 4)
                                              ? ListaCategorias()
                                              : (selectorTabBusqueda.page == 5)
                                                  ? ListaSubCategorias()
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
                    return _crearItem(context, snapshot.data[i], responsive);
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

  Widget _crearItem(
      BuildContext context, ProductoModel productoData, Responsive responsive) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalleProductos(idProducto: productoData.idProducto,
              
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(2, 3),
            ),
          ],
        ),
        margin: EdgeInsets.all(responsive.ip(1)),
        height: responsive.hp(15),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                width: responsive.wp(42),
                child: CachedNetworkImage(
                  placeholder: (context, url) => Image(
                    image: AssetImage('assets/jar-loading.gif'),
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => Image(
                      image: AssetImage('assets/carga_fallida.jpg'),
                      fit: BoxFit.cover),
                  imageUrl: '$apiBaseURL/${productoData.productoImage}',
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: responsive.wp(53),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${productoData.productoName}',
                    style: TextStyle(
                        fontSize: responsive.ip(2.3),
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                      '${productoData.productoCurrency} ${productoData.productoPrice}',
                      style: TextStyle(
                          fontSize: responsive.ip(2.5),
                          fontWeight: FontWeight.bold,
                          color: Colors.red)),
                  Text('${productoData.productoBrand}'),
                  Text('${productoData.productoSize}'),
                  Text('${productoData.productoModel}')
                ],
              ),
            )
          ],
        ),
      ),
    );
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
                    return _crearItem(context, snapshot.data[i], responsive);
                  });
            } else {
              return Center(
                child: Text('No hay datos'),
              );
            }
          } else {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
        });
  }

  Widget _crearItem(BuildContext context, SubsidiaryServiceModel servicioData,
      Responsive responsive) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'detalleServicio',
            arguments: servicioData.idSubsidiaryservice);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(2, 3),
            ),
          ],
        ),
        margin: EdgeInsets.all(responsive.ip(1)),
        height: responsive.hp(11),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                width: responsive.wp(42),
                child: CachedNetworkImage(
                  placeholder: (context, url) => Image(
                    image: AssetImage('assets/jar-loading.gif'),
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => Image(
                      image: AssetImage('assets/carga_fallida.jpg'),
                      fit: BoxFit.cover),
                  imageUrl:
                      '$apiBaseURL/${servicioData.subsidiaryServiceImage}',
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: responsive.wp(53),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${servicioData.subsidiaryServiceName}',
                    style: TextStyle(
                        fontSize: responsive.ip(2.3),
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                      '${servicioData.subsidiaryServiceCurrency} ${servicioData.subsidiaryServicePrice}',
                      style: TextStyle(
                          fontSize: responsive.ip(2.5),
                          fontWeight: FontWeight.bold,
                          color: Colors.red)),
                  Text('${servicioData.subsidiaryServiceDescription}',
                      style: TextStyle(color: Colors.red)),
                ],
              ),
            )
          ],
        ),
      ),
    );
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
    final responsive = Responsive.of(context);
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
                    return _crearItem(context, snapshot.data[i], responsive);
                  });
            } else {
              return Center(
                child: Text('No hay datos'),
              );
            }
          } else {
            return Center(
              child: Text('No hay datos'),
            );
          }
        });
  }

  Widget _crearItem(BuildContext context, CompanySubsidiaryModel negocioData,
      Responsive responsive) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'detalleNegocio', arguments: negocioData);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(2, 3),
            ),
          ],
        ),
        margin: EdgeInsets.all(responsive.ip(1)),
        height: responsive.hp(15),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                width: responsive.wp(42),
                child: Stack(
                  children: <Widget>[
                    CachedNetworkImage(
                      placeholder: (context, url) => Image(
                        image: AssetImage('assets/jar-loading.gif'),
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) => Image(
                          image: AssetImage('assets/carga_fallida.jpg'),
                          fit: BoxFit.cover),
                      imageUrl: '$apiBaseURL/${negocioData.companyImage}',
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      left: 0,
                      bottom: 0,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: responsive.hp(.5),
                          //horizontal: responsive.wp(2)
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${negocioData.companyName}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: responsive.ip(2),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: responsive.wp(53),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${negocioData.companyName}',
                    style: TextStyle(
                        fontSize: responsive.ip(2.3),
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  Text('${negocioData.companyType}',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold)),
                  Text('${negocioData.cityName}'),
                ],
              ),
            )
          ],
        ),
      ),
    );
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
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return ProYSerPorItemSubcategoryPage(
                            nameItem: '${snapshot.data[i].itemsubcategoryName}',
                            idItem: '${snapshot.data[i].idItemsubcategory}',
                          );
                        },
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
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
            child: Text("No hay datos"),
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
      builder:
          (BuildContext context, AsyncSnapshot<List<CategoriaModel>> snapshot) {
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
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return SubcategoryPorCategoryPage(
                            nombreCategoria: snapshot.data[i].categoryName,
                            idCategoria: snapshot.data[i].idCategory,
                          );
                        },
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
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

class ListaSubCategorias extends StatelessWidget {
  const ListaSubCategorias({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final busquedaBloc = ProviderBloc.busqueda(context);

    final responsive = Responsive.of(context);

    return StreamBuilder(
      stream: busquedaBloc.busquedaSubcategoryController,
      builder: (BuildContext context,
          AsyncSnapshot<List<SubcategoryModel>> snapshot) {
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
                        '${snapshot.data[i].subcategoryName}',
                        style: TextStyle(
                            fontSize: responsive.ip(1.8),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return ItemSubcategoryPorSubcategoryPage(
                            nombreSubcategoria:
                                snapshot.data[i].subcategoryName,
                            idSubCategoria: snapshot.data[i].idSubcategory,
                          );
                        },
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
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
            child: Text("No hay datos"),
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
                    return ('${snapshot.data[i].tipo}' == 'producto')
                        ? ListTile(
                            leading: FadeInImage(
                              placeholder: AssetImage('assets/no-image.png'),
                              image: NetworkImage(
                                '$apiBaseURL/${snapshot.data[i].subsidiaryGoodImage}',
                              ),
                              width: responsive.wp(5),
                              fit: BoxFit.contain,
                            ),
                            title:
                                Text('${snapshot.data[i].subsidiaryGoodName}'),
                            subtitle: Text(
                                '${snapshot.data[i].subsidiaryGoodCurrency}'),
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
                          )
                        : ListTile(
                            leading: FadeInImage(
                              placeholder: AssetImage('assets/no-image.png'),
                              image: NetworkImage(
                                '$apiBaseURL/${snapshot.data[i].subsidiaryServiceImage}',
                              ),
                              width: responsive.wp(5),
                              fit: BoxFit.contain,
                            ),
                            title: Text(
                                '${snapshot.data[i].subsidiaryServiceName}'),
                            subtitle: Text(
                                '${snapshot.data[i].subsidiaryServiceCurrency}'),
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

class ListaProductosYServiciosIdSubisdiary extends StatelessWidget {
  const ListaProductosYServiciosIdSubisdiary({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final busquedaBloc = ProviderBloc.busqueda(context);
    //busquedaBloc.obtenerBusquedaProducto('$query');

    final responsive = Responsive.of(context);
    return StreamBuilder(
        stream: busquedaBloc.busquedaProductoPorIdSucursalStream,
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