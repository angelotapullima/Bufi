import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/pointModel.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/customCacheManager.dart';
import 'package:bufi/src/utils/favoritos.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart' as utils;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PointsPage extends StatefulWidget {
  @override
  _PointsPageState createState() => _PointsPageState();
}

class _PointsPageState extends State<PointsPage> {
  @override
  Widget build(BuildContext context) {
    // final pointsBloc = ProviderBloc.points(context);
    // pointsBloc.obtenerPoints();
    final pointsProdBloc = ProviderBloc.points(context);
    pointsProdBloc.obtenerPointsProductosXSucursal();

    final responsive = Responsive.of(context);
    return Scaffold(
      body: StreamBuilder(
        stream: pointsProdBloc.favProductoStrem,
        builder:
            (BuildContext context, AsyncSnapshot<List<PointModel>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return ListView.builder(
                  shrinkWrap: true,
                  //scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            margin: EdgeInsets.all(3),
                            width: double.infinity,
                            color: Colors.blueGrey[100],
                            child: Text(
                              '${snapshot.data[index].subsidiaryName}',
                              style: TextStyle(fontSize: 20),
                            )),
                        Container(
                          height: responsive.hp(34),
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  snapshot.data[index].listProducto.length,
                              itemBuilder: (BuildContext context, int i) {
                                final goodData =
                                    snapshot.data[index].listProducto[i];

                                return Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: responsive.wp(1),
                                    vertical: responsive.hp(1),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: Offset(
                                            0, 2), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  width: responsive.wp(42.5),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: responsive.hp(17),
                                        child: Stack(
                                          children: <Widget>[
                                            Hero(
                                              tag: goodData.idProducto,
                                              child: Container(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft: Radius
                                                              .circular(8),
                                                          topRight:
                                                              Radius.circular(
                                                                  8)),
                                                  child: CachedNetworkImage(
                                                    cacheManager:
                                                        CustomCacheManager(),
                                                    placeholder:
                                                        (context, url) => Image(
                                                            image: AssetImage(
                                                                'assets/jar-loading.gif'),
                                                            fit: BoxFit.cover),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                    imageUrl:
                                                        '$apiBaseURL/${goodData.productoImage}',
                                                    imageBuilder: (context,
                                                            imageProvider) =>
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
                                            ),
                                            Positioned(
                                              left: 0,
                                              top: 0,
                                              child: Container(
                                                padding: EdgeInsets.all(
                                                    responsive.ip(.5)),
                                                color: Colors.red,
                                                //double.infinity,
                                                height: responsive.hp(3),
                                                child: Text(
                                                  'Producto',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          responsive.ip(1.5),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            )

                                            //https://tytperu.com/594-thickbox_default/smartphone-samsung-galaxy-s10.jpg
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: responsive.hp(5),
                                        padding: EdgeInsets.symmetric(
                                            vertical: responsive.hp(1)),
                                        //color: Colors.white.withOpacity(.8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                              height: responsive.hp(3.5),
                                              width: responsive.wp(20),
                                              decoration: BoxDecoration(
                                                color:
                                                    Colors.blue.withOpacity(.2),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    FontAwesomeIcons
                                                        .shoppingCart,
                                                    size: responsive.ip(1.5),
                                                    color: Colors.blue[800],
                                                  ),
                                                  SizedBox(
                                                    width: responsive.wp(1),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      final buttonBloc =
                                                          ProviderBloc.tabs(
                                                              context);
                                                      buttonBloc.changePage(2);

                                                      utils.agregarAlCarrito(
                                                          context,
                                                          goodData.idProducto);
                                                    },
                                                    child: Text(
                                                      'Agregar',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blue[800],
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              child: Container(
                                                height: responsive.hp(3.5),
                                                width: responsive.wp(12),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue
                                                      .withOpacity(.2),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: (goodData
                                                            .productoFavourite ==
                                                        '0')
                                                    ? Icon(
                                                        FontAwesomeIcons.heart,
                                                        color: Colors.red)
                                                    : Icon(
                                                        FontAwesomeIcons
                                                            .solidHeart,
                                                        color: Colors.red),
                                              ),
                                              onTap: () {
                                                print("desfavorito");
                                                quitarProductoFavorito(
                                                    context, goodData);
                                                
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                      Text(
                                        goodData.productoName,
                                        style: TextStyle(
                                            fontSize: responsive.ip(1.5),
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                          '${goodData.productoCurrency} ${goodData.productoPrice}',
                                          style: TextStyle(
                                              fontSize: responsive.ip(1.9),
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red)),
                                      Text(
                                        goodData.productoBrand,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: responsive.ip(1.5),
                                        ),
                                      )
                                    ],
                                  ),
                                );

                                // : Container(color: Colors.red,
                                // child: Text("data"),);
                              }),
                        ),
                      ],
                    );
                  });
            } else {
              return Center(
                child: Text('No hay Points'),
              );
            }
          } else {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
        },
      ),
    );
  }

  void quitarSubsidiaryFavorito(BuildContext context, SubsidiaryModel data) {}
}
