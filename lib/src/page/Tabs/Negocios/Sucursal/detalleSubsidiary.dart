import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/page/Tabs/Negocios/Sucursal/tabInfoPrincipalSucursalPage.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/ListarProductosPorSucursal.dart';
import 'package:bufi/src/page/Tabs/Negocios/servicios/ListarServiciosXsucursal.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      body: StreamBuilder(
          stream: subsidiaryBloc.subsidiaryIdStream,
          builder: (context, snapshot) {
            return _crearAppbar(responsive, subsidiary);
          }),
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
                              color: Colors.black.withOpacity(.1)),
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
            ListarProductosPorSucursalPage(idSucursal: subsidiary.idSubsidiary),
            ListarServiciosXSucursalPage(idSucursal: subsidiary.idSubsidiary),
          ],
        ));
  }
}
