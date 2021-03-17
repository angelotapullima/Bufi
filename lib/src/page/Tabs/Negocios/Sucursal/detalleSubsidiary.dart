import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
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

class DetalleSubsidiary extends StatefulWidget {
  final String nombreSucursal;
  final String idSucursal;
  const DetalleSubsidiary(
      {Key key, @required this.nombreSucursal, @required this.idSucursal})
      : super(key: key);

  @override
  _DetalleSubsidiaryState createState() => _DetalleSubsidiaryState();
}

class _DetalleSubsidiaryState extends State<DetalleSubsidiary> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DetailSubsidiaryBloc>(context, listen: false);

    provider.changeToInformation();

    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                CebeceraItem(
                  nombreSucursal: widget.nombreSucursal, idSucursal: widget.idSucursal,
                ),
                SelectCategory(),
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
  final _selected = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DetailSubsidiaryBloc>(context, listen: false);

    final responsive = Responsive.of(context);
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverCustomHeaderDelegate(
        maxHeight: responsive.hp(6),
        minHeight: responsive.hp(6),
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: EdgeInsets.symmetric(
            horizontal: responsive.wp(1),
          ),
          child: Row(
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
                      style: Theme.of(context).textTheme.headline6.copyWith(
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
        ),
      ),
    );
  }
}

class CebeceraItem extends StatelessWidget {
  final String idSucursal;
  final String nombreSucursal;
  const CebeceraItem({Key key, @required this.nombreSucursal,@required this.idSucursal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 10),
      sliver: SliverToBoxAdapter(
        child: Container(
          height: responsive.hp(5),
          child: Row(
            children: [
              BackButton(),
              Text(
                nombreSucursal,
                style: TextStyle(
                    fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
              ),
              Spacer(),
              BusquedaProductoXsucursalWidget(responsive: responsive, idSucursal:idSucursal,)

            ],
          ),
        ),
      ),
    );
  }
}
/* 
class DetalleSubsidiary extends StatefulWidget {
  const DetalleSubsidiary({Key key}) : super(key: key);

  @override
  _DetalleSubsidiaryState createState() => _DetalleSubsidiaryState();
}

class _DetalleSubsidiaryState extends State<DetalleSubsidiary>
    with SingleTickerProviderStateMixin {
  //Controlador del Tab
  TabController _controllerTab;

  @override
  void initState() {
    super.initState();
    _controllerTab = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final SubsidiaryModel subsidiary =
        ModalRoute.of(context).settings.arguments;
    //final subsidiary = ModalRoute.of(context).settings.arguments;

    final subsidiaryBloc = ProviderBloc.listarsucursalPorId(context);
    subsidiaryBloc.obtenerSucursalporId(subsidiary.idSubsidiary);
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: StreamBuilder(
            stream: subsidiaryBloc.subsidiaryIdStream,
            builder: (context, snapshot) {
              return _crearAppbar(responsive, subsidiary);
            }),
      ),
      //floatingActionButton: _buttonFloating(context, subsidiary, responsive),
    );
  }

  Widget _crearAppbar(Responsive responsive, SubsidiaryModel subsidiary) {
    return NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              elevation: 5.0,
              backgroundColor: Colors.black,
              expandedHeight: responsive.hp(30),
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Container(
                  height: responsive.hp(8),
                  child: Text(
                    '${subsidiary.subsidiaryName}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.ip(2.3),
                    ),
                  ),
                ),
                background: Stack(
                  children: [
                    Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: Colors.white),
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            //si pecacheManager: CustomCacheManager(),
                            placeholder: (context, url) => Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: Image(
                                  image: AssetImage('assets/jar-loading.gif'),
                                  fit: BoxFit.cover),
                            ),
                            errorWidget: (context, url, error) => Container(
                                width: double.infinity,
                                height: double.infinity,
                                child: Center(child: Icon(Icons.error))),
                            //imageUrl: '$apiBaseURL/${companyModel.companyImage}',
                            imageUrl:
                                'https://i.pinimg.com/564x/23/8f/6b/238f6b5ea5ab93832c281b42d3a1a853.jpg',
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: double.infinity,
                            width: double.infinity,
                            color: Colors.black.withOpacity(.1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottom: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.red,
                labelStyle: TextStyle(
                    fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
                controller: _controllerTab,
                tabs: [
                  Tab(
                    text: "Principal",
                  ),
                  Tab(
                    text: "Productos",
                  ),
                  Tab(
                    text: "Servicios",
                  ),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _controllerTab,
          children: [
            TabProductosSucursalPage(),
            GridviewProductoPorSucursal(idSucursal: subsidiary.idSubsidiary),
            ListarServiciosXSucursalPage(idSucursal: subsidiary.idSubsidiary),
          ],
        ));
  }
}
 */
