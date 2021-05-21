import 'package:bufi/src/models/bienesServiciosModel.dart';
import 'package:bufi/src/models/subsidiaryService.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bufi/src/utils/utils.dart' as utils;

class ServiciosWidget extends StatefulWidget {
  final SubsidiaryServiceModel serviceData;
  ServiciosWidget({Key key, @required this.serviceData}) : super(key: key);

  @override
  _ServiciosWidgetState createState() => _ServiciosWidgetState();
}

class _ServiciosWidgetState extends State<ServiciosWidget> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: responsive.wp(1), vertical: responsive.hp(.5)),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ], borderRadius: BorderRadius.circular(8), color: Colors.white),
        width: responsive.wp(42.5),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: responsive.hp(18),
              child: Stack(
                children: <Widget>[
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8)),
                      child: CachedNetworkImage(
                        //cacheManager: CustomCacheManager(),
                        placeholder: (context, url) => Image(
                            image: AssetImage('assets/jar-loading.gif'),
                            fit: BoxFit.cover),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        imageUrl:
                            '$apiBaseURL/${widget.serviceData.subsidiaryServiceImage}',
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
                ],
              ),
            ),
            (widget.serviceData.subsidiaryServiceFavourite == '1')
                ? _favorito(responsive, context)
                : _desfavorito(responsive, context),
            Text(
              widget.serviceData.subsidiaryServiceName,
              style: TextStyle(
                  fontSize: responsive.ip(1.5), color: Color(0XFFb1bdef)),
            ),
            Text(
                '${widget.serviceData.subsidiaryServiceCurrency} ${widget.serviceData.subsidiaryServicePrice}',
                style: TextStyle(
                    fontSize: responsive.ip(1.9),
                    fontWeight: FontWeight.bold,
                    color: Colors.red)),
            Text(
              widget.serviceData.subsidiaryServiceDescription,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: responsive.ip(1.5),
                  color: Colors.red),
            ),
          ],
        ),
      ),
      onTap: () {
        utils.agregarPSaSugerencia(
            context, widget.serviceData.idSubsidiaryservice, 'servicio');
        Navigator.pushNamed(context, 'detalleServicio',
            arguments: widget.serviceData.idSubsidiaryservice);
      },
    );
  }

  Widget _desfavorito(Responsive responsive, BuildContext context) {
    return GestureDetector(
      child: Container(
          height: responsive.hp(5),
          padding: EdgeInsets.symmetric(vertical: responsive.hp(1)),
          color: Colors.white.withOpacity(.4),
          child: Container(
              height: responsive.hp(3.5),
              width: responsive.wp(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(FontAwesomeIcons.heart, color: Colors.red))),
      onTap: () {
        guardarServicioFavorito(context, widget.serviceData);
      },
    );
  }

  Widget _favorito(Responsive responsive, BuildContext context) {
    return GestureDetector(
      child: Container(
        height: responsive.hp(5),
        padding: EdgeInsets.symmetric(vertical: responsive.hp(1)),
        color: Colors.white.withOpacity(.4),
        child: Container(
          height: responsive.hp(3.5),
          width: responsive.wp(12),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(FontAwesomeIcons.solidHeart, color: Colors.red),
        ),
      ),
      onTap: () {
        quitarServicioFavorito(context, widget.serviceData);
      },
    );
  }
}

class ServiciosCompletoWidget extends StatefulWidget {
  final BienesServiciosModel serviceData;
  ServiciosCompletoWidget({Key key, @required this.serviceData})
      : super(key: key);

  @override
  _ServiciosCompletoWidgetState createState() =>
      _ServiciosCompletoWidgetState();
}

class _ServiciosCompletoWidgetState extends State<ServiciosCompletoWidget> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: responsive.wp(1), vertical: responsive.hp(.5)),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ], borderRadius: BorderRadius.circular(8), color: Colors.white),
        width: responsive.wp(42.5),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: responsive.hp(18),
              child: Stack(
                children: <Widget>[
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8)),
                      child: CachedNetworkImage(
                        //cacheManager: CustomCacheManager(),
                        placeholder: (context, url) => Image(
                            image: AssetImage('assets/jar-loading.gif'),
                            fit: BoxFit.cover),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        imageUrl:
                            '$apiBaseURL/${widget.serviceData.subsidiaryServiceImage}',
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
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(
                        responsive.ip(.5),
                      ),
                      color: Colors.blue,
                      //double.infinity,
                      height: responsive.hp(3),
                      child: Text(
                        'Servicio',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: responsive.ip(1.5),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
            (widget.serviceData.subsidiaryServiceFavourite == '1')
                ? _favorito(responsive, context)
                : _desfavorito(responsive, context),
            Text(
              widget.serviceData.subsidiaryServiceName,
              style: TextStyle(
                  fontSize: responsive.ip(1.5), color: Color(0XFFb1bdef)),
            ),
            Text(
                '${widget.serviceData.subsidiaryServiceCurrency} ${widget.serviceData.subsidiaryServicePrice}',
                style: TextStyle(
                    fontSize: responsive.ip(1.9),
                    fontWeight: FontWeight.bold,
                    color: Colors.red)),
            Text(
              widget.serviceData.subsidiaryServiceDescription,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: responsive.ip(1.5),
                  color: Colors.red),
            ),
          ],
        ),
      ),
      onTap: () {
        // utils.agregarPSaSugerencia(
        //     context, widget.serviceData.idSubsidiaryservice, 'servicio');
        Navigator.pushNamed(context, 'detalleServicio',
            arguments: widget.serviceData.idSubsidiaryservice);
      },
    );
  }

  Widget _desfavorito(Responsive responsive, BuildContext context) {
    return GestureDetector(
      child: Container(
          height: responsive.hp(5),
          padding: EdgeInsets.symmetric(vertical: responsive.hp(1)),
          color: Colors.white.withOpacity(.4),
          child: Container(
              height: responsive.hp(3.5),
              width: responsive.wp(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(FontAwesomeIcons.heart, color: Colors.red))),
      onTap: () {
        guardarServicioFavorito2(context, widget.serviceData);
      },
    );
  }

  Widget _favorito(Responsive responsive, BuildContext context) {
    return GestureDetector(
      child: Container(
        height: responsive.hp(5),
        padding: EdgeInsets.symmetric(vertical: responsive.hp(1)),
        color: Colors.white.withOpacity(.4),
        child: Container(
          height: responsive.hp(3.5),
          width: responsive.wp(12),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(FontAwesomeIcons.solidHeart, color: Colors.red),
        ),
      ),
      onTap: () {
        quitarServicioFavorito2(context, widget.serviceData);
      },
    );
  }
}

Widget serviceWidgetCompleto(BuildContext context,
    BienesServiciosModel serviceData, Responsive responsive) {
  return GestureDetector(
    child: Container(
      margin: EdgeInsets.symmetric(
          horizontal: responsive.wp(1), vertical: responsive.hp(1)),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 2), // changes position of shadow
        ),
      ], borderRadius: BorderRadius.circular(8), color: Colors.white),
      width: responsive.wp(42.5),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: responsive.hp(14),
            child: Stack(
              children: <Widget>[
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                    child: CachedNetworkImage(
                      //cacheManager: CustomCacheManager(),
                      placeholder: (context, url) => Image(
                          image: AssetImage('assets/jar-loading.gif'),
                          fit: BoxFit.cover),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      imageUrl:
                          '$apiBaseURL/${serviceData.subsidiaryServiceImage}',
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
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(
                      responsive.ip(.5),
                    ),
                    color: Colors.blue,
                    //double.infinity,
                    height: responsive.hp(3),
                    child: Text(
                      'Servicio',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: responsive.ip(1.5),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )

                //https://tytperu.com/594-thickbox_default/smartphone-samsung-galaxy-s10.jpg
              ],
            ),
          ),
          // Container(
          //     height: responsive.hp(5),
          //     padding: EdgeInsets.symmetric(vertical: responsive.hp(1)),
          //     color: Colors.white.withOpacity(.4),
          //     child: Container(
          //       height: responsive.hp(3.5),
          //       width: responsive.wp(12),
          //       decoration: BoxDecoration(
          //         color: Colors.red.withOpacity(.2),
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //       child: Icon(FontAwesomeIcons.heart, color: Colors.red),
          //     )
          //     //],
          //     //),
          //     ),
          (serviceData.subsidiaryServiceFavourite == '1')
              ? GestureDetector(
                  child: Container(
                    height: responsive.hp(5),
                    padding: EdgeInsets.symmetric(vertical: responsive.hp(1)),
                    color: Colors.white.withOpacity(.4),
                    child: Container(
                      height: responsive.hp(3.5),
                      width: responsive.wp(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                          Icon(FontAwesomeIcons.solidHeart, color: Colors.red),
                    ),
                  ),
                  onTap: () {
                    quitarServicioFavorito2(context, serviceData);
                  },
                )
              : GestureDetector(
                  child: Container(
                      height: responsive.hp(5),
                      padding: EdgeInsets.symmetric(vertical: responsive.hp(1)),
                      color: Colors.white.withOpacity(.4),
                      child: Container(
                          height: responsive.hp(3.5),
                          width: responsive.wp(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                              Icon(FontAwesomeIcons.heart, color: Colors.red))),
                  onTap: () {
                    guardarServicioFavorito2(context, serviceData);
                  },
                ),
          Text(
            serviceData.subsidiaryServiceName,
            style: TextStyle(
                fontSize: responsive.ip(1.5), color: Color(0XFFb1bdef)),
          ),
          Text(
              '${serviceData.subsidiaryServiceCurrency} ${serviceData.subsidiaryServicePrice}',
              style: TextStyle(
                  fontSize: responsive.ip(1.9),
                  fontWeight: FontWeight.bold,
                  color: Colors.red)),
          Text(
            serviceData.subsidiaryServiceDescription,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: responsive.ip(1.5),
                color: Colors.red),
          ),
        ],
      ),
    ),
    onTap: () {
      utils.agregarPSaSugerencia(
          context, serviceData.idSubsidiaryservice, 'servicio');
      Navigator.pushNamed(context, 'detalleServicio',
          arguments: serviceData.idSubsidiaryservice);
    },
  );
}

Widget grillaServicios(Responsive responsive, BienesServiciosModel data) {
  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: responsive.wp(1),
      vertical: responsive.hp(1),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 2), // changes position of shadow
        ),
      ],
    ),
    width: responsive.wp(42.5),
    child: Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: responsive.hp(18),
          child: Stack(
            children: <Widget>[
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                  child: CachedNetworkImage(
                    //cacheManager: CustomCacheManager(),
                    placeholder: (context, url) => Image(
                        image: AssetImage('assets/jar-loading.gif'),
                        fit: BoxFit.cover),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    imageUrl: '$apiBaseURL/${data.subsidiaryServiceImage}',
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
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(responsive.ip(.5)),
                  color: Colors.blue,
                  //double.infinity,
                  height: responsive.hp(3),
                  child: Text(
                    'Servicio',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: responsive.ip(1.5),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          height: responsive.hp(5),
          padding: EdgeInsets.symmetric(vertical: responsive.hp(1)),
          //color: Colors.white.withOpacity(.8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: responsive.hp(3.5),
                width: responsive.wp(20),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.shoppingCart,
                      size: responsive.ip(1.5),
                      color: Colors.blue[800],
                    ),
                    SizedBox(
                      width: responsive.wp(1),
                    ),
                  ],
                ),
              ),
              Container(
                height: responsive.hp(3.5),
                width: responsive.wp(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(FontAwesomeIcons.heart, color: Colors.red),
              )
            ],
          ),
        ),
        Text(
          '${data.subsidiaryServiceName}',
          style: TextStyle(
              fontSize: responsive.ip(1.5),
              color: Colors.grey[800],
              fontWeight: FontWeight.w700),
        ),
        Text('${data.subsidiaryServiceCurrency} ${data.subsidiaryServicePrice}',
            style: TextStyle(
                fontSize: responsive.ip(1.9),
                fontWeight: FontWeight.bold,
                color: Colors.red)),
        Text(
          '${data.subsidiaryServiceDescription}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: responsive.ip(1.5),
              color: Colors.red),
        ),
      ],
    ),
  );
}
