import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/categoriaGeneralModel.dart';
import 'package:bufi/src/models/categoriaModel.dart';
import 'package:bufi/src/page/Categorias/pro_y_ser_por_itemSubcategory_page.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/widgets/widgetBusquedas/widgetBusqProduct.dart';

import 'package:flutter/material.dart';


class ListaCategoria extends StatefulWidget {
  ListaCategoria({Key key}) : super(key: key);

  @override
  _ListaCategoriaState createState() => _ListaCategoriaState();
}

class _ListaCategoriaState extends State<ListaCategoria> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final categoriaBloc = ProviderBloc.categoria(context);
    categoriaBloc.obtenerCategorias();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //_buscarProductos(responsive),
            //SizedBox(height: 20),Stack(
            Container(
              height: responsive.hp(5),
              child: Stack(
                children: [
                  BackButton(),
                  Container(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'Categorías',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: responsive.ip(2.5),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
            BusquedaProductoWidget(responsive: responsive),
            SizedBox(
              height: responsive.hp(.5),
            ),
            Expanded(
              child: Container(
                height: responsive.hp(88),
                child: StreamBuilder(
                  stream: categoriaBloc.categoriaStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<CategoriaModel>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length > 0) {
                        return _listCategoria(
                            snapshot.data, context, responsive);
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    } else {
                      return Center(child: Text("Algo está mal"));
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listCategoria(List<CategoriaModel> categorias, BuildContext context,
      Responsive responsive) {
    //final bottomBloc = ProviderBloc.bottom(context);
    final naviCategBloc = ProviderBloc.naviCategoria(context);
    naviCategBloc.changeIndexPage(categorias[0].idCategory);

    return StreamBuilder(
        stream: naviCategBloc.categoriasIndexStream,
        builder: (context, snapshot) {
          return Row(
            children: <Widget>[
              Container(
                width: responsive.wp(30),
                //height: responsive.hp(90),
                child: CategoriaBienesServicios(categorias:categorias),
              ),
              Container(
                width: responsive.wp(69),
                child: SubcategoriaPorIdCategoria(
                  naviCategBloc.index,
                ),
              )
            ],
          );
        });
  }

  
}

class CategoriaBienesServicios extends StatefulWidget {

  final List<CategoriaModel> categorias;

  const CategoriaBienesServicios({Key key,@required this.categorias}) : super(key: key);

  @override
  _CategoriaBienesServiciosState createState() =>
      _CategoriaBienesServiciosState();
}

class _CategoriaBienesServiciosState extends State<CategoriaBienesServicios> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Scaffold(
      body: _listaCategorias(widget.categorias, responsive),
    );
  }

  Widget _listaCategorias(
      List<CategoriaModel> categorias, Responsive responsive) {
    return Container(
      //height: responsive.hp(90),
      width: responsive.wp(30),
      margin: EdgeInsets.all(2),
      child: ListView.builder(
        itemCount: categorias.length,
        itemBuilder: (BuildContext context, int index) {
          return _categ(context, categorias[index]);
        },
      ),
    );
  }

  Widget _categ(BuildContext context, CategoriaModel categoria) {
    //final size = MediaQuery.of(context).size;
    final responsive = Responsive.of(context);
    final naviCategBloc = ProviderBloc.naviCategoria(context);

    return StreamBuilder(
      stream: naviCategBloc.categoriasIndexStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return GestureDetector(
            child: Container(
                margin: EdgeInsets.all(2),
                height: responsive.hp(10),
                //width: size.width * 0.25,
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  color: (categoria.idCategory == snapshot.data)
                      ? Colors.black
                      : Color(0xFFF93963),
                  border: Border.all(color: Colors.grey[100]),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    '${categoria.categoryName}',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                )),
            onTap: () {
              naviCategBloc.changeIndexPage(categoria.idCategory);
              //Navigator.pushNamed(context, 'ProductosID',arguments: categoria);
            });
      },
    );
  }
}

class SubcategoriaPorIdCategoria extends StatefulWidget {
  SubcategoriaPorIdCategoria(this.index);
  final String index;

  @override
  _SubcategoriaPorIdCategoriaState createState() =>
      _SubcategoriaPorIdCategoriaState();
}

class _SubcategoriaPorIdCategoriaState
    extends State<SubcategoriaPorIdCategoria> {
  @override
  Widget build(BuildContext context) {
    final subcategoriasBloc = ProviderBloc.subcategoriaGeneral(context);
    //subCategoriasBloc.cargandoProductosFalse();
    subcategoriasBloc.obtenerSubcategoriaXIdCategoria(widget.index);

    return Scaffold(
      body: StreamBuilder(
        stream: subcategoriasBloc.subCategoriaGeneralStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<SubCategoriaGeneralModel>> snapshot) {
          List<SubCategoriaGeneralModel> subcategoriasGeneral = snapshot.data;
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return ListView.builder(
                  // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //   crossAxisCount: 2,
                  // ),
                  itemCount: subcategoriasGeneral.length,
                  itemBuilder: (context, index) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount:
                          subcategoriasGeneral[index].itemSubcategoria.length +
                              1,
                      itemBuilder: (BuildContext context, int i) {
                        if (i == 0) {
                          return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              margin: EdgeInsets.all(3),
                              color: Colors.blueGrey[100],
                              child: Text(
                                '${subcategoriasGeneral[index].nombre}',
                                style: TextStyle(
                                    color: Colors.blueGrey[700],
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              ));
                        }

                        //Lista de Items
                        int indd = i - 1;

                        return Container(
                          child: ListTile(
                            title: Text(
                              '${subcategoriasGeneral[index].itemSubcategoria[indd].itemsubcategoryName}',
                              style: TextStyle(fontSize: 16),
                            ),
                            leading: Icon(Icons.arrow_circle_up),
                            onTap: () {

                              Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return ProYSerPorItemSubcategoryPage(
                                    nameItem:  '${subcategoriasGeneral[index].itemSubcategoria[indd].itemsubcategoryName}',
                                    idItem:  '${subcategoriasGeneral[index].itemSubcategoria[indd].idItemsubcategory}',
                                  );
                                },
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  var begin = Offset(0.0, 1.0);
                                  var end = Offset.zero;
                                  var curve = Curves.ease;

                                  var tween =
                                      Tween(begin: begin, end: end).chain(
                                    CurveTween(curve: curve),
                                  );

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ));


                             
                            },
                          ),
                        );

                        //                     child: Text(
                        // '${subcategoriasGeneral[index].itemSubcategoria[indd].itemsubcategoryName}'),
                      },
                    );

                    // GestureDetector(
                    //   child: Card(
                    //     //color: Colors.pink[400],
                    //     child: Column(
                    //       children: [
                    //         Center(
                    //           child: Text(
                    //             subcategorias[index].subcategoryName,
                    //             style: TextStyle(
                    //                 fontSize: 15,
                    //                 //color: Colors.grey,
                    //                 fontWeight: FontWeight.bold),
                    //             textAlign: TextAlign.center,
                    //           ),
                    //         ),
                    //         // Expanded(
                    //         //   child: ListTile(
                    //         //     title: Text(
                    //         //         '${subcategorias[index].subcategoryName}'),
                    //         //     subtitle: Text(
                    //         //         'subtitulo:${subcategorias[index].subcategoryName}'),
                    //         //     leading: Icon(Icons.arrow_circle_down),
                    //         //     onTap: () {},
                    //         //   ),
                    //         // )
                    //       ],
                    //     ),
                    //   ),
                    //   // onTap: (){
                    //   //   Navigator.pushNamed(context, "listaItemSubcategoria", arguments: subcategorias[index]);
                    //   // },
                    // );
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          } else {
            return Center(child: Text("No existen Subcategorias"));
          }
        },
      ),
    );
  }
}
