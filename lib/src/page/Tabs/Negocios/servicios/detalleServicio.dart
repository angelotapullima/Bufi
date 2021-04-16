import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/subsidiaryService.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/detalleProducto/detalleProducto.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalleServicio extends StatefulWidget {
  //final SubsidiaryServiceModel servicio;
  const DetalleServicio({Key key}) : super(key: key);

  @override
  _DetalleServicioState createState() => _DetalleServicioState();
}

class _DetalleServicioState extends State<DetalleServicio>
    with SingleTickerProviderStateMixin {
  ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final String id = ModalRoute.of(context).settings.arguments;
    final detailServicioBloc = ProviderBloc.servi(context);
    detailServicioBloc.detalleServicioPorIdSubsidiaryService(id);

    return Scaffold(
      body: Container(
        child: StreamBuilder(
            stream: detailServicioBloc.detailServiciostream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Stack(
                  children: [
                    _custonScroll(responsive, snapshot.data[0]),
                    _buttomContacto(responsive, snapshot.data[0])
                  ],
                );
                //Center(child: Text(negocio[0].companyName));

                //_crearAppbar(responsive, negocio[0]);
              } else if (snapshot.hasError) {
                return snapshot.error;
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }

  Widget _custonScroll(Responsive responsive, SubsidiaryServiceModel service) {
    return CustomScrollView(
      controller: controller,
      slivers: [
        _crearAppbar(responsive, service),
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
                      Spacer(),
                      Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                TitleText(
                                  text: '${service.subsidiaryServiceCurrency}',
                                  color: LightColor.red,
                                  fontSize: responsive.ip(3),
                                ),
                                TitleText(
                                  text: '${service.subsidiaryServicePrice}',
                                  fontSize: responsive.ip(3),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: responsive.wp(30),
                            child: RatingBar.readOnly(
                              size: 20,
                              initialRating: double.parse(
                                  '${service.subsidiaryServiceStatus}'),
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
                        Text("Descripción:"),
                        SizedBox(
                          width: responsive.wp(2),
                        ),
                        Text(
                          ('${service.subsidiaryServiceDescription}'),
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
                        Text("Disponible:"),
                        SizedBox(
                          width: responsive.wp(2),
                        ),
                        Text(
                          ('${service.subsidiaryServiceStatus}') == '1'
                              ? 'Si'
                              : 'No',
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
                        Text("Contacto:"),
                        SizedBox(
                          width: responsive.wp(2),
                        ),
                        Text(
                          '${service.listSubsidiary[0].subsidiaryCellphone}  ',
                          style: TextStyle(
                            fontSize: responsive.ip(2),
                          ),
                        ),
                        Text(
                          ('${service.listSubsidiary[0].subsidiaryCellphone2}') !=
                                  ''
                              ? '-  ${service.listSubsidiary[0].subsidiaryCellphone2}'
                              : '',
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
                        Text("Dirección:"),
                        SizedBox(
                          width: responsive.wp(2),
                        ),
                        Text(
                          '${service.listSubsidiary[0].subsidiaryAddress}',
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
          ]),
        ),
      ],
    );
  }

  Widget _buttomContacto(
      Responsive responsive, SubsidiaryServiceModel service) {
    return Positioned(
        bottom: 0,
        right: 0,
        left: 150,
        child: GestureDetector(
          onTap: () {
            print('Contactar');
            Navigator.push(
                context,
                PageRouteBuilder(
                  opaque: false,
                  transitionDuration: const Duration(milliseconds: 700),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return Contactar(service);
                    //return DetalleProductitos(productosData: productosData);
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                ));
          },
          child: Container(
            height: responsive.hp(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30)),
                color: Colors.blueAccent),
            child: Center(
              child: Text(
                'Contactar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: responsive.ip(3),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ));
  }

  Widget _crearAppbar(
      Responsive responsive, SubsidiaryServiceModel serviceModel) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.white,
      expandedHeight: responsive.hp(30),
      floating: false,
      actions: [],
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Container(
          //color: Colors.red,
          height: responsive.hp(4),
          child: Text(
            '${serviceModel.subsidiaryServiceName}',
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
                    imageUrl:
                        '$apiBaseURL/${serviceModel.subsidiaryServiceImage}',
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
    );
  }
}

class Contactar extends StatefulWidget {
  final SubsidiaryServiceModel service;
  Contactar(this.service);
  @override
  _ContactarState createState() => _ContactarState();
}

class _ContactarState extends State<Contactar> {
  bool expandFlag = false;
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Material(
      color: Colors.black45,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.transparent),
          ),
          Center(
            child: Container(
                margin: EdgeInsets.only(
                    left: responsive.ip(1), right: responsive.ip(1)),
                height: responsive.hp(38),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: ListView(
                  children: [
                    _itemContacto(responsive, 'WhatsApp', 'wp',
                        FontAwesomeIcons.whatsapp, widget.service),
                    _itemContacto(responsive, 'Enviar correo', 'mail',
                        Icons.mail, widget.service),
                    _itemLlamar(responsive, 'Llamar', 'call', Icons.call,
                        widget.service),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget _itemLlamar(Responsive responsive, nombre, ruta, IconData icon,
      SubsidiaryServiceModel service) {
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: responsive.ip(1.5), vertical: responsive.ip(0.5)),
        width: double.infinity,
        height: responsive.ip(24),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  expandFlag = !expandFlag;
                });
              },
              child: Row(
                children: [
                  SizedBox(
                    width: responsive.wp(3),
                  ),
                  Icon(icon),
                  SizedBox(
                    width: responsive.wp(8),
                  ),
                  Text(nombre,
                      style: TextStyle(
                          //color: Colors.red,
                          fontSize: responsive.ip(2),
                          fontWeight: FontWeight.bold)),
                  Spacer(),
                  IconButton(
                      icon: Icon(
                        expandFlag
                            ? Icons.keyboard_arrow_down_outlined
                            : Icons.arrow_right_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          expandFlag = !expandFlag;
                        });
                      }),
                ],
              ),
            ),
            ExpandableContainer(
              expanded: expandFlag,
              expandedHeight: 1,
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () {
                      _launchCall(
                          '${service.listSubsidiary[0].subsidiaryCellphone}');
                    },
                    child: Center(
                      child: Text(
                          '${service.listSubsidiary[0].subsidiaryCellphone}'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if ('${service.listSubsidiary[0].subsidiaryCellphone2}' !=
                          '')
                        _launchCall(
                            '${service.listSubsidiary[0].subsidiaryCellphone2}');
                    },
                    child: Center(
                      child: Text(
                          '${service.listSubsidiary[0].subsidiaryCellphone2}'),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }

  Widget _itemContacto(Responsive responsive, nombre, ruta, IconData icon,
      SubsidiaryServiceModel service) {
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: responsive.ip(1.5), vertical: responsive.ip(0.5)),
        width: double.infinity,
        height: responsive.ip(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: GestureDetector(
          child: Row(
            children: [
              SizedBox(
                width: responsive.wp(3),
              ),
              Icon(icon),
              SizedBox(
                width: responsive.wp(8),
              ),
              Text(nombre,
                  style: TextStyle(
                      //color: Colors.red,
                      fontSize: responsive.ip(2),
                      fontWeight: FontWeight.bold)),
              Spacer(),
              Icon(Icons.arrow_right_outlined),
              SizedBox(
                width: responsive.wp(2),
              ),
            ],
          ),
          onTap: () {
            if (ruta == 'wp') {
              _launchWhatsApp(
                  '${service.listSubsidiary[0].subsidiaryCellphone}',
                  'Estoy interesado en el servicio: ${service.subsidiaryServiceName}');
            } else if (ruta == 'mail') {
              _launchMail('${service.listSubsidiary[0].subsidiaryEmail}',
                  '${service.subsidiaryServiceName}');
            }
          },
        ));
  }

  void _launchWhatsApp(
    String numero,
    String mensaje,
  ) async {
    String url = "whatsapp://send?=+51$numero&text=$mensaje";
    await canLaunch(url) ? launch(url) : print('No se puede abrir WhatsApp');
  }

  void _launchCall(
    String numero,
  ) async {
    String url = 'tel:+51$numero';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchMail(String mail, String mensaje) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: '$mail',
      query:
          'subject=Bufi - $mensaje Feedback&body=Solicito informació acerca del servicio $mensaje',
    );

    var url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class ExpandableContainer extends StatelessWidget {
  final bool expanded;
  final double collapsedHeight;
  final int expandedHeight;
  final Widget child;

  ExpandableContainer({
    @required this.child,
    this.collapsedHeight = 0.0,
    this.expandedHeight = 0,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final responsive = Responsive.of(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: expanded ? expandedHeight * responsive.hp(8) : collapsedHeight,
      child: Container(
        child: child,
        decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.transparent)),
      ),
    );
  }
}
