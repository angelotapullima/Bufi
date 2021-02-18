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
                              child: Row(
                                children: [
                                  Container(
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
                                  Column(
                                    children: [
                                      Text(
                                        "Registrar Sucursal",
                                        style: TextStyle(
                                            fontSize: responsive.ip(3)),
                                      ),
                                      Text(
                                        "Complete los campos",
                                        style: TextStyle(
                                            fontSize: responsive.ip(2)),
                                      ),
                                    ],
                                  ),
                                ],
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
                return SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: responsive.hp(6),horizontal: responsive.wp(8)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (isDark) ? Colors.white : Colors.red,
                                ),
                                child: BackButton(
                                  color: (isDark) ? Colors.black : Colors.white,
                                )),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: responsive.wp(6),
                                  top: responsive.hp(3.5),
                                  bottom: responsive.wp(6)),
                              child: Column(
                                children: [
                                  Text(
                                    "Registrar Sucursal",
                                    style:
                                        TextStyle(fontSize: responsive.ip(3)),
                                  ),
                                  Text(
                                    "Complete los campos",
                                    style:
                                        TextStyle(fontSize: responsive.ip(2)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        _nombre(regSucursal, responsive, _nameController),
                        SizedBox(
                          height: 10,
                        ),
                        _direccion(regSucursal, responsive, _surnameController),
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
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]),
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
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
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]),
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
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
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]),
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
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
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]),
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
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
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]),
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
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
