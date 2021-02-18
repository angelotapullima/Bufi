import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/customCacheManager.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bufi/src/widgets/extentions.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
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
    final prefs = new Preferences();

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: responsive.hp(3.5),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(4)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: responsive.ip(10),
                    height: responsive.ip(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        cacheManager: CustomCacheManager(),
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
                        Text(
                          'Ver Perfil',
                          style: TextStyle(
                              fontSize: responsive.ip(1.8),
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ]),
          ),
          SizedBox(
            height: responsive.hp(2),
          ),
          // _general(responsive)

          Container(
            margin: EdgeInsets.all(
              responsive.ip(1.5),
            ),
            padding: EdgeInsets.symmetric(
              vertical: responsive.hp(2),
              horizontal: responsive.wp(2),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: Column(
              children: [
                Text(
                  'Bufis',
                  style: TextStyle(
                      fontSize: responsive.ip(2.8),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: responsive.hp(3),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    bottonCircular(responsive, 'Recargas'),
                    bottonCircular(responsive, 'misMovimientos'),
                    bottonCircular(responsive, 'Compras'),
                  ],
                ),
                SizedBox(
                  height: responsive.hp(1.8),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    bottonCircular(responsive, 'puntos de Recargas'),
                    bottonCircular(responsive, 'información de mi cuenta'),
                    bottonCircular(responsive, 'Compras'),
                  ],
                )
              ],
            ),
          ),

          

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
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
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

  Widget _asistencia(Responsive responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Asistencia',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: responsive.ip(3),
                color: Colors.green),
          ),
          SizedBox(
            height: responsive.hp(1.5),
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 3),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.grey[300],
              ),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(
                    responsive.ip(1),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.card_giftcard,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: responsive.wp(1.5),
                      ),
                      Text(
                        'Guía para mejor manejo de la App',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: responsive.ip(1.8),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(
                    responsive.ip(1),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.card_giftcard,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: responsive.wp(1.5),
                      ),
                      Text(
                        'Contactar con el equipo de Soporte',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: responsive.ip(1.8),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(responsive.ip(1)),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.card_giftcard,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: responsive.wp(1.5),
                      ),
                      Text(
                        'Deja un Comentario',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: responsive.ip(1.8),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _general(Responsive responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'General',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: responsive.ip(3),
                color: Colors.green),
          ),
          SizedBox(
            height: responsive.hp(1.5),
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 3),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.grey[300],
              ),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(
                    responsive.ip(1),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.card_giftcard,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: responsive.wp(1.5),
                      ),
                      Text(
                        'Bufis',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: responsive.ip(1.8),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(
                    responsive.ip(1),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.card_giftcard,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: responsive.wp(1.5),
                      ),
                      Text(
                        'Mis Movimientos',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: responsive.ip(1.8),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(responsive.ip(1)),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.card_giftcard,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: responsive.wp(1.5),
                      ),
                      Text(
                        'Mis Reservas',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: responsive.ip(1.8),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(responsive.ip(1)),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.card_giftcard,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: responsive.wp(1.5),
                      ),
                      Text(
                        'Solicitar Recargas',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: responsive.ip(1.8),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(responsive.ip(1)),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.card_giftcard,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: responsive.wp(1.5),
                      ),
                      Text(
                        'Mensajes',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: responsive.ip(1.8),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(responsive.ip(1)),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.card_giftcard,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: responsive.wp(1.5),
                      ),
                      Text(
                        'Crear Chancha',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: responsive.ip(1.8),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _aplicacion(Responsive responsive) {
    return Padding(
        padding: EdgeInsets.all(responsive.wp(3)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Aplicación',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.ip(3),
                      color: Colors.green)),
              SizedBox(height: responsive.hp(1.5)),
              Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 3)
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300])),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(responsive.ip(1)),
                      child: Row(children: <Widget>[
                        Icon(
                          Icons.card_giftcard,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: responsive.wp(1.5),
                        ),
                        Text('Política De Privacidad',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: responsive.ip(1.8)))
                      ]),
                    ),
                    Divider(),
                    Padding(
                        padding: EdgeInsets.all(responsive.ip(1)),
                        child: Row(children: <Widget>[
                          Icon(
                            Icons.card_giftcard,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: responsive.wp(1.5),
                          ),
                          Text('Términos de servicio',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: responsive.ip(1.8)))
                        ])),
                    Divider(),
                    Padding(
                        padding: EdgeInsets.all(responsive.ip(1)),
                        child: Row(children: <Widget>[
                          Icon(
                            Icons.card_giftcard,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: responsive.ip(1.5),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('App Versión',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: responsive.ip(1.8))),
                              Text('1.0',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: responsive.ip(1.8))),
                            ],
                          )
                        ])),
                  ],
                ),
              )
            ]));
  }
}
