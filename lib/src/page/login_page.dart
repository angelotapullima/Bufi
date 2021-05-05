import 'package:bufi/src/bloc/login_bloc.dart';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/page/recuperarPassword_page.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _cargando = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final loginBloc = ProviderBloc.login(context);
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: _cargando,
          builder: (BuildContext context, bool dataToque, Widget child) {
            return Stack(
              children: [
                _form(context, responsive, loginBloc),
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
      BuildContext context, Responsive responsive, LoginBloc loginBloc) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              FlutterLogo(
                size: responsive.ip(20),
              ),
              Text(
                "Bienvenido",
                style: TextStyle(
                    fontSize: responsive.ip(3), fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: responsive.ip(2),
                ),
                child: Text(
                  "Inicie Sesión",
                  style: TextStyle(
                    fontSize: responsive.ip(2.5),
                  ),
                ),
              ),
              _email(loginBloc, responsive),
              _pass(loginBloc, responsive),
              _botonLogin(context, loginBloc, responsive),
              Padding(
                padding: EdgeInsets.all(
                  responsive.ip(4.5),
                ),
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RecuperarPasswordPage()));
                    },
                    child: Text("Olvidé mi Contraseña")),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "¿No tiene una cuenta?,  ",
                    style: TextStyle(
                      fontSize: responsive.ip(2.2),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        'registroUsuario',
                      );
                    },
                    child: Text(
                      "Registrese",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: responsive.ip(2.2),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _email(LoginBloc bloc, Responsive responsive) {
    return StreamBuilder(
      stream: bloc.emailStream,
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
                fillColor: Theme.of(context).dividerColor,
                hintText: 'Ingrese su nickname',
                hintStyle: TextStyle(
                    fontSize: responsive.ip(1.8),
                    fontFamily: 'Montserrat',
                    color: Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                filled: true,
                contentPadding: EdgeInsets.all(
                  responsive.ip(2),
                ),
                errorText: snapshot.error,
                suffixIcon: Icon(
                  Icons.alternate_email,
                  color: Color(0xFFF93963),
                )),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );
  }

  Widget _pass(LoginBloc bloc, Responsive responsive) {
    return StreamBuilder(
      stream: bloc.passwordStream,
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
              fillColor: Theme.of(context).dividerColor,
              hintText: 'Ingrese su contraseña',
              hintStyle: TextStyle(
                  fontSize: responsive.ip(1.8),
                  fontFamily: 'Montserrat',
                  color: Colors.black54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
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
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  Widget _botonLogin(
      BuildContext context, LoginBloc bloc, Responsive responsive) {
    return StreamBuilder(
        stream: bloc.formValidStream,
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
                child: Text('Iniciar Sesión'),
                color: Color(0xFFF93963),
                textColor: Colors.white,
                onPressed:
                    (snapshot.hasData) ? () => _submit(context, bloc) : null,
              ),
            ),
          );
        });
  }

  _submit(BuildContext context, LoginBloc bloc) async {
    _cargando.value = true;
    final int code = await bloc.login('${bloc.email}', '${bloc.password}');

    if (code == 1) {
      print(code);

      Navigator.of(context)
          .pushNamedAndRemoveUntil('home', (Route<dynamic> route) => true);

      // Navigator.pushReplacementNamed(context, 'home');
    } else if (code == 2) {
      print(code);
      showToast1('Ocurrio un error', 2, ToastGravity.CENTER);
    } else if (code == 3) {
      print(code);
      showToast1('Datos incorrectos', 2, ToastGravity.CENTER);
    }

    _cargando.value = false;
  }
}
