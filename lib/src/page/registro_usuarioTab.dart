import 'package:bufi/src/api/login_api.dart';
import 'package:bufi/src/api/registroUsuario_api.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:platform_date_picker/platform_date_picker.dart';

enum PageMostrar { page1, page2 }

class RegistroUsuario extends StatefulWidget {
  @override
  _RegistroUsuarioState createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  PageMostrar _currentPage = PageMostrar.page1;
  ValueNotifier<bool> _cargando = ValueNotifier(false);

  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerLastName = TextEditingController();
  TextEditingController _controllerSurName = TextEditingController();
  TextEditingController _controllerNacimiento = TextEditingController();
  TextEditingController _controllerPhone = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  TextEditingController _controllerConfirmPassword = TextEditingController();
  TextEditingController _controlleruser = TextEditingController();

  String valueSexo = 'Seleccionar';
  List<String> itemSexo = [
    'Seleccionar',
    'Masculino',
    'Femenino',
  ];

  @override
  void dispose() {
    _controllerName?.clear();
    _controllerLastName?.clear();
    _controllerSurName?.clear();
    _controllerNacimiento?.clear();
    _controllerPhone?.clear();
    _controlleruser?.clear();
    _controllerEmail?.clear();
    _controllerPassword?.clear();
    _controllerConfirmPassword?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //variable para el tamaño responsive
    final responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: ValueListenableBuilder(
          valueListenable: _cargando,
          builder: (BuildContext context, bool data, Widget child) {
            return Stack(
              children: <Widget>[
                SafeArea(
                  bottom: false,
                  child: SingleChildScrollView(
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      child: _currentPage == PageMostrar.page1 ? page1(responsive, context) : page2(responsive, context),
                    ),
                  ),
                ),
                (!data)
                    ? Container()
                    : Center(
                        child: CircularProgressIndicator(),
                      )
              ],
            );
          }),
    );
  }

  Widget page2(Responsive responsive, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "En Bufi encontraras todo lo que necesitas 😎",
            style: TextStyle(
              fontSize: responsive.ip(2.8),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: responsive.hp(3),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.wp(0),
            ),
            child: Text(
              'Datos de Cuenta',
              style: TextStyle(
                fontSize: responsive.ip(3),
                fontWeight: FontWeight.w700,
                color: Colors.blue[900],
              ),
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
              'Usuario(*)',
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
                Icons.person_add_alt,
                color: Colors.blue,
              ),
              _controlleruser),
          SizedBox(
            height: responsive.hp(2),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.wp(0),
            ),
            child: Text(
              'Contraseña(*)',
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
                Ionicons.ios_lock,
                color: Colors.blue,
              ),
              _controllerPassword),
          SizedBox(
            height: responsive.hp(2),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.wp(0),
            ),
            child: Text(
              'Confirmar Contraseña(*)',
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
                Ionicons.ios_lock,
                color: Colors.blue,
              ),
              _controllerConfirmPassword),
          SizedBox(
            height: responsive.hp(2),
          ),
          Text(
            'Al crear una cuenta significa que usted está de acuerdo con nuestros términos y condiciones y nuestra politica de privacidad',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: responsive.ip(1.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: responsive.hp(2),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'terminosycondiciones');
            },
            child: Text(
              'Ver términos y condiciones',
              style: TextStyle(color: Colors.black, fontSize: responsive.ip(1.7), fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: responsive.hp(2),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _currentPage = PageMostrar.page1;
                  });
                },
                child: Text(
                  "Volver",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(2),
                  ),
                  primary: Colors.blue[900],
                  onPrimary: Colors.grey.shade800,
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () async {
                  _cargando.value = true;
                  if (_controlleruser.text.isEmpty && _controllerPassword.text.isEmpty && _controllerConfirmPassword.text.isEmpty) {
                    //mostrar mensaje de text name vacio
                    showToast1("Debe rellenar todos los campos", 2, ToastGravity.CENTER);
                  } else {
                    if (_controllerPassword.text == _controllerConfirmPassword.text) {
                      final registerUserApi = RegisterUserApi();

                      final res = await registerUserApi.registro(
                        _controllerName.text,
                        _controllerLastName.text,
                        _controllerSurName.text,
                        _controllerNacimiento.text,
                        _controllerPhone.text,
                        valueSexo,
                        _controlleruser.text,
                        _controllerEmail.text,
                        _controllerPassword.text,
                      );

                      if (res == 1) {
                        //registro exitoso
                        final log = LoginApi();
                        final resL = await log.login(_controlleruser.text, _controllerPassword.text);
                        if (resL == 1) {
                          _cargando.value = false;

                          Navigator.pushNamed(context, 'home');
                        } else {
                          _cargando.value = false;
                        }
                      } else if (res == 3) {
                        showToast1('Ya existe un usuario con este nickname registrado', 2, ToastGravity.BOTTOM);
                      } else if (res == 4) {
                        showToast1('Ya existe un usuario con este correo registrado', 2, ToastGravity.BOTTOM);
                      } else {
                        showToast1('Hubo un error', 2, ToastGravity.BOTTOM);
                      }
                      _cargando.value = false;
                    } else {
                      showToast1('las contraseñas no coinciden', 2, ToastGravity.CENTER);
                    }

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
                child: Text(
                  "Finalizar",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(2),
                  ),
                  primary: Color(0xFFF93963),
                  onPrimary: Colors.grey.shade800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget page1(Responsive responsive, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            height: responsive.hp(3),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.wp(0),
            ),
            child: Text(
              'Datos Personales',
              style: TextStyle(
                fontSize: responsive.ip(3),
                fontWeight: FontWeight.w700,
                color: Colors.blue[900],
              ),
            ),
          ),

          SizedBox(
            height: responsive.hp(2),
          ),

          //Input Name
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.wp(0),
            ),
            child: Text(
              'Nombres (*)',
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
              _controllerName),
          SizedBox(
            height: responsive.hp(2),
          ),

          //Apellidos
          Row(
            children: [
              Container(
                width: responsive.wp(45),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(0),
                      ),
                      child: Text(
                        'Apellido Paterno(*)',
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
                        _controllerLastName),
                  ],
                ),
              ),
              Spacer(),
              Container(
                width: responsive.wp(45),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(0),
                      ),
                      child: Text(
                        'Apellido Materno(*)',
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
                        _controllerSurName),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(
            height: responsive.hp(2),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.wp(0),
            ),
            child: Text(
              'Télefono(*)',
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
                Icons.phone_android,
                color: Colors.blue,
              ),
              _controllerPhone),
          SizedBox(
            height: responsive.hp(2),
          ),

          Row(
            children: [
              Container(
                width: responsive.wp(45),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(0),
                      ),
                      child: Text(
                        'F. de Nacimiento',
                        style: TextStyle(
                          fontSize: responsive.ip(2),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: responsive.hp(1),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(2),
                      ),
                      width: responsive.wp(45),
                      height: responsive.hp(6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[300],
                      ),
                      child: TextField(
                        cursorColor: Colors.transparent,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Colors.black45,
                              fontSize: responsive.ip(1.7),
                            ),
                            hintText: 'Fecha'),
                        enableInteractiveSelection: false,
                        controller: _controllerNacimiento,
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          _selectdateInicio(context);
                        },
                        //controller: montoPagarontroller,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                width: responsive.wp(45),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(0),
                      ),
                      child: Text(
                        'Sexo',
                        style: TextStyle(
                          fontSize: responsive.ip(2),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: responsive.hp(1),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(1),
                      ),
                      height: responsive.hp(6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[300],
                      ),
                      width: responsive.wp(45),
                      child: DropdownButton<String>(
                        dropdownColor: Colors.white,
                        focusColor: Colors.red,
                        value: valueSexo,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: responsive.ip(1.7),
                        ),
                        underline: Container(),
                        onChanged: (String data) {
                          setState(() {
                            valueSexo = data;
                          });
                        },
                        items: itemSexo.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(
            height: responsive.hp(2),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.wp(0),
            ),
            child: Text(
              'Email(*)',
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
                Icons.email,
                color: Colors.blue,
              ),
              _controllerEmail),
          SizedBox(
            height: responsive.hp(2),
          ),
          Row(
            children: [
              Text(
                '(*) campos obligatorios',
                style: TextStyle(
                  fontSize: responsive.ip(1.5),
                ),
              ),
            ],
          ),
          SizedBox(
            height: responsive.hp(2),
          ),

          Row(
            children: [
              Spacer(),
              ElevatedButton(
                onPressed: () async {
                  if (_controllerName.text.isEmpty ||
                      _controllerLastName.text.isEmpty ||
                      _controllerSurName.text.isEmpty ||
                      _controllerPhone.text.isEmpty ||
                      _controllerEmail.text.isEmpty) {
                    //mostrar mensaje de text name vacio
                    showToast1("Debe rellenar todos los campos obligatorios", 2, ToastGravity.CENTER);
                  } else {
                    setState(() {
                      _currentPage = PageMostrar.page2;
                    });

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
                child: Text(
                  "Continuar",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(2),
                  ),
                  primary: Color(0xFFF93963),
                  onPrimary: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          SizedBox(
            height: responsive.hp(4),
          ),
        ],
      ),
    );
  }

  _selectdateInicio(BuildContext context) async {
    DateTime picked = await PlatformDatePicker.showDate(
      context: context,
      backgroundColor: Colors.white,
      firstDate: DateTime(DateTime.now().year - 100),
      initialDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    print('date $picked');
    if (picked != null) {
      setState(() {
        _controllerNacimiento.text = "${picked.year.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";

        print(_controllerNacimiento.text);
      });
    }
  }

  Widget _input(Responsive responsive, double ancho, Icon iconn, TextEditingController controller) {
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
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.black45),
          hintText: '',
          prefixIcon: iconn,
        ),
        enableInteractiveSelection: false,
        controller: controller,
        //controller: montoPagarontroller,
      ),
    );
  }
}
