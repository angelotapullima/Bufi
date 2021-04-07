import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/CompanySubsidiaryModel.dart';
import 'package:bufi/src/models/bienesServiciosModel.dart';
import 'package:bufi/src/models/cuentaModel.dart';
import 'package:bufi/src/models/notificacionModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/models/subsidiaryService.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/detalleProducto/detalleProducto.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:bufi/src/widgets/busquedas/widgetBusquedaGeneral.dart';
import 'package:bufi/src/widgets/carrousel_principal.dart';
import 'package:bufi/src/widgets/lista_de_categorias.dart';
import 'package:bufi/src/widgets/sliver_header_delegate.dart';
import 'package:bufi/src/widgets/widgetBienes.dart';
import 'package:bufi/src/widgets/widgetServicios.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class PrincipalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bienesServiciosBloc = ProviderBloc.bienesServicios(context);
    bienesServiciosBloc.obtenerBienesServiciosResumen();
    final preferences = Preferences();
    final responsive = Responsive.of(context);
    //final subsidiary = SubsidiaryModel();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            HeaderWidget(responsive: responsive, preferences: preferences),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.wp(2),
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(
                    height: responsive.hp(.5),
                  ),
                  Container(
                    height: responsive.hp(12),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            IconButton(
                                icon: Icon(Icons.trending_down),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, "listaCategoriasAll");
                                }),
                            Text("Categorias")
                          ],
                        ),
                        SizedBox(
                          width: responsive.wp(1.5),
                        ),
                        Expanded(
                          child: ListCategoriasPrincipal(),
                        ),
                      ],
                    ),
                  ),
                  //ListCategoriasPrincipal(),

                  CarrouselPrincipal(),
                  SizedBox(
                    height: responsive.hp(1),
                  ),
                  BienesResu(),
                  SizedBox(
                    height: responsive.hp(1),
                  ),
                  Servicios(),
                  SizedBox(
                    height: responsive.hp(1),
                  ),
                  Negocios(),
                  SizedBox(
                    height: responsive.hp(3),
                  ),
                  SugerenciaBusqueda(),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    Key key,
    @required this.responsive,
    @required this.preferences,
  }) : super(key: key);

  final Responsive responsive;
  final Preferences preferences;

  @override
  Widget build(BuildContext context) {
    final cuentaBloc = ProviderBloc.cuenta(context);
    //notificaciones
    final notificacionesBloc = ProviderBloc.notificaciones(context);
    notificacionesBloc.listarNotificacionesPendientes();

    if (preferences.personName != null) {
      cuentaBloc.obtenerSaldo();
    }
    return SliverPersistentHeader(
        floating: true,
        delegate: SliverCustomHeaderDelegate(
          maxHeight: responsive.hp(13),
          minHeight: responsive.hp(13),
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
            child: Column(
              children: [
                Row(
                  children: [
                    (preferences.personName != null)
                        ? Container(
                            width: responsive.ip(5),
                            height: responsive.ip(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                imageUrl: '${preferences.userImage}',
                                //cacheManager: CustomCacheManager(),
                                placeholder: (context, url) => Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Image(
                                      image: AssetImage('assets/loading.gif'),
                                      fit: BoxFit.cover),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Center(
                                    child: Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    SizedBox(
                      width: responsive.wp(3),
                    ),
                    (preferences.personName != null)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Buenos días'),
                              Text(
                                '${preferences.personName}',
                                style: GoogleFonts.pacifico(
                                  textStyle: TextStyle(
                                      fontSize: responsive.ip(2),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          )
                        : Text(
                            'Bienvenido',
                            style: GoogleFonts.andika(
                              textStyle: TextStyle(
                                  fontSize: responsive.ip(2.5),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                    Spacer(),
                    Container(
                      width: responsive.wp(11),
                      child: Image(
                        image: AssetImage('assets/moneda.png'),
                      ),
                    ),
                    StreamBuilder(
                      stream: cuentaBloc.saldoStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<CuentaModel>> snapshot) {
                        int valorcito = 0;

                        if (snapshot.hasData) {
                          if (snapshot.data.length > 0) {
                            valorcito =
                                double.parse(snapshot.data[0].cuentaSaldo)
                                    .toInt();
                          }
                        }

                        return Container(
                          child: Text(
                            valorcito.toString(),
                            style: TextStyle(
                                fontSize: responsive.ip(1.8),
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      width: responsive.wp(2),
                    ),
                    /* InkWell(
                      onTap: () {
                        if (preferences.personName == null) {
                          showBarModalBottomSheet(
                            expand: true,
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => ModalLogin(),
                          );
                        } else {}
                      },
                      child: Icon(
                        FontAwesomeIcons.bell,
                        size: responsive.ip(2.5),
                        color: Colors.yellowAccent[600],
                      ),
                    ),
                     */InkWell(
                        onTap: () {
                          // if (preferences.personName == null) {
                          //    showBarModalBottomSheet(
                          //     expand: true,
                          //     context: context,
                          //     backgroundColor: Colors.transparent,
                          //     builder: (context) => ModalLogin(),
                          //   );
                          // } else {

                          // }

                          Navigator.pushNamed(context, "notificaciones");
                        },
                        child: Container(
                          //color: Colors.blue,
                          width: responsive.wp(8),
                          child: Stack(
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.bell,
                                size: responsive.ip(3.5),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: StreamBuilder(
                                    stream: notificacionesBloc
                                        .notificacionesPendientesStream,
                                    builder: (context,
                                        AsyncSnapshot<List<NotificacionesModel>>
                                            snapshot) {
                                      List<NotificacionesModel> notificaciones =
                                          snapshot.data;
                                      if (snapshot.hasData) {
                                        if (snapshot.data.length > 0) {
                                          return Container(
                                            child: Text(
                                              '${notificaciones.length}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: responsive.ip(1.5)),
                                            ),
                                            alignment:
                                                Alignment.center,
                                            width: responsive.ip(2),
                                            height: responsive.ip(2),
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle),
                                          );
                                        } else {
                                          return Container(
                                              );
                                        }
                                      } else {
                                        return Center(
                                            child: Text(
                                                "0"));
                                      }
                                    }),
                                //child: Icon(Icons.brightness_1, size: 8,color: Colors.redAccent,  )
                              )
                            ],
                          ),
                        )),
                    SizedBox(width: responsive.wp(2)),
                  ],
                ),
                SizedBox(
                  height: responsive.hp(2),
                ),
                BusquedaGeneralWidget(responsive: responsive),
              ],
            ),
          ),
        ));
  }
}

class BienesResu extends StatefulWidget {
  const BienesResu({Key key}) : super(key: key);

  @override
  _BienesResuState createState() => _BienesResuState();
}

class _BienesResuState extends State<BienesResu> {
  @override
  Widget build(BuildContext context) {
    final bienesBloc = ProviderBloc.bienesServicios(context);

    final responsive = Responsive.of(context);
    //final subsidiary = SubsidiaryModel();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Productos Populares',
              style: TextStyle(
                  fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
            ),
            //SizedBox(width: 30,),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  "listarBienesAll",
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.pink,
                ),
                padding: EdgeInsets.all(
                  responsive.ip(.8),
                ),
                child: Text(
                  "Ver Todos",
                  style: TextStyle(
                      fontSize: responsive.ip(1.5),
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  //textAlign: TextAlign.end,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: responsive.hp(1),
        ),
        Container(
          height: responsive.hp(32),
          child: StreamBuilder(
            stream: bienesBloc.bienesStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<ProductoModel>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: BienesWidget(
                            producto: snapshot.data[index],
                          ),
                          onTap: () {
                            agregarPSaSugerencia(context,
                                snapshot.data[index].idProducto, 'bien');

                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration:
                                    const Duration(milliseconds: 100),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return DetalleProductos(
                                      producto: snapshot.data[index]);
                                  //return DetalleProductitos(productosData: productosData);
                                },
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                            /* Navigator.pushNamed(context, 'detalleProducto',
                                arguments:
                                    snapshot.data[index].idProducto); */
                          },
                        );

                        // crearItem(
                        //     context, snapshot.data[index], responsive);
                      });
                } else {
                  return Center(child: CupertinoActivityIndicator());
                }
              } else {
                return Center(child: CupertinoActivityIndicator());
              }
            },
          ),
        ),
      ],
    );
  }
}

class Servicios extends StatefulWidget {
  @override
  _ServiciosState createState() => _ServiciosState();
}

class _ServiciosState extends State<Servicios> {
  @override
  Widget build(BuildContext context) {
    final serviciosBloc = ProviderBloc.bienesServicios(context);
    serviciosBloc.obtenerBienesServiciosResumen();
    final responsive = Responsive.of(context);
    // SubsidiaryModel subsidiary = SubsidiaryModel();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Servicios Populares',
              style: TextStyle(
                  fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "listarServiciosAll");
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.pink,
                ),
                padding: EdgeInsets.all(responsive.ip(.8)),
                child: Text(
                  "Ver Todos",
                  style: TextStyle(
                      fontSize: responsive.ip(1.5),
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  //textAlign: TextAlign.end,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: responsive.hp(1)),
        Container(
          height: responsive.hp(32),
          child: StreamBuilder(
            stream: serviciosBloc.serviciosStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<SubsidiaryServiceModel>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return ServiciosWidget(
                            serviceData:snapshot.data[index]);
                        // _crearItem(
                        //     context, snapshot.data[index], responsive);
                      });
                } else {
                  return Center(child: CupertinoActivityIndicator());
                }
              } else {
                return Center(child: CupertinoActivityIndicator());
              }
            },
          ),
        ),
      ],
    );
  }
}

class Negocios extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final negociosBloc = ProviderBloc.negocios(context);
    //negociosBloc.obtenernegocios();
    final responsive = Responsive.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Negocios Populares',
              style: TextStyle(
                  fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
            ),
            //SizedBox(width: 30,),
            GestureDetector(
              onTap: () async {
                final buttonBloc = ProviderBloc.tabs(context);
                buttonBloc.changePage(3);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.pink,
                ),
                padding: EdgeInsets.all(responsive.ip(.8)),
                child: Text(
                  "Ver Todos",
                  style: TextStyle(
                      fontSize: responsive.ip(1.5),
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  //textAlign: TextAlign.end,
                ),
              ),
            ),
          ],
        ),
        Container(
          height: responsive.hp(26),
          child: StreamBuilder(
            //stream: negociosBloc.negociosStream,
            stream: negociosBloc.listarNeg,
            builder: (BuildContext context,
                AsyncSnapshot<List<CompanySubsidiaryModel>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return _crearItem(
                            context, snapshot.data[index], responsive);
                      });
                } else {
                  return Center(child: CupertinoActivityIndicator());
                }
              } else {
                return Center(child: CupertinoActivityIndicator());
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _crearItem(BuildContext context, CompanySubsidiaryModel servicioData,
      Responsive responsive) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "detalleNegocio", arguments: servicioData);
      },
      child: Stack(
        children: <Widget>[
          Container(
            width: responsive.wp(42.5),
            child: Card(
              elevation: 2,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Center(
                          child: Container(
                            width: responsive.ip(10),
                            height: responsive.ip(10),
                            child: CachedNetworkImage(
                              //cacheManager: CustomCacheManager(),
                              placeholder: (context, url) => Image(
                                  image: AssetImage('assets/jar-loading.gif'),
                                  fit: BoxFit.cover),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              imageUrl:
                                  '$apiBaseURL/${servicioData.companyImage}',
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
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              FontAwesomeIcons.heart,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${servicioData.companyName}',
                      style: TextStyle(
                        fontSize: responsive.ip(2),
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      servicioData.idCompany,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: responsive.ip(1.9),
                      ),
                    ),
                    Text(
                      '${servicioData.companyType}',
                      style: TextStyle(
                          fontSize: responsive.ip(1.9),
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SugerenciaBusqueda extends StatefulWidget {
  @override
  _SugerenciaBusquedaState createState() => _SugerenciaBusquedaState();
}

class _SugerenciaBusquedaState extends State<SugerenciaBusqueda> {
  @override
  Widget build(BuildContext context) {
    final sugerenciaBusquedaBloc = ProviderBloc.sugerenciaXbusqueda(context);
    sugerenciaBusquedaBloc.listarSugerenciasXbusqueda();
    final responsive = Responsive.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'De acuerdo a lo que buscaste',
                style: TextStyle(
                    fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
              ),
            ),
            GestureDetector(
              onTap: () {
                //Navigator.pushNamed(context, "listarServiciosAll");
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.pink,
                ),
                padding: EdgeInsets.all(responsive.ip(.8)),
                child: Text(
                  "Ver Todos",
                  style: TextStyle(
                      fontSize: responsive.ip(1.5),
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  //textAlign: TextAlign.end,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: responsive.hp(1)),
        Container(
          //height: responsive.hp(30),
          child: StreamBuilder(
            stream: sugerenciaBusquedaBloc.sugerenciaBusquedaStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<BienesServiciosModel>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  return GridView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      itemCount: snapshot.data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        if (snapshot.data[index].tipo == 'bien') {
                          return bienesWidgetCompelto(
                              context, snapshot.data[index], responsive);
                        } else {
                          return serviceWidgetCompleto(
                              context, snapshot.data[index], responsive);
                        }
                      });
                } else {
                  return Center(child: CupertinoActivityIndicator());
                }
              } else {
                return Center(child: CupertinoActivityIndicator());
              }
            },
          ),
        ),
      ],
    );
  }
}
