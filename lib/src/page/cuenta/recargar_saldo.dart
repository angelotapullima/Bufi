import 'package:bufi/src/bloc/cuenta_bloc.dart';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/database/tipo_pago_database.dart';
import 'package:bufi/src/models/tipos_pago_model.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/customCacheManager.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:bufi/src/widgets/clipper_ticket.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bufi/src/widgets/extentions.dart';

class RecargarSaldo extends StatelessWidget {
  const RecargarSaldo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cuentaBloc = ProviderBloc.cuenta(context);
    cuentaBloc.obtenerRecargaPendiente();

    deseleccionarTiposPago();
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: cuentaBloc.recargaStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<RecargaModel>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return (snapshot.data[0].result == '3')
                  ? TieneRecargas(
                      pagos: snapshot.data[0],
                    )
                  : NotieneRecargas();
            } else {
              return Container(
                width: double.infinity,
                child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Consultando recargas'),
                        CircularProgressIndicator(),
                      ]),
                ),
              );
            }
          } else {
            return Container(
              width: double.infinity,
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Consultando recargas'),
                      CircularProgressIndicator(),
                    ]),
              ),
            );
          }
        },
      ),
    );
  }
}

class NotieneRecargas extends StatefulWidget {
  const NotieneRecargas({Key key}) : super(key: key);

  @override
  _NotieneRecargasState createState() => _NotieneRecargasState();
}

class _NotieneRecargasState extends State<NotieneRecargas> {
  TextEditingController controlMonto = TextEditingController();
  final _cargando = ValueNotifier<bool>(false);

  @override
  void dispose() {
    controlMonto?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final tiposPagoBloc = ProviderBloc.tiPago(context);
    tiposPagoBloc.obtenerTiposPago();
    tiposPagoBloc.obtenerTipoPagoSeleccionado();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Métodos para recargar tus bufis',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ValueListenableBuilder(
          valueListenable: _cargando,
          builder: (BuildContext context, bool dataToque, Widget child) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: responsive.hp(2),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(2),
                        ),
                        child: Text(
                          'Seleccione un método de recarga',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: responsive.ip(1.8),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: responsive.hp(2),
                      ),
                      StreamBuilder(
                        stream: tiposPagoBloc.tiposPagoStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<TiposPagoModel>> snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.length > 0) {
                              return GridView.builder(
                                  padding: EdgeInsets.all(0),
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          childAspectRatio: 1),
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return bottonCircular(
                                        responsive, snapshot.data[index]);
                                  });
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        },
                      ),
                      StreamBuilder(
                        stream: tiposPagoBloc.mensajeTipoPagoSeleccionadoStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<TiposPagoModel>> snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.length > 0) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: responsive.wp(2),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: responsive.hp(2),
                                    ),
                                    Text(
                                      snapshot.data[0].tipoPagoMsj,
                                      style: TextStyle(
                                          fontSize: responsive.ip(1.5),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        },
                      ),
                      SizedBox(
                        height: responsive.hp(2),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Monto a recargar',
                              style: TextStyle(
                                fontSize: responsive.ip(1.8),
                              ),
                            ),
                            SizedBox(
                              height: responsive.hp(.5),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: controlMonto,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: 'monto',
                                      fillColor: Colors.white,
                                      hintStyle: TextStyle(
                                        fontSize: responsive.ip(2),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey[300]),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                      filled: true,
                                      contentPadding: EdgeInsets.all(8),
                                      //errorText: snapshot.error,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: responsive.wp(5),
                                ),
                                FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(color: Colors.green),
                                  ),
                                  color: Colors.green,
                                  onPressed: () async {
                                    _cargando.value = true;
                                    final tiposPagoDatabase =
                                        TiposPagoDatabase();

                                    final listaTipos = await tiposPagoDatabase
                                        .obtenerTiposPagoSeleccionado();

                                    if (listaTipos.length > 0) {
                                      if (controlMonto.text.isEmpty) {
                                        showToast(context,
                                            'Por favor indique un monto de recarga');
                                      } else {
                                        //llamada api

                                        print('llamada api');
                                      }

                                      _cargando.value = false;
                                    } else {
                                      showToast(context,
                                          'Por favor seleccione un método de recarga');

                                      _cargando.value = false;
                                    }
                                  },
                                  child: Text(
                                    'Solicitar',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                (dataToque)
                    ? Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: Colors.black.withOpacity(.6),
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: responsive.wp(10),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: responsive.wp(10),
                            ),
                            width: double.infinity,
                            height: responsive.hp(13),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: responsive.wp(10),
                                vertical: responsive.wp(6),
                              ),
                              height: responsive.ip(4),
                              width: responsive.ip(4),
                              child: Image(
                                  image: AssetImage('assets/loading.gif'),
                                  fit: BoxFit.contain),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            );
          }),
    );
  }

  Widget bottonCircular(Responsive responsive, TiposPagoModel tiposPagoModel) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[50],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, .3),
            ),
          ],
        ),
        margin: EdgeInsets.all(
          responsive.wp(1),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: responsive.wp(2),
          vertical: responsive.hp(1),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    height: responsive.ip(6),
                    width: responsive.ip(6),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        cacheManager: CustomCacheManager(),
                        placeholder: (context, url) => Image(
                            image: AssetImage('assets/jar-loading.gif'),
                            fit: BoxFit.cover),
                        errorWidget: (context, url, error) => Image(
                            image: AssetImage('assets/carga_fallida.jpg'),
                            fit: BoxFit.cover),
                        imageUrl: '$apiBaseURL/${tiposPagoModel.tipoPagoImg}',
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
                  Text(
                    tiposPagoModel.tipoPagoNombre,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            (tiposPagoModel.seleccionado == '1')
                ? Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: responsive.wp(3.5),
                      backgroundColor: Colors.red,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ).ripple(
        () {
          seleccionarTiposPago(context, tiposPagoModel.idTipoPago);
        },
        /* borderRadius: BorderRadius.all(
          Radius.circular(13),
        ), */
      ),
    );
  }
}

class TieneRecargas extends StatelessWidget {
  final RecargaModel pagos;
  const TieneRecargas({Key key, @required this.pagos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Scaffold(
      backgroundColor: Color(0xff303c59),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(
                  horizontal: responsive.wp(2),
                ),
                child: PhysicalShape(
                  color: Colors.white,
                  shadowColor: Colors.blue,
                  elevation: .5,
                  clipper: TicketClipper(),
                  child: Container(
                    height: 60,
                    child: Center(
                      child: Text(
                        'Recarga Pendiente',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: responsive.ip(1.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                margin: EdgeInsets.symmetric(
                  horizontal: responsive.wp(3.5),
                ),
                child: MySeparator(
                  color: Color(0xff303c59),
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(
                  horizontal: responsive.wp(2),
                ),
                child: PhysicalShape(
                  color: Colors.white,
                  shadowColor: Colors.blue,
                  elevation: .5,
                  clipper: ExtendedClipper(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: responsive.hp(2),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                          left: responsive.wp(1.5),
                        ),
                        height: responsive.hp(12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                            image: AssetImage('assets/logo_bufeotec.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: responsive.hp(2),
                      ),
                      Text(
                        pagos.codigo,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: responsive.ip(6.5),
                        ),
                      ),
                      SizedBox(
                        height: responsive.hp(3),
                      ),
                      Divider(),
                      /* Container(
                        color: Colors.white,
                        margin: EdgeInsets.symmetric(
                          horizontal: responsive.wp(1.5),
                        ),
                        child: MySeparator(
                          color: Color(0xFF648BE7),
                        ),
                      ), */
                      SizedBox(
                        height: responsive.hp(1.5),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: responsive.wp(4),
                          ),
                          Text(
                            'Monto',
                            style: TextStyle(
                              fontSize: responsive.ip(2),
                            ),
                          ),
                          Spacer(),
                          Text(
                            'S/ ${pagos.monto}',
                            style: TextStyle(
                              fontSize: responsive.ip(2),
                            ),
                          ),
                          SizedBox(
                            width: responsive.wp(4),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: responsive.hp(1.5),
                      ),
                      Divider(),
                      SizedBox(
                        height: responsive.hp(1.5),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: responsive.wp(3.5)),
                        child: Text(
                          pagos.mensaje,
                          style: TextStyle(
                              fontSize: responsive.ip(1.7),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: responsive.hp(1.5),
                      ),
                      Divider(),
                      SizedBox(
                        height: responsive.hp(1.5),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Ver Agentes',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: responsive.hp(4),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: responsive.hp(4.5),
            left: responsive.wp(2),
            child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: CircleAvatar(
                radius: responsive.ip(1.8),
                backgroundColor: Colors.white,
                child: Icon(Icons.close),
              ),
            ),
          )
        ],
      ),
    );
  }
}
