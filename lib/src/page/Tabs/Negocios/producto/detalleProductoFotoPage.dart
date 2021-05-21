import 'dart:io';
import 'dart:typed_data';

import 'package:bufi/src/bloc/producto/paginaActualBloc.dart';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class DetalleProductoFoto extends StatefulWidget {
  const DetalleProductoFoto({Key key, @required this.productosData})
      : super(key: key);

  final ProductoModel productosData;

  @override
  _DetalleProductoFotoState createState() => _DetalleProductoFotoState();
}

class _DetalleProductoFotoState extends State<DetalleProductoFoto> {
  final _toque = ValueNotifier<bool>(false);
  Uint8List _imageFile;
  ScreenshotController screenshotController = ScreenshotController();
  List<String> imagePaths = [];
  //final _pageController = PageController(viewportFraction: 1, initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    //contador
    final contadorBloc = ProviderBloc.contadorPagina(context);
    contadorBloc.changeContadorfoto(contadorBloc.pageContador);
    //controlador del PageView
    final _pageController = PageController(
        viewportFraction: 1, initialPage: contadorBloc.pageContador);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          GestureDetector(
            child: Container(
                //radius: responsive.ip(2.5),
                color: Colors.transparent,
                child: Icon(
                    Icons.share) //Icon(Icons.arrow_back, color: Colors.black),
                ),
            onTap: () async {
              await takeScreenshotandShare(widget.productosData.idProducto);
              //_logoScreen.value = false;
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: _toque,
        builder: (BuildContext context, bool dataToque, Widget child) {
          return InkWell(
            onTap: () {
              if (dataToque) {
                _toque.value = false;
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
                        child: photoViewGallery(widget.productosData,
                            _pageController, contadorBloc, responsive),
                      ),

                      //Container(color: Colors.red),

                      //Datos del producto
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
                                      '${widget.productosData.productoName}',
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
                                    'S/. ${widget.productosData.productoPrice}',
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
                                '${widget.productosData.productoCharacteristics} ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: responsive.ip(1.8),
                                ),
                              ),
                              SizedBox(
                                height: responsive.hp(5),
                              ),
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
                Container(
                  color: Colors.black,
                  height: double.infinity,
                  width: double.infinity,
                ),
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
                          tag: '${widget.productosData.idProducto}',
                          child: photoViewGallery(widget.productosData,
                              _pageController, contadorBloc, responsive)),
                    ),
                  ),
                ),

                //Numero de paginas
                Positioned(
                  top: 0,
                  left: responsive.wp(40),
                  child: StreamBuilder(
                      stream: contadorBloc.selectContadorFotoStream,
                      builder: (context, snapshot) {
                        return Container(
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
                            (contadorBloc.pageContadorFoto + 1).toString() +
                                '/' +
                                widget.productosData.listFotos.length
                                    .toString(),
                            // style: TextStyle(fontWeight: FontWeight.bold
                            // ),
                          ),
                        );
                      }),
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
                                      '${widget.productosData.productoName}',
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
                                    'S/. ${widget.productosData.productoPrice}',
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
                              SizedBox(
                                height: responsive.hp(5),
                              ),
                              SizedBox(
                                height: responsive.hp(2),
                              ),
                              Text(
                                '${widget.productosData.productoCharacteristics} ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: responsive.ip(1.8),
                                ),
                              ),
                              SizedBox(
                                height: responsive.hp(5),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget photoViewGallery(
      ProductoModel productosData,
      PageController _pageController,
      ContadorPaginaProductosBloc contadorBloc,
      Responsive responsive) {
    return Container(
      child: PhotoViewGallery.builder(
        scrollPhysics: BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: CachedNetworkImageProvider(
              '$apiBaseURL/${productosData.listFotos[index].galeriaFoto}',
            ),
            //initialScale: PhotoViewComputedScale.contained * 0.8,
            // heroAttributes:
            //     PhotoViewHeroAttributes(
            //         tag:
            //             '${productosData.idProducto}'),
          );
        },
        itemCount: productosData.listFotos.length,
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: responsive.wp(40),
            height: responsive.hp(60),
            child: CircularProgressIndicator(
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes,
            ),
          ),
        ),
        // backgroundDecoration:
        //     widget.backgroundDecoration,
        pageController: _pageController,
        onPageChanged: (int index) {
          contadorBloc.changeContadorfoto(index);
        },
      ),
    );
  }

  takeScreenshotandShare(String nombre) async {
    var now = DateTime.now();
    nombre = now.microsecond.toString();
    _imageFile = null;
    screenshotController
        .capture(delay: Duration(milliseconds: 10), pixelRatio: 2.0)
        .then((Uint8List image) async {
      setState(() {
        _imageFile = image;
      });

      await ImageGallerySaver.saveImage(image);

      // Save image to gallery,  Needs plugin  https://pub.dev/packages/image_gallery_saver

      final directory = (await getApplicationDocumentsDirectory()).path;
      Uint8List pngBytes = _imageFile;
      File imgFile = new File('$directory/Screenshot$nombre.png');
      imgFile.writeAsBytes(pngBytes);

      imagePaths.add(imgFile.path);
      final RenderBox box = context.findRenderObject() as RenderBox;
      await Share.shareFiles(imagePaths,
          text: '',
          subject: '',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }).catchError((onError) {
      print(onError);
    });
  }
}
