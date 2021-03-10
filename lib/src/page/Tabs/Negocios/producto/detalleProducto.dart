import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/database/marcaProducto_database.dart';
import 'package:bufi/src/database/modeloProducto_database.dart';
import 'package:bufi/src/database/tallaProducto_database.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/page/Tabs/Carrito/confirmacionPedido/confirmacion_pedido_item.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/detalle_carrito.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:bufi/src/widgets/extentions.dart';
import 'package:bufi/src/widgets/translate_animation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bufi/src/utils/utils.dart' as utils;
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:shimmer/shimmer.dart';

class DetalleProductos extends StatefulWidget {
  final ProductoModel producto;
  const DetalleProductos({Key key, @required this.producto}) : super(key: key);

  @override
  _DetalleProductosState createState() => _DetalleProductosState();
}

class _DetalleProductosState extends State<DetalleProductos> {
  //controlador del PageView
  final _pageController = PageController(viewportFraction: 1, initialPage: 0);
  //int pagActual = 0;
  final tallaProductoDb = TallaProductoDatabase();
  final marcaProductoDb = MarcaProductoDatabase();
  final modeloProductoDb = ModeloProductoDatabase();

  @override
  void initState() {
    limpiarOpciones();
    super.initState();
  }

  void limpiarOpciones() {
    tallaProductoDb.updateEstadoa0();
    marcaProductoDb.updateEstadoa0();
    modeloProductoDb.updateEstadoa0();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final datosProdBloc = ProviderBloc.datosProductos(context);
    datosProdBloc.listarDatosProducto(widget.producto.idProducto);
    //contador para el PageView
    final contadorBloc = ProviderBloc.contadorPagina(context);
    contadorBloc.changeContador(0);

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

    bool isLiked = false;
    return Scaffold(
      body: StreamBuilder(
          stream: datosProdBloc.datosProdStream,
          builder: (context, AsyncSnapshot<List<ProductoModel>> snapshot) {
            List<ProductoModel> listProd = snapshot.data;
            if (snapshot.hasData) {
              if (listProd[0].listTallaProd.length > 0) {
                return Stack(
                  children: <Widget>[
                    _backgroundImage(
                        context, responsive, listProd, contadorBloc),

                    // Iconos arriba de la imagen del producto
                    SafeArea(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
                                      border:
                                          Border.all(color: Colors.grey[300]),
                                    ),
                                    margin: EdgeInsets.symmetric(
                                      horizontal: responsive.wp(5),
                                      vertical: responsive.hp(1.3),
                                    ),
                                    child: Text(
                                      (contadorBloc.pageContador + 1)
                                              .toString() +
                                          '/' +
                                          listProd[0]
                                              .listFotos
                                              .length
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
                            // _icon(
                            //     isLiked
                            //         ? Icons.favorite
                            //         : Icons.favorite_border,
                            //     color: isLiked
                            //         ? LightColor.lightGrey
                            //         : LightColor.red,
                            //     size: responsive.ip(1.7),
                            //     padding: responsive.ip(1.25),
                            //     isOutLine: false, onPressed: () {
                            //   setState(() {
                            //     isLiked = !isLiked;
                            //   });
                            // }),
                            SizedBox(
                              width: responsive.wp(5),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TranslateAnimation(
                      duration: const Duration(milliseconds: 400),
                      child: _contenido(responsive, context, listProd),
                    ),

                    BotonAgregar(
                        responsive: responsive,
                        producto: widget.producto,
                        listProd: listProd)
                  ],
                );
              } else {
                return Center(
                  child: NutsActivityIndicator(
                    radius: responsive.ip(1),
                    activeColor: Colors.white,
                    inactiveColor: Colors.redAccent,
                    tickCount: 11,
                    startRatio: 0.55,
                    animationDuration: Duration(milliseconds: 2003),
                  ),
                );
              }
            } else {
              return Center(
                child: NutsActivityIndicator(
                  radius: responsive.ip(1),
                  activeColor: Colors.white,
                  inactiveColor: Colors.redAccent,
                  tickCount: 11,
                  startRatio: 0.55,
                  animationDuration: Duration(milliseconds: 2003),
                ),
              );
            }
          }),
    );
  }

  Widget _backgroundImage(BuildContext context, Responsive responsive,
      List<ProductoModel> listProd, contadorBloc) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.47,
      width: double.infinity,
      child: Stack(
        children: [
          PageView.builder(
              itemCount: listProd[0].listFotos.length,
              controller: _pageController,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'detalleProductoFoto',
                          arguments: listProd[0]);
                    },
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
                            '$apiBaseURL/${listProd[0].listFotos[index].galeriaFoto}',

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
              onPageChanged: (int index) {
                contadorBloc.changeContador(index);
              }),
        ],
      ),
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
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
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
                  (listProd[0].listTallaProd.length > 1)
                      ? _talla(responsive, listProd)
                      : Container(),
                  (listProd[0].listMarcaProd.length > 1)
                      ? _marca(responsive, listProd)
                      : Container(),
                  (listProd[0].listModeloProd.length > 1)
                      ? _modelo(responsive, listProd)
                      : Container(),
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
     bool _enabled = true;
    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
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
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              height: 8.0,
                              color: Colors.white,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.0),
                            ),
                            Container(
                              width: double.infinity,
                              height: 8.0,
                              color: Colors.white,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.0),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: FlatButton(
                onPressed: () {
                  setState(() {
                    _enabled = !_enabled;
                  });
                },
                child: Text(
                  _enabled ? 'Stop' : 'Play',
                  style: Theme.of(context).textTheme.button.copyWith(
                      fontSize: 18.0,
                      color: _enabled ? Colors.redAccent : Colors.green),
                )),
          )
        ],
      ),
    );

    // Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: <Widget>[
    //     TitleText(
    //       text: "Available Size",
    //       fontSize: 14,
    //     ),
    //     SizedBox(height: 20),
    //     Text(
    //         "Clean lines, versatile and timeless—the people shoe returns with the Nike Air Max 90. Featuring the same iconic Waffle sole, stitched overlays and classic TPU accents you come to love, it lets you walk among the pantheon of Air. ßNothing as fly, nothing as comfortable, nothing as proven. The Nike Air Max 90 stays true to its OG running roots with the iconic Waffle sole, stitched overlays and classic TPU details. Classic colours celebrate your fresh look while Max Air cushioning adds comfort to the journey."),
    //   ],
    // );
  }

  Widget _talla(Responsive responsive, List<ProductoModel> listProd) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(
          text: "Tallas",
          fontSize: 14,
        ),
        Container(
          height: responsive.hp(8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: listProd[0].listTallaProd.length,
            itemBuilder: (BuildContext context, int index) {
              return _tallaWidget(listProd, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _marca(Responsive responsive, List<ProductoModel> listProd) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(
          text: "Marcas",
          fontSize: 14,
        ),
        SizedBox(
          height: responsive.hp(1),
        ),
        Container(
          height: responsive.hp(8),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: listProd[0].listMarcaProd.length,
            itemBuilder: (BuildContext context, int index) {
              return _marcaWidget(listProd, index);
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: <Widget>[
              //     _marcaWidget(listProd, index),
              //     //_sizeWidget("US 7", isSelected: true),
              //   ],
              // );
            },
          ),
        ),
      ],
    );
  }

  Widget _modelo(Responsive responsive, List<ProductoModel> listProd) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(
          text: "Modelo",
          fontSize: 14,
        ),
        SizedBox(height: responsive.hp(1)),
        Container(
          height: responsive.hp(8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: listProd[0].listModeloProd.length,
            itemBuilder: (BuildContext context, int index) {
              return _modeloWidget(listProd, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _tallaWidget(List<ProductoModel> listProd, int index) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
              color: LightColor.iconColor,
              style: (listProd[0].listTallaProd[index].estado == '1')
                  ? BorderStyle.solid
                  : BorderStyle.none),
          borderRadius: BorderRadius.all(Radius.circular(13)),
          color: (listProd[0].listTallaProd[index].estado == '1')
              ? LightColor.red
              : Theme.of(context).backgroundColor,
        ),
        child: TitleText(
          text: listProd[0].listTallaProd[index].tallaProducto,
          fontSize: 16,
          color: (listProd[0].listTallaProd[index].estado == '1')
              ? LightColor.background
              : LightColor.titleTextColor,
        ),
      ).ripple(() async {
        print('presionado ${listProd[0].listTallaProd[index].idTallaProducto}');

        await cambiarEstadoTalla(context, listProd[0].listTallaProd[index]);
      }, borderRadius: BorderRadius.all(Radius.circular(13))),
    );
  }

  Widget _marcaWidget(List<ProductoModel> listProd, int index,
      {bool isSelected = false}) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
              color: LightColor.iconColor,
              style: !isSelected ? BorderStyle.solid : BorderStyle.none),
          borderRadius: BorderRadius.all(Radius.circular(13)),
          color: (listProd[0].listMarcaProd[index].estado == '1')
              ? LightColor.red
              : Theme.of(context).backgroundColor,
        ),
        child: TitleText(
          text: listProd[0].listMarcaProd[index].marcaProducto,
          fontSize: 16,
          color: (listProd[0].listMarcaProd[index].estado == '1')
              ? LightColor.background
              : LightColor.titleTextColor,
        ),
      ).ripple(
        () async {
          print(
              'presionado ${listProd[0].listMarcaProd[index].idMarcaProducto}');

          await cambiarEstadoMarca(context, listProd[0].listMarcaProd[index]);
          //print("estado ${listProd[0].listMarcaProd[index].estado}");
        },
        borderRadius: BorderRadius.all(
          Radius.circular(13),
        ),
      ),
    );
  }

  Widget _modeloWidget(List<ProductoModel> listProd, int index,
      {bool isSelected = false}) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
              color: LightColor.iconColor,
              style: !isSelected ? BorderStyle.solid : BorderStyle.none),
          borderRadius: BorderRadius.all(Radius.circular(13)),
          color: (listProd[0].listModeloProd[index].estado == '1')
              ? LightColor.red
              : Theme.of(context).backgroundColor,
        ),
        child: TitleText(
          text: listProd[0].listModeloProd[index].modeloProducto,
          fontSize: 16,
          color: (listProd[0].listModeloProd[index].estado == '1')
              ? LightColor.background
              : LightColor.titleTextColor,
        ),
      ).ripple(
        () async {
          await cambiarEstadoModelo(context, listProd[0].listModeloProd[index]);
        },
        borderRadius: BorderRadius.all(
          Radius.circular(13),
        ),
      ),
    );
  }
}

class BotonAgregar extends StatelessWidget {
  const BotonAgregar({
    Key key,
    @required this.responsive,
    @required this.producto,
    @required this.listProd,
  }) : super(key: key);

  final Responsive responsive;
  final ProductoModel producto;
  final List<ProductoModel> listProd;

  @override
  Widget build(BuildContext context) {
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
              final tallaDatabase = TallaProductoDatabase();
              final tallas = await tallaDatabase
                  .obtenerTallaProductoPorIdProductoEnEstado1(
                      producto.idProducto);
              //widget.producto.idProducto);
              //modelo
              final modeloDatabase = ModeloProductoDatabase();
              final modelos = await modeloDatabase
                  .obtenerModeloProductoPorIdProductoEnEstado1(
                      producto.idProducto);
              //Marca
              final marcaDatabase = MarcaProductoDatabase();
              final marcas = await marcaDatabase
                  .obtenerMarcaProductoPorIdProductoEnEstado1(
                      producto.idProducto);

              if (tallas.length > 0) {
                if (modelos.length > 0) {
                  if (marcas.length > 0) {
                    await agregarAlCarrito(
                        context,
                        producto.idProducto,
                        tallas[0].tallaProducto,
                        modelos[0].modeloProducto,
                        marcas[0].marcaProducto);

                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return ConfirmacionItemPedido(
                              idProducto: producto.idProducto
                              //widget.producto.idProducto
                              );
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
                  } else {
                    utils.showToast(context, 'Por favor seleccione una marca');
                  }
                } else {
                  utils.showToast(context, 'Por favor seleccione un modelo');
                }
              } else {
                utils.showToast(context, 'Por favor seleccione una talla');
              }
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
              if (listProd[0].listTallaProd.length == 1) {
                await cambiarEstadoTalla(context, listProd[0].listTallaProd[0]);
              }
              if (listProd[0].listMarcaProd.length == 1) {
                await cambiarEstadoMarca(context, listProd[0].listMarcaProd[0]);
              }
              if (listProd[0].listModeloProd.length == 1) {
                await cambiarEstadoModelo(
                    context, listProd[0].listModeloProd[0]);
              }

              //Tallas
              final tallaDatabase = TallaProductoDatabase();
              final tallasSeleccionado = await tallaDatabase
                  .obtenerTallaProductoPorIdProductoEnEstado1(
                      producto.idProducto);

              //modelo
              final modeloDatabase = ModeloProductoDatabase();
              final modelosSeleccionados = await modeloDatabase
                  .obtenerModeloProductoPorIdProductoEnEstado1(
                      producto.idProducto);
              //Marca
              final marcaDatabase = MarcaProductoDatabase();
              final marcasSeleccionadas = await marcaDatabase
                  .obtenerMarcaProductoPorIdProductoEnEstado1(
                      producto.idProducto);

              if (tallasSeleccionado.length > 0) {
                if (modelosSeleccionados.length > 0) {
                  if (marcasSeleccionadas.length > 0) {
                    await agregarAlCarrito(
                        context,
                        producto.idProducto,
                        tallasSeleccionado[0].tallaProducto,
                        modelosSeleccionados[0].modeloProducto,
                        marcasSeleccionadas[0].marcaProducto);

                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return DetalleCarrito(producto: producto);
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
                  } else {
                    utils.showToast(context, 'Por favor seleccione una marca');
                  }
                } else {
                  utils.showToast(context, 'Por favor seleccione un modelo');
                }
              } else {
                utils.showToast(context, 'Por favor seleccione una talla');
              }
            }),
          ],
        ),
      ),
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
