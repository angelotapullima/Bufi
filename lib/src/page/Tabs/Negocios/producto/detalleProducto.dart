import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/detalle_carrito.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:bufi/src/widgets/extentions.dart';
import 'package:bufi/src/widgets/translate_animation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetalleProductos extends StatefulWidget {
  final ProductoModel producto;
  const DetalleProductos({Key key, @required this.producto}) : super(key: key);

  @override
  _DetalleProductosState createState() => _DetalleProductosState();
}

class _DetalleProductosState extends State<DetalleProductos> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    Widget _icon(
      IconData icon, {
      Color color = LightColor.iconColor,
      double size,
      double padding = 10,
      bool isOutLine = false,
      Function onPressed,
    }) {
      return Container(
        height: responsive.ip(4),
        width: responsive.ip(4),
        //padding: EdgeInsets.all(padding),
        // margin: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[300],
          ),
          //style: isOutLine ? BorderStyle.solid : BorderStyle.none),
          borderRadius: BorderRadius.all(
            Radius.circular(13),
          ),
          color: isOutLine ? Colors.white : Colors.white,
        ),
        child: Center(child: Icon(icon, color: color, size: size)),
      ).ripple(
        () {
          if (onPressed != null) {
            onPressed();
          }
        },
        borderRadius: BorderRadius.all(
          Radius.circular(13),
        ),
      );
    }

    bool isLiked = false;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          //DetalleCarrito

          agregarAlCarrito(context, widget.producto.idProducto);

          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (context, animation, secondaryAnimation) {
                return DetalleCarrito(producto: widget.producto);
                //return DetalleProductitos(productosData: productosData);
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          );
        },
        label: Row(
          children: [
            Icon(Icons.shopping_cart_outlined),
            Text(' Agregar'),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          _backgroundImage(context),
          //ImagenProducto(),
          SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  //BackButton(),
                  _icon(
                    Icons.arrow_back_ios,
                    color: Colors.black54,
                    size: responsive.ip(1.7),
                    padding: responsive.ip(1.25),
                    isOutLine: true,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  _icon(isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? LightColor.lightGrey : LightColor.red,
                      size: responsive.ip(1.7),
                      padding: responsive.ip(1.25),
                      isOutLine: false, onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                  }),
                ],
              ),
            ),
          ),
          TranslateAnimation(
            duration: const Duration(milliseconds: 400),
            child: _contenido(
              responsive,
              context,
            ),
          ),
        ],
      ),
    );
  }

  Widget _backgroundImage(BuildContext context) {
    final size = MediaQuery.of(context).size;

    List<String> listProd = [
      "https://i.blogs.es/d07883/huawei-p40-pro-1/1366_2000.jpg",
      "https://cnet4.cbsistatic.com/img/BZhOgzaNcsc8fVQJmML9334-S-8=/2019/12/21/08bc2882-f90d-44b8-92e9-f5cf67f5db4d/samsung-galaxy-fold.jpg"
    ];

    return Container(
      child: GestureDetector(
          onTap: () {
            //Navigator.pushNamed(context, 'detalleProductoFoto', arguments: carrito);
          },
          onVerticalDragUpdate: (drag) {
            if (drag.primaryDelta > 7) {
              Navigator.pop(context);
            }
          },
          child: CarrouselProducto(listProd)

          // Container(
          //   width: double.infinity,
          //   height: size.height * 0.50,
          //   child: Hero(
          //     tag: widget.producto.idProducto,
          //     child: ClipRRect(
          //       child: CachedNetworkImage(
          //         //cacheManager: CustomCacheManager(),
          //         placeholder: (context, url) => Image(
          //             image: const AssetImage('assets/jar-loading.gif'),
          //             fit: BoxFit.cover),
          //         errorWidget: (context, url, error) => Image(
          //             image: AssetImage('assets/carga_fallida.jpg'),
          //             fit: BoxFit.cover),
          //         imageUrl: '$apiBaseURL/${widget.producto.productoImage}',
          //         imageBuilder: (context, imageProvider) => Container(
          //           decoration: BoxDecoration(
          //             image: DecorationImage(
          //               image: imageProvider,
          //               fit: BoxFit.fitHeight,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          ),
    );
  }

  Widget _contenido(
    Responsive responsive,
    BuildContext context,
  ) {
    return Container(
      margin: EdgeInsets.only(
        top: responsive.hp(21),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.7,
        builder: (context, scrollController) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 4,
                    blurRadius: 19,
                    offset: Offset(0, 5), // changes position of shadow
                  ),
                ],
                color: Colors.white),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(height: 5),
                  Container(
                    alignment: Alignment.center,
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                          color: LightColor.iconColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TitleText(
                            text: "${widget.producto.productoName}",
                            fontSize: 25),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                TitleText(
                                  text: "S/ ",
                                  fontSize: 18,
                                  color: LightColor.red,
                                ),
                                TitleText(
                                  text: "${widget.producto.productoPrice}",
                                  fontSize: 25,
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.star,
                                    color: LightColor.yellowColor, size: 17),
                                Icon(Icons.star,
                                    color: LightColor.yellowColor, size: 17),
                                Icon(Icons.star,
                                    color: LightColor.yellowColor, size: 17),
                                Icon(Icons.star,
                                    color: LightColor.yellowColor, size: 17),
                                Icon(Icons.star_border, size: 17),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _availableSize(),
                  SizedBox(
                    height: 20,
                  ),
                  _availableColor(),
                  SizedBox(
                    height: 20,
                  ),
                  _description(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _description() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleText(
          text: "Available Size",
          fontSize: 14,
        ),
        SizedBox(height: 20),
        Text(
            "Clean lines, versatile and timeless—the people shoe returns with the Nike Air Max 90. Featuring the same iconic Waffle sole, stitched overlays and classic TPU accents you come to love, it lets you walk among the pantheon of Air. ßNothing as fly, nothing as comfortable, nothing as proven. The Nike Air Max 90 stays true to its OG running roots with the iconic Waffle sole, stitched overlays and classic TPU details. Classic colours celebrate your fresh look while Max Air cushioning adds comfort to the journey."),
      ],
    );
  }

  Widget _availableSize() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleText(
          text: "Available Size",
          fontSize: 14,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _sizeWidget("US 6"),
            _sizeWidget("US 7", isSelected: true),
            _sizeWidget("US 8"),
            _sizeWidget("US 9"),
          ],
        )
      ],
    );
  }

  Widget _sizeWidget(String text, {bool isSelected = false}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
            color: LightColor.iconColor,
            style: !isSelected ? BorderStyle.solid : BorderStyle.none),
        borderRadius: BorderRadius.all(Radius.circular(13)),
        color:
            isSelected ? LightColor.orange : Theme.of(context).backgroundColor,
      ),
      child: TitleText(
        text: text,
        fontSize: 16,
        color: isSelected ? LightColor.background : LightColor.titleTextColor,
      ),
    ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(13)));
  }

  Widget _availableColor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleText(
          text: "Available Size",
          fontSize: 14,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _colorWidget(LightColor.yellowColor, isSelected: true),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.lightBlue),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.black),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.red),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.skyBlue),
          ],
        )
      ],
    );
  }

  Widget _colorWidget(Color color, {bool isSelected = false}) {
    return CircleAvatar(
      radius: 12,
      backgroundColor: color.withAlpha(150),
      child: isSelected
          ? Icon(
              Icons.check_circle,
              color: color,
              size: 18,
            )
          : CircleAvatar(radius: 7, backgroundColor: color),
    );
  }
}

class TitleText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  const TitleText(
      {Key key,
      this.text,
      this.fontSize = 18,
      this.color = LightColor.titleTextColor,
      this.fontWeight = FontWeight.w800})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: GoogleFonts.muli(
            fontSize: fontSize, fontWeight: fontWeight, color: color));
  }
}

class LightColor {
  static const Color background = Color(0XFFFFFFFF);

  static const Color titleTextColor = const Color(0xff1d2635);
  static const Color subTitleTextColor = const Color(0xff797878);

  static const Color skyBlue = Color(0xff2890c8);
  static const Color lightBlue = Color(0xff5c3dff);

  static const Color orange = Color(0xffE65829);
  static const Color red = Color(0xffF72804);

  static const Color lightGrey = Color(0xffE1E2E4);
  static const Color grey = Color(0xffA1A3A6);
  static const Color darkgrey = Color(0xff747F8F);

  static const Color iconColor = Color(0xffa8a09b);
  static const Color yellowColor = Color(0xfffbba01);

  static const Color black = Color(0xff20262C);
  static const Color lightblack = Color(0xff5F5F60);
}

// class ImagenProducto extends StatelessWidget {
//   List<String> listProd = [
//     'https://plazaisabella.com/img/descuentos/descuentos-banner.jpg',
//     "https://elamigogeek.com/wp-content/uploads/2019/05/moto-z4-1013x1024.jpg"
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final responsive = Responsive.of(context);

//     return Padding(
//       padding: EdgeInsets.only(top: responsive.ip(6)),
//       child: Row(
//         children: [
//           Container(
//             color: Colors.blue,
//             width: responsive.wp(20),
//             height: responsive.hp(38),
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: listProd.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return Card(
//                     child: Container(
//                         height: responsive.hp(12),
//                         child: Image.network(listProd[index])));
//               },
//             ),
//           ),
//           Expanded(
//             child: GestureDetector(
//                 onTap: () {
//                   //Navigator.pushNamed(context, 'detalleProductoFoto', arguments: carrito);
//                 },
//                 onVerticalDragUpdate: (drag) {
//                   if (drag.primaryDelta > 7) {
//                     Navigator.pop(context);
//                   }
//                 },
//                 child: CarrouselProducto(listProd)),
//           )
//         ],
//       ),
//     );
//   }
// }

class CarrouselProducto extends StatelessWidget {
  final _pageController = PageController(viewportFraction: 0.9, initialPage: 1);
  //List<String> listProd = ["https://i.blogs.es/d07883/huawei-p40-pro-1/1366_2000.jpg","https://elamigogeek.com/wp-content/uploads/2019/05/moto-z4-1013x1024.jpg"];
  

  final List<String> listProd;
  CarrouselProducto(this.listProd);
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final size = MediaQuery.of(context).size;
    return _buildPageView(responsive, size);
  }

  _buildPageView(Responsive responsive, Size size) {
    return Padding(
      padding: EdgeInsets.only(top: responsive.ip(6)),
      child: Container(
        //width:
        //double.infinity,
        height: size.height * 0.38,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          color: Colors.transparent,
        ),
        // height: responsive.hp(19),
        child: PageView.builder(
          
            itemCount: listProd.length,
            controller: _pageController,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: responsive.wp(1)),
                //padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: GestureDetector(
                  onTap: () {},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      //cacheManager: CustomCacheManager(),
                      placeholder: (context, url) => Image(
                          image: AssetImage('assets/jar-loading.gif'),
                          fit: BoxFit.cover),
                      errorWidget: (context, url, error) => Image(
                          image: AssetImage('assets/carga_fallida.jpg'),
                          fit: BoxFit.cover),
                      imageUrl: listProd[index],
                      // 'https://plazaisabella.com/img/descuentos/descuentos-banner.jpg',
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
              );
            },
            onPageChanged: (int index) {}),
      ),
    );
  }
}

/* 


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guabba/api/productos/productos_api.dart';
import 'package:guabba/bloc/provider_bloc.dart';
import 'package:guabba/database/producto_bd.dart';
import 'package:guabba/models/productoModel.dart';
import 'package:guabba/utils/constants.dart';
import 'package:guabba/utils/responsive.dart';
import 'package:guabba/utils/utils.dart';

class DetalleProducto extends StatefulWidget {
  DetalleProducto({Key key}) : super(key: key);
 
  @override
  _DetalleProductoState createState() => _DetalleProductoState();
}

class _DetalleProductoState extends State<DetalleProducto> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final String id = ModalRoute.of(context).settings.arguments;
    final detailsProductoBloc = ProviderBloc.productos(context);
    detailsProductoBloc.detalleProductosPorIdSubsidiaryGood(id);

    //llenarTablaSugerenciaBusqueda(id,"bienes" );

    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            child: StreamBuilder(
                stream: detailsProductoBloc.detailsproductostream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length > 0) {
                      List<ProductoModel> listproduc = snapshot.data;
                      return Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  height: responsive.hp(45),
                                  width: double.infinity,
                                  child: Stack(
                                    children: [
                                      CachedNetworkImage(
                                        //cacheManager: CustomCacheManager(),
                                        placeholder: (context, url) => Image(
                                            image: AssetImage(
                                                'assets/jar-loading.gif'),
                                            fit: BoxFit.cover),
                                        errorWidget: (context, url, error) =>
                                            Image(
                                                image: AssetImage(
                                                    'assets/carga_fallida.jpg'),
                                                fit: BoxFit.cover),
                                        imageUrl:
                                            '$apiBaseURL/${listproduc[0].productoImage}',
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: (isDark)
                                                  ? Colors.white
                                                  : Colors.red,
                                            ),
                                            child: BackButton(
                                              color: (isDark)
                                                  ? Colors.black
                                                  : Colors.white,
                                            )),
                                        top: responsive.hp(5),
                                        left: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${listproduc[0].productoName} ${listproduc[0].productoBrand} ${listproduc[0].productoModel}",
                                        style: TextStyle(fontSize: 24),
                                        textAlign: TextAlign.center,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Seleccione"),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      children: <Widget>[
                                                        GestureDetector(
                                                          child: Text("Editar"),
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                        SizedBox(height: 8),
                                                        GestureDetector(
                                                          child: Text(
                                                              "Deshabilitar"),
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        "¿Está seguro de que desea deshabilitar el servicio?"),
                                                                    content: Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                          GestureDetector(
                                                                            child:
                                                                                Text("SI"),
                                                                            onTap:
                                                                                () async {
                                                                              //Navigator.pop(context);

                                                                              await _submitDeshabilitar(id, context);

                                                                              // if (subsidiaryGoodModel.subsidiaryServiceStatus=='1') {
                                                                              // }
                                                                              // else{
                                                                              //   final subserviceDb = SubsidiaryServiceDatabase();
                                                                              //   await subserviceDb.habilitarSubsidiaryServiceDb(subsidiaryGoodModel);
                                                                              // }
                                                                            },
                                                                          ),
                                                                          GestureDetector(
                                                                            child:
                                                                                Text("NO"),
                                                                            onTap:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                          ),
                                                                        ]),
                                                                  );
                                                                });
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        icon: Icon(Icons.edit),
                                      )
                                    ],
                                  ),
                                ),

                                Text(
                                  "${listproduc[0].productoCurrency} ${listproduc[0].productoPrice}",
                                  style: TextStyle(fontSize: 22),
                                ),
                                // Text(listproduc[0].subsidiaryGoodBrand),
                                // Text(listproduc[0].subsidiaryGoodModel),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Card(
                                      elevation: 2,
                                      child: Container(
                                        width: responsive.hp(30),
                                        height: responsive.hp(13),
                                        child: Column(children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text("Talla",
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                              Text("Stock",
                                                  style:
                                                      TextStyle(fontSize: 16))
                                            ],
                                          ),
                                          //Text(listproduc[0].subsidiaryGoodBrand),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 25.0, bottom: 15),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(listproduc[0]
                                                      .productoSize),
                                                  Text(listproduc[0]
                                                      .productoStock),
                                                ]),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ),
                                ),

                                Card(
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Text(
                                        'DESCRIPCION',
                                        style: TextStyle(
                                            fontSize: responsive.ip(2.0)),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        width: responsive.hp(50),
                                        height: responsive.hp(13),
                                        child: Text(
                                          ('${listproduc[0].productoCharacteristics}') ==
                                                  'null'
                                              ? "Ninguna descripcion por ahora"
                                              : ('${listproduc[0].productoCharacteristics}'),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 200),
                              ],
                            ),
                          ),
                          _agregarAlCarrito(responsive, listproduc, isDark)
                        ],
                      );
                    } else {
                      return Center(
                          child: Text('No tiene productos registrados'));
                    }
                  } else {
                    return Center(child: CupertinoActivityIndicator());
                  }
                }),
          ),
        ],
      ),
    );
  }

  Future _submitDeshabilitar(String id, BuildContext context) async {
    ProductoModel productoModel = ProductoModel();
    productoModel.idProducto = id;
    final productoApi = ProductosApi();
    final res = await productoApi.deshabilitarSubsidiaryProducto(id);
    if (res.toString() == '1') {
      final productoDatabase = ProductoDatabase();
      await productoDatabase.deshabilitarSubsidiaryProductoDb(productoModel);
      Navigator.pop(context);
      print('Producto Deshabilitado');
      //AlertDialog(title: Text("Servicio Deshabilitado"));
    } else {
      Navigator.pop(context);
      Navigator.pop(context);
      print('Estamos cagados');
    }

    // if (subsidiaryGoodModel.subsidiaryServiceStatus=='1') {
    // }
    // else{
    //   final subserviceDb = SubsidiaryServiceDatabase();
    //   await subserviceDb.habilitarSubsidiaryServiceDb(subsidiaryGoodModel);
    // }
  }

  Widget _agregarAlCarrito(Responsive responsive,
      List<ProductoModel> listproduc, bool isDark) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: responsive.hp(13),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(50.0),
            topRight: const Radius.circular(50.0),
          ),
          color: (isDark) ? Color(0xFF2C2B2B) : Colors.grey[300],
        ),
        //margin: EdgeInsets.only(top: responsive.hp(80)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "${listproduc[0].productoCurrency} ${listproduc[0].productoPrice}",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            RaisedButton(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                //padding: EdgeInsets.all(0.0),
                child: Text(
                  'Añadir al carrito',
                  style: TextStyle(fontSize: 16),
                ),
                color: Color(0xFFF93963),
                textColor: Colors.white,
                onPressed: () {
                  //  final buttonBloc = ProviderBloc.tabs(context);
                  // buttonBloc.changePage(2);
                  agregarAlCarrito(context, listproduc[0].idProducto);

                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("El producto se agregó al carrito"),
                        );
                      });
                }),
          ],
        ),
      ),
    );
  }
}
 */
