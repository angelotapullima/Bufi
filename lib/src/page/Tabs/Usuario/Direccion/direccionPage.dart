import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/direccionModel.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bufi/src/widgets/extentions.dart';

class DireccionDeliveryPage extends StatelessWidget {
  const DireccionDeliveryPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    final direccionesBloc = ProviderBloc.direc(context);
    direccionesBloc.obtenerDirecciones();
    return Scaffold(
      body: StreamBuilder(
          stream: direccionesBloc.direccionesStream,
          builder: (context, AsyncSnapshot<List<DireccionModel>> snapshot) {
            if (snapshot.hasData) {
              return SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        BackButton(),
                        Container(
                          child: Text(
                            "Direcciónes de entrega",
                            style: TextStyle(
                                fontSize: responsive.ip(2),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: responsive.wp(60),
                          height: responsive.hp(7),
                          padding: EdgeInsets.symmetric(
                              vertical: responsive.hp(.5),
                              horizontal: responsive.wp(2)),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(35),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              Expanded(
                                child: Text(
                                  'Agregar una dirección',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ).ripple(
                          () {
                            Navigator.pushNamed(context, 'agregarDireccion');
                          },
                        ),
                        // (snapshot.data.length > 0)
                        //     ? Container(
                        //         width: responsive.wp(30),
                        //         padding: EdgeInsets.symmetric(
                        //             vertical: responsive.hp(.5),
                        //             horizontal: responsive.wp(2)),
                        //         decoration: BoxDecoration(
                        //           color: Colors.red,
                        //           borderRadius: BorderRadius.circular(35),
                        //         ),
                        //         child: Row(
                        //           children: [
                        //             Icon(
                        //               Icons.delete,
                        //               color: Colors.white,
                        //             ),
                        //             Expanded(
                        //               child: Text(
                        //                 'Eliminar direcciones',
                        //                 textAlign: TextAlign.center,
                        //                 style: TextStyle(color: Colors.white),
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ).ripple(
                        //         () {},
                        //       )
                        //     : Container()
                      ],
                    ),
                    SizedBox(
                      height: responsive.hp(3),
                    ),
                    (snapshot.data.length > 0)
                        ? Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: snapshot.data.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        left: responsive.wp(55)),
                                    child: Container(
                                      width: responsive.wp(40),
                                      padding: EdgeInsets.symmetric(
                                          vertical: responsive.hp(.5),
                                          horizontal: responsive.wp(2)),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.check,
                                            color: Colors.white,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Eliminar todo',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ).ripple(
                                      () async {
                                        eliminarTodasLasDirecciones(context);
                                      },
                                    ),
                                  );
                                }
                                int i = index - 1;
                                return Container(
                                  //color: Colors.blue,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: responsive.wp(2),
                                      ),
                                      Icon(Icons.home),
                                      SizedBox(
                                        width: responsive.wp(2),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${snapshot.data[i].address}',
                                              style: TextStyle(
                                                  fontSize: responsive.ip(1.7),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '${snapshot.data[i].referencia}',
                                              style: TextStyle(
                                                fontSize: responsive.ip(1.7),
                                              ),
                                            ),
                                            Text(
                                              '${snapshot.data[i].distrito}',
                                              style: TextStyle(
                                                fontSize: responsive.ip(1.7),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: responsive.wp(2),
                                      ),
                                      IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            eliminarDireccion(
                                                context, snapshot.data[i]);
                                          })
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(
                            child: Text('No se regitró ninguna dirección'),
                          )
                  ],
                ),
              );
            } else {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
          }),
    );
  }
}
