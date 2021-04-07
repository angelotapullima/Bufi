

import 'package:bufi/src/bloc/provider_bloc.dart';

import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/page/Tabs/Carrito/confirmacionPedido/confirmacion_pedido_item.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/AgregarAlCarritoAnimacion.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/detalleProducto/detalleProductoBloc.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:bufi/src/widgets/extentions.dart';
import 'package:bufi/src/widgets/translate_animation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class DetalleProductos extends StatefulWidget {
  final ProductoModel producto;
  const DetalleProductos({Key key, @required this.producto}) : super(key: key);

  @override
  _DetalleProductosState createState() => _DetalleProductosState();
}

class _DetalleProductosState extends State<DetalleProductos> {
  //controlador del PageView

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final datosProdBloc = ProviderBloc.datosProductos(context);
    datosProdBloc.listarDatosProducto(widget.producto.idProducto);
    //contador para el PageView
    final contadorBloc = ProviderBloc.contadorPagina(context);
    contadorBloc.changeContador(0);

    return Scaffold(
      body: StreamBuilder(
          stream: datosProdBloc.datosProdStream,
          builder: (context, AsyncSnapshot<List<ProductoModel>> listaGeneral) {
            List<ProductoModel> listProd = listaGeneral.data;

            bool _enabled = true;
            if (listaGeneral.hasData) {
              if (listProd.length > 0) {
                return Cuerpo(listProd: listProd);
              } else {
                return SafeArea(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: responsive.wp(5),
                          ),
                          BackButton(),
                          Spacer()
                        ],
                      ),
                      Expanded(
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          enabled: _enabled,
                          child: ListView.builder(
                            itemBuilder: (_, __) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 48.0,
                                    height: 48.0,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: double.infinity,
                                          height: 8.0,
                                          color: Colors.white,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.0),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          height: 8.0,
                                          color: Colors.white,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.0),
                                        ),
                                        Container(
                                          width: 40.0,
                                          height: 8.0,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            itemCount: 6,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            } else {
              return SafeArea(
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: responsive.wp(5),
                        ),
                        BackButton(),
                        Spacer()
                      ],
                    ),
                    Expanded(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        enabled: _enabled,
                        child: ListView.builder(
                          itemBuilder: (_, __) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 48.0,
                                  height: 48.0,
                                  color: Colors.white,
                                ),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: double.infinity,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 2.0),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 2.0),
                                      ),
                                      Container(
                                        width: 40.0,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          itemCount: 6,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}

class Cuerpo extends StatefulWidget {
  const Cuerpo({
    Key key,
    @required this.listProd,
  }) : super(key: key);

  final List<ProductoModel> listProd;

  @override
  _CuerpoState createState() => _CuerpoState();
}

class _CuerpoState extends State<Cuerpo> {
  @override
  Widget build(BuildContext context) {
    final contadorBloc = ProviderBloc.contadorPagina(context);
    final responsive = Responsive.of(context);

    final provider = Provider.of<DetalleProductoBloc>(context, listen: false);

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
            Radius.circular(100),
          ),
          color: isOutLine ? Colors.white : Colors.white,
        ),
        child: Center(
          child: Icon(icon, color: color, size: size),
        ),
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

    return ValueListenableBuilder<int>(
        valueListenable: provider.show,
        builder: (_, value, __) {
          return Stack(
            children: <Widget>[

              BackGroundImage(listProd:  widget.listProd,),
              

              // Iconos arriba de la imagen del producto
              SafeArea(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Row(
                    children: <Widget>[
                      //BackButton(),

                      SizedBox(
                        width: responsive.wp(5),
                      ),
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
                      Spacer(),
                      //contador de páginas
                      StreamBuilder(
                          stream: contadorBloc.selectContadorStream,
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
                                (contadorBloc.pageContador + 1).toString() +
                                    '/' +
                                    widget.listProd[0].listFotos.length
                                        .toString(),
                              ),
                            );
                          }),

                      Spacer(),

                      _icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.black54,
                        size: responsive.ip(2.4),
                        padding: responsive.ip(1.25),
                        // isOutLine: false,
                        onPressed: () {
                          final buttonBloc = ProviderBloc.tabs(context);
                          buttonBloc.changePage(2);
                        },
                      ),
                      GestureDetector(
                        child: Icon(Icons.arrow_right_outlined),
                        onTap: () {
                          final buttonBloc = ProviderBloc.tabs(context);
                          buttonBloc.changePage(2);
                        },
                      ),

                      SizedBox(
                        width: responsive.wp(5),
                      ),
                    ],
                  ),
                ),
              ),
              TranslateAnimation(
                duration: const Duration(milliseconds: 400),
                child: _contenido(responsive, context, widget.listProd, value),
              ),

              BotonAgregar(responsive: responsive, listProd: widget.listProd)
            ],
          );
        });
  }

  Widget _contenido(Responsive responsive, BuildContext context,
      List<ProductoModel> listProd, int value) {
    return Container(
      margin: EdgeInsets.only(
        top: responsive.hp(21),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.7,
        builder: (context, scrollController) {
          return Container(
            //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TitleText(
                            text: "${listProd[value].productoName}",
                            fontSize: responsive.ip(2)),
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
                                  text: "${listProd[value].productoPrice}",
                                  fontSize: responsive.ip(2),
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
                  TallasProductos(
                    productos: listProd,
                  ),
                  ModelosProductos(
                    productos: listProd,
                  ),
                  MarcasProductos(
                    productos: listProd,
                  ),
                  SizedBox(
                    height: responsive.hp(2),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                    child: Text(
                      '$lorepIpsum',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: responsive.ip(1.6)),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }


}


class BackGroundImage extends StatefulWidget {
  const BackGroundImage({Key key, @required this.listProd}) : super(key: key);

  final List<ProductoModel> listProd;

  @override
  _BackGroundImageState createState() => _BackGroundImageState();
}

class _BackGroundImageState extends State<BackGroundImage> {

  final _pageController = PageController(viewportFraction: 1, initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
 final provider = Provider.of<DetalleProductoBloc>(context, listen: false);

    final contadorBloc = ProviderBloc.contadorPagina(context);


    return ValueListenableBuilder<int>(
        valueListenable: provider.show,
        builder: (_, value, __) {
        return Container(
          height: size.height * 0.47,
          width: double.infinity,
          child: Stack(
            children: [
              PageView.builder(
                  itemCount: widget.listProd[value].listFotos.length,
                  controller: _pageController,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, 'detalleProductoFoto',
                              arguments: widget.listProd);
                        },
                        child: Hero(
                          tag:
                              '$apiBaseURL/${widget.listProd[value].listFotos[index].galeriaFoto}',
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

                              imageUrl:
                                  '$apiBaseURL/${widget.listProd[value].listFotos[index].galeriaFoto}',

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
                      ),
                    );
                  },
                  onPageChanged: (int index) {
                    contadorBloc.changeContador(index);
                  }),
            ],
          ),
        );
      }
    );
  
  }
}

class MarcasProductos extends StatelessWidget {
  const MarcasProductos({
    Key key,
    @required this.productos,
  }) : super(key: key);

  final List<ProductoModel> productos;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DetalleProductoBloc>(context, listen: false);

    final responsive = Responsive.of(context);
    return ValueListenableBuilder<int>(
        valueListenable: provider.show,
        builder: (_, value, __) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(5),
                  ),
                  child: Text(
                    'Marcas',
                    style: TextStyle(
                        fontSize: responsive.ip(2),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: responsive.hp(1),
                ),
                Container(
                  height: responsive.hp(4.5),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: productos.length,
                      itemBuilder: (_, index) {
                        return InkWell(
                          onTap: () {
                            provider.changeIndex(index);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: responsive.wp(3),
                            ),
                            margin: EdgeInsets.only(
                              right: responsive.wp(.5),
                              left: responsive.wp(2),
                            ),
                            decoration: BoxDecoration(
                              color:
                                  (index == value) ? Colors.blue : Colors.red,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                productos[index].productoBrand,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: responsive.ip(1.5),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                )

                //_description(),
              ],
            ),
          );
        });
  }
}

class ModelosProductos extends StatelessWidget {
  const ModelosProductos({
    Key key,
    @required this.productos,
  }) : super(key: key);

  final List<ProductoModel> productos;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DetalleProductoBloc>(context, listen: false);
    final responsive = Responsive.of(context);

    return ValueListenableBuilder<int>(
        valueListenable: provider.show,
        builder: (_, value, __) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(5),
                  ),
                  child: Text(
                    'Modelos',
                    style: TextStyle(
                        fontSize: responsive.ip(2),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: responsive.hp(1),
                ),
                Container(
                  height: responsive.hp(4.5),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: productos.length,
                      itemBuilder: (_, index) {
                        return InkWell(
                          onTap: () {
                            provider.changeIndex(index);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: responsive.wp(3),
                            ),
                            margin: EdgeInsets.only(
                              right: responsive.wp(.5),
                              left: responsive.wp(2),
                            ),
                            decoration: BoxDecoration(
                              color:
                                  (index == value) ? Colors.blue : Colors.red,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                productos[index].productoModel,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: responsive.ip(1.5),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                )

                //_description(),
              ],
            ),
          );
        });
  }
}

class TallasProductos extends StatelessWidget {
  const TallasProductos({
    Key key,
    @required this.productos,
  }) : super(key: key);

  final List<ProductoModel> productos;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DetalleProductoBloc>(context, listen: false);
    final responsive = Responsive.of(context);

    return ValueListenableBuilder<int>(
        valueListenable: provider.show,
        builder: (_, value, __) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(5),
                  ),
                  child: Text(
                    'Tallas',
                    style: TextStyle(
                        fontSize: responsive.ip(2),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: responsive.hp(1),
                ),
                Container(
                  height: responsive.hp(4.5),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: productos.length,
                      itemBuilder: (_, index) {
                        return InkWell(
                          onTap: () {
                            provider.changeIndex(index);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: responsive.wp(3),
                            ),
                            margin: EdgeInsets.only(
                              right: responsive.wp(.5),
                              left: responsive.wp(2),
                            ),
                            decoration: BoxDecoration(
                              color:
                                  (index == value) ? Colors.blue : Colors.red,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                productos[index].productoSize,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: responsive.ip(1.5),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                )

                //_description(),
              ],
            ),
          );
        });
  }
}

class BotonAgregar extends StatelessWidget {
  const BotonAgregar({
    Key key,
    @required this.responsive,
    @required this.listProd,
  }) : super(key: key);

  final Responsive responsive;
  final List<ProductoModel> listProd;

  @override
  Widget build(BuildContext context) {
    final contadorBloc = ProviderBloc.contadorPagina(context);

    final provider = Provider.of<DetalleProductoBloc>(context, listen: false);

    return StreamBuilder(
        stream: contadorBloc.selectContadorStream,
        builder: (context, snapshot) {
          return ValueListenableBuilder<int>(
              valueListenable: provider.show,
              builder: (_, value, __) {
                return Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    child: Row(
                      children: [
                        Container(
                          width: responsive.wp(40),
                          padding: EdgeInsets.only(
                            bottom: responsive.hp(3),
                            top: responsive.hp(1),
                            left: responsive.wp(3),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[400],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.donut_large_outlined,
                                color: Colors.white,
                              ),
                              Text(
                                ' Pedir ahora',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: responsive.ip(1.8),
                                ),
                              ),
                            ],
                          ),
                        ).ripple(() async {
                          //Tallas

                          await agregarAlCarrito(
                              context,
                              listProd[value].idProducto,
                              listProd[value].productoSize,
                              listProd[value].productoModel,
                              listProd[value].productoBrand);

                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 300),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return ConfirmacionItemPedido(
                                    idProducto: listProd[value].idProducto
                                    //widget.producto.idProducto
                                    );
                                //return DetalleProductitos(productosData: productosData);
                              },
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        }),
                        Container(
                          width: responsive.wp(60),
                          padding: EdgeInsets.only(
                            bottom: responsive.hp(3),
                            top: responsive.hp(1),
                            left: responsive.wp(3),
                            right: responsive.wp(10),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[600],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.white,
                              ),
                              Text(
                                ' Agregar a la cesta',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: responsive.ip(1.8),
                                ),
                              ),
                            ],
                          ),
                        ).ripple(() async {
                          await agregarAlCarrito(
                              context,
                              listProd[value].idProducto,
                              listProd[value].productoSize,
                              listProd[value].productoModel,
                              listProd[value].productoBrand);

                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              opaque: false,
                              transitionDuration:
                                  const Duration(milliseconds: 300),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return Agregarcarrito(
                                  urlImage:
                                      '$apiBaseURL/${listProd[value].listFotos[contadorBloc.pageContador].galeriaFoto}',
                                );
                                //return DetalleProductitos(productosData: productosData);
                              },
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              });
        });
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
