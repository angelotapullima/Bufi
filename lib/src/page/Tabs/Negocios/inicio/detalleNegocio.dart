import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/CompanySubsidiaryModel.dart';
import 'package:bufi/src/models/companyModel.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/page/Tabs/Negocios/Sucursal/detailsSubsidiary/detalleSubsidiary.dart';
import 'package:bufi/src/page/Tabs/Negocios/Sucursal/detalleSubisidiaryBloc.dart';
import 'package:bufi/src/page/Tabs/Negocios/Sucursal/detailsSubsidiary/detalleSubsidiary.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rating_bar/rating_bar.dart';

class DetalleNegocio extends StatefulWidget {
  // String idCompany;
  // DetalleNegocio(this.idCompany);

  @override
  _DetalleNegocioState createState() => _DetalleNegocioState();
}

class _DetalleNegocioState extends State<DetalleNegocio>
    with SingleTickerProviderStateMixin {
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    //definir una variable que se paso por el navigator
    CompanySubsidiaryModel company = ModalRoute.of(context).settings.arguments;
    final detallenegocio = ProviderBloc.negocios(context);
    detallenegocio.obtenernegociosporID(company.idCompany);
    final responsive = Responsive.of(context);
    return Scaffold(
      body: Container(
        child: StreamBuilder(
          stream: detallenegocio.detalleNegStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            List<CompanyModel> negocio = snapshot.data;
            if (snapshot.hasData) {
              return
                  //Center(child: Text(negocio[0].companyName));
                  _custonScroll(responsive, negocio[0]);
              //_crearAppbar(responsive, negocio[0]);
            } else if (snapshot.hasError) {
              return snapshot.error;
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.pushNamed(context, 'registroSubsidiary',
      //         arguments: company.idCompany);
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }

  Widget _custonScroll(Responsive responsive, CompanyModel company) {
    var dateCreacion = obtenerFechaHora(company.companyCreatedAt);
    var dateUnion = obtenerFechaHora(company.companyJoin);
    return CustomScrollView(
      controller: controller,
      slivers: [
        _crearAppbar(responsive, company),
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(
              height: responsive.hp(3),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.wp(2),
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
                          initialRating:
                              double.parse('${company.companyStatus}'),
                          isHalfAllowed: true,
                          halfFilledIcon: Icons.star_half,
                          filledIcon: Icons.star,
                          emptyIcon: Icons.star_border,
                          filledColor: Colors.yellow,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.wp(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        Text("Delivery:"),
                        SizedBox(
                          width: responsive.wp(2),
                        ),
                        Text(
                          ('${company.companyDelivery}') == "0" ? "No" : "Si",
                          style: TextStyle(
                            fontSize: responsive.ip(2),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: responsive.hp(2.5),
                    ),
                    Row(
                      children: [
                        Text("Entrega:"),
                        // Icon(
                        //   FontAwesomeIcons.clock,
                        //   color: Colors.red,
                        //   size: 22,
                        // ),
                        SizedBox(
                          width: responsive.wp(2),
                        ),
                        Text(
                          ('${company.companyEntrega}') == "0" ? "No" : "Si",
                          style: TextStyle(
                            fontSize: responsive.ip(2),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: responsive.hp(2.5),
                    ),
                    Row(
                      children: [
                        Text("Tarjeta:"),
                        // Icon(FontAwesomeIcons.phoneAlt,
                        //     color: Colors.red[700], size: 22),
                        SizedBox(
                          width: responsive.wp(2),
                        ),
                        Text(
                          ('${company.companyTarjeta}') == "0" ? "No" : "Si",
                          style: TextStyle(
                            fontSize: responsive.ip(2),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: responsive.hp(2.5),
                    ),
                    Row(
                      children: [
                        Text("Codigo Corto:"),
                        SizedBox(
                          width: responsive.wp(2),
                        ),
                        Text(
                          '${company.companyShortcode}',
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
                        Text("Creado:"),
                        SizedBox(
                          width: responsive.wp(2),
                        ),
                        Text(
                          '$dateCreacion',
                          style: TextStyle(
                            fontSize: responsive.ip(2),
                          ),
                        ),
                      ],
                    ),
                    //SizedBox(height: responsive.hp(2.5)),
                    // Row(
                    //   children: [
                    //     Icon(FontAwesomeIcons.home,
                    //         color: Colors.red[800], size: 22),
                    //     SizedBox(width: responsive.wp(2)),
                    //     Text('${company.companyMt}',
                    //         style: TextStyle(fontSize: responsive.ip(2))),
                    //   ],
                    // ),
                    SizedBox(
                      height: responsive.hp(2.5),
                    ),
                    Row(
                      children: [
                        Text("Se unió:"),
                        SizedBox(
                          width: responsive.wp(2),
                        ),
                        Text(
                          '$dateUnion',
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
                        Text("Estado:"),
                        SizedBox(
                          width: responsive.wp(2),
                        ),
                        Text(
                          ('${company.companyStatus}') == "1"
                              ? "Activo"
                              : "Desactivado",
                          style: TextStyle(
                            fontSize: responsive.ip(2),
                          ),
                        )
                      ],
                    ),

                    SizedBox(
                      height: responsive.hp(2.5),
                    ),
                    Row(
                      children: [
                        Text("id Negocio:"),
                        SizedBox(
                          width: responsive.wp(2),
                        ),
                        Text(
                          ('${company.idCompany}'),
                          style: TextStyle(
                            fontSize: responsive.ip(2),
                          ),
                        )
                      ],
                    ),
                  ],
                )),
            SizedBox(
              height: 30,
            ),
            _listSucursal(context, responsive, company.idCompany)
          ]),
        ),
      ],
    );
  }

  Widget _listSucursal(BuildContext context, Responsive responsive, String id) {
    final sucursalNegocio = ProviderBloc.sucursal(context);
    sucursalNegocio.obtenerSucursalporIdCompany(id);

    return Padding(
      padding: EdgeInsets.only(left: responsive.wp(3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Nuestras sucursales",
            style: TextStyle(
                color: Colors.black,
                fontSize: responsive.ip(2.7),
                fontWeight: FontWeight.bold),
          ),
          Divider(color: Colors.grey),
          Container(
            padding: EdgeInsets.only(
              left: responsive.wp(2),
              right: responsive.wp(2),
              bottom: responsive.hp(2),
            ),
            height: responsive.hp(25),
            child: StreamBuilder(
                stream: sucursalNegocio.sucursalStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<SubsidiaryModel>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length > 0) {
                      List<SubsidiaryModel> sedes = snapshot.data;
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: sedes.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              final provider =
                                  Provider.of<DetailSubsidiaryBloc>(context,
                                      listen: false);

                              provider.changeToInformation();

                              Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return DetalleSubsidiary(
                                    idSucursal: sedes[index].idSubsidiary,
                                    nombreSucursal: sedes[index].subsidiaryName,
                                    imgSucursal: sedes[index].subsidiaryImg,
                                  );
                                },
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  var begin = Offset(0.0, 1.0);
                                  var end = Offset.zero;
                                  var curve = Curves.ease;

                                  var tween =
                                      Tween(begin: begin, end: end).chain(
                                    CurveTween(curve: curve),
                                  );

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ));
                            },
                            child: Container(
                              width: responsive.wp(45),
                              child: Stack(children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    //cacheManager: CustomCacheManager(),
                                    placeholder: (context, url) => Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: Image(
                                          image: AssetImage(
                                              'assets/jar-loading.gif'),
                                          fit: BoxFit.cover),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: Center(
                                        child: Icon(Icons.error),
                                      ),
                                    ),
                                    //imageUrl: '$apiBaseURL/${companyModel.companyImage}',
                                    imageUrl:
                                        '$apiBaseURL/${sedes[index].subsidiaryImg}',
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
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    color: Colors.black.withOpacity(.4),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            sedes[index].subsidiaryName,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: responsive.ip(2.5),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        //Id subsidiary
                                        Text(
                                          sedes[index].idSubsidiary,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: responsive.ip(2.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child:
                                      (sedes[index].subsidiaryFavourite == "0")
                                          ? IconButton(
                                              icon: Icon(FontAwesomeIcons.heart,
                                                  color: Colors.red),
                                              onPressed: () {
                                                setState(() {
                                                  guardarSubsidiaryFavorito(
                                                      context, sedes[index]);
                                                });
                                              },
                                            )
                                          : IconButton(
                                              icon: Icon(
                                                  FontAwesomeIcons.solidHeart,
                                                  color: Colors.red),
                                              onPressed: () {
                                                // quitarSubsidiaryFavorito(
                                                //     context, sedes[index]);
                                              },
                                            ),
                                )
                              ]),
                            ),
                          );

                          //https://i.pinimg.com/564x/23/8f/6b/238f6b5ea5ab93832c281b42d3a1a853.jpg
                        },
                      );
                    } else {
                      return Center(
                          child: Text("Aun no se registran sucursales"));
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget _crearAppbar(Responsive responsive, CompanyModel companyModel) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.white,
      expandedHeight: responsive.hp(30),
      floating: false,
      actions: [
        // GestureDetector(
        //   onTap: () {
        //     //Mandar el id company
        //     Navigator.pushNamed(context, 'actualizarNegocio',
        //         arguments: companyModel.idCompany);
        //   },
        //   child: Container(
        //     margin: EdgeInsets.symmetric(vertical: responsive.hp(1)),
        //     width: responsive.wp(25),
        //     decoration: BoxDecoration(
        //       color: Colors.red,
        //       borderRadius: BorderRadius.circular(20),
        //     ),
        //     child: Center(
        //       child: Text(
        //         'Actualizar',
        //         style: TextStyle(color: Colors.white),
        //         textAlign: TextAlign.center,
        //       ),
        //     ),
        //   ),
        // ),
      ],
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Container(
          //color: Colors.red,
          height: responsive.hp(4),
          child: Text(
            '${companyModel.companyName}',
            style: TextStyle(
                color: Colors.black,
                fontSize: responsive.ip(3),
                fontWeight: FontWeight.bold),
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
                  bottomRight: Radius.circular(25)),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    //cacheManager: CustomCacheManager(),
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
                      child: Center(
                        child: Icon(Icons.error),
                      ),
                    ),
                    //imageUrl: '$apiBaseURL/${companyModel.companyImage}',
                    imageUrl: '$apiBaseURL/${companyModel.companyImage}',
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
      // bottom: TabBar(
      //   labelColor: Colors.black,
      //   unselectedLabelColor: Colors.grey,
      //   indicatorColor: Colors.red,
      //   labelStyle: TextStyle(fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
      //   controller: _controllerTab,
      //   tabs: [
      //     Tab(
      //       text: "Información",
      //     ),
      //     Tab(
      //       text: "Productos",
      //     ),
      //   ],
      // ),
    );
    //];
    //},
    // body: TabBarView(
    //   controller: _controllerTab,
    //   children: [
    //     TabInfoNegocioPage(),
    //     TabProductosNegocioPage(),
    //   ],
    // ),
    //);
  }
}
