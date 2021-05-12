import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bufi/src/widgets/extentions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: _datos(context, responsive),
      )),
    );
  }

  Widget _datos(BuildContext context, Responsive responsive) {
    final cuentaBloc = ProviderBloc.cuenta(context);
    final prefs = new Preferences();

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: responsive.hp(3.5)),
          if (prefs.personName != null)
            Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: responsive.ip(1.5),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: responsive.hp(2),
                    horizontal: responsive.wp(2),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: responsive.ip(10),
                        height: responsive.ip(10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: Image(
                                  image: AssetImage('assets/no-image.png'),
                                  fit: BoxFit.cover),
                            ),
                            errorWidget: (context, url, error) => Container(
                                width: double.infinity,
                                height: double.infinity,
                                child: Center(child: Icon(Icons.error))),
                            imageUrl: '${prefs.userImage}',
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: responsive.wp(4.5),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              '${prefs.personName} ${prefs.personSurname}',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: responsive.ip(1.8),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${prefs.userEmail}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: responsive.ip(1.8)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${prefs.userNickname}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: responsive.ip(1.8)),
                            ),
                            // Text(
                            //   'Ver Perfil',
                            //   style: TextStyle(
                            //       fontSize: responsive.ip(1.8),
                            //       color: Colors.blueAccent,
                            //       fontWeight: FontWeight.bold),
                            // ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: responsive.hp(2),
                ),

                //Pedidos
                Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: responsive.ip(1.5),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: responsive.hp(2),
                      horizontal: responsive.wp(2),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Column(
                      children: [
                        Text(
                          "Mis Pedidos",
                          style: TextStyle(
                              fontSize: responsive.ip(2.5),
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: responsive.hp(1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            bottonPedido(responsive, 'Pendientes de Envío'),
                            bottonPedido(responsive, 'Enviados'),
                            // bottonPedido(
                            //     responsive, 'Pendientes de valoración'),
                          ],
                        ),
                      ],
                    )),

                //Bufis
                Container(
                  margin: EdgeInsets.all(
                    responsive.ip(1.5),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: responsive.hp(2),
                    horizontal: responsive.wp(2),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Column(
                    children: [
                      SizedBox(height: responsive.hp(1.5)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          bottonCircular(responsive, 'Recargas'),
                          bottonCircular(responsive, 'misMovimientos'),
                          bottonCircular(responsive, 'Agentes'),
                        ],
                      ),
                      SizedBox(
                        height: responsive.hp(1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          bottonCircular(responsive, 'puntos de Recargas'),
                          bottonCircular(
                              responsive, 'información de mi cuenta'),
                          bottonCircular(responsive, 'Compras'),
                        ],
                      )
                    ],
                  ),
                ),

                _item(responsive, "Mi perfil", "perfil", FontAwesomeIcons.user),
              ],
            )
          else
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(responsive.ip(1.5)),
                  child: InkWell(
                    onTap: () async {
                      prefs.clearPreferences();

                      Navigator.pushNamedAndRemoveUntil(
                          context, 'login', (route) => false);
                    },
                    child: new Container(
                      //width: 100.0,
                      height: responsive.hp(6),
                      decoration: new BoxDecoration(
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 3)
                        ],
                        color: Colors.white,
                        border:
                            new Border.all(color: Colors.grey[300], width: 1.0),
                        borderRadius: new BorderRadius.circular(8.0),
                      ),
                      child: new Center(
                        child: new Text(
                          'Iniciar sesión',
                          style: new TextStyle(
                              fontSize: responsive.ip(2),
                              fontWeight: FontWeight.w800,
                              color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ),
                Text('No hay Usuario'),
                _item(responsive, "Agentes", "agentes", Icons.gps_fixed),
              ],
            ),

          //Direccion
          _item(responsive, "Direcciones de entrega", "direccion",
              Icons.gps_fixed),

          _itemCarrito(responsive, "Carrito", Icons.shopping_cart),

          _itemUrl(
              responsive,
              "Políticas de Privacidad",
              'https://politicas.lacasadelasenchiladas.pe/politicas-privacidad.html',
              Icons.privacy_tip_outlined),

          _itemUrl(
              responsive,
              "Términos y Condiciones",
              'https://politicas.lacasadelasenchiladas.pe/politicas-privacidad.html',
              Icons.save_alt),

          _item(responsive, "Configuración", "direccion", Icons.settings),

          //SizedBox(height: responsive.hp(2)),

          Container(
              margin: EdgeInsets.symmetric(
                  horizontal: responsive.ip(1.5), vertical: responsive.ip(0.5)),
              width: double.infinity,
              height: responsive.ip(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: ListTile(
                title: Text("Versión de la app",
                    style: TextStyle(
                        //color: Colors.red,
                        fontSize: responsive.ip(2),
                        fontWeight: FontWeight.bold)),
                subtitle: Text("Versión 1.0",
                    style: TextStyle(
                        //color: Colors.red,
                        fontSize: responsive.ip(2),
                        fontWeight: FontWeight.bold)),
              )),
          if (prefs.personName != null)
            Padding(
              padding: EdgeInsets.all(responsive.ip(1.5)),
              child: InkWell(
                onTap: () async {
                  prefs.clearPreferences();

                  Navigator.pushNamedAndRemoveUntil(
                      context, 'login', (route) => false);
                },
                child: new Container(
                  //width: 100.0,
                  height: responsive.hp(6),
                  decoration: new BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 3)
                    ],
                    color: Colors.white,
                    border: new Border.all(color: Colors.grey[300], width: 1.0),
                    borderRadius: new BorderRadius.circular(8.0),
                  ),
                  child: new Center(
                    child: new Text(
                      'Cerrar sesión',
                      style: new TextStyle(
                          fontSize: responsive.ip(2),
                          fontWeight: FontWeight.w800,
                          color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _item(Responsive responsive, nombre, ruta, IconData icon) {
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: responsive.ip(1.5), vertical: responsive.ip(0.5)),
        width: double.infinity,
        height: responsive.ip(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: ListTile(
          title: Text(nombre,
              style: TextStyle(
                  //color: Colors.red,
                  fontSize: responsive.ip(2),
                  fontWeight: FontWeight.bold)),
          leading: Icon(icon),
          trailing: Icon(Icons.arrow_right_outlined),
          onTap: () {
            Navigator.pushNamed(context, ruta);
          },
        ));
  }

  Widget _itemUrl(Responsive responsive, nombre, url, IconData icon) {
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: responsive.ip(1.5), vertical: responsive.ip(0.5)),
        width: double.infinity,
        height: responsive.ip(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: ListTile(
          title: Text(nombre,
              style: TextStyle(
                  //color: Colors.red,
                  fontSize: responsive.ip(2),
                  fontWeight: FontWeight.bold)),
          leading: Icon(icon),
          trailing: Icon(Icons.arrow_right_outlined),
          onTap: () {
            _launchInBrowser(url);
          },
        ));
  }

  Widget _itemCarrito(Responsive responsive, nombre, IconData icon) {
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: responsive.ip(1.5), vertical: responsive.ip(0.5)),
        width: double.infinity,
        height: responsive.ip(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: ListTile(
          title: Text(nombre,
              style: TextStyle(
                  //color: Colors.red,
                  fontSize: responsive.ip(2),
                  fontWeight: FontWeight.bold)),
          leading: Icon(icon),
          trailing: Icon(Icons.arrow_right_outlined),
          onTap: () {
            final buttonBloc = ProviderBloc.tabs(context);
            buttonBloc.changePage(2);
          },
        ));
  }

  Widget bottonCircular(Responsive responsive, String texto) {
    return Container(
      width: responsive.wp(25),
      child: Column(
        children: [
          CircleAvatar(
            radius: responsive.wp(5),
            child: Icon(Icons.ad_units),
          ),
          Text(
            texto,
            textAlign: TextAlign.center,
          )
        ],
      ),
    ).ripple(
      () {
        if (texto == 'misMovimientos') {
          Navigator.pushNamed(context, 'misMovimientos');
        } else if (texto == 'Recargas') {
          Navigator.pushNamed(context, 'recargarSaldo');
          //Navigator.pushNamed(context, 'prueba');
        } else if (texto == 'puntos de Recargas') {
          Navigator.pushNamed(context, 'puntosRecarga');
        } else if (texto == 'Agentes') {
          Navigator.pushNamed(context, 'agentes');
        }

        /* if (onPressed != null) {
            onPressed();
          } */
      },
      borderRadius: BorderRadius.all(
        Radius.circular(13),
      ),
    );
  }

  Widget bottonPedido(Responsive responsive, String texto) {
    return Container(
      width: responsive.wp(25),
      child: Column(
        children: [
          CircleAvatar(
            radius: responsive.wp(5),
            child: Icon(
              Icons.ad_units,
              color: Colors.red,
            ),
            backgroundColor: Colors.grey[200],
          ),
          Text(
            texto,
            textAlign: TextAlign.center,
          )
        ],
      ),
    ).ripple(
      () {
        if (texto == 'Pendientes de Envío') {
          Navigator.pushNamed(context, 'pedidos');
        } else if (texto == 'Enviados') {
          Navigator.pushNamed(context, 'pedidosEnviados');
        } else if (texto == 'Pendientes de valoración') {
          Navigator.pushNamed(context, 'valoracion');
          //Navigator.pushNamed(context, 'prueba');
        }
      },
      borderRadius: BorderRadius.all(
        Radius.circular(13),
      ),
    );
  }
}
