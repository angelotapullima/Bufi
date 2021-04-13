import 'dart:math';

import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/categoriaModel.dart';
import 'package:bufi/src/page/Categorias/subcategory_por_idCategory_page.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:flutter/material.dart';

class ListCategoriasPrincipal extends StatelessWidget {
  const ListCategoriasPrincipal({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final categoriaBloc = ProviderBloc.categoria(context);
    categoriaBloc.obtenerCategorias();

    return StreamBuilder(
        stream: categoriaBloc.categoriaStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<CategoriaModel>> snapshot) {
          List<CategoriaModel> listCategoria = snapshot.data;

          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return Container(
                height: responsive.hp(12),
                //color: Colors.red,
                child: ListView.builder(
                  itemCount: listCategoria.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    //var residuo = index % 2;

                    return Container(
                      width: responsive.wp(18),
                      height: responsive.hp(12),
                      margin: EdgeInsets.symmetric(
                        horizontal: responsive.wp(1),
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return SubcategoryPorCategoryPage(
                                    nombreCategoria:
                                        snapshot.data[index].categoryName,
                                    idCategoria:
                                        snapshot.data[index].idCategory,
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

                              //PantallaCategoriaItem
                            },
                            child: CircleAvatar(
                              radius: responsive.hp(3.2),
                              backgroundColor: Colors.primaries[
                                  Random().nextInt(Colors.primaries.length)],
                              child: Icon(Icons.access_alarm_sharp,
                                  color: Colors.white),
                            ),
                          ),
                          Text(
                            '${listCategoria[index].categoryName}',
                            style: TextStyle(fontSize: responsive.ip(1.2)),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          } else {
            return Text("Error");
          }
        });
  }
}
