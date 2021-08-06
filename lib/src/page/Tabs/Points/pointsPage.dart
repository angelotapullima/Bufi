import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/pointModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/models/subsidiaryService.dart';
import 'package:bufi/src/page/Tabs/Negocios/Sucursal/detailsSubsidiary/detalleSubsidiary.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/detalleProducto/detalleProducto.dart';
import 'package:bufi/src/page/Tabs/Points/points_bloc.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:bufi/src/utils/utils.dart' as utils;

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

    final provider = Provider.of<PointsBlocListener>(context, listen: false);

    final responsive = Responsive.of(context);
    return Scaffold(
      body: StreamBuilder(
        stream: pointsProdBloc.favProductoStrem,
        builder: (BuildContext context, AsyncSnapshot<List<PointModel>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return SafeArea(
                child: Column(children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: provider.show,
                    builder: (_, value, __) {
                      return (value)
                          ? Container(
                              color: Colors.transparent,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: responsive.wp(5),
                                vertical: responsive.hp(1),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Mis Points',
                                    style: TextStyle(color: Colors.black, fontSize: responsive.ip(3), fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              color: Colors.transparent,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: responsive.wp(5), vertical: responsive.hp(1)),
                              child: Text(
                                'Mis Points',
                                style: TextStyle(color: Colors.transparent, fontSize: responsive.ip(2.5), fontWeight: FontWeight.w700),
                              ),
                            );
                    },
                  ),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        controller: provider.controller,
                        //scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length + 1,
                        itemBuilder: (context, index) {
                          bool productosList = false;
                          bool servicesList = false;

                          if (index == 0) {
                            return Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.symmetric(
                                horizontal: responsive.wp(5),
                                // vertical: responsive.hp(1),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Mis Points',
                                    style: TextStyle(color: Colors.black, fontSize: responsive.ip(3), fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            );
                          }
                          int xxx = index - 1;
                          //Lista que muestra los productos por sucursal
                          if (snapshot.data[xxx].listProducto.length > 0) {
                            productosList = true;
                          }
                          if (snapshot.data[xxx].listServicio.length > 0) {
                            servicesList = true;
                          }
                          return (productosList && servicesList)
                              ? AmbosVerdaderos(
                                  xxx: xxx,
                                  ambos: snapshot.data,
                                )
                              : (productosList && !servicesList)
                                  ? ProductosVerdaderos(xxx: xxx, producto: snapshot.data)
                                  : (!productosList && servicesList)
                                      ? ServiciosVerdaderos(xxx: xxx, servicios: snapshot.data)
                                      : _soloSucursal(responsive, context, snapshot, xxx);
                        }),
                  )
                ]),
              );
            } else {
              return SafeArea(
                child: Column(
                  children: [
                    Container(
                      color: Colors.transparent,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(5),
                        vertical: responsive.hp(1),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Mis Points',
                            style: TextStyle(color: Colors.black, fontSize: responsive.ip(3), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text('No hay Points'),
                      ),
                    ),
                  ],
                ),
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

  Widget _soloSucursal(Responsive responsive, BuildContext context, AsyncSnapshot<List<PointModel>> snapshot, int xxx) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.horizontal,
      background: Container(
        margin: EdgeInsets.symmetric(
          horizontal: responsive.wp(1),
        ),
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.delete, color: Colors.white),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        quitarSubsidiaryFavoritodePointPage(context, snapshot.data[xxx]);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.symmetric(
          vertical: responsive.hp(1),
          horizontal: responsive.wp(2),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: responsive.wp(3),
          vertical: responsive.wp(2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${snapshot.data[xxx].subsidiaryName}',
                  style: TextStyle(fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetalleSubsidiary(
                              idSucursal: snapshot.data[xxx].idSubsidiary,
                              nombreSucursal: snapshot.data[xxx].subsidiaryName,
                              imgSucursal: snapshot.data[xxx].subsidiaryImg,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(1),
                          vertical: responsive.hp(.5),
                        ),
                        child: Text(
                          'Ver más',
                          style: TextStyle(color: Colors.white),
                        ),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.red),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        quitarSubsidiaryFavoritodePointPage(context, snapshot.data[xxx]);
                      },
                    )
                  ],
                )
              ],
            ),
            Row(
              children: [
                Text(
                  '${snapshot.data[xxx].companyRating}',
                  style: TextStyle(
                    fontSize: responsive.ip(1.8),
                  ),
                ),
                Icon(
                  Icons.star,
                  color: Colors.yellow,
                )
              ],
            ),
            Text(
              '${snapshot.data[xxx].subsidiaryAddress}',
              style: TextStyle(
                fontSize: responsive.ip(1.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void quitarSubsidiaryFavorito(BuildContext context, SubsidiaryModel data) {}
}

class ProductosVerdaderos extends StatelessWidget {
  const ProductosVerdaderos({
    Key key,
    @required this.xxx,
    @required this.producto,
  }) : super(key: key);

  final int xxx;
  final List<PointModel> producto;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          margin: EdgeInsets.all(3),
          width: double.infinity,
          color: Colors.blueGrey[100],
          child: Text(
            '${producto[xxx].subsidiaryName}',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Container(
          height: responsive.hp(34),
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: producto[xxx].listProducto.length,
              itemBuilder: (BuildContext context, int i) {
                final goodData = producto[xxx].listProducto[i];

                return WidgetBienesFavoritos(responsive: responsive, goodData: goodData);
              }),
        ),
      ],
    );
  }
}

class ServiciosVerdaderos extends StatelessWidget {
  const ServiciosVerdaderos({
    Key key,
    @required this.xxx,
    @required this.servicios,
  }) : super(key: key);

  final int xxx;
  final List<PointModel> servicios;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Container(
      height: responsive.hp(74),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            margin: EdgeInsets.all(3),
            width: double.infinity,
            color: Colors.blueGrey[100],
            child: Text(
              '${servicios[xxx].subsidiaryName}',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            height: responsive.hp(34),
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: servicios[xxx].listServicio.length,
                itemBuilder: (BuildContext context, int i) {
                  final goodData = servicios[xxx].listServicio[i];

                  return WidgetServiciosFavoritos(responsive: responsive, serviceData: goodData);
                }),
          ),
        ],
      ),
    );
  }
}

class AmbosVerdaderos extends StatelessWidget {
  const AmbosVerdaderos({
    Key key,
    @required this.xxx,
    @required this.ambos,
  }) : super(key: key);

  final int xxx;
  final List<PointModel> ambos;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          margin: EdgeInsets.all(3),
          width: double.infinity,
          color: Colors.blueGrey[100],
          child: Text(
            '${ambos[xxx].subsidiaryName}',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Container(
          height: responsive.hp(68),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: responsive.hp(34),
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: ambos[xxx].listProducto.length,
                    itemBuilder: (BuildContext context, int i) {
                      final goodData = ambos[xxx].listProducto[i];

                      return WidgetBienesFavoritos(responsive: responsive, goodData: goodData);
                    }),
              ),
              Container(
                height: responsive.hp(34),
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: ambos[xxx].listServicio.length,
                    itemBuilder: (BuildContext context, int i) {
                      final goodData = ambos[xxx].listServicio[i];

                      return WidgetServiciosFavoritos(responsive: responsive, serviceData: goodData);
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WidgetBienesFavoritos extends StatelessWidget {
  const WidgetBienesFavoritos({
    Key key,
    @required this.responsive,
    @required this.goodData,
  }) : super(key: key);

  final Responsive responsive;
  final ProductoModel goodData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
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
          children: [
            Container(
              width: double.infinity,
              height: responsive.hp(17),
              child: Stack(
                children: <Widget>[
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Image(image: AssetImage('assets/jar-loading.gif'), fit: BoxFit.cover),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        imageUrl: '$apiBaseURL/${goodData.productoImage}',
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
                      padding: EdgeInsets.all(
                        responsive.ip(.5),
                      ),
                      color: Colors.red,
                      //double.infinity,
                      height: responsive.hp(3),
                      child: Text(
                        'Producto',
                        style: TextStyle(color: Colors.white, fontSize: responsive.ip(1.5), fontWeight: FontWeight.bold),
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
                vertical: responsive.hp(1),
              ),
              //color: Colors.white.withOpacity(.8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Container(
                  //   height: responsive.hp(3.5),
                  //   width: responsive.wp(20),
                  //   decoration: BoxDecoration(
                  //     color: Colors.blue.withOpacity(.2),
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Icon(
                  //         FontAwesomeIcons.shoppingCart,
                  //         size: responsive.ip(1.5),
                  //         color: Colors.blue[800],
                  //       ),
                  //       SizedBox(
                  //         width: responsive.wp(1),
                  //       ),
                  //       GestureDetector(
                  //         onTap: () {
                  //           final buttonBloc = ProviderBloc.tabs(context);
                  //           buttonBloc.changePage(2);

                  //           utils.agregarAlCarrito(context, goodData.idProducto);
                  //         },
                  //         child: Text(
                  //           'Agregar',
                  //           style: TextStyle(
                  //               color: Colors.blue[800],
                  //               fontWeight: FontWeight.bold),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),

                  GestureDetector(
                    child: Container(
                      height: responsive.hp(3.5),
                      width: responsive.wp(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: (goodData.productoFavourite == '0') ? Icon(FontAwesomeIcons.heart, color: Colors.red) : Icon(FontAwesomeIcons.solidHeart, color: Colors.red),
                    ),
                    onTap: () {
                      quitarProductoFavorito(context, goodData);
                      utils.showToast(context, 'el producto se quitó de favoritos');
                    },
                  )
                ],
              ),
            ),
            Text(
              goodData.productoName,
              style: TextStyle(fontSize: responsive.ip(1.5), color: Colors.grey[800], fontWeight: FontWeight.w700),
            ),
            Text('${goodData.productoCurrency} ${goodData.productoPrice}', style: TextStyle(fontSize: responsive.ip(1.9), fontWeight: FontWeight.bold, color: Colors.red)),
            Text(
              goodData.productoBrand,
              style: TextStyle(
                color: Colors.grey,
                fontSize: responsive.ip(1.5),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        agregarPSaSugerencia(context, goodData.idProducto, 'bien');

        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 100),
            pageBuilder: (context, animation, secondaryAnimation) {
              return DetalleProductos(
                idProducto: goodData.idProducto,
              );
              //return DetalleProductitos(productosData: productosData);
            },
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      },
    );
  }
}

class WidgetServiciosFavoritos extends StatelessWidget {
  const WidgetServiciosFavoritos({
    Key key,
    @required this.responsive,
    @required this.serviceData,
  }) : super(key: key);

  final Responsive responsive;
  final SubsidiaryServiceModel serviceData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
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
          children: [
            Container(
              width: double.infinity,
              height: responsive.hp(17),
              child: Stack(
                children: <Widget>[
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Image(image: AssetImage('assets/jar-loading.gif'), fit: BoxFit.cover),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        imageUrl: '$apiBaseURL/${serviceData.subsidiaryServiceImage}',
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
                      padding: EdgeInsets.all(
                        responsive.ip(.5),
                      ),
                      color: Colors.blue,
                      //double.infinity,
                      height: responsive.hp(3),
                      child: Text(
                        'Servicio',
                        style: TextStyle(color: Colors.white, fontSize: responsive.ip(1.5), fontWeight: FontWeight.bold),
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
                vertical: responsive.hp(1),
              ),
              //color: Colors.white.withOpacity(.8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    child: Container(
                      height: responsive.hp(3.5),
                      width: responsive.wp(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                          (serviceData.subsidiaryServiceFavourite == '0') ? Icon(FontAwesomeIcons.heart, color: Colors.red) : Icon(FontAwesomeIcons.solidHeart, color: Colors.red),
                    ),
                    onTap: () {
                      quitarServicioFavorito(context, serviceData);
                      utils.showToast(context, 'el servicio se eliminó de favoritos');
                    },
                  )
                ],
              ),
            ),
            Text(
              serviceData.subsidiaryServiceName,
              style: TextStyle(fontSize: responsive.ip(1.5), color: Colors.grey[800], fontWeight: FontWeight.w700),
            ),
            Text('${serviceData.subsidiaryServiceCurrency} ${serviceData.subsidiaryServicePrice}',
                style: TextStyle(fontSize: responsive.ip(1.9), fontWeight: FontWeight.bold, color: Colors.red)),
            // Text(
            //   serviceData.br,
            //   style: TextStyle(
            //     color: Colors.grey,
            //     fontSize: responsive.ip(1.5),
            //   ),
            // )
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, 'detalleServicio', arguments: serviceData.idSubsidiaryservice);
      },
    );
  }
}
