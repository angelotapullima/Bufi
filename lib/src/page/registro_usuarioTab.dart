import 'package:bufi/src/api/login_api.dart';
import 'package:bufi/src/api/registroUsuario_api.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistroUsuario extends StatefulWidget {
  @override
  _RegistroUsuarioState createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerLastName = TextEditingController();
  TextEditingController _controllerSurName = TextEditingController();
  TextEditingController _controllerNacimiento = TextEditingController();
  TextEditingController _controllerPhone = TextEditingController();
  TextEditingController _controllerGenre = TextEditingController();
  TextEditingController _controllerCel = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  bool mostrarCarga = false;

  @override
  void dispose() {
    _controllerName?.clear();
    _controllerLastName?.clear();
    _controllerCel?.clear();
    _controllerEmail?.clear();
    _controllerPassword?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //variable para el tamaño responsive
    final responsive = Responsive.of(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        BackButton(),
                      ],
                    ),
                    Text(
                      "Bienvenido a Bufi ✋ ",
                      style: TextStyle(
                        fontSize: responsive.ip(2.8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: responsive.hp(1.5),
                    ),
                    Text(
                      "Supongo que eres nuevo por aquí. puede comenzar a usar la aplicación después de registrarse",
                      style: TextStyle(
                        fontSize: responsive.ip(1.7),
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(
                      height: responsive.hp(6),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(0),
                      ),
                      child: Text(
                        'Nombres',
                        style: TextStyle(
                          fontSize: responsive.ip(2),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: responsive.hp(1),
                    ),
                    _input(
                      responsive,
                      double.infinity,
                      Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                    ),
                     SizedBox(
                      height: responsive.hp(2),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(0),
                      ),
                      child: Text(
                        'Apellido Paterno',
                        style: TextStyle(
                          fontSize: responsive.ip(2),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: responsive.hp(1),
                    ),
                    _input(
                      responsive,
                      double.infinity,
                      Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(
                      height: responsive.hp(2),
                    ),
                    //Apellidos
                    _apellidosUsuario(context, responsive),
                    SizedBox(
                      height: responsive.hp(2),
                    ),

                    _nickNameUsuario(context, responsive),
                    SizedBox(
                      height: responsive.hp(2),
                    ),
                    _celularUsuario(context, responsive),
                    SizedBox(
                      height: responsive.hp(2),
                    ),
                    _emailUsuario(context, responsive),
                    SizedBox(
                      height: responsive.hp(2),
                    ),
                    passwordUsuario(context, responsive),
                    SizedBox(
                      height: responsive.hp(2),
                    ),

                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              mostrarCarga = true;
                            });

                            if (_controllerName.text.isEmpty &&
                                _controllerLastName.text.isEmpty &&
                                _controllerGenre.text.isEmpty &&
                                _controllerPassword.text.isEmpty &&
                                _controllerCel.text.isEmpty &&
                                _controllerEmail.text.isEmpty) {
                              //mostrar mensaje de text name vacio
                              showToast1("Debe rellenar todos los campos", 2, ToastGravity.CENTER);
                              setState(() {
                                mostrarCarga = false;
                              });
                            } else {
                              final registroUser = RegisterUser();

                              /*  final res = await registroUser.registro(
                                  _controllerName.text, _controllerLastName.text, _controllerNickName.text, _controllerCel.text, _controllerEmail.text, _controllerPassword.text);
          
                              if (res == 1) {
                                //registro exitoso
                                final log = LoginApi();
                                final resL = await log.login(_controllerEmail.text, _controllerPassword.text);
                                if (resL == 1) {
                                  Navigator.pushNamed(context, 'home');
                                } else {}
                              } else if (res == 2) {
                                //registro failed
                              } else {
                                //registro failed
          
                                setState(() {
                                  mostrarCarga = false;
                                });
                              } */
                            }
                          },
                          child: Text("Registrar"),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                            padding: EdgeInsets.all(0.0),
                            primary: Color(0xFFF93963),
                            onPrimary: Colors.grey.shade800,
                          ),
                        )

                        // RaisedButton(
                        //   onPressed: () async {
                        //     setState(() {
                        //       mostrarCarga = true;
                        //     });

                        //     if (_controllerName.text.isEmpty &&
                        //         _controllerLastName.text.isEmpty &&
                        //         _controllerNickName.text.isEmpty &&
                        //         _controllerPassword.text.isEmpty &&
                        //         _controllerCel.text.isEmpty &&
                        //         _controllerEmail.text.isEmpty) {
                        //       //mostrar mensaje de text name vacio
                        //       showToast1("Debe rellenar todos los campos", 2,
                        //           ToastGravity.CENTER);
                        //       setState(() {
                        //         mostrarCarga = false;
                        //       });
                        //     } else {
                        //       final registroUser = RegisterUser();

                        //       final res = await registroUser.registro(
                        //           _controllerName.text,
                        //           _controllerLastName.text,
                        //           _controllerNickName.text,
                        //           _controllerCel.text,
                        //           _controllerEmail.text,
                        //           _controllerPassword.text);

                        //       if (res == 1) {
                        //         //registro exitoso
                        //         final log = LoginApi();
                        //         final resL = await log.login(
                        //             _controllerEmail.text,
                        //             _controllerPassword.text);
                        //         if (resL == 1) {
                        //           Navigator.pushNamed(context, 'home');
                        //         } else {}
                        //       } else if (res == 2) {
                        //         //registro failed
                        //       } else {
                        //         //registro failed

                        //         setState(() {
                        //           mostrarCarga = false;
                        //         });
                        //       }
                        //     }
                        //   },
                        //   shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(30.0)),
                        //   padding: EdgeInsets.all(0.0),
                        //   child: Text("Registrar"),
                        //   //color: Theme.of(context),
                        //   textColor: Colors.grey.shade800,
                        // ),
                        ),
                    SizedBox(
                      height: responsive.hp(4),
                    ),

                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "¿Ya tienes una cuenta?",
                          style: TextStyle(
                            fontSize: responsive.ip(2.2),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              'login',
                            );
                          },
                          child: Text(
                            "Ingresa",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
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
          ),
          (mostrarCarga == false)
              ? Container()
              : Center(
                  child: CircularProgressIndicator(),
                )
        ],
      ),
    );
  }

  Widget _input(Responsive responsive, double ancho, Icon iconn) {
    return Container(
      width: ancho,
      height: responsive.hp(6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]),
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey[300],
      ),
      child: TextField(
        cursorColor: Colors.transparent,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(border: InputBorder.none, hintStyle: TextStyle(color: Colors.black45), hintText: '', prefixIcon: iconn),
        enableInteractiveSelection: false,
        controller: _controllerSurName,
        //controller: montoPagarontroller,
      ),
    );
  }

  Widget passwordUsuario(BuildContext context, Responsive responsive) {
    return TextField(
      controller: _controllerPassword,
      textAlign: TextAlign.left,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          fillColor: Color(0xFFECEDF1),
          hintText: 'Contraseña',
          hintStyle: TextStyle(fontSize: responsive.ip(2), fontFamily: 'Montserrat', color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          filled: true,
          contentPadding: EdgeInsets.all(16),
          suffixIcon: Icon(
            Icons.security,
            color: Color(0xFFF93963),
          )),
    );
  }

  Widget _emailUsuario(BuildContext context, Responsive responsive) {
    return TextField(
      controller: _controllerEmail,
      textAlign: TextAlign.left,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          fillColor: Color(0xFFECEDF1),
          hintText: 'email',
          hintStyle: TextStyle(fontSize: responsive.ip(2), fontFamily: 'Montserrat', color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          filled: true,
          contentPadding: EdgeInsets.all(16),
          suffixIcon: Icon(
            Icons.email,
            color: Color(0xFFF93963),
          )),
    );
  }

  Widget _celularUsuario(BuildContext context, Responsive responsive) {
    return TextField(
      controller: _controllerCel,
      textAlign: TextAlign.left,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          fillColor: Color(0xFFECEDF1),
          hintText: 'Celular',
          hintStyle: TextStyle(fontSize: responsive.ip(2), fontFamily: 'Montserrat', color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          filled: true,
          contentPadding: EdgeInsets.all(16),
          suffixIcon: Icon(
            Icons.mobile_screen_share,
            color: Color(0xFFF93963),
          )),
    );
  }

  Widget _nickNameUsuario(BuildContext context, Responsive responsive) {
    return TextField(
      controller: _controllerSurName,
      textAlign: TextAlign.left,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          fillColor: Color(0xFFECEDF1),
          hintText: 'nickName',
          hintStyle: TextStyle(fontSize: responsive.ip(2), fontFamily: 'Montserrat', color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          filled: true,
          contentPadding: EdgeInsets.all(16),
          suffixIcon: Icon(
            Icons.email,
            color: Color(0xFFF93963),
          )),
    );
  }

  Widget _apellidosUsuario(BuildContext context, Responsive responsive) {
    return TextField(
      controller: _controllerLastName,
      textAlign: TextAlign.left,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          fillColor: Color(0xFFECEDF1),
          hintText: 'Apeliidos',
          hintStyle: TextStyle(fontSize: responsive.ip(2), fontFamily: 'Montserrat', color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          filled: true,
          contentPadding: EdgeInsets.all(16),
          suffixIcon: Icon(
            Icons.verified_user,
            color: Color(0xFFF93963),
          )),
    );
  }

  Widget _nombreUsuario(BuildContext context, Responsive responsive) {
    return TextField(
      controller: _controllerName,
      textAlign: TextAlign.left,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        fillColor: Color(0xFFECEDF1),
        hintText: 'Nombres',
        hintStyle: TextStyle(fontSize: responsive.ip(2), fontFamily: 'Montserrat', color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        contentPadding: EdgeInsets.all(16),
        suffixIcon: Icon(
          Icons.verified_user,
          color: Color(0xFFF93963),
        ),
      ),
    );
  }
}
