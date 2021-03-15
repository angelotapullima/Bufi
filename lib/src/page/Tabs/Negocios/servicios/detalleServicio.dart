

import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/subsidiaryService.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetalleServicio extends StatefulWidget {
  final SubsidiaryServiceModel servicio;
  const DetalleServicio({Key key, @required this.servicio}) : super(key: key);


  @override
  _DetalleServicioState createState() => _DetalleServicioState();
}

class _DetalleServicioState extends State<DetalleServicio> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final String id = ModalRoute.of(context).settings.arguments;
    final detailServicioBloc = ProviderBloc.servi(context);
    detailServicioBloc.detalleServicioPorIdSubsidiaryService(id);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            child: StreamBuilder(
                stream: detailServicioBloc.detailServiciostream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length > 0) {
                      List<SubsidiaryServiceModel> listservices = snapshot.data;
                      return Stack(
                        children: [
                          SingleChildScrollView(
                              child: Column(
                            children: [
                              Container(
                                height: responsive.hp(45),
                                width: double.infinity,
                                child: CachedNetworkImage(
                                  //cacheManager: CustomCacheManager(),
                                  placeholder: (context, url) => Image(
                                      image:
                                          AssetImage('assets/jar-loading.gif'),
                                      fit: BoxFit.cover),
                                  errorWidget: (context, url, error) => Image(
                                      image: AssetImage(
                                          'assets/carga_fallida.jpg'),
                                      fit: BoxFit.cover),
                                  imageUrl:
                                      '$apiBaseURL/${listservices[0].subsidiaryServiceImage}',
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "${listservices[0].subsidiaryServiceName} ",
                                      style: TextStyle(fontSize: 24),
                                      textAlign: TextAlign.center,
                                    ),

                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Seleccione"),
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        child: Text("Editar"),
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                      ),
                                                      GestureDetector(
                                                        child: Text(
                                                            "Deshabilitar"),
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: Text(
                                                                      "¿Está seguro de que desea deshabilitar el servicio?"),
                                                                  content: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      children: [
                                                                        GestureDetector(
                                                                          child:
                                                                              Text("SI"),
                                                                          onTap:
                                                                              () async {
                                                                            /* //Navigator.pop(context);

                                                                            SubsidiaryServiceModel
                                                                                subsidiaryServiceModel =
                                                                                SubsidiaryServiceModel();
                                                                            subsidiaryServiceModel.idSubsidiaryservice =
                                                                                id;
                                                                            final serviceApi =
                                                                                ServiceApi();
                                                                            final res =
                                                                                await serviceApi.deshabilitarSubsidiaryService(id);
                                                                            if (res.toString() ==
                                                                                '1') {
                                                                              final subserviceDb = SubsidiaryServiceDatabase();
                                                                              await subserviceDb.deshabilitarSubsidiaryServiceDb(subsidiaryServiceModel);
                                                                              Navigator.pop(context);
                                                                              print('Servicio Deshabilitado');
                                                                              //AlertDialog(title: Text("Servicio Deshabilitado"));
                                                                            } else {
                                                                              Navigator.pop(context);
                                                                              Navigator.pop(context);
                                                                              print('Estamos cagados');
                                                                            }

                                                                            // if (subsidiaryServiceModel.subsidiaryServiceStatus=='1') {
                                                                            // }
                                                                            // else{
                                                                            //   final subserviceDb = SubsidiaryServiceDatabase();
                                                                            //   await subserviceDb.habilitarSubsidiaryServiceDb(subsidiaryServiceModel);
                                                                            // } */
                                                                          },
                                                                        ),
                                                                        GestureDetector(
                                                                          child:
                                                                              Text("NO"),
                                                                          onTap:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                        ),
                                                                      ]),
                                                                );
                                                              });
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      icon: Icon(Icons.edit),
                                    )
                                    //Icon(Icons.edit)
                                  ],
                                ),
                              ),
                              Text(
                                "${listservices[0].subsidiaryServiceCurrency} ${listservices[0].subsidiaryServicePrice}",
                                style: TextStyle(fontSize: 22),
                              ),

                              Text(
                                ("${listservices[0].subsidiaryServiceStatus}" ==
                                        '1')
                                    ? 'habilitado'
                                    : 'deshabilitado',
                                style: TextStyle(fontSize: 24),
                                textAlign: TextAlign.center,
                              ),
                              // Text(listservices[0].subsidiaryServiceBrand),
                              // Text(listservices[0].subsidiaryServiceModel),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 2,
                                    child: Container(
                                      width: responsive.hp(50),
                                      height: responsive.hp(20),
                                      child: Column(children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text("Descripción",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        //Text(listservices[0].subsidiaryServiceBrand),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 25.0, bottom: 15),
                                          child: Column(children: [
                                            Text(
                                                listservices[0]
                                                    .subsidiaryServiceDescription,
                                                style: TextStyle(fontSize: 16)),
                                            Text(
                                                listservices[0]
                                                    .subsidiaryServiceStatus,
                                                style: TextStyle(fontSize: 16)),
                                            Text(
                                                listservices[0]
                                                    .subsidiaryServiceRating,
                                                style: TextStyle(fontSize: 16)),
                                          ]),
                                        ),
                                      ]),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )),
                          _agregarAlCarrito(responsive, listservices)
                        ],
                      );
                    } else {
                      return Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            Text('El servicio se encuentra deshabilitado',
                                style: TextStyle(fontSize: responsive.ip(2))),
                            Text(
                              '¿desea habilitarlo?',
                              style: TextStyle(fontSize: responsive.ip(2)),
                            ),
                            RaisedButton(
                              onPressed: () async {
                                await _submit(id, context);
                              },
                              child: Text("Si"),
                            )
                          ]));
                    }
                  } else {
                    return Center(child: CupertinoActivityIndicator());
                  }
                }),
          ),
        ],
      ),
    );
  }

  Future _submit(String id, BuildContext context) async {

  /*   SubsidiaryServiceModel subsidiaryServiceModel = SubsidiaryServiceModel();
    subsidiaryServiceModel.idSubsidiaryservice = id;
    final serviceApi = ServiceApi();
    final res = await serviceApi.deshabilitarSubsidiaryService(id);
    if (res.toString() == '1') {
      final subserviceDb = SubsidiaryServiceDatabase();
      await subserviceDb.deshabilitarSubsidiaryServiceDb(subsidiaryServiceModel);
      Navigator.pop(context);
      print('Servicio Deshabilitado');
     
    } else {
      Navigator.pop(context);
      //Navigator.pop(context);
      print('Estamos cagados');
    } */
  }

  Widget _agregarAlCarrito(
      Responsive responsive, List<SubsidiaryServiceModel> listservices) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: responsive.hp(13),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(50.0),
              topRight: const Radius.circular(50.0)),
          color: Colors.grey[300],
        ),
        //margin: EdgeInsets.only(top: responsive.hp(80)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
                "${listservices[0].subsidiaryServiceCurrency} ${listservices[0].subsidiaryServicePrice}",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            RaisedButton(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                //padding: EdgeInsets.all(0.0),
                child: Text(
                  'Añadir al carrito',
                  style: TextStyle(fontSize: 16),
                ),
                color: Color(0xFFF93963),
                textColor: Colors.white,
                onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
