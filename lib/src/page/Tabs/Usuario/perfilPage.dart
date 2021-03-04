import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/customCacheManager.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prefs = new Preferences();
    final responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(title: Text("Mi Perfil"),backgroundColor: Colors.transparent,),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: responsive.hp(3.5)),
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: responsive.ip(1.5),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: responsive.hp(2),
                    horizontal: responsive.wp(4),
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
                              imageBuilder: (context, imageProvider) =>
                                  Container(
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
                        // SizedBox(
                        //   width: responsive.wp(1),
                        // ),
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
                        ),
                      ]),
                ),
                Positioned(
                    top: 10,
                    right: 15,
                    child: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {},
                    ))
              ],
            ),
            SizedBox(height: responsive.hp(1.5)),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: responsive.ip(1.5), vertical: responsive.ip(0.5)),
              padding: EdgeInsets.symmetric(
                vertical: responsive.hp(2),
                horizontal: responsive.wp(3),
              ),
              width: double.infinity,
              height: responsive.ip(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Correo electrónico",
                      style: TextStyle(
                          //color: Colors.red,
                          fontSize: responsive.ip(2),
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: responsive.hp(1)),
                  Text(
                    '${prefs.userEmail}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: responsive.ip(1.8)),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: responsive.ip(1.5), vertical: responsive.ip(0.5)),
              padding: EdgeInsets.symmetric(
                vertical: responsive.hp(2),
                horizontal: responsive.wp(3),
              ),
              width: double.infinity,
              height: responsive.ip(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Celular",
                      style: TextStyle(
                          //color: Colors.red,
                          fontSize: responsive.ip(2),
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: responsive.hp(1)),
                  Text(
                    '123456789',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: responsive.ip(1.8)),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: responsive.ip(1.5), vertical: responsive.ip(0.5)),
              padding: EdgeInsets.symmetric(
                vertical: responsive.hp(2),
                horizontal: responsive.wp(3),
              ),
              width: double.infinity,
              height: responsive.ip(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Contraseña",
                      style: TextStyle(
                          //color: Colors.red,
                          fontSize: responsive.ip(2),
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: responsive.hp(1)),
                  Text(
                    '********',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: responsive.ip(1.8)),
                  ),
                ],
              ),
            ),

             SizedBox(height: responsive.hp(6)),
            Center(
                  child: SizedBox(
                    width: responsive.wp(80),
                    child: RaisedButton(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      color: Colors.red,
                      onPressed: () {
                        
                      },
                      child: Text("Cambiar",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: responsive.ip(2.2))),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
