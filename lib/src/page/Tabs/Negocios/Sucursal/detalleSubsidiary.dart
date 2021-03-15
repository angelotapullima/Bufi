import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/page/Tabs/Negocios/Sucursal/detalleSubisidiaryBloc.dart';

import 'package:bufi/src/page/Tabs/Negocios/producto/GridviewProductosPorSucursal.dart';
import 'package:bufi/src/theme/theme.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/widgets/sliver_header_delegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class DetalleSubsidiary extends StatelessWidget {
  final String nombreSucursal;
  final String idSucursal;
  const DetalleSubsidiary(
      {Key key, @required this.nombreSucursal, @required this.idSucursal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productoBloc = ProviderBloc.productos(context);
    productoBloc.listarProductosPorSucursal(idSucursal);

    final responsive = Responsive.of(context);

    final provider = Provider.of<DetailSubsidiaryBloc>(context, listen: false);

    return Scaffold(
      body: StreamBuilder(
          stream: productoBloc.productoStream,
          builder: (BuildContext context,
              AsyncSnapshot<List<ProductoModel>> snapshot) {
            bool _enabled = true;
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                return SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: CustomScrollView(
                          slivers: [
                            CebeceraItem(
                              nombreSucursal: nombreSucursal,
                            ),
                            SelectCategory(),
                            ValueListenableBuilder<PageDetailsSucursal>(
                                valueListenable: provider.page,
                                builder: (_, value, __) {
                                  return (value ==
                                          PageDetailsSucursal.productos)
                                      ? GridviewProductoPorSucursal(
                                          productos: snapshot.data,
                                        )
                                      : (value ==
                                              PageDetailsSucursal.informacion)
                                          ? InformacionWidget()
                                          : (value ==
                                                  PageDetailsSucursal.servicios)
                                              ? ServiciosWidget()
                                              : Container();
                                })
                          ],
                        ),
                      )
                    ],
                  ),
                );
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





class ServiciosWidget extends StatelessWidget {
  const ServiciosWidget({Key key}) : super(key: key);

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
             
              Text(
                'Servicios',
                style: TextStyle(
                    fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class InformacionWidget extends StatelessWidget {
  const InformacionWidget({Key key}) : super(key: key);

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
             
              Text(
                'información',
                style: TextStyle(
                    fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
              ),
            ],
          ),
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
  final String nombreSucursal;
  const CebeceraItem({Key key, @required this.nombreSucursal})
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
