import 'package:bufi/src/bloc/login_bloc.dart';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/customCacheManager.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prefs = new Preferences();
    final responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Mi Perfil"),
        backgroundColor: Colors.transparent,
      ),
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
            GestureDetector(
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: responsive.ip(1.5),
                    vertical: responsive.ip(0.5)),
                padding: EdgeInsets.symmetric(
                  vertical: responsive.hp(2),
                  horizontal: responsive.wp(3),
                ),
                width: double.infinity,
                height: responsive.ip(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Correo electrónico",
                            style: TextStyle(
                                //color: Colors.red,
                                fontSize: responsive.ip(2),
                                fontWeight: FontWeight.bold)),
                        // InkWell(
                        //   child: Icon(Icons.edit),
                        //   onTap: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) =>
                        //                 RestablecerContrasenhaPage()));
                        //   },
                        // )
                      ],
                    ),
                    SizedBox(height: responsive.hp(1)),
                    Text(
                      '${prefs.userEmail}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: responsive.ip(1.8)),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RestablecerContrasenhaPage()));
              },
            ),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: responsive.ip(1.5),
                    vertical: responsive.ip(0.5)),
                padding: EdgeInsets.symmetric(
                  vertical: responsive.hp(2),
                  horizontal: responsive.wp(3),
                ),
                width: double.infinity,
                height: responsive.ip(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Celular",
                            style: TextStyle(
                                //color: Colors.red,
                                fontSize: responsive.ip(2),
                                fontWeight: FontWeight.bold)),
                        // InkWell(
                        //   child: Icon(Icons.edit),
                        //   onTap: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) =>
                        //                 RestablecerContrasenhaPage()));
                        //   },
                        // )
                      ],
                    ),
                    SizedBox(height: responsive.hp(1)),
                    Text(
                      '123456789',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: responsive.ip(1.8)),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RestablecerContrasenhaPage()));
              },
            ),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: responsive.ip(1.5),
                    vertical: responsive.ip(0.5)),
                padding: EdgeInsets.symmetric(
                  vertical: responsive.hp(2),
                  horizontal: responsive.wp(3),
                ),
                width: double.infinity,
                height: responsive.ip(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Contraseña",
                            style: TextStyle(
                                //color: Colors.red,
                                fontSize: responsive.ip(2),
                                fontWeight: FontWeight.bold)),
                        //SizedBox(width: responsive.wp(50)),
                        //     InkWell(
                        //       child: Icon(Icons.edit),
                        //       onTap: () {
                        //         Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //                 builder: (context) =>
                        // RestablecerContrasenhaPage()));
                        //       },
                        //     )
                      ],
                    ),
                    SizedBox(height: responsive.hp(1)),
                    Text(
                      '********',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: responsive.ip(1.8)),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RestablecerContrasenhaPage()));
              },
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
                  onPressed: () {},
                  child: Text("Cambiar",
                      style: TextStyle(
                          color: Colors.white, fontSize: responsive.ip(2.2))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RestablecerContrasenhaPage extends StatefulWidget {
  const RestablecerContrasenhaPage({Key key}) : super(key: key);

  @override
  _RestablecerContrasenhaPageState createState() =>
      _RestablecerContrasenhaPageState();
}

class _RestablecerContrasenhaPageState
    extends State<RestablecerContrasenhaPage> {
  final _cargando = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    //final prefs = new Preferences();
    final responsive = Responsive.of(context);
    final passwordBloc = ProviderBloc.login(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Cambiar contraseña"),
        backgroundColor: Colors.transparent,
      ),
      body: ValueListenableBuilder(
          valueListenable: _cargando,
          builder: (BuildContext context, bool dataToque, Widget child) {
            return Stack(
              children: [
                // SafeArea(
                //   child: IconButton(
                //       icon: Icon(Icons.arrow_back_ios),
                //       onPressed: () {
                //         Navigator.of(context).pop();
                //       }),
                // ),
                _form(context, responsive, passwordBloc),
                (dataToque)
                    ? Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: responsive.wp(10)),
                          padding: EdgeInsets.symmetric(
                              horizontal: responsive.wp(10)),
                          width: double.infinity,
                          height: responsive.hp(13),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: responsive.wp(10),
                                vertical: responsive.wp(6)),
                            height: responsive.ip(4),
                            width: responsive.ip(4),
                            child: Image(
                                image: AssetImage('assets/loading.gif'),
                                fit: BoxFit.contain),
                          ),
                        ),
                      )
                    : Container()
              ],
            );
          }),
    );
  }

  Widget _form(
      BuildContext context, Responsive responsive, LoginBloc passwordBloc) {
    return SafeArea(
        child: Container(
      color: Colors.white,
      height: double.infinity,
      child: Column(
        children: [
          Spacer(),
          Text(
            "Restablecer Contraseña",
            style: TextStyle(
                fontSize: responsive.ip(3), fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: responsive.wp(10),
          ),
          _pass(responsive, 'Nueva contraseña', passwordBloc),
          _pass2(responsive, 'Confirmar contraseña', passwordBloc),
          _botonLogin(context, passwordBloc, responsive),
          Spacer()
        ],
      ),
    ));
  }

  Widget _pass(Responsive responsive, String titulo, LoginBloc passwordBloc) {
    return StreamBuilder(
      stream: passwordBloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: responsive.hp(2),
            left: responsive.wp(6),
            right: responsive.wp(6),
          ),
          child: TextField(
            obscureText: true,
            textAlign: TextAlign.left,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              //fillColor: Colors.white,
              hintText: titulo,
              hintStyle: TextStyle(
                  fontSize: responsive.ip(1.8),
                  fontFamily: 'Montserrat',
                  color: Colors.black54),
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(30),
              //   borderSide: BorderSide(
              //     width: 0,
              //     style: BorderStyle.none,
              //   ),
              // ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[500]),
              ),

              filled: true,
              contentPadding: EdgeInsets.all(
                responsive.ip(2),
              ),
              errorText: snapshot.error,
              suffixIcon: Icon(
                Icons.lock_outline,
                color: Color(0xFFF93963),
              ),
            ),
            onChanged: passwordBloc.changePassword,
          ),
        );
      },
    );
  }

  Widget _pass2(Responsive responsive, String titulo, LoginBloc passwordBloc) {
    return StreamBuilder(
      stream: passwordBloc.passwordConfirmStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: responsive.hp(2),
            left: responsive.wp(6),
            right: responsive.wp(6),
          ),
          child: TextField(
            obscureText: true,
            textAlign: TextAlign.left,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              //fillColor: Theme.of(context).dividerColor,
              hintText: titulo,
              hintStyle: TextStyle(
                  fontSize: responsive.ip(1.8),
                  fontFamily: 'Montserrat',
                  color: Colors.black54),
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(30),
              //   borderSide: BorderSide(
              //     width: 0,
              //     style: BorderStyle.none,
              //   ),
              // ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[500]),
              ),
              filled: true,
              contentPadding: EdgeInsets.all(
                responsive.ip(2),
              ),
              errorText: snapshot.error,
              suffixIcon: Icon(
                Icons.lock_outline,
                color: Color(0xFFF93963),
              ),
            ),
            onChanged: passwordBloc.changePasswordConfirm,
          ),
        );
      },
    );
  }

  Widget _botonLogin(
      BuildContext context, LoginBloc passwordBloc, Responsive responsive) {
    return StreamBuilder(
        stream: passwordBloc.formValidPassStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Padding(
            padding: EdgeInsets.only(
              top: responsive.hp(2),
              left: responsive.wp(6),
              right: responsive.wp(6),
            ),
            child: SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.all(0.0),
                  child: Text('Confirmar'),
                  color: Color(0xFFF93963),
                  textColor: Colors.white,
                  onPressed: (snapshot.hasData)
                      ? () => _submit(context, passwordBloc)
                      : null,
                )),
          );
        });
  }

  _submit(BuildContext context, LoginBloc bloc) async {
    //Mostrar alerta de diálogo antes de cambiar la contraseña
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cambiar la contraseña'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
               Text('¿Está seguro de cambiar la contraseña?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Si'),
              onPressed: () async {
                _cargando.value = true;
                final int code =
                    await bloc.restablecerPassword('${bloc.password}');

                if (code == 1) {
                  print(code);
                  showToast1('Contraseña restablecida', 2, ToastGravity.CENTER);
                  Navigator.of(context).pop();
                } else if (code == 2) {
                  print(code);
                  showToast1('Ocurrio un error', 2, ToastGravity.CENTER);
                } else if (code == 3) {
                  print(code);
                  showToast1('Datos incorrectos', 2, ToastGravity.CENTER);
                }

                _cargando.value = false;
              },
            ),
            TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        );
      },
    );

    // _cargando.value = true;
    // final int code = await bloc.restablecerPassword('${bloc.password}');

    // if (code == 1) {
    //   print(code);
    //   showToast1('Contraseña restablecida', 2, ToastGravity.CENTER);
    //   Navigator.of(context).pop();
    // } else if (code == 2) {
    //   print(code);
    //   showToast1('Ocurrio un error', 2, ToastGravity.CENTER);
    // } else if (code == 3) {
    //   print(code);
    //   showToast1('Datos incorrectos', 2, ToastGravity.CENTER);
    // }

    // _cargando.value = false;
  }
}
