import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/page/Tabs/Negocios/Sucursal/tabInfoPrincipalSucursalPage.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/GridviewProductosPorSucursal.dart';
import 'package:bufi/src/page/Tabs/Negocios/servicios/ListarServiciosXsucursal.dart';
import 'package:bufi/src/theme/theme.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/widgets/sliver_header_delegate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetalleSubsidiary extends StatelessWidget {
  const DetalleSubsidiary({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SubsidiaryModel subsidiary =
        ModalRoute.of(context).settings.arguments;
    //final subsidiary = ModalRoute.of(context).settings.arguments;

    final subsidiaryBloc = ProviderBloc.listarsucursalPorId(context);
    subsidiaryBloc.obtenerSucursalporId(subsidiary.idSubsidiary);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [CebeceraItem(), SelectCategory()],
              ),
            )
          ],
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
    final responsive = Responsive.of(context);
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverCustomHeaderDelegate(
        maxHeight: responsive.hp(6),
        minHeight: responsive.hp(6),
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: EdgeInsets.symmetric(
            horizontal: responsive.wp(2),
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
                    print(i);
                  },
                  child: Container(
                    padding: EdgeInsets.only(bottom: 5, left: 20, right: 20),
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
                          ),
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
  const CebeceraItem({Key key}) : super(key: key);

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
              Text('Ella no te ama'),
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
