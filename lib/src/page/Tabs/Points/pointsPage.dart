import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/models/pointModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      body: Column(
        children: [
          StreamBuilder(
            stream: pointsProdBloc.favProductoStrem,
            builder: (BuildContext context,
                AsyncSnapshot<List<PointModel>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              margin: EdgeInsets.all(3),
                              color: Colors.blueGrey[100],
                              child: Text(snapshot.data[index].subsidiaryName)),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data[index].listProducto.length,
                                itemBuilder: (BuildContext context, int i) {
                                  return Container(child: Text(snapshot.data[index].listProducto[i].productoName));
                                  // Container(
                                  //   width: responsive.wp(45),
                                  //   height: responsive.hp(15),
                                  //   child: Stack(children: [
                                  //     Hero(
                                  //       tag:
                                  //           '${snapshot.data[index].idSubsidiary}-subisdiary',
                                  //       child: ClipRRect(
                                  //         borderRadius: BorderRadius.circular(10),
                                  //         child: CachedNetworkImage(
                                  //           //cacheManager: CustomCacheManager(),
                                  //           placeholder: (context, url) =>
                                  //               Container(
                                  //             width: double.infinity,
                                  //             height: double.infinity,
                                  //             child: Image(
                                  //                 image: AssetImage(
                                  //                     'assets/jar-loading.gif'),
                                  //                 fit: BoxFit.cover),
                                  //           ),
                                  //           errorWidget: (context, url, error) =>
                                  //               Container(
                                  //                   width: double.infinity,
                                  //                   height: double.infinity,
                                  //                   child: Center(
                                  //                       child: Icon(Icons.error))),
                                  //           //imageUrl: '$apiBaseURL/${companyModel.companyImage}',
                                  //           imageUrl:
                                  //               'https://i.pinimg.com/564x/23/8f/6b/238f6b5ea5ab93832c281b42d3a1a853.jpg',
                                  //           imageBuilder:
                                  //               (context, imageProvider) =>
                                  //                   Container(
                                  //             decoration: BoxDecoration(
                                  //               image: DecorationImage(
                                  //                 image: imageProvider,
                                  //                 fit: BoxFit.cover,
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     Positioned(
                                  //       bottom: 0,
                                  //       left: 0,
                                  //       right: 0,
                                  //       child: Container(
                                  //         color: Colors.black.withOpacity(.4),
                                  //         child: Text(
                                  //           snapshot.data[index].subsidiaryName,
                                  //           style: TextStyle(
                                  //             color: Colors.white,
                                  //             fontSize: responsive.ip(2.5),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     Positioned(
                                  //         top: 5,
                                  //         right: 5,
                                  //         child: IconButton(
                                  //           icon: Icon(Icons.delete_outline,
                                  //               color: Colors.red),
                                  //           onPressed: () {
                                  //             // setState(() {
                                  //             //   quitarSubsidiaryFavorito(
                                  //             //       context, snapshot.data[index]);
                                  //             // });
                                  //           },
                                  //         ))
                                  //   ]),
                                  // );
                                }),

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

          // Expanded(
          //   child: StreamBuilder(
          //       stream: pointsProdBloc.productoFavoritoStream,
          //       builder:
          //           (context, AsyncSnapshot<List<ProductoModel>> snapshot) {
          //         List<ProductoModel> producto = snapshot.data;
          //         return ListView.builder(
          //           shrinkWrap: true,
          //           itemCount: producto.length,
          //           itemBuilder: (BuildContext context, int index) {
          //             return Container(
          //               width: responsive.wp(45),
          //               height: responsive.hp(15),
          //               child: Stack(children: [
          //                 Hero(
          //                   tag: '${producto[index].idSubsidiary}-subisdiary',
          //                   child: ClipRRect(
          //                     borderRadius: BorderRadius.circular(10),
          //                     child: CachedNetworkImage(
          //                       //cacheManager: CustomCacheManager(),
          //                       placeholder: (context, url) => Container(
          //                         width: double.infinity,
          //                         height: double.infinity,
          //                         child: Image(
          //                             image:
          //                                 AssetImage('assets/jar-loading.gif'),
          //                             fit: BoxFit.cover),
          //                       ),
          //                       errorWidget: (context, url, error) => Container(
          //                           width: double.infinity,
          //                           height: double.infinity,
          //                           child: Center(child: Icon(Icons.error))),
          //                       //imageUrl: '$apiBaseURL/${companyModel.companyImage}',
          //                       imageUrl:
          //                           'https://i.pinimg.com/564x/23/8f/6b/238f6b5ea5ab93832c281b42d3a1a853.jpg',
          //                       imageBuilder: (context, imageProvider) =>
          //                           Container(
          //                         decoration: BoxDecoration(
          //                           image: DecorationImage(
          //                             image: imageProvider,
          //                             fit: BoxFit.cover,
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //                 Positioned(
          //                   bottom: 0,
          //                   left: 0,
          //                   right: 0,
          //                   child: Container(
          //                     color: Colors.black.withOpacity(.4),
          //                     child: Text(
          //                       producto[index].productoName,
          //                       style: TextStyle(
          //                         color: Colors.white,
          //                         fontSize: responsive.ip(2.5),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //                 Positioned(
          //                     top: 5,
          //                     right: 5,
          //                     child: IconButton(
          //                       icon: Icon(Icons.delete_outline,
          //                           color: Colors.red),
          //                       onPressed: () {
          //                         // setState(() {

          //                         // });
          //                       },
          //                     ))
          //               ]),
          //             );

          //           },
          //         );
          //       }),
          // ),
        ],
      ),
    );
  }

  void quitarSubsidiaryFavorito(BuildContext context, SubsidiaryModel data) {}
}
