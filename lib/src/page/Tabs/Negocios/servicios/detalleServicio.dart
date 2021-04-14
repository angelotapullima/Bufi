import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/subsidiaryService.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/detalleProducto/detalleProducto.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rating_bar/rating_bar.dart';

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
                return
                    //Center(child: Text(negocio[0].companyName));
                    _custonScroll(responsive, snapshot.data[0]);
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
                              ? 'SI'
                              : 'NO',
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
