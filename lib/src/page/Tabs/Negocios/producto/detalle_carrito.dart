import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/carritoGeneralModel..dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/ListarProductosPorSucursalCarrito.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/detalle_carrito_bloc.dart';
import 'package:bufi/src/theme/theme.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/customCacheManager.dart';
import 'package:bufi/src/utils/responsive.dart';
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

    carritoBloc.obtenerCarritoListHorizontalProducto();

    return StreamBuilder(
        stream: carritoBloc.carritoProductListHorizontalStream,
        builder: (context, AsyncSnapshot<List<ProductoModel>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: SafeArea(
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
                                                      productos: snapshot.data,
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
                                                            ListaCarritoDetails()),
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
                ),
              );
            } else {
              return Text('ella no te ama');
            }
          } else {
            return Text('ella no te ama 2');
          }
        });
  }
}

class ProductsHorizontal extends StatelessWidget {
  final List<ProductoModel> productos;
  const ProductsHorizontal({
    Key key,
    @required this.productos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final carritoBloc = ProviderBloc.productosCarrito(context);

    carritoBloc.obtenerCarritoListHorizontalProducto();
    final responsive = Responsive.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(6),
        vertical: responsive.hp(1),
      ),
      child: Row(
        children: [
          (productos.length > 2)
              ? Container(
                  transform: Matrix4.translationValues(0, 0, 0),
                  child: Hero(
                    tag: '${productos[2].idProducto}',
                    child: CircleAvatar(
                      radius: responsive.wp(5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(100),
                        ),
                        child: CachedNetworkImage(
                          cacheManager: CustomCacheManager(),
                          placeholder: (context, url) => Image(
                              image: const AssetImage('assets/jar-loading.gif'),
                              fit: BoxFit.cover),
                          errorWidget: (context, url, error) => Image(
                              image: AssetImage('assets/carga_fallida.jpg'),
                              fit: BoxFit.cover),
                          imageUrl: '$apiBaseURL/${productos[2].productoImage}',
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
                )
              : Container(),
          (productos.length > 1)
              ? Container(
                  transform: Matrix4.translationValues(-15, 0, 0),
                  child: Hero(
                    tag: '${productos[1].idProducto}',
                    child: CircleAvatar(
                      radius: responsive.wp(5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(100),
                        ),
                        child: CachedNetworkImage(
                          cacheManager: CustomCacheManager(),
                          placeholder: (context, url) => Image(
                              image: const AssetImage('assets/jar-loading.gif'),
                              fit: BoxFit.cover),
                          errorWidget: (context, url, error) => Image(
                              image: AssetImage('assets/carga_fallida.jpg'),
                              fit: BoxFit.cover),
                          imageUrl: '$apiBaseURL/${productos[1].productoImage}',
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
                )
              : Container(),
          Container(
            transform: Matrix4.translationValues(-30, 0, 0),
            child: CircleAvatar(
              radius: responsive.wp(5),
              child: Hero(
                tag: '${productos[0].idProducto}',
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(100),
                  ),
                  child: CachedNetworkImage(
                    cacheManager: CustomCacheManager(),
                    placeholder: (context, url) => Image(
                        image: const AssetImage('assets/jar-loading.gif'),
                        fit: BoxFit.cover),
                    errorWidget: (context, url, error) => Image(
                        image: AssetImage('assets/carga_fallida.jpg'),
                        fit: BoxFit.cover),
                    imageUrl: '$apiBaseURL/${productos[0].productoImage}',
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
          ),
          Spacer(),
          Text(
            'S/. 40.00',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: responsive.ip(2),
            ),
          )
        ],
      ),
    );
  }
}

class ListaCarritoDetails extends StatefulWidget {
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
    final carritoBloc = ProviderBloc.productosCarrito(context);
    return StreamBuilder(
        stream: carritoBloc.carritoGeneralStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<CarritoGeneralModel>> snapshot) {
          if (snapshot.hasData) {
            List<CarritoGeneralModel> listcarrito = snapshot.data;

            if (listcarrito.length > 0) {
              return ListView.builder(
                  itemCount: listcarrito.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: listcarrito[index].carrito.length + 1,
                      itemBuilder: (BuildContext context, int i) {
                        if (i == 0) {
                          return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 1, vertical: 1),
                              width: double.infinity,
                              child: Row(
                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      '${listcarrito[index].nombre}',
                                      style: TextStyle(
                                          color: InstagramColors.pink,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    //Divider(),
                                  ]));
                        }
                        int indd = i - 1;
                        var precioFinal = double.parse(
                                listcarrito[index].carrito[indd].precio) *
                            double.parse(
                                snapshot.data[index].carrito[indd].cantidad);

                        return Row(
                          children: [
                            Container(
                              width: responsive.wp(30),
                              height: responsive.wp(30),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                child: CachedNetworkImage(
                                  //cacheManager: CustomCacheManager(),
                                  placeholder: (context, url) => Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Image(
                                        image: AssetImage('assets/loading.gif'),
                                        fit: BoxFit.fitWidth),
                                  ),
                                  imageUrl:
                                      '$apiBaseURL/${listcarrito[index].carrito[indd].image}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              width: responsive.wp(70),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${listcarrito[index].carrito[indd].nombre}' +
                                        ' ' +
                                        '${listcarrito[index].carrito[indd].marca}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                      '${listcarrito[index].carrito[indd].precio}',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white)),
                                  Text(
                                    '${listcarrito[index].carrito[indd].moneda}' +
                                        ' ' +
                                        '$precioFinal',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                  Text(
                                      '${listcarrito[index].carrito[indd].nombre}',
                                      style: TextStyle(color: Colors.white)),
                                  CantidadCarrito(
                                    carrito: listcarrito[index].carrito[indd],
                                    llamada: llamada,
                                    idSudsidiaryGood:
                                        '${listcarrito[index].carrito[indd].idSubsidiaryGood}',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  });
            } else {
              return Center(
                child: Text('No haz añadido nada'),
              );
            }
          } else {
            return Container();
          }
        });
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
