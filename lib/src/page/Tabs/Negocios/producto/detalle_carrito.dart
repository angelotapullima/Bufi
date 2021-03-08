import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/carritoGeneralModel..dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/page/Tabs/Carrito/confirmacionPedido/confirmacion_pedido.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/ListarProductosPorSucursalCarrito.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/detalle_carrito_bloc.dart';
import 'package:bufi/src/theme/theme.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/customCacheManager.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:bufi/src/widgets/cantidad_producto.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

const cartPanel = 180.00;

class DetalleCarrito extends StatefulWidget {
  final ProductoModel producto;
  const DetalleCarrito({Key key, @required this.producto}) : super(key: key);

  @override
  _DetalleCarritoState createState() => _DetalleCarritoState();
}

class _DetalleCarritoState extends State<DetalleCarrito> {
  final bloc = DetailsCartBloc();

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 700), () {
      bloc.changeToCart();
    });
    super.initState();
  }

  void _onVerticalGesture(DragUpdateDetails details) {
    print(details.primaryDelta);

    if (details.primaryDelta < -7) {
      bloc.changeToCart();
    } else if (details.primaryDelta > 12) {
      bloc.changeToNormal();
    }
  }

  double getTopForWhitePanel(ScreenState state, Size size) {
    if (state == ScreenState.normal) {
      return -cartPanel;
    } else if (state == ScreenState.cart) {
      return -(size.height - kToolbarHeight - cartPanel / 5);
    }

    return 0.0;
  }

  double getTopForBlackPanel(ScreenState state, Size size) {
    if (state == ScreenState.normal) {
      return size.height - kToolbarHeight - cartPanel;
    } else if (state == ScreenState.cart) {
      return cartPanel / 2;
    }

    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final size = MediaQuery.of(context).size;

    final carritoBloc = ProviderBloc.productosCarrito(context);
    carritoBloc.obtenerCarritoPorSucursal();

    carritoBloc.obtenerCarritoListHorizontalProducto();

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
          stream: carritoBloc.carritoGeneralStream,
          builder: (BuildContext context,
              AsyncSnapshot<List<CarritoGeneralSuperior>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                return SafeArea(
                  bottom: false,
                  child: AnimatedBuilder(
                      animation: bloc,
                      builder: (context, _) {
                        return Column(
                          children: [
                            AppBarCustom(responsive: responsive),

                            Expanded(
                              child: Stack(
                                children: [
                                  Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    color: Colors.black,
                                  ),
                                  AnimatedPositioned(
                                    curve: Curves.decelerate,
                                    duration: Duration(milliseconds: 600),
                                    left: 0,
                                    right: 0,
                                    top: getTopForWhitePanel(
                                        bloc.screenState, size),
                                    height: size.height - kToolbarHeight,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(30),
                                        bottomRight: Radius.circular(30),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(30),
                                            bottomRight: Radius.circular(30),
                                          ),
                                        ),
                                        child:
                                            ListarProductosPorSucursalCarrito(
                                                idSucursal: widget
                                                    .producto.idSubsidiary),
                                      ),
                                    ),
                                  ),
                                  AnimatedPositioned(
                                    curve: Curves.decelerate,
                                    duration: Duration(milliseconds: 600),
                                    left: 0,
                                    right: 0,
                                    top: getTopForBlackPanel(
                                        bloc.screenState, size),
                                    height: size.height,
                                    child: GestureDetector(
                                      onVerticalDragUpdate: _onVerticalGesture,
                                      child: Container(
                                          color: Colors.black,
                                          child: (bloc.screenState ==
                                                  ScreenState.normal)
                                              ? Column(
                                                  children: [
                                                    IconButton(
                                                        icon: Icon(
                                                          Icons
                                                              .keyboard_arrow_up_sharp,
                                                          color: Colors.white,
                                                          size:
                                                              responsive.ip(3),
                                                        ),
                                                        onPressed: () {
                                                          bloc.changeToCart();
                                                        }),
                                                    ProductsHorizontal(
                                                      monto: snapshot
                                                          .data[0].montoGeneral,
                                                    ),
                                                  ],
                                                )
                                              : Column(
                                                  children: [
                                                    IconButton(
                                                        icon: Icon(
                                                          Icons
                                                              .keyboard_arrow_down,
                                                          color: Colors.white,
                                                          size:
                                                              responsive.ip(3),
                                                        ),
                                                        onPressed: () {
                                                          bloc.changeToNormal();
                                                        }),
                                                    Expanded(
                                                      child:
                                                          ListaCarritoDetails(
                                                        carrito: snapshot.data,
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            //ListarBienesAll(),
                          ],
                        );
                      }),
                );
              } else {
                return Text('ella no te ama');
              }
            } else {
              return Text('ella no te ama 2');
            }
          }),
    );
  }
}

class ProductsHorizontal extends StatelessWidget {
  final String monto;
  const ProductsHorizontal({
    Key key,
    @required this.monto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final carritoBloc = ProviderBloc.productosCarrito(context);

    carritoBloc.obtenerCarritoListHorizontalProducto();
    final responsive = Responsive.of(context);
    return StreamBuilder(
        stream: carritoBloc.carritoProductListHorizontalStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.wp(6),
                  vertical: responsive.hp(1),
                ),
                child: Row(
                  children: [
                    SizedBox(width: responsive.wp(4)),
                    (snapshot.data.length > 2)
                        ? Container(
                            transform: Matrix4.translationValues(0, 0, 0),
                            child: Hero(
                              tag: '${snapshot.data[2].idProducto}',
                              child: CircleAvatar(
                                radius: responsive.wp(5),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                  child: CachedNetworkImage(
                                    cacheManager: CustomCacheManager(),
                                    placeholder: (context, url) => Image(
                                        image: const AssetImage(
                                            'assets/jar-loading.gif'),
                                        fit: BoxFit.cover),
                                    errorWidget: (context, url, error) => Image(
                                        image: AssetImage(
                                            'assets/carga_fallida.jpg'),
                                        fit: BoxFit.cover),
                                    imageUrl:
                                        '$apiBaseURL/${snapshot.data[2].productoImage}',
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
                            ),
                          )
                        : Container(),
                    (snapshot.data.length > 1)
                        ? Container(
                            transform: Matrix4.translationValues(-15, 0, 0),
                            child: Hero(
                              tag: '${snapshot.data[1].idProducto}',
                              child: CircleAvatar(
                                radius: responsive.wp(5),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                  child: CachedNetworkImage(
                                    cacheManager: CustomCacheManager(),
                                    placeholder: (context, url) => Image(
                                        image: const AssetImage(
                                            'assets/jar-loading.gif'),
                                        fit: BoxFit.cover),
                                    errorWidget: (context, url, error) => Image(
                                        image: AssetImage(
                                            'assets/carga_fallida.jpg'),
                                        fit: BoxFit.cover),
                                    imageUrl:
                                        '$apiBaseURL/${snapshot.data[1].productoImage}',
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
                            ),
                          )
                        : Container(),
                    Container(
                      transform: Matrix4.translationValues(-30, 0, 0),
                      child: CircleAvatar(
                        radius: responsive.wp(5),
                        child: Hero(
                          tag: '${snapshot.data[0].idProducto}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                            child: CachedNetworkImage(
                              cacheManager: CustomCacheManager(),
                              placeholder: (context, url) => Image(
                                  image: const AssetImage(
                                      'assets/jar-loading.gif'),
                                  fit: BoxFit.cover),
                              errorWidget: (context, url, error) => Image(
                                  image: AssetImage('assets/carga_fallida.jpg'),
                                  fit: BoxFit.cover),
                              imageUrl:
                                  '$apiBaseURL/${snapshot.data[0].productoImage}',
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
                      ),
                    ),
                    Spacer(),
                    Text(
                      'S/. $monto',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: responsive.ip(2),
                      ),
                    )
                  ],
                ),
              );
            } else {
              return Container();
            }
          } else {
            return Container();
          }
        });
  }
}

class ListaCarritoDetails extends StatefulWidget {
  final List<CarritoGeneralSuperior> carrito;

  const ListaCarritoDetails({
    Key key,
    @required this.carrito,
  }) : super(key: key);

  //List<CarritoGeneralSuperior> carrito;
  @override
  _ListaCarritoState createState() => _ListaCarritoState();
}

class _ListaCarritoState extends State<ListaCarritoDetails> {
  void llamada() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Container(
      child: Stack(
        children: [
          ListView.builder(
              itemCount: widget.carrito[0].car.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == widget.carrito[0].car.length) {
                  return SizedBox(height: responsive.hp(30));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: widget.carrito[0].car[index].carrito.length + 1,
                  itemBuilder: (BuildContext context, int i) {
                    if (i == 0) {
                      return Container(
                        color: Colors.blueGrey,
                        padding: EdgeInsets.symmetric(
                            horizontal: 1, vertical: responsive.hp(.5)),
                        width: double.infinity,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: responsive.wp(3),
                              ),
                              Icon(
                                Icons.store,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: responsive.wp(2),
                              ),
                              Text(
                                '${widget.carrito[0].car[index].nombreSucursal}',
                                style: TextStyle(
                                    color: InstagramColors.cardLight,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              //Divider(),
                            ]),
                      );
                    }

                    int indd = i - 1;
                    var precioFinal = double.parse(
                            widget.carrito[0].car[index].carrito[indd].precio) *
                        double.parse(widget
                            .carrito[0].car[index].carrito[indd].cantidad);

                    return Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: responsive.wp(3),
                        vertical: responsive.hp(2),
                      ),
                      height: responsive.hp(14),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if ('${widget.carrito[0].car[index].carrito[indd].estadoSeleccionado}' ==
                                  '0') {
                                cambiarEstadoCarrito(
                                    context,
                                    '${widget.carrito[0].car[index].carrito[indd].idSubsidiaryGood}',
                                    '1');
                              } else {
                                cambiarEstadoCarrito(
                                    context,
                                    '${widget.carrito[0].car[index].carrito[indd].idSubsidiaryGood}',
                                    '0');
                              }
                            },
                            child: Container(
                              width: responsive.wp(8),
                              child: Stack(
                                children: [
                                  Container(
                                    child: Center(
                                      child: CircleAvatar(
                                        radius: 10,
                                        backgroundColor: Colors.red,
                                      ),
                                    ),
                                  ),
                                  ('${widget.carrito[0].car[index].carrito[indd].estadoSeleccionado}' ==
                                          '0')
                                      ? Container(
                                          child: Center(
                                            child: CircleAvatar(
                                              radius: 7,
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                          ),

                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: responsive.wp(35),
                              child: Stack(
                                children: [
                                  Container(
                                    height: responsive.hp(15),
                                    width: responsive.wp(40),
                                    child: CachedNetworkImage(
                                      cacheManager: CustomCacheManager(),
                                      placeholder: (context, url) => Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: Image(
                                            image: AssetImage(
                                                'assets/loading.gif'),
                                            fit: BoxFit.fitWidth),
                                      ),
                                      imageUrl:
                                          '$apiBaseURL/${widget.carrito[0].car[index].carrito[indd].image}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: responsive.wp(1)),
                                      color: Colors.black.withOpacity(.5),
                                      width: double.infinity,
                                      //double.infinity,
                                      height: responsive.hp(3),
                                      child: Text(
                                        '${widget.carrito[0].car[index].carrito[indd].nombre}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          //SizedBox(height: 50),
                          Expanded(
                            child: Container(
                              //width: responsive.wp(50),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${widget.carrito[0].car[index].carrito[indd].nombre}' +
                                        ' ' +
                                        '${widget.carrito[0].car[index].carrito[indd].marca}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    '${widget.carrito[0].car[index].carrito[indd].moneda}' +
                                        ' ' +
                                        '$precioFinal',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: responsive.ip(2)),
                                  ),
                                  Text(
                                    '${widget.carrito[0].car[index].carrito[indd].nombre}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  CantidadCarrito(
                                    carrito: widget
                                        .carrito[0].car[index].carrito[indd],
                                    llamada: llamada,
                                    idSudsidiaryGood:
                                        '${widget.carrito[0].car[index].carrito[indd].idSubsidiaryGood}', marcaProducto: '${widget.carrito[0].car[index].carrito[indd].marca}', modeloProducto: '${widget.carrito[0].car[index].carrito[indd].modelo}', tallaProducto: '${widget.carrito[0].car[index].carrito[indd].talla}',
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Container(
                            width: responsive.wp(6),
                            child: GestureDetector(
                              onTap: () {
                                agregarAlCarritoContador(
                                    context,
                                    '${widget.carrito[0].car[index].carrito[indd].idSubsidiaryGood}','${widget.carrito[0].car[index].carrito[indd].talla}','${widget.carrito[0].car[index].carrito[indd].modelo}','${widget.carrito[0].car[index].carrito[indd].marca}',
                                    0);
                              },
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.grey,
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              }),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: responsive.hp(28),
              color: Colors.black,
              child: Column(
                children: [
                  Row(
                    children: [
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          double monto =
                              double.parse(widget.carrito[0].montoGeneral);

                          if (monto > 0) {
                            Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return ConfirmacionPedido();
                              },
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                var begin = Offset(0.0, 1.0);
                                var end = Offset.zero;
                                var curve = Curves.ease;

                                var tween = Tween(begin: begin, end: end).chain(
                                  CurveTween(curve: curve),
                                );

                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                            ));
                          } else {
                            showToast(context,
                                'Por favor seleccione productos para confirmar el pago',
                                duration: 3);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.wp(3),
                            vertical: responsive.hp(.5),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.red),
                          child: Text(
                            'Pagar S/ ${widget.carrito[0].montoGeneral}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: responsive.ip(1.5),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: responsive.wp(4),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppBarCustom extends StatelessWidget {
  const AppBarCustom({
    Key key,
    @required this.responsive,
  }) : super(key: key);

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: kToolbarHeight,
      child: Row(
        children: [
          BackButton(),
          Expanded(
            child: Text(
              'Productos del vendedor',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(icon: Icon(Icons.filter_list), onPressed: () {}),
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
        ],
      ),
    );
  }
}
