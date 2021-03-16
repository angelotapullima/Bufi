import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/bienesServiciosModel.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:bufi/src/widgets/busquedas/widgetBusqItemSubcategoria.dart';
import 'package:bufi/src/widgets/widgetBienes.dart';
import 'package:bufi/src/widgets/busquedas/widgetBusqProduct.dart';
import 'package:bufi/src/widgets/widgetServicios.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:shimmer/shimmer.dart';

//Ahora vengo yo csmaree

class ProYSerPorItemSubcategoryPage extends StatefulWidget {
  final String idItem;
  final String nameItem;
  ProYSerPorItemSubcategoryPage(
      {Key key, @required this.idItem, @required this.nameItem})
      : super(key: key);

  @override
  _ProYSerPorItemSubcategoryPageState createState() =>
      _ProYSerPorItemSubcategoryPageState();
}

class _ProYSerPorItemSubcategoryPageState
    extends State<ProYSerPorItemSubcategoryPage> {
  ValueNotifier<bool> switchFiltro = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    final Responsive responsive = new Responsive.of(context);
    final itemSubcatBloc = ProviderBloc.itemSubcategoria(context);
    itemSubcatBloc.listarBienesServiciosXIdItemSubcategoria(widget.idItem);
    return Scaffold(
      body: StreamBuilder(
          stream: itemSubcatBloc.cargandoItemsStream,
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data) {
                bool _enabled = true;
                return SafeArea(
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: responsive.hp(5),
                          child: Stack(
                            children: [
                              BackButton(),
                              Container(
                                padding:
                                    EdgeInsets.only(left: responsive.wp(10)),
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    widget.nameItem,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: responsive.ip(2.5),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
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
                  ),
                );
              } else {
                return SafeArea(
                  child: ValueListenableBuilder(
                      valueListenable: switchFiltro,
                      builder: (BuildContext context, bool data, Widget child) {
                        return Column(
                          children: [
                            Container(
                              height: responsive.hp(5),
                              child: Stack(
                                children: [
                                  BackButton(),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: responsive.wp(10)),
                                    width: double.infinity,
                                    child: Center(
                                      child: Text(
                                        widget.nameItem,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: responsive.ip(2.5),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: responsive.wp(2),
                                ),
                                Expanded(
                                    child: BusquedaItemSubcategoriaWidget(
                                        responsive: responsive)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.category),
                                        onPressed: () {}),
                                    IconButton(
                                        icon: Icon(Icons.filter_list),
                                        onPressed: () {
                                          if (data) {
                                            switchFiltro.value = false;
                                          } else {
                                            switchFiltro.value = true;
                                          }
                                        }),
                                  ],
                                ),
                              ],
                            ),
                            StreamBuilder(
                              stream: itemSubcatBloc.itemSubStream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<BienesServiciosModel>>
                                      snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data.length > 0) {
                                  } else {
                                    return Text("No hay datos para mostrar");
                                  }
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }

                                return (!data)
                                    ? _listaBienesServicios(
                                        snapshot.data, responsive)
                                    : _grilla(snapshot.data, responsive);
                              },
                            ),
                          ],
                        );
                      }),
                );
              }
            } else {
              return Center(
                child: NutsActivityIndicator(
                  radius: 12,
                  activeColor: Colors.white,
                  inactiveColor: Colors.redAccent,
                  tickCount: 11,
                  startRatio: 0.55,
                  animationDuration: Duration(milliseconds: 2003),
                ),
              );
            }
          }),
    );
  }

  Widget _grilla(List<BienesServiciosModel> data, Responsive responsive) {
    return Expanded(
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: .7),
          itemCount: data.length,
          itemBuilder: (context, index) {
            return ('${data[index].tipo}' == 'bienes')
                ? grillaBienes(responsive, data[index])
                : grillaServicios(responsive, data[index]);
          }),
    );
  }

  Widget _listaBienesServicios(
      List<BienesServiciosModel> data, Responsive responsive) {
    return Expanded(
        child: ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return ('${data[index].tipo}' == 'bienes')
            ? _bienesWidget(responsive, data, index)
            //Servicios
            : _serviciosWidget(responsive, data, index);
      },
    ));
  }

  Widget _serviciosWidget(
      Responsive responsive, List<BienesServiciosModel> data, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "detalleServicio");
      },
      child: Container(
        color: Colors.white,
        height: responsive.hp(16),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        width: double.infinity,
        child: Row(
          children: [
            Container(
              width: responsive.wp(30),
              height: responsive.hp(20),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    child: CachedNetworkImage(
                      //cacheManager: CustomCacheManager(),
                      placeholder: (context, url) => Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Image(
                            image: AssetImage('assets/loading.gif'),
                            fit: BoxFit.fitWidth),
                      ),
                      imageUrl:
                          '$apiBaseURL/${data[index].subsidiaryServiceImage}',
                      fit: BoxFit.cover,
                      //'assets/producto.jpg'
                      //'$apiBaseURL/${data[index].subsidiaryGoodImage}'
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      color: Colors.black.withOpacity(.5),
                      width: double.infinity,
                      //double.infinity,
                      child: Text(
                        '${data[index].subsidiaryServiceName}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: responsive.ip(2),
                            fontWeight: FontWeight.bold),
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
            //SizedBox(height: 50),
            Container(
              //color: Colors.red,
              width: responsive.wp(60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${data[index].subsidiaryServiceName}',
                    style: TextStyle(
                        fontSize: responsive.ip(2),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${data[index].subsidiaryServiceCurrency + data[index].subsidiaryServicePrice}',
                    style: TextStyle(
                        fontSize: responsive.ip(2.5),
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${data[index].subsidiaryServiceDescription}',
                    style: TextStyle(
                        fontSize: responsive.ip(1.8),
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    SizedBox(width: 5),
                    Text('${data[index].subsidiaryServiceRating}'),
                    SizedBox(width: 10),
                  ])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bienesWidget(
      Responsive responsive, List<BienesServiciosModel> data, int index) {
    return GestureDetector(
      onTap: () {
        irADetalleProducto(data[index], context);
      },
      child: Container(
        height: responsive.hp(16),
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        width: double.infinity,
        child: Row(
          children: [
            Container(
              width: responsive.wp(30),
              height: responsive.hp(16),
              child: Stack(
                children: [
                  Hero(
                    tag: data[index].idSubsidiarygood,
                    child: Container(
                      child: CachedNetworkImage(
                        //cacheManager: CustomCacheManager(),
                        placeholder: (context, url) => Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: Image(
                              image: AssetImage('assets/loading.gif'),
                              fit: BoxFit.cover),
                        ),
                        imageUrl:
                            '$apiBaseURL/${data[index].subsidiaryGoodImage}',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      color: Colors.black.withOpacity(.5),
                      width: double.infinity,
                      //double.infinity,
                      child: Text(
                        '${data[index].subsidiaryGoodName}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: responsive.ip(2),
                            fontWeight: FontWeight.bold),
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
                      color: Colors.red,
                      //double.infinity,
                      height: responsive.hp(3),
                      child: Text(
                        'Producto',
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
              width: responsive.wp(60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${data[index].subsidiaryGoodName}',
                    style: TextStyle(
                        fontSize: responsive.ip(2.5),
                        fontWeight: FontWeight.bold),
                  ),
                  //Text('${data[index].subsidiaryGoodMeasure}'),

                  Text(
                    '${data[index].subsidiaryGoodCurrency + data[index].subsidiaryGoodPrice}',
                    style: TextStyle(
                        fontSize: responsive.ip(2.5),
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                  Text('${data[index].subsidiaryGoodBrand}',
                      style: TextStyle(
                          fontSize: responsive.ip(2.5),
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    SizedBox(width: 5),
                    //Text('${data[index].subsidiaryGoodRating}'),
                    Text('bien'),
                    SizedBox(width: 10),
                  ])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
