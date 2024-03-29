import 'package:bufi/src/api/categorias_api.dart';
import 'package:bufi/src/api/configuracion_api.dart';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/theme/theme.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/services.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with AfterLayoutMixin {
  @override
  void afterFirstLayout(BuildContext context) async {
    final preferences = Preferences();
    final categoriaApi = CategoriasApi();
    final configuracionApi = ConfiguracionApi();

    if (preferences.cargaCategorias == null) {
      await categoriaApi.obtenerCategorias(context);
      await configuracionApi.obtenerConfiguracion();
      preferences.cargaCategorias = 'paso';
    } else {
      categoriaApi.obtenerCategorias(context);
      configuracionApi.obtenerConfiguracion();
    }

    var fecha = DateTime.now();
    var hora = fecha.hour;
    if (hora >= 18) {
      preferences.saludo = 'Buenas noches';
    } else if (hora >= 12) {
      preferences.saludo = 'Buenas tardes';
    } else {
      preferences.saludo = 'Buenos días';
    }

    Navigator.pushReplacementNamed(context, 'home');

    /*  if (preferences.personName != null) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      Navigator.pushReplacementNamed(context, 'login');
    }  */
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Theme.of(context).brightness,
      statusBarColor: Colors.transparent,
    ));

    final responsive = Responsive.of(context);

    final buttonBloc = ProviderBloc.tabs(context);
    buttonBloc.changePage(0);

    final porcentajeBloc = ProviderBloc.porcentaje(context);
    return Scaffold(
      backgroundColor: InstagramColors.blue,
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlutterLogo(
                  size: responsive.ip(20),
                ),
                SizedBox(
                  height: responsive.hp(2.5),
                ),
                NutsActivityIndicator(
                  radius: 15,
                  activeColor: Colors.white,
                  inactiveColor: Colors.redAccent,
                  tickCount: 11,
                  startRatio: 0.55,
                  animationDuration: Duration(milliseconds: 2003),
                ),
                SizedBox(
                  height: responsive.hp(1.5),
                ),
                Text(
                  'Estamos cargando nuestros productos',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: responsive.ip(1.8), color: Colors.white),
                ),
                StreamBuilder(
                  stream: porcentajeBloc.procentajeStream,
                  builder: (context, snapshot) {
                    double porcentaje2 = porcentajeBloc.procentaje;
                    int porcentaje = 0;
                    if (porcentaje2 != null) {
                      porcentaje = porcentaje2.toInt();
                    }

                    return Text(
                      '$porcentaje%',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: responsive.ip(1.8), color: Colors.white),
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
