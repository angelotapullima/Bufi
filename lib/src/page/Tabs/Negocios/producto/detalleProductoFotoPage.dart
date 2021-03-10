import 'dart:io';
import 'dart:typed_data';

import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/customCacheManager.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:screenshot/screenshot.dart';

class DetalleProductoFoto extends StatefulWidget {
  const DetalleProductoFoto({Key key}) : super(key: key);

  @override
  _DetalleProductoFotoState createState() => _DetalleProductoFotoState();
}

class _DetalleProductoFotoState extends State<DetalleProductoFoto> {
  final _toque = ValueNotifier<bool>(false);
  File _imageFile;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final ProductoModel productosData =
        ModalRoute.of(context).settings.arguments;

    final responsive = Responsive.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            GestureDetector(
              child: Container(
                  //radius: responsive.ip(2.5),
                  color: Colors.transparent,
                  child: Icon(Icons
                      .share) //Icon(Icons.arrow_back, color: Colors.black),
                  ),
              onTap: () async {
                await takeScreenshotandShare(productosData.idProducto);
                //_logoScreen.value = false;
              },
            ),
          ],
        ),
        body: ValueListenableBuilder(
            valueListenable: _toque,
            builder: (BuildContext context, bool dataToque, Widget child) {
              //contador para el PageView
              final contadorBloc = ProviderBloc.contadorPagina(context);
              print(dataToque);
              return InkWell(
                onTap: () {
                  if (dataToque) {
                    _toque.value;
                  } else {
                    _toque.value = true;
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Screenshot(
                      controller: screenshotController,
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: StreamBuilder(
                                stream: contadorBloc.selectContadorStream,
                                builder: (context, snapshot) {
                                  return PhotoView(
                                    imageProvider: CachedNetworkImageProvider(
                                      '$apiBaseURL/${productosData.listFotos[contadorBloc.pageContador].galeriaFoto}',
                                      cacheManager: CustomCacheManager(),
                                    ),
                                  );
                                }),
                          ),
                          Positioned(
                            top: 0,
                            //right: 0,
                            left: 0,
                            child: Container(
                              height: responsive.hp(3),
                              padding: EdgeInsets.symmetric(
                                horizontal: responsive.wp(2),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                border: Border.all(color: Colors.grey[300]),
                              ),
                              margin: EdgeInsets.symmetric(
                                horizontal: responsive.wp(5),
                                vertical: responsive.hp(1.3),
                              ),
                              child: Text(
                                (contadorBloc.pageContador + 1).toString() +
                                    '/' +
                                    productosData.listFotos.length.toString(),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: Container(
                              color: Colors.black.withOpacity(.6),
                              padding: EdgeInsets.symmetric(
                                horizontal: responsive.wp(5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          '${productosData.productoName}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: responsive.ip(3),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        width: responsive.wp(4),
                                      ),
                                      Text(
                                        'S/. ${productosData.productoPrice}',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: responsive.ip(3),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: responsive.hp(2),
                                  ),
                                  Text(
                                    '${productosData.productoCharacteristics} ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: responsive.ip(1.8),
                                    ),
                                  ),
                                  SizedBox(
                                    height: responsive.hp(5),
                                  )
                                ],
                              ),
                            ),
                          ),
                          // Container(
                          //   height: responsive.hp(12),
                          //   child: Center(
                          //     child: Image.asset('assets/producto.jpg'),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    // Container(
                    //   color: Colors.yellow,
                    //   height: double.infinity,
                    //   width: double.infinity,
                    // ),
                    Center(
                      child: GestureDetector(
                        onVerticalDragUpdate: (drag) {
                          if (drag.primaryDelta > 7) {
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          child: Hero(
                            tag: '${productosData.idProducto}',
                            child: PhotoView(
                              imageProvider: CachedNetworkImageProvider(
                                '$apiBaseURL/${productosData.listFotos[contadorBloc.pageContador].galeriaFoto}',
                                cacheManager: CustomCacheManager(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    (!dataToque)
                        ? Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: Container(
                              color: Colors.black.withOpacity(.6),
                              padding: EdgeInsets.symmetric(
                                horizontal: responsive.wp(5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          '${productosData.productoName}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: responsive.ip(3),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        width: responsive.wp(4),
                                      ),
                                      Text(
                                        'S/. ${productosData.productoPrice}',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: responsive.ip(3),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: responsive.hp(2),
                                  ),
                                  Text(
                                    '${productosData.listMarcaProd[0].marcaProducto} ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: responsive.ip(1.8),
                                    ),
                                  ),
                                  SizedBox(
                                    height: responsive.hp(5),
                                  )
                                ],
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              );
            }),
      ),
    );
  }

  takeScreenshotandShare(String nombre) async {
    var now = DateTime.now();
    nombre = now.microsecond.toString();
    _imageFile = null;
    screenshotController
        .capture(delay: Duration(milliseconds: 10), pixelRatio: 2.0)
        .then((File image) async {
      setState(() {
        _imageFile = image;
      });

      await ImageGallerySaver.saveImage(image.readAsBytesSync());

      // Save image to gallery,  Needs plugin  https://pub.dev/packages/image_gallery_saver
      print("File Saved to Gallery");

      final directory = (await getApplicationDocumentsDirectory()).path;
      Uint8List pngBytes = _imageFile.readAsBytesSync();
      File imgFile = new File('$directory/Screenshot$nombre.png');
      imgFile.writeAsBytes(pngBytes);
      print("File Saved to Gallery");

      await Share.file(
          'Anupam', 'Screenshot$nombre.png', pngBytes, 'image/png');
    }).catchError((onError) {
      print(onError);
    });
  }
}
