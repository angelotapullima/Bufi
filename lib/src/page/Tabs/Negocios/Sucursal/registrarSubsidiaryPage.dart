import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/bloc/subsidiary/registrarSubsidiary_bloc.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:bufi/src/utils/utils.dart' as utils;

class RegistroSubsidiary extends StatelessWidget {
  SubsidiaryModel submodel = SubsidiaryModel();
  //const RegistroSubsidiary({Key key}) : super(key: key);
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _celController = TextEditingController();
  TextEditingController _cel2Controller = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final idCompany = ModalRoute.of(context).settings.arguments;
    final responsive = Responsive.of(context);
    final regSucursal = ProviderBloc.registroSuc(context);
    regSucursal.changeCargando();

    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      body: StreamBuilder(
          stream: regSucursal.cargandoSucursalStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data) {
                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 50.0),
                                    child: Text(
                                      "Nombre de Sucurrssal",
                                      style:
                                          TextStyle(fontSize: responsive.ip(3)),
                                    ),
                                  ),
                                  Positioned(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: (isDark)
                                              ? Colors.white
                                              : Colors.red,
                                        ),
                                        child: BackButton(
                                          color: (isDark)
                                              ? Colors.black
                                              : Colors.white,
                                        )),
                                    //top: responsive.hp(5),
                                    // left: 10,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 32.0),
                              child: Text(
                                "Complete los campos",
                                style: TextStyle(fontSize: responsive.ip(2)),
                              ),
                            ),
                            _nombre(regSucursal, responsive, _nameController),
                            SizedBox(
                              height: 10,
                            ),
                            _direccion(
                                regSucursal, responsive, _surnameController),
                            SizedBox(
                              height: 10,
                            ),
                            _celular(regSucursal, responsive, _celController),
                            SizedBox(
                              height: 10,
                            ),
                            _celular2(regSucursal, responsive, _cel2Controller),
                            SizedBox(
                              height: 10,
                            ),
                            _email(regSucursal, responsive, _emailController),
                            SizedBox(height: 10),
                            _btn_registrar(context, regSucursal, idCompany),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    )
                  ],
                );
              } else {
                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 50.0, left: 90),
                                    child: Text(
                                      "Nombre de Sucursal",
                                      style:
                                          TextStyle(fontSize: responsive.ip(3)),
                                    ),
                                  ),
                                  Positioned(
                                    child: Container(
                                        // decoration: BoxDecoration(
                                        //   //shape: BoxShape.circle,
                                        //   color: (isDark)
                                        //       ? Colors.white
                                        //       : Colors.red,
                                        // ),
                                        child: BackButton(
                                          color: (isDark)
                                              ? Colors.black
                                              : Colors.white,
                                        )),
                                    top: responsive.hp(5),
                                    left: 10,
                                    //right: 190,
                                  ),

                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 32.0),
                              child: Text(
                                "Complete los campos",
                                style: TextStyle(fontSize: responsive.ip(2)),
                              ),
                            ),
                            _nombre(regSucursal, responsive, _nameController),
                            SizedBox(
                              height: 10,
                            ),
                            _direccion(
                                regSucursal, responsive, _surnameController),
                            SizedBox(
                              height: 10,
                            ),
                            _celular(regSucursal, responsive, _celController),
                            SizedBox(
                              height: 10,
                            ),
                            _celular2(regSucursal, responsive, _cel2Controller),
                            SizedBox(
                              height: 10,
                            ),
                            _email(regSucursal, responsive, _emailController),
                            SizedBox(height: 10),
                            _btn_registrar(context, regSucursal, idCompany),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Widget _nombre(RegistroSucursalBloc regisSucursalBloc, Responsive responsive,
      TextEditingController _nameController) {
    return StreamBuilder(
      stream: regisSucursalBloc.nombreSucursalStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return TextField(
          controller: _nameController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            fillColor: Theme.of(context).dividerColor,
            hintText: 'Nombre de Sucursal',
            hintStyle: TextStyle(fontSize: responsive.ip(2)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            contentPadding: EdgeInsets.all(16),
            errorText: snapshot.error,
            suffixIcon: Icon(
              Icons.store,
              color: Theme.of(context).primaryColor,
            ),
          ),
          onChanged: regisSucursalBloc.changenombreSucursal,
        );
      },
    );
  }

  Widget _direccion(RegistroSucursalBloc regisSucursalBloc,
      Responsive responsive, TextEditingController _surnameController) {
    return StreamBuilder(
      stream: regisSucursalBloc.direccionSucursalStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return TextField(
          controller: _surnameController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            fillColor: Theme.of(context).dividerColor,
            hintText: 'Direccion',
            hintStyle: TextStyle(fontSize: responsive.ip(2)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            contentPadding: EdgeInsets.all(16),
            errorText: snapshot.error,
            suffixIcon: Icon(
              Icons.location_on,
              color: Theme.of(context).primaryColor,
            ),
          ),
          onChanged: regisSucursalBloc.changedireccionSucursal,
        );
      },
    );
  }

  Widget _celular(RegistroSucursalBloc regisSucursalBloc, Responsive responsive,
      TextEditingController _celController) {
    return StreamBuilder(
      stream: regisSucursalBloc.celularSucursalStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return TextField(
          controller: _celController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            fillColor: Theme.of(context).dividerColor,
            hintText: 'Celular',
            hintStyle: TextStyle(fontSize: responsive.ip(2)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            contentPadding: EdgeInsets.all(16),
            errorText: snapshot.error,
            suffixIcon: Icon(
              Icons.phone,
              color: Theme.of(context).primaryColor,
            ),
          ),
          onChanged: regisSucursalBloc.changecelularSucursal,
        );
      },
    );
  }

  Widget _celular2(RegistroSucursalBloc regisSucursalBloc,
      Responsive responsive, TextEditingController _cel2Controller) {
    return StreamBuilder(
      stream: regisSucursalBloc.celular2SucursalStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return TextField(
          controller: _cel2Controller,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            fillColor: Theme.of(context).dividerColor,
            hintText: 'Celular-otro',
            hintStyle: TextStyle(fontSize: responsive.ip(2)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            contentPadding: EdgeInsets.all(16),
            errorText: snapshot.error,
            suffixIcon: Icon(
              Icons.phone,
              color: Theme.of(context).primaryColor,
            ),
          ),
          onChanged: regisSucursalBloc.changecelular2Sucursal,
        );
      },
    );
  }

  Widget _email(RegistroSucursalBloc regisSucursalBloc, Responsive responsive,
      _emailController) {
    return StreamBuilder(
      stream: regisSucursalBloc.emailSucursalStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return TextField(
          controller: _emailController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            fillColor: Theme.of(context).dividerColor,
            hintText: 'Email',
            hintStyle: TextStyle(fontSize: responsive.ip(2)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            contentPadding: EdgeInsets.all(16),
            errorText: snapshot.error,
            suffixIcon: Icon(
              Icons.email,
              color: Theme.of(context).primaryColor,
            ),
          ),
          onChanged: regisSucursalBloc.changeemailSucursal,
        );
      },
    );
  }

  Widget _btn_registrar(BuildContext context,
      RegistroSucursalBloc regisSucursalBloc, String idCompany) {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        child: Text("Registrar"),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        onPressed: () {
          if (_nameController.text.length > 0) {
            if (_surnameController.text.length > 0) {
              if (_celController.text.length > 0) {
                if (_cel2Controller.text.length > 0) {
                  if (_emailController.text.length > 0) {
                    _submit(context, regisSucursalBloc, idCompany);
                  } else {
                    utils.showToast(context, 'Debe ingresar el email');
                  }
                } else {
                  utils.showToast(context, 'Debe ingresar el celular2');
                }
              } else {
                utils.showToast(context, 'Debe ingresar el numero de celular');
              }
            } else {
              utils.showToast(context, 'Debe ingresar la direccion');
            }
          } else {
            utils.showToast(context, 'Debe ingresar el nombre');
          }
        },
      ),
    );
  }

  _submit(BuildContext context, RegistroSucursalBloc regisSucursalBloc,
      String idCompany) async {
    submodel.subsidiaryName = regisSucursalBloc.nameEmpresa;
    submodel.subsidiaryCellphone = regisSucursalBloc.cel;
    submodel.subsidiaryCellphone2 = regisSucursalBloc.cel2;
    submodel.subsidiaryAddress = regisSucursalBloc.direccion;
    submodel.subsidiaryEmail = regisSucursalBloc.email;
    submodel.idCompany = idCompany;

    final int code = await regisSucursalBloc.registroSucursal(submodel);

    if (code == 1) {
      print(code);
      utils.showToast(context, 'Negocio Registrado');

      Navigator.pop(context);
    } else if (code == 2) {
      print(code);
      utils.showToast(context, 'Ocurrio un error');
    } else if (code == 6) {
      print(code);
      utils.showToast(context, 'Datos incorrectos');
    }
  }
}
