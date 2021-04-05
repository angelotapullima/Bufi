import 'dart:async';
import 'dart:ui';

import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/page/Tabs/Negocios/Sucursal/detailsSubsidiary/page_filtro_details_subsidiary.dart';
import 'package:bufi/src/page/Tabs/Negocios/Sucursal/detalleSubisidiaryBloc.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/GridviewProductosPorSucursal.dart';
import 'package:bufi/src/page/Tabs/Negocios/servicios/GridviewServiciosPorSucursal.dart';
import 'package:bufi/src/theme/theme.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/widgets/busquedas/PorSucursal/widgetBusqProductXSucursal.dart';
import 'package:bufi/src/widgets/sliver_header_delegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:rxdart/subjects.dart';

class DetalleSubsidiary extends StatefulWidget {
  final String nombreSucursal;
  final String idSucursal;
  const DetalleSubsidiary(
      {Key key, @required this.nombreSucursal, @required this.idSucursal})
      : super(key: key);

  @override
  _DetalleSubsidiaryState createState() => _DetalleSubsidiaryState();
}

class _DetalleSubsidiaryState extends State<DetalleSubsidiary>
    with SingleTickerProviderStateMixin<DetalleSubsidiary> {
  ScrollController _scrollController = ScrollController();

  AnimationController _animationController;
  StreamController<bool> isSidebarOpenedStreamController;
  Stream<bool> isSidebarOpenedStream;
  StreamSink<bool> isSidebarOpenedSink;
  final _animationDuration = const Duration(milliseconds: 100);

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;

    WidgetsBinding.instance.addPostFrameCallback((_) => {
          _scrollController.addListener(() {
            if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent) {
              print('pixels ${_scrollController.position.pixels}');
              print('maxScrool ${_scrollController.position.maxScrollExtent}');
              print('dentro');

              final productoBloc = ProviderBloc.productos(context);
              productoBloc.listarProductosPorSucursal(widget.idSucursal);

              final serviciosBloc = ProviderBloc.servi(context);
              serviciosBloc.listarServiciosPorSucursal(widget.idSucursal);
            }
          })
        });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();

    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedSink.close();

    super.dispose();
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted) {
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DetailSubsidiaryBloc>(context, listen: false);

    final responsive = Responsive.of(context);

    return Scaffold(
        body: SafeArea(
      bottom: false,
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    CebeceraItem(
                      nombreSucursal: widget.nombreSucursal,
                      idSucursal: widget.idSucursal,
                    ),
                    SelectCategory(
                      iconPressed:onIconPressed,
                    ),
                    ValueListenableBuilder<PageDetailsSucursal>(
                        valueListenable: provider.page,
                        builder: (_, value, __) {
                          return (value == PageDetailsSucursal.productos)
                              ? GridviewProductoPorSucursal(
                                  idSucursal: widget.idSucursal,
                                )
                              : (value == PageDetailsSucursal.informacion)
                                  ? InformacionWidget(
                                      idSucursal: widget.idSucursal,
                                    )
                                  : (value == PageDetailsSucursal.servicios)
                                      ? GridviewServiciosPorSucursal(
                                          idSucursal: widget.idSucursal,
                                        )
                                      : Container();
                        })
                  ],
                ),
              )
            ],
          ),
          StreamBuilder<bool>(
            initialData: false,
            stream: isSidebarOpenedStream,
            builder: (context, isSideBarOpenedAsync) {
              return AnimatedPositioned(
                duration: _animationDuration,
                top: 0,
                bottom: 0,
                left: isSideBarOpenedAsync.data ? 0 : responsive.wp(100),
                right: isSideBarOpenedAsync.data ? 0 : -responsive.wp(100),
                child: Container(
                  decoration: BoxDecoration(),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          onIconPressed();
                        },
                        child: Container(
                          width: responsive.wp(40),
                          decoration: new BoxDecoration(
                            color: Colors.black.withOpacity(.1),
                          ),
                          child: ClipRRect(
                            child: new BackdropFilter(
                              filter: new ImageFilter.blur(
                                  sigmaX: 5.0, sigmaY: 5.0),
                              child: new Container(
                                decoration: new BoxDecoration(
                                  color: Colors.white.withOpacity(0.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: responsive.wp(60),
                        color: Colors.white,
                        child: FiltroPageProductosPorSubsidiary(
                          iconPressed: onIconPressed,
                          idSubsidiary: widget.idSucursal,
                          //productos: listProduct,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    ));
  }
}

class InformacionWidget extends StatelessWidget {
  final String idSucursal;
  const InformacionWidget({Key key, @required this.idSucursal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sucursalBloc = ProviderBloc.sucursal(context);
    sucursalBloc.obtenerSucursalporId(idSucursal);

    final responsive = Responsive.of(context);
    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 10),
      sliver: SliverToBoxAdapter(
        child: Container(
          color: Colors.white,
          height: responsive.hp(80),
          child: StreamBuilder(
              stream: sucursalBloc.subsidiaryIdStream,
              builder:
                  (context, AsyncSnapshot<List<SubsidiaryModel>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length > 0) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: responsive.hp(3),
                          left: responsive.wp(3),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: responsive.wp(30),
                                  child: RatingBar.readOnly(
                                    size: 20,
                                    initialRating: double.parse(
                                        '${snapshot.data[0].subsidiaryStatus}'),
                                    isHalfAllowed: true,
                                    halfFilledIcon: Icons.star_half,
                                    filledIcon: Icons.star,
                                    emptyIcon: Icons.star_border,
                                    filledColor: Colors.yellow,
                                  ),
                                ),
                                Text('${snapshot.data[0].subsidiaryStatus}'),
                              ],
                            ),
                            SizedBox(
                              height: responsive.hp(3),
                            ),
                            Text(
                              "Información",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: responsive.ip(2.7),
                                  fontWeight: FontWeight.bold),
                            ),
                            Divider(color: Colors.grey),
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    size: 28, color: Colors.red[700]),
                                SizedBox(
                                  width: responsive.wp(2),
                                ),
                                Text(
                                  '${snapshot.data[0].subsidiaryAddress}',
                                  style: TextStyle(
                                    fontSize: responsive.ip(2),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: responsive.hp(2.5)),
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.clock,
                                  color: Colors.red,
                                  size: 22,
                                ),
                                SizedBox(
                                  width: responsive.wp(2),
                                ),
                                Text(
                                  '${snapshot.data[0].subsidiaryOpeningHours}',
                                  style: TextStyle(
                                    fontSize: responsive.ip(2),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: responsive.hp(2.5),
                            ),
                            Row(
                              children: [
                                Icon(FontAwesomeIcons.phoneAlt,
                                    color: Colors.red[700], size: 22),
                                SizedBox(
                                  width: responsive.wp(2),
                                ),
                                Text(
                                  '${snapshot.data[0].subsidiaryCellphone}',
                                  style: TextStyle(
                                    fontSize: responsive.ip(2),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: responsive.hp(2.5),
                            ),
                            Row(
                              children: [
                                Icon(Icons.mail,
                                    size: 28, color: Colors.red[700]),
                                SizedBox(
                                  width: responsive.wp(2),
                                ),
                                Text(
                                  '${snapshot.data[0].subsidiaryEmail}',
                                  style: TextStyle(
                                    fontSize: responsive.ip(2),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: responsive.hp(2.5)),
                            Row(
                              children: [
                                Icon(FontAwesomeIcons.home,
                                    color: Colors.red, size: 22),
                                SizedBox(width: responsive.wp(2)),
                                Text(
                                  '${snapshot.data[0].subsidiaryPrincipal}',
                                  style: TextStyle(
                                    fontSize: responsive.ip(2),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: responsive.hp(2.5)),
                            Row(
                              children: [
                                Icon(FontAwesomeIcons.home,
                                    color: Colors.red[800], size: 22),
                                SizedBox(width: responsive.wp(2)),
                                Text(
                                  '${snapshot.data[0].subsidiaryCoordX}',
                                  style: TextStyle(
                                    fontSize: responsive.ip(2),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                } else {
                  return Container();
                }
              }),
        ),
      ),
    );
  }
}

const selectCategory = <String>['Información', 'Productos', 'Servicios'];

class SelectCategory extends StatelessWidget {
  SelectCategory({Key key, @required this.iconPressed}) : super(key: key);
  final VoidCallback iconPressed;
  final _selected = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DetailSubsidiaryBloc>(context, listen: false);

    final responsive = Responsive.of(context);
    return ValueListenableBuilder<PageDetailsSucursal>(
        valueListenable: provider.page,
        builder: (_, value, __) {
          return SliverPersistentHeader(
            pinned: true,
            delegate: SliverCustomHeaderDelegate(
              maxHeight: (value == PageDetailsSucursal.productos)
                  ? responsive.hp(10.5)
                  : responsive.hp(6),
              minHeight: (value == PageDetailsSucursal.productos)
                  ? responsive.hp(10.5)
                  : responsive.hp(6),
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.wp(1),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        selectCategory.length,
                        (i) => ValueListenableBuilder(
                          valueListenable: _selected,
                          builder: (_, value, __) => CupertinoButton(
                            padding: EdgeInsets.zero,
                            pressedOpacity: 1,
                            onPressed: () {
                              _selected.value = i;

                              if (i == 0) {
                                provider.changeToInformation();
                              } else if (i == 1) {
                                provider.changeToProductos();
                              } else {
                                provider.changeToServicios();
                              }
                              print(i);
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                bottom: responsive.hp(.2),
                                left: responsive.wp(5),
                                right: responsive.wp(5),
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: (i == value)
                                          ? InstagramColors.pink
                                          : Colors.transparent,
                                      width: 2.5),
                                ),
                              ),
                              child: Text(
                                selectCategory[i],
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                        color: (i == value)
                                            ? null
                                            : Theme.of(context).dividerColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: responsive.ip(1.7)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    (value == PageDetailsSucursal.productos)
                        ? Row(
                            children: [
                              Spacer(),
                              /* IconButton(
                                  icon: Icon(Icons.category), onPressed: () {}), */
                              IconButton(
                                icon: Icon(Icons.filter_list),
                                onPressed: () {

                                   iconPressed();
                                },
                              ),
                              SizedBox(width: responsive.wp(5))
                            ],
                          )
                        : Container()
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class CebeceraItem extends StatelessWidget {
  final String idSucursal;
  final String nombreSucursal;
  const CebeceraItem(
      {Key key, @required this.nombreSucursal, @required this.idSucursal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return SliverPadding(
      padding: EdgeInsets.only(top: 10),
      sliver: SliverToBoxAdapter(
        child: Container(
          height: responsive.hp(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                BackButton(),
                BusquedaProductoXsucursalWidget(
                  responsive: responsive,
                  idSucursal: idSucursal,
                )
              ]),

              Padding(
                padding: EdgeInsets.only(
                    left: responsive.ip(2), top: responsive.ip(1)),
                child: Row(
                  children: [
                    Icon(Icons.store),
                    SizedBox(width: responsive.wp(2)),
                    Text(
                      nombreSucursal,
                      style: TextStyle(
                          fontSize: responsive.ip(2.4),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              //Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
