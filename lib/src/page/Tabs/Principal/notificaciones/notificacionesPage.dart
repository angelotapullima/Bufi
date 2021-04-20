import 'package:bufi/src/bloc/provider_bloc.dart';

import 'package:bufi/src/models/notificacionModel.dart';
import 'package:bufi/src/page/Tabs/Principal/notificaciones/detalleNotificacionesPage.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/customCacheManager.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bufi/src/utils/utils.dart';

class NotificacionesPage extends StatefulWidget {
  NotificacionesPage({Key key}) : super(key: key);

  @override
  _NotificacionesPageState createState() => _NotificacionesPageState();
}

class _NotificacionesPageState extends State<NotificacionesPage> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final notificacionesBloc = ProviderBloc.notificaciones(context);
    notificacionesBloc.listarNotificaciones();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: responsive.ip(5.0)),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          // color: Colors.white,
          child: Column(
            children: [
              Container(
                height: responsive.hp(5),
                child: Stack(
                  children: [
                    BackButton(),
                    Container(
                      padding: EdgeInsets.only(
                        left: responsive.wp(5),
                      ),
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          'Notificaciones',
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
              StreamBuilder(
                  stream: notificacionesBloc.listarnotificacionesStream,
                  builder: (context,
                      AsyncSnapshot<List<NotificacionesModel>> snapshot) {
                    List<NotificacionesModel> notificaciones = snapshot.data;

                    if (snapshot.hasData) {
                      if (snapshot.data.length > 0) {
                        return Expanded(
                          child: Container(
                            width: double.infinity,
                            //height: responsive.ip(48),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: notificaciones.length + 1,
                              itemBuilder: (BuildContext context, int i) {
                                if (i == 0) {
                                  return StreamBuilder(
                                      stream: notificacionesBloc
                                          .notificacionesPendientesStream,
                                      builder: (context,
                                          AsyncSnapshot<
                                                  List<NotificacionesModel>>
                                              snapshot) {
                                        if (snapshot.hasData) {
                                          //Para mostrar el mensaje cuando no hay ninguna notificacion pendiente de leer
                                          return (snapshot.data.length == 0)
                                              ? Container(
                                                  color: Colors.transparent,
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        responsive.wp(5),
                                                    vertical: responsive.hp(2),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        'No tienes notificaciones pendientes',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: responsive
                                                                .ip(2),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Divider(),
                                                      SizedBox(
                                                          height:
                                                              responsive.hp(3)),
                                                      Text(
                                                        'Anteriores',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: responsive
                                                                .ip(2.5),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              : Container();
                                        } else {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                      });
                                }
                                int index = i - 1;
                                final pendiente =
                                    notificaciones[index].notificacionEstado ==
                                        "0";
                                var fecha = obtenerFechaHora(
                                    notificaciones[index].notificacionDatetime);
                                return GestureDetector(
                                  onTap: () {
                                    leerNotificacion(
                                        context, notificaciones[index]);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetalleNotificacionesPage(
                                                noti: notificaciones[index],
                                              )),
                                    );

                                    // notificacionesBloc
                                    //     .listarNotificacionesPendientes(
                                    //         notificaciones[index]
                                    //             .idNotificacion);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: responsive.ip(1.5),
                                        vertical: responsive.ip(0.5)),
                                    width: double.infinity,
                                    height: responsive.ip(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: pendiente
                                            ? Colors.red[300]
                                            : Colors.white),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: responsive.wp(20),
                                          height: responsive.hp(20),
                                          child: CachedNetworkImage(
                                            cacheManager: CustomCacheManager(),
                                            placeholder: (context, url) =>
                                                Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              child: Image(
                                                  image: AssetImage(
                                                      'assets/loading.gif'),
                                                  fit: BoxFit.fitWidth),
                                            ),
                                            imageUrl:
                                                '$apiBaseURL/${notificaciones[index].notificacionImagen}',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  '${notificaciones[index].notificacionMensaje}',
                                                  style: TextStyle(
                                                      color: pendiente
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize:
                                                          responsive.ip(2),
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text('$fecha',
                                                  style: TextStyle(
                                                      color: pendiente
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize:
                                                          responsive.ip(2),
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        return Center(
                          child: Container(
                            child: Text("No tienes notificaciones pendientes"),
                          ),
                        );
                      }
                    } else {
                      return Center(
                          child: Text("no tiene ninguna notificaciónfff"));
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
