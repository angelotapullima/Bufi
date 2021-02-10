import 'package:bufi/src/api/negocio/negocios_api.dart';
import 'package:bufi/src/bloc/categoriaPrincipal/categoria_bloc.dart';
import 'package:bufi/src/bloc/negocio/ActualizarNegocio_bloc.dart';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/CompanySubsidiaryModel.dart';
import 'package:bufi/src/models/categoriaModel.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/textStyle.dart';
import 'package:bufi/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';

class ActualizarNegocio extends StatefulWidget {
  @override
  _ActualizarNegocioState createState() => _ActualizarNegocioState();
}

class _ActualizarNegocioState extends State<ActualizarNegocio> {
  bool _d = false;
  bool _e = false;
  bool _t = false;
  CompanySubsidiaryModel csmodel = CompanySubsidiaryModel();
  NegocioArgumentos ngargumentsmodel = NegocioArgumentos();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _rucController = TextEditingController();
  TextEditingController _direccionController = TextEditingController();
  TextEditingController _celController = TextEditingController();
  TextEditingController _cel2Controller = TextEditingController();
  TextEditingController _calleXController = TextEditingController();
  TextEditingController _calleYController = TextEditingController();
  TextEditingController _shortcodeController = TextEditingController();
  TextEditingController _actOpeningHoursController = TextEditingController();

  String type = "";
  String categNameylacsm = "";
  int cant = 0;

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    final responsive = Responsive.of(context);
    final categoriasBloc = ProviderBloc.categoria(context);
    categoriasBloc.obtenerCategorias();
    final updateNegBloc = ProviderBloc.actualizarNeg(context);
    updateNegBloc.updateNegocio(id);

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
            stream: updateNegBloc.negControllerStream,
            builder: (context,
                AsyncSnapshot<List<CompanySubsidiaryModel>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  if (cant == 0) {
                    _nameController.text = snapshot.data[0].companyName;
                    _rucController.text = snapshot.data[0].companyRuc;
                    _direccionController.text =
                        snapshot.data[0].subsidiaryAddress;
                    _celController.text = snapshot.data[0].subsidiaryCellphone;
                    _cel2Controller.text =
                        snapshot.data[0].subsidiaryCellphone2;
                    _calleXController.text = snapshot.data[0].subsidiaryCoordX;
                    _calleYController.text = snapshot.data[0].subsidiaryCoordY;
                    _shortcodeController.text =
                        snapshot.data[0].companyShortcode;
                    _actOpeningHoursController.text =
                        snapshot.data[0].subsidiaryOpeningHours;
                    if (snapshot.data[0].companyDelivery == "1") {
                      _d = true;
                    } else {
                      _d = false;
                    }

                    if (snapshot.data[0].companyEntrega == "1") {
                      _e = true;
                    } else {
                      _e = false;
                    }

                    if (snapshot.data[0].companyTarjeta == "1") {
                      _t = true;
                    } else {
                      _t = false;
                    }

                    //jalar los datos del dropdown de la página anterior

                    type = snapshot.data[0].companyType;
                    categNameylacsm = snapshot.data[0].categoriaName;
                  }

                  return Column(
                    children: [
                      Row(
                        children: [
                          BackButton(
                            color: Colors.black,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: responsive.wp(6),
                                top: responsive.hp(3.5),
                                bottom: responsive.hp(3.5)),
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Actualizar Negocio",
                                  style: TextStyle(
                                    fontSize: responsive.ip(3),
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text("Complete los campos",
                                    style:
                                        TextStyle(fontSize: responsive.ip(2)))
                              ],
                            ),
                          ),
                        ],
                      ),
                      _form(context, categoriasBloc, updateNegBloc, responsive,
                          id),
                    ],
                  );
                } else {
                  return Text("No hay datos");
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }

  Widget _form(BuildContext context, CategoriaBloc cBloc,
      ActualizarNegocioBloc updateNegBloc, Responsive responsive, String id) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.wp(8),
            vertical: responsive.hp(1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Nombre",
                style: textlabel,
              ),
              _textInput(updateNegBloc, responsive, _nameController,
                  "Nombre de empresa", id),
              Text(
                "Ruc",
                style: textlabel,
              ),
              _textInput(updateNegBloc, responsive, _rucController, "RUC", id),
              Text(
                "Dirección",
                style: textlabel,
              ),
              _textInput(updateNegBloc, responsive, _direccionController,
                  "Direccion", id),
              Text(
                "Celular",
                style: textlabel,
              ),
              _textInput(
                  updateNegBloc, responsive, _celController, "celular", id),
              Text(
                "Celular 2",
                style: textlabel,
              ),
              _textInput(
                  updateNegBloc, responsive, _cel2Controller, "ceular2", id),
              Text(
                "Coordenada X",
                style: textlabel,
              ),
              _textInput(
                  updateNegBloc, responsive, _calleXController, "calleX", id),
              Text(
                "Coordenada Y",
                style: textlabel,
              ),
              _textInput(
                  updateNegBloc, responsive, _calleYController, "calleY", id),
              Text(
                "Código corto",
                style: textlabel,
              ),
              _textInput(updateNegBloc, responsive, _shortcodeController,
                  "codigo corto de empresa", id),
              Text(
                "Horario de atención",
                style: textlabel,
              ),
              _textInput(updateNegBloc, responsive, _actOpeningHoursController,
                  "Horas de Apertura", id),
              _type2(),
              SizedBox(height: 10),
              _categoria(cBloc),
              _delivery(),
              _entrega(),
              _tarjeta(),
              //_botonRegistro(context, updateNegBloc),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textInput(ActualizarNegocioBloc updateNegBloc, Responsive responsive,
      TextEditingController controller, String name, String id) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.left,
        //readOnly: true,
        decoration: InputDecoration(
          hintText: name,
          hintStyle: TextStyle(fontSize: responsive.ip(2)),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]),
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          filled: true,
          contentPadding: EdgeInsets.all(16),
          //errorText: snapshot.error,
        ),
        //onChanged: updateNegBloc.changeNameEmpresa,
        onTap: () async {
          final negocioApi = NegociosApi();

          //respuesta que devuelve el servicio de actualizar
          final res = await negocioApi.updateNegocio(csmodel);

          //Para actualizar los datos en la bd
          if (res == 1) {
            final csModel = CompanySubsidiaryModel();

            csModel.companyName = _nameController.text;
            csModel.companyRuc = _rucController.text;
            csModel.direccion = _direccionController.text;
            csModel.subsidiaryCellphone = _celController.text;
            csModel.subsidiaryCellphone2 = _cel2Controller.text;
            csModel.subsidiaryCoordX = _calleXController.text;
            csModel.subsidiaryCoordY = _calleYController.text;
            csModel.companyShortcode = _shortcodeController.text;
            csModel.subsidiaryOpeningHours = _actOpeningHoursController.text;
            // csModel.companyType =
            // csModel.idCategory =
            // csModel.companyDelivery =

            //     csModel.companyEntrega = csModel.companyTarjeta =
            utils.showToast(context, "Negocio actualizado");
          } else {
            utils.showToast(context, "No se pudo actualizar");
          }

          // ngargumentsmodel.id = id;
          // ngargumentsmodel.nombre = name;

          // _showAlertDialog(context, controller);

          // Navigator.pushNamed(context, "negocioActualizado",
          //     arguments: ngargumentsmodel);
        },
      ),
    );
  }

  Widget _type() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 2.0, left: 40.0, right: 40.0),
        child: Row(
          children: <Widget>[
            Text('Tipo'),
            SizedBox(
              width: 30.0,
            ),
            Expanded(
              child: DropdownButton<String>(
                  hint: Text("Seleccione tipo de empresa"),
                  value: csmodel.companyType,
                  items: [
                    DropdownMenuItem(
                      child: Text("Pequeña"),
                      value: "Pequeña",
                    ),
                    DropdownMenuItem(
                      child: Text("Mediana"),
                      value: "Mediana",
                    ),
                    DropdownMenuItem(
                      child: Text("Grande"),
                      value: "Grande",
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      cant++;
                      csmodel.companyType = value;
                    });
                  }),
            )
          ],
        ));
  }

  Widget _type2() {
    return Padding(
        padding: EdgeInsets.only(bottom: 2.0, right: 3),
        child: Row(
          children: <Widget>[
            Text('Tipo', style: textlabel),
            SizedBox(
              width: 50.0,
            ),
            Expanded(
              child: Container(
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 1.0,
                        style: BorderStyle.solid,
                        color: Colors.grey[500]),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                        hint: Text("Seleccione tipo de empresa"),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                          size: 32,
                        ),
                        value: type,
                        items: [
                          DropdownMenuItem(
                            child: Text("Seleccionar"),
                            value: "Seleccionar",
                          ),
                          DropdownMenuItem(
                            child: Text("Pequeña"),
                            value: "Pequeña",
                          ),
                          DropdownMenuItem(
                            child: Text("mediana"),
                            value: "mediana",
                          ),
                          DropdownMenuItem(
                            child: Text("Grande"),
                            value: "Grande",
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            cant++;
                            type = value;
                          });
                        }),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Widget _categoria(CategoriaBloc bloc) {
    return Padding(
        padding: EdgeInsets.only(bottom: 2.0, right: 3),
        child: Row(
          children: <Widget>[
            Text('Categoría', style: textlabel),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: StreamBuilder(
                  stream: bloc.categoriaStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<CategoriaModel>> snapshot) {
                    if (snapshot.hasData) {
                      final cat = snapshot.data;
                      return Container(
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 1.0,
                                style: BorderStyle.solid,
                                color: Colors.grey[500]),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              hint: Text("Seleccione una categoría"),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                                size: 32,
                              ),
                              value: categNameylacsm,
                              items: cat.map((e) {
                                return DropdownMenuItem<String>(
                                  value: categNameylacsm,
                                  child: Text(
                                    e.categoryName,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                              // onChanged: (value) {
                              //   categ = value;
                              //   print(categ);
                              //   this.setState(() {
                              //     cant++;
                              //   });
                              // },
                              onChanged: (String value) {
                                setState(() {
                                  categNameylacsm = value;
                                  cant++;
                                  obtenerIdCategoria(value, cat);
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            )
          ],
        ));
  }

  void obtenerIdCategoria(String dato, List<CategoriaModel> list) {
    for (int i = 0; i < list.length; i++) {
      if (dato == list[i].categoryName) {
        categNameylacsm = list[i].idCategory;
      }
    }

    print(categNameylacsm);
  }

  Widget _delivery() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0, left: 24.0, right: 24.0),
      child: SwitchListTile(
          value: _d,
          title: Text('¿Realiza Delivery?'),
          activeColor: Colors.redAccent,
          onChanged: (value) {
            setState(() {
              cant++;
              _d = value;
              if (_d) {
                csmodel.companyDelivery = 'true';
              } else {
                csmodel.companyDelivery = '';
              }
            });
          }),
    );
  }

  Widget _entrega() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0, left: 24.0, right: 24.0),
      child: SwitchListTile(
          value: _e,
          title: Text('¿Realiza Entregas?'),
          activeColor: Colors.redAccent,
          onChanged: (value) => setState(() {
                cant++;
                _e = value;
                if (_e) {
                  csmodel.companyEntrega = 'true';
                } else {
                  csmodel.companyEntrega = '';
                }
              })),
    );
  }

  Widget _tarjeta() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0, left: 24.0, right: 24.0),
      child: SwitchListTile(
          value: _t,
          title: Text('¿Acepta Tarjeta?'),
          activeColor: Colors.redAccent,
          onChanged: (value) => setState(() {
                cant++;
                _t = value;
                if (_t) {
                  csmodel.companyTarjeta = 'true';
                } else {
                  csmodel.companyTarjeta = '';
                }
              })),
    );
  }

  void _showAlertDialog(
      BuildContext context, TextEditingController controller) {
    //TextEditingController _textFieldController = TextEditingController();
    String codeDialog;
    String valueText;
    showDialog(
        context: context,
        builder: (buildcontext) {
          return AlertDialog(
            title: Text("Nombre"),
            content: TextField(
              controller: controller,
              // onChanged: (value) {
              //   setState(() {
              //     valueText = value;
              //   });
              // },

              decoration: InputDecoration(hintText: "Ingrese dato"),
            ),
            actions: [
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text(
                  "CERRAR",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  valueText = controller.text;
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  // Widget _botonRegistro(
  //     BuildContext context, ActualizarNegocioBloc updateNegBloc) {
  //   return StreamBuilder(
  //       stream: updateNegBloc.formValidStream,
  //       builder: (BuildContext context, AsyncSnapshot snapshot) {
  //         return Padding(
  //           padding: const EdgeInsets.only(top: 10.0, left: 24.0, right: 24.0),
  //           child: SizedBox(
  //             width: double.infinity,
  //             child: RaisedButton(
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(30.0)),
  //               padding: EdgeInsets.all(0.0),
  //               child: Text('Registrar Negocio'),
  //               color: Theme.of(context).primaryColor,
  //               textColor: Colors.white,
  //               onPressed: (snapshot.hasData)
  //                   ? () {
  //                       print('llega');
  //                       //_submit(context, updateNegBloc);
  //                     }
  //                   : null,
  //             ),
  //           ),
  //         );
  //       });
  // }

  // _submit(BuildContext context, ActualizarNegocioBloc updateNegBloc) async {

  //   data.companyName = updateNegBloc.nameEmpresa;
  //   data.cell = updateNegBloc.cel;
  //   data.direccion = updateNegBloc.direccion;
  //   String sh;
  //   final List<String> tmp = data.companyName.split(" ");
  //   if (tmp.length == 1) {
  //     sh = data.companyName;
  //   } else {
  //     sh = data.companyName.replaceAll(" ", "_");
  //   }

  //   data.companyShortcode = 'www.guabba.com/$sh';

  //   final int code = await updateNegBloc.actualizarNegocio(cdata, sdata);

  //   if (code == 1) {
  //     print(code);
  //     utils.showToast(context, 'Negocio Registrado');
  //     Navigator.pop(context);
  //   } else if (code == 2) {
  //     print(code);
  //     utils.showToast(context, 'Ocurrio un error');
  //   } else if (code == 3) {
  //     print(code);
  //     utils.showToast(context, 'Shortcode incorrecto');
  //   } else if (code == 6) {
  //     print(code);
  //     utils.showToast(context, 'Datos incorrectos');
  //   }
  // }
}

class NegocioArgumentos {
  String nombre;
  String id;

  NegocioArgumentos({this.nombre, this.id});
}
