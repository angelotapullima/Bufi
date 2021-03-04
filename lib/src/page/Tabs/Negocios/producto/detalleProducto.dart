import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/galeriaProductoModel.dart';
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
 
  //controlador del PageView
  final _pageController = PageController(viewportFraction: 0.9, initialPage: 0);
  int pagActual = 0;

  @override
  void initState() {
    super.initState();
    currentPage();
  }

  void currentPage() {
    _pageController.addListener(() {
      setState(() {
        pagActual = _pageController.page.toInt();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final datosProdBloc = ProviderBloc.datosProductos(context);
    datosProdBloc.listarDatosProducto('3');

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
        body: StreamBuilder(
            stream: datosProdBloc.datosProdStream,
            builder: (context, AsyncSnapshot<List<ProductoModel>> snapshot) {
              List<ProductoModel> listProd = snapshot.data;
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  return Stack(
                    children: <Widget>[
                      _backgroundImage(
                          context, responsive, pagActual, listProd),

                      // Iconos arriba de la imagen del producto
                      SafeArea(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
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
                              //contador de páginas
                              Container(
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
                                child: Text((pagActual + 1).toString() +
                                    '/' +
                                    listProd[0].listFotos.length.toString()),
                              ),

                              _icon(
                                  isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isLiked
                                      ? LightColor.lightGrey
                                      : LightColor.red,
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
                        child: _contenido(responsive, context, listProd),
                      ),
                    ],
                  );
                } else {
                  return Container(
                    child: Text('vacio'),
                  );
                }
              } else {
                return Container(
                  child: Text('nulo'),
                );
              }
            }));
  }

  Widget _backgroundImage(BuildContext context, Responsive responsive,
      int pagActual, List<ProductoModel> listProd) {
    final size = MediaQuery.of(context).size;

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
          child: Padding(
            padding: EdgeInsets.only(top: responsive.ip(6)),
            child: Container(
              // color: Colors.red,

              height: size.height * 0.38,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                color: Colors.transparent,
              ),
              // height: responsive.hp(19),
              child: Stack(
                children: [
                  PageView.builder(
                      itemCount: listProd[0].listFotos.length,
                      controller: _pageController,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: responsive.wp(1)),

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
                                          image: AssetImage(
                                              'assets/jar-loading.gif'),
                                          fit: BoxFit.cover),

                                      errorWidget: (context, url, error) =>
                                          Image(
                                              image: AssetImage(
                                                  'assets/carga_fallida.jpg'),
                                              fit: BoxFit.cover),

                                      imageUrl:
                                          '$apiBaseURL/${listProd[0].listFotos[index].galeriaFoto}',

                                      imageBuilder: (context, imageProvider) =>
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
                              );
                      },
                      onPageChanged: (int index) {
                        //_currentPageNotifier.value = index;
                        //contadorProductos.changeContador(index);
                      }),
                  // Positioned(
                  //   left: 0.0,
                  //   right: 0.0,
                  //   bottom: responsive.hp(3.2),
                  //   child: CirclePageIndicator(
                  //     selectedDotColor: Colors.black,
                  //     dotColor: Colors.grey[400],
                  //     itemCount: listProd.length,
                  //     currentPageNotifier: _currentPageNotifier,

                  //   ),
                  // )
                ],
              ),
            ),
          )),
    );
  }

  Widget _contenido(Responsive responsive, BuildContext context,
      List<ProductoModel> listProd) {
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
                  _availableSize2(listProd),
                  SizedBox(
                    height: 20,
                  ),
                  _availableColor(),
                  SizedBox(
                    height: 20,
                  ),
                  _marca(listProd),
                  _modelo(listProd),
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

  Widget _availableSize2( List<ProductoModel> listProd) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleText(
          text: "Tallas",
          fontSize: 14,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _sizeWidget2(listProd),
            // _sizeWidget("US 6"),
             _sizeWidget("US 7", isSelected: true),
            // _sizeWidget("US 8"),
            // _sizeWidget("US 9"),
          ],
        )
      ],
    );
  }

  Widget _marca( List<ProductoModel> listProd) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleText(
          text: "Marcas",
          fontSize: 14,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _marcaWidget(listProd),
            // _sizeWidget("US 6"),
             _sizeWidget("US 7", isSelected: true),
            // _sizeWidget("US 8"),
            // _sizeWidget("US 9"),
          ],
        )
      ],
    );
  }

  Widget _modelo( List<ProductoModel> listProd) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleText(
          text: "Modelo",
          fontSize: 14,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _modeloWidget(listProd),
            // _sizeWidget("US 6"),
             _sizeWidget("US 7", isSelected: true),
            // _sizeWidget("US 8"),
            // _sizeWidget("US 9"),
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

  Widget _sizeWidget2(List<ProductoModel> listProd, {bool isSelected = false}) {
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
        text: listProd[0].listTallaProd[0].tallaProducto,
        fontSize: 16,
        color: isSelected ? LightColor.background : LightColor.titleTextColor,
      ),
    ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(13)));
  }

  Widget _marcaWidget(List<ProductoModel> listProd, {bool isSelected = false}) {
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
        text: listProd[0].listMarcaProd[0].marcaProducto,
        fontSize: 16,
        color: isSelected ? LightColor.background : LightColor.titleTextColor,
      ),
    ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(13)));
  }

  Widget _modeloWidget(List<ProductoModel> listProd, {bool isSelected = false}) {
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
        text: listProd[0].listModeloProd[0].modeloProducto,
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
