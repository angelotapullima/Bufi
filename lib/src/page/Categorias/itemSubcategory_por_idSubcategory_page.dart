import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/page/Categorias/ProductosPotItemsubcategory/pro_y_ser_por_itemSubcategory_page.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/models/itemSubcategoryModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ItemSubcategoryPorSubcategoryPage extends StatelessWidget {
  final String nombreSubcategoria;
  final String idSubCategoria;
  const ItemSubcategoryPorSubcategoryPage(
      {Key key,
      @required this.nombreSubcategoria,
      @required this.idSubCategoria})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemSubcategoriasBloc = ProviderBloc.subcategoriaGeneral(context);
    itemSubcategoriasBloc
        .obtenerItemSubcategoryPorIdSubcategory(idSubCategoria);
    final responsive = Responsive.of(context);
    return Scaffold(
      body: SafeArea(
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
                        nombreSubcategoria,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: responsive.ip(2.5),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: itemSubcategoriasBloc.itemSubcategoryStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ItemSubCategoriaModel>> snapshot) {
                    return GridView.builder(
                        padding: EdgeInsets.all(0),
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: snapshot.data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: .85, crossAxisCount: 4),
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return ProYSerPorItemSubcategoryPage(
                                    nameItem:
                                        '${snapshot.data[i].itemsubcategoryName}',
                                    idItem:
                                        '${snapshot.data[i].idItemsubcategory}',
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
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: responsive.wp(2),
                                  vertical: responsive.hp(.2)),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(
                                      responsive.ip(1),
                                    ),
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.grey[400]),
                                    ),
                                    child: Container(
                                      height: responsive.ip(5),
                                      width: responsive.ip(5),
                                      /* transform:
                                                    Matrix4.translationValues(
                                                        0, 0, 0), */
                                      child: CachedNetworkImage(
                                        /* cacheManager:
                                                      CustomCacheManager(), */
                                        placeholder: (context, url) => Image(
                                            image: const AssetImage(
                                                'assets/jar-loading.gif'),
                                            fit: BoxFit.cover),
                                        errorWidget: (context, url, error) =>
                                            Image(
                                                image: AssetImage(
                                                    'assets/carga_fallida.jpg'),
                                                fit: BoxFit.cover),
                                        imageUrl:
                                            '$apiBaseURL/${snapshot.data[i].itemsubcategoryImage}',
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
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
                                  SizedBox(
                                    height: responsive.hp(.5),
                                  ),
                                  Text(
                                    '${snapshot.data[i].itemsubcategoryName}',
                                    style: TextStyle(
                                        fontSize: responsive.ip(1.3),
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  }),
            )
          ],
        ),
      ),
    );
  }
}
