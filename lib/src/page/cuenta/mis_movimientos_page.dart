import 'package:bufi/src/bloc/mis_movimientos_bloc.dart';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MisMovimientosPage extends StatelessWidget {
  const MisMovimientosPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final misMovimientosBloc = ProviderBloc.misMov(context);
    misMovimientosBloc.obtenerMisMovimientos();
    misMovimientosBloc.cargandoMovimientosFalse();

    final responsive = Responsive.of(context);
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        elevation: 0,
        title: Text('Mis Movimientos'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 5),
        padding: EdgeInsets.only(
          top: 5,
          right: responsive.wp(2),
          left: responsive.wp(3),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          color: Colors.white,
        ),
        child: StreamBuilder(
          stream: misMovimientosBloc.misMovimientosBlocstream,
          builder: (BuildContext context,
              AsyncSnapshot<List<MovimientosPorFecha>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      leading: null,
                      leadingWidth: 0,
                      backgroundColor: Colors.white,
                      expandedHeight: responsive.hp(5),
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Row(
                          children: [
                            Text(
                              'Concepto',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: responsive.ip(2),
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Text(
                              'Monto',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: responsive.ip(2),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          var fecha = obtenerFecha(snapshot.data[index].fecha);
                          return ListView.builder(
                              padding: EdgeInsets.symmetric(
                                vertical: responsive.hp(.8),
                              ),
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount:
                                  snapshot.data[index].listMovimientos.length +
                                      1,
                              itemBuilder: (context, i) {
                                if (i == 0) {
                                  return Text(
                                    '$fecha',
                                    style: TextStyle(
                                        fontSize: responsive.ip(2),
                                        fontWeight: FontWeight.bold),
                                  );
                                }
                                int ii = i - 1;
                                return InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, 'ticketMovimientos',
                                        arguments:
                                            '${snapshot.data[index].listMovimientos[ii].nroOperacion}');
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom: responsive.hp(2),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${snapshot.data[index].listMovimientos[ii].concepto}',
                                                style: TextStyle(
                                                  fontSize: responsive.ip(1.5),
                                                ),
                                              ),
                                              Text(
                                                '${snapshot.data[index].listMovimientos[ii].fecha}',
                                                style: TextStyle(
                                                  fontSize: responsive.ip(1.5),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: responsive.wp(1),
                                        ),
                                        ('${snapshot.data[index].listMovimientos[ii].ind}' ==
                                                '0')
                                            ? Icon(
                                                Icons.arrow_downward,
                                                color: Colors.red,
                                              )
                                            : Icon(Icons.arrow_upward,
                                                color: Colors.green),
                                        SizedBox(
                                          width: responsive.wp(1),
                                        ),
                                        Container(
                                          width: responsive.wp(17),
                                          child: Text(
                                            'S/. ${snapshot.data[index].listMovimientos[ii].monto}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: responsive.ip(1.5),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: responsive.wp(11),
                                          child: Image(
                                            image:
                                                AssetImage('assets/moneda.png'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        childCount: snapshot.data.length,
                      ),
                    )
                  ],
                );
              } else {
                return Center(
                  child: StreamBuilder(
                      stream: misMovimientosBloc.cargadoApiMovimientos,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return (snapshot.data)
                              ? Center(
                                  child: CupertinoActivityIndicator(),
                                )
                              : Center(child: Text('No hay Movimientos'));
                        } else {
                          return Center(
                            child: CupertinoActivityIndicator(),
                          );
                        }
                      }),
                );
              }
            } else {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
