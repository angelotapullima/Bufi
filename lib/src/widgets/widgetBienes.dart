import 'dart:ui';
import 'package:bufi/src/models/bienesServiciosModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/customCacheManager.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bufi/src/utils/utils.dart' as utils;

Widget bienesWidgetCompelto(BuildContext context, BienesServiciosModel goodData,
    Responsive responsive) {
  return Container(
    margin: EdgeInsets.symmetric(
        horizontal: responsive.wp(1), vertical: responsive.hp(1)),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 2), // changes position of shadow
        ),
      ],
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
    ),
    width: responsive.wp(42.5),
    height: responsive.hp(10),
    child: Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: responsive.hp(18),
          child: Stack(
            children: <Widget>[
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                  child: CachedNetworkImage(
                    cacheManager: CustomCacheManager(),
                    placeholder: (context, url) => Image(
                        image: AssetImage('assets/jar-loading.gif'),
                        fit: BoxFit.cover),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    imageUrl: '$apiBaseURL/${goodData.subsidiaryGoodImage}',
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
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(responsive.ip(.5)),
                  color: Colors.red,
                  //double.infinity,
                  height: responsive.hp(3),
                  child: Text(
                    'Producto',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: responsive.ip(1.5),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )

              //https://tytperu.com/594-thickbox_default/smartphone-samsung-galaxy-s10.jpg
            ],
          ),
        ),
        // Container(
        //   height: responsive.hp(5),
        //   padding: EdgeInsets.symmetric(vertical: responsive.hp(1)),
        //   //color: Colors.white.withOpacity(.8),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: [
        //       Container(
        //         height: responsive.hp(3.5),
        //         width: responsive.wp(20),
        //         decoration: BoxDecoration(
        //           color: Colors.blue.withOpacity(.2),
        //           borderRadius: BorderRadius.circular(10),
        //         ),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Icon(
        //               FontAwesomeIcons.shoppingCart,
        //               size: responsive.ip(1.5),
        //               color: Colors.blue[800],
        //             ),
        //             SizedBox(
        //               width: responsive.wp(1),
        //             ),
        //             GestureDetector(
        //               onTap: () {
        //                 final buttonBloc = ProviderBloc.tabs(context);
        //                 buttonBloc.changePage(2);

        //                 utils.agregarAlCarrito(
        //                     context, goodData.idSubsidiarygood);
        //                 //Navigator.pushNamed(context, "")
        //               },
        //               child: Text(
        //                 'Agregar',
        //                 style: TextStyle(
        //                     color: Colors.blue[800],
        //                     fontWeight: FontWeight.bold),
        //               ),
        //             )
        //           ],
        //         ),
        //       ),
        //       Container(
        //         height: responsive.hp(3.5),
        //         width: responsive.wp(12),
        //         decoration: BoxDecoration(
        //           color: Colors.red.withOpacity(.2),
        //           borderRadius: BorderRadius.circular(10),
        //         ),
        //         child: Icon(FontAwesomeIcons.heart, color: Colors.red),
        //       )
        //     ],
        //   ),
        // ),
        Text(
          goodData.subsidiaryGoodName,
          style: TextStyle(
              fontSize: responsive.ip(1.5),
              color: Colors.grey[800],
              fontWeight: FontWeight.w700),
        ),
        Text(
            '${goodData.subsidiaryGoodCurrency} ${goodData.subsidiaryGoodPrice}',
            style: TextStyle(
                fontSize: responsive.ip(1.9),
                fontWeight: FontWeight.bold,
                color: Colors.red)),
        Text(
          goodData.subsidiaryGoodBrand,
          style: TextStyle(
            color: Colors.grey,
            fontSize: responsive.ip(1.5),
          ),
        )
      ],
    ),
  );
}

class BienesWidget extends StatefulWidget {
  final ProductoModel producto;

  const BienesWidget({Key key, @required this.producto}) : super(key: key);
  @override
  _BienesWidgetState createState() => _BienesWidgetState();
}

class _BienesWidgetState extends State<BienesWidget> {
  int cant = 0;
  bool favorite = false;

  @override
  Widget build(BuildContext context) {
    if (cant == 0) {
      favorite = (widget.producto.productoFavourite == '1') ? true : false;
    }
    final responsive = Responsive.of(context);
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
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      width: responsive.wp(42.5),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: responsive.hp(18),
            child: Stack(
              children: <Widget>[
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                    child: CachedNetworkImage(
                      cacheManager: CustomCacheManager(),
                      placeholder: (context, url) => Image(
                          image: AssetImage('assets/jar-loading.gif'),
                          fit: BoxFit.cover),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      imageUrl: '$apiBaseURL/${widget.producto.productoImage}',
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
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(responsive.ip(.5)),
                    color: Colors.red,
                    //double.infinity,
                    height: responsive.hp(3),
                    child: Text(
                      'Productos',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: responsive.ip(1.5),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                //Favorito
                Positioned(
                    right: 0,
                    top: 2,
                    child:
                        //(widget.producto.productoFavourite == '1')
                        favorite
                            ? GestureDetector(
                                child: Container(
                                  height: responsive.hp(3.5),
                                  width: responsive.wp(12),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(FontAwesomeIcons.solidHeart,
                                      color: Colors.white),
                                ),
                                onTap: () {
                                  setState(() {
                                    favorite = false;
                                    //final buttonBloc = ProviderBloc.tabs(context);
                                    //buttonBloc.changePage(1);
                                    quitarProductoFavorito(
                                        context, widget.producto);
                                    cant++;
                                  });
                                },
                              )
                            : GestureDetector(
                                child: Container(
                                  height: responsive.hp(3.5),
                                  width: responsive.wp(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(FontAwesomeIcons.heart,
                                      color: Colors.white),
                                ),
                                onTap: () {
                                  setState(() {
                                    favorite = true;
                                    //final buttonBloc = ProviderBloc.tabs(context);
                                    //buttonBloc.changePage(1);
                                    guardarProductoFavorito(
                                        context, widget.producto);
                                        utils.showToast(context, 'el producto se agregó a favoritos');
                                  });
                                },
                              )),
                //Cuando el producto no esta disponible
                // Positioned(
                //   //left: responsive.wp(1),
                //   top: responsive.hp(5),
                //   child: Container(
                //     transform: Matrix4.rotationZ(-0.7),
                //     height: responsive.hp(3),
                //     width: responsive.wp(17),
                //     decoration: BoxDecoration(
                //       color: Colors.red
                //     ),
                //     child: const Text('No disponible'),
                //   ),
                // ),
              ],
            ),
          ),
          Text(
            widget.producto.productoName,
            style: TextStyle(
                fontSize: responsive.ip(1.5),
                color: Colors.grey[800],
                fontWeight: FontWeight.w700),
          ),
          Text(
              '${widget.producto.productoCurrency} ${widget.producto.productoPrice}',
              style: TextStyle(
                  fontSize: responsive.ip(1.9),
                  fontWeight: FontWeight.bold,
                  color: Colors.red)),
          Text(
            widget.producto.productoBrand,
            style: TextStyle(
              fontSize: responsive.ip(1.5),
            ),
          ),
          Text(
            '${widget.producto.productoSize}',
            style: TextStyle(
                fontSize: responsive.ip(1.5), fontWeight: FontWeight.w700),
          ),
          Text(
            '${widget.producto.productoModel}',
            style: TextStyle(
                fontSize: responsive.ip(1.5), fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}


class BienesCompletoWidget extends StatefulWidget {
  final BienesServiciosModel producto;

  const BienesCompletoWidget({Key key, @required this.producto}) : super(key: key);
  @override
  _BienesCompletoWidgetState createState() => _BienesCompletoWidgetState();
}

class _BienesCompletoWidgetState extends State<BienesCompletoWidget> {
  int cant = 0;
  bool favorite = false;

  @override
  Widget build(BuildContext context) {
    if (cant == 0) {
      favorite = (widget.producto.subsidiaryGoodFavourite == '1') ? true : false;
    }
    final responsive = Responsive.of(context);
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
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      width: responsive.wp(42.5),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: responsive.hp(18),
            child: Stack(
              children: <Widget>[
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                    child: CachedNetworkImage(
                      cacheManager: CustomCacheManager(),
                      placeholder: (context, url) => Image(
                          image: AssetImage('assets/jar-loading.gif'),
                          fit: BoxFit.cover),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      imageUrl: '$apiBaseURL/${widget.producto.subsidiaryGoodImage}',
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
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(responsive.ip(.5)),
                    color: Colors.red,
                    //double.infinity,
                    height: responsive.hp(3),
                    child: Text(
                      'Productos',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: responsive.ip(1.5),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                //Favorito
                Positioned(
                    right: 0,
                    top: 2,
                    child:
                        //(widget.producto.productoFavourite == '1')
                        favorite
                            ? GestureDetector(
                                child: Container(
                                  height: responsive.hp(3.5),
                                  width: responsive.wp(12),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(FontAwesomeIcons.solidHeart,
                                      color: Colors.white),
                                ),
                                onTap: () {
                                  setState(() {
                                    favorite = false;
                                    quitarProductoFavorito2(
                                        context, widget.producto);
                                    cant++;
                                  });
                                },
                              )
                            : GestureDetector(
                                child: Container(
                                  height: responsive.hp(3.5),
                                  width: responsive.wp(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(FontAwesomeIcons.heart,
                                      color: Colors.white),
                                ),
                                onTap: () {
                                  setState(() {
                                    favorite = true;
                                    //final buttonBloc = ProviderBloc.tabs(context);
                                    //buttonBloc.changePage(1);
                                    guardarProductoFavorito2(
                                        context, widget.producto);
                                        utils.showToast(context, 'el producto se agregó a favoritos');
                                  });
                                },
                              )),
               
              ],
            ),
          ),
          Text(
            widget.producto.subsidiaryGoodName,
            style: TextStyle(
                fontSize: responsive.ip(1.5),
                color: Colors.grey[800],
                fontWeight: FontWeight.w700),
          ),
          Text(
              '${widget.producto.subsidiaryGoodCurrency} ${widget.producto.subsidiaryGoodPrice}',
              style: TextStyle(
                  fontSize: responsive.ip(1.9),
                  fontWeight: FontWeight.bold,
                  color: Colors.red)),
          Text(
            widget.producto.subsidiaryGoodBrand,
            style: TextStyle(
              fontSize: responsive.ip(1.5),
            ),
          ),
          Text(
            '${widget.producto.subsidiaryGoodSize}',
            style: TextStyle(
                fontSize: responsive.ip(1.5), fontWeight: FontWeight.w700),
          ),
          Text(
            '${widget.producto.subsidiaryGoodModel}',
            style: TextStyle(
                fontSize: responsive.ip(1.5), fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}


Widget grillaBienes(Responsive responsive, BienesServiciosModel data) {
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
          offset: Offset(0, 2), // changes position of shadow
        ),
      ],
    ),
    width: responsive.wp(42.5),
    child: Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: responsive.hp(18),
          child: Stack(
            children: <Widget>[
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                  child: CachedNetworkImage(
                    cacheManager: CustomCacheManager(),
                    placeholder: (context, url) => Image(
                        image: AssetImage('assets/jar-loading.gif'),
                        fit: BoxFit.cover),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    imageUrl: '$apiBaseURL/${data.subsidiaryGoodImage}',
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
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(responsive.ip(.5)),
                  color: Colors.red,
                  //double.infinity,
                  height: responsive.hp(3),
                  child: Text(
                    'Producto',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: responsive.ip(1.5),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )

              //https://tytperu.com/594-thickbox_default/smartphone-samsung-galaxy-s10.jpg
            ],
          ),
        ),
        Container(
          height: responsive.hp(5),
          padding: EdgeInsets.symmetric(vertical: responsive.hp(1)),
          //color: Colors.white.withOpacity(.8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: responsive.hp(3.5),
                width: responsive.wp(20),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.shoppingCart,
                      size: responsive.ip(1.5),
                      color: Colors.blue[800],
                    ),
                    SizedBox(
                      width: responsive.wp(1),
                    ),
                  ],
                ),
              ),
              Container(
                height: responsive.hp(3.5),
                width: responsive.wp(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(FontAwesomeIcons.heart, color: Colors.red),
              )
            ],
          ),
        ),
        Text(
          data.subsidiaryGoodName,
          style: TextStyle(
              fontSize: responsive.ip(1.5),
              color: Colors.grey[800],
              fontWeight: FontWeight.w700),
        ),
        Text('${data.subsidiaryGoodCurrency} ${data.subsidiaryGoodPrice}',
            style: TextStyle(
                fontSize: responsive.ip(1.9),
                fontWeight: FontWeight.bold,
                color: Colors.red)),
        Text(
          data.subsidiaryGoodBrand,
          style: TextStyle(
            color: Colors.grey,
            fontSize: responsive.ip(1.5),
          ),
        )
      ],
    ),
  );
}
