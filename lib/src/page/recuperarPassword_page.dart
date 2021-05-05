import 'package:bufi/src/bloc/login_bloc.dart';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RecuperarPasswordPage extends StatefulWidget {
  const RecuperarPasswordPage({Key key}) : super(key: key);

  @override
  _RecuperarPasswordPageState createState() => _RecuperarPasswordPageState();
}

class _RecuperarPasswordPageState extends State<RecuperarPasswordPage> {
  final _cargando = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    //final prefs = new Preferences();
    final responsive = Responsive.of(context);
    final correoBloc = ProviderBloc.login(context);

    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: _cargando,
          builder: (BuildContext context, bool dataToque, Widget child) {
            return Stack(
              children: [
                SafeArea(
                  child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ),
                _form(context, responsive, correoBloc),
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
      BuildContext context, Responsive responsive, LoginBloc correoBloc) {
    return SafeArea(
        child: Container(
      color: Colors.white,
      height: double.infinity,
      child: Column(
        children: [
          Spacer(),
          Text(
            "¿Olvidaste la contraseña?",
            style: TextStyle(
                fontSize: responsive.ip(3), fontWeight: FontWeight.bold),
          ),
          Text(
            "¡No te preocupes! Introduce tu correo electrónico para establecer una nueva contraseña",
            style: TextStyle(fontSize: responsive.ip(2)),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: responsive.wp(10),
          ),
          _email(responsive, 'Correo electrónico', correoBloc),
          _boton(context, correoBloc, responsive),
          Spacer()
        ],
      ),
    ));
  }

  Widget _email(Responsive responsive, String titulo, LoginBloc correoBloc) {
    return StreamBuilder(
      stream: correoBloc.correoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: responsive.hp(2),
            left: responsive.wp(6),
            right: responsive.wp(6),
          ),
          child: TextField(
            textAlign: TextAlign.left,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              //fillColor: Colors.white,
              hintText: titulo,
              hintStyle: TextStyle(
                  fontSize: responsive.ip(1.8),
                  fontFamily: 'Montserrat',
                  color: Colors.black54),
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
                Icons.alternate_email,
                color: Color(0xFFF93963),
              ),
            ),
            onChanged: correoBloc.changeCorreo,
          ),
        );
      },
    );
  }

  Widget _boton(
      BuildContext context, LoginBloc correoBloc, Responsive responsive) {
    return StreamBuilder(
        stream: correoBloc.buttomValidCorreoStream,
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
                  child: Text('Enviar'),
                  color: Color(0xFFF93963),
                  textColor: Colors.white,
                  onPressed: (snapshot.hasData)
                      ? () => _submit(context, correoBloc)
                      : null,
                )),
          );
        });
  }

  _submit(BuildContext context, LoginBloc bloc) async {
    _cargando.value = true;
    final int code = await bloc.restablecerPass('${bloc.correo}');
    if (code == 1) {
      print(code);
      Navigator.of(context).pop();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ConfirmCodePage()));
    } else if (code == 2) {
      print(code);
      showToast1('Ocurrio un error', 2, ToastGravity.CENTER);
    } else if (code == 3) {
      print(code);
      showToast1(
          'El correo ingresdo no está registrado', 2, ToastGravity.CENTER);
    }

    _cargando.value = false;
  }
}

class ConfirmCodePage extends StatefulWidget {
  const ConfirmCodePage({Key key}) : super(key: key);

  @override
  _ConfirmCodePageState createState() => _ConfirmCodePageState();
}

class _ConfirmCodePageState extends State<ConfirmCodePage> {
  final _cargando = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    //final prefs = new Preferences();
    final responsive = Responsive.of(context);
    final codigoBloc = ProviderBloc.login(context);

    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: _cargando,
          builder: (BuildContext context, bool dataToque, Widget child) {
            return Stack(
              children: [
                SafeArea(
                  child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ),
                _form(context, responsive, codigoBloc),
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
      BuildContext context, Responsive responsive, LoginBloc codigoBloc) {
    return SafeArea(
        child: Container(
      color: Colors.white,
      height: double.infinity,
      child: Column(
        children: [
          Spacer(),
          Text(
            "Verifica tu cuenta",
            style: TextStyle(
                fontSize: responsive.ip(3), fontWeight: FontWeight.bold),
          ),
          Text(
            "Te enviamos un mensaje a su correo electrónico con un código de verificación.",
            style: TextStyle(fontSize: responsive.ip(2)),
            textAlign: TextAlign.center,
          ),
          Text(
            "Ingrésalo a continuación para restablecer tu contraseña.",
            style: TextStyle(fontSize: responsive.ip(2)),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: responsive.wp(10),
          ),
          _codigo(responsive, 'Ingresar Código', codigoBloc),
          _boton(context, codigoBloc, responsive),
          Spacer()
        ],
      ),
    ));
  }

  Widget _codigo(Responsive responsive, String titulo, LoginBloc codigoBloc) {
    return StreamBuilder(
      stream: codigoBloc.correoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: responsive.hp(2),
            left: responsive.wp(6),
            right: responsive.wp(6),
          ),
          child: TextField(
            textAlign: TextAlign.left,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              //fillColor: Colors.white,
              hintText: titulo,
              hintStyle: TextStyle(
                  fontSize: responsive.ip(1.8),
                  fontFamily: 'Montserrat',
                  color: Colors.black54),
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
            onChanged: codigoBloc.changeCodigo,
          ),
        );
      },
    );
  }

  Widget _boton(
      BuildContext context, LoginBloc codigoBloc, Responsive responsive) {
    return StreamBuilder(
        stream: codigoBloc.buttomValidCodigoStream,
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
                      ? () => _submit(context, codigoBloc)
                      : null,
                )),
          );
        });
  }

  _submit(BuildContext context, LoginBloc bloc) async {
    _cargando.value = true;
    final int code = await bloc.restablecerPass1('${bloc.codigo}');

    if (code == 1) {
      print(code);
      Navigator.of(context).pop();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => RestablecerPasswordPage()));
    } else if (code == 2) {
      print(code);
      showToast1('Código Incorrecto', 2, ToastGravity.CENTER);
    } else if (code == 3) {
      print(code);
      showToast1('Ocurrió un error', 2, ToastGravity.CENTER);
    }

    _cargando.value = false;
  }
}

class RestablecerPasswordPage extends StatefulWidget {
  const RestablecerPasswordPage({Key key}) : super(key: key);

  @override
  _RestablecerPasswordPageState createState() =>
      _RestablecerPasswordPageState();
}

class _RestablecerPasswordPageState extends State<RestablecerPasswordPage> {
  final _cargando = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    //final prefs = new Preferences();
    final responsive = Responsive.of(context);
    final passwordBloc = ProviderBloc.login(context);

    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: _cargando,
          builder: (BuildContext context, bool dataToque, Widget child) {
            return Stack(
              children: [
                SafeArea(
                  child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ),
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
                  child: Text('Actualizar contraseña'),
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
          title: Text('Restablecer la contraseña'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Está seguro de actualizar la contraseña?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Si'),
              onPressed: () async {
                _cargando.value = true;
                final int code =
                    await bloc.restablecerPassOk('${bloc.password}');
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

                Navigator.of(context).pop();

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
  }
}
