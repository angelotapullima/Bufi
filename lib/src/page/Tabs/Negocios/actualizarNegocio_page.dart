import 'package:bufi/src/bloc/categoriaPrincipal/categoria_bloc.dart';
import 'package:bufi/src/bloc/negocio/ActualizarNegocio_bloc.dart';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/CompanySubsidiaryModel.dart';
import 'package:bufi/src/models/categoriaModel.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/textStyle.dart';
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
                  _nameController.text = snapshot.data[0].companyName;
                  _rucController.text = snapshot.data[0].companyRuc;
                  _direccionController.text =
                      snapshot.data[0].subsidiaryAddress;
                  _celController.text = snapshot.data[0].subsidiaryCellphone;
                  _cel2Controller.text = snapshot.data[0].subsidiaryCellphone2;
                  _calleXController.text = snapshot.data[0].subsidiaryCoordX;
                  _calleYController.text = snapshot.data[0].subsidiaryCoordY;
                  _shortcodeController.text = snapshot.data[0].companyShortcode;
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

                  return Stack(
                    children: [
                      _form(context, categoriasBloc, updateNegBloc, responsive,
                          id),
                      Padding(
                        padding: EdgeInsets.only(top: responsive.hp(2.5)),
                        child: BackButton(
                          color: Colors.black,
                        ),
                      ),
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
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.wp(8),
          vertical: responsive.hp(1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: responsive.hp(3.5)),
              child: Text(
                "ACTUALIZAR NEGOCIO",
                style: TextStyle(fontSize: responsive.ip(3)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 25.0),
              child: Text(
                "Complete los campos",
                style: TextStyle(fontSize: responsive.ip(2)),

                //Theme.of(context).textTheme.subtitle,
              ),
            ),
            //_name(updateNegBloc, responsive),
            Text(
              "Nombre",
              style: textlabel,
            ),
            _textInput(
                updateNegBloc,
                responsive,
                _nameController,
                "Nombre de empresa",
                Icon(
                  Icons.store,
                  color: Theme.of(context).primaryColor,
                ),
                id),
            Text(
              "Ruc",
              style: textlabel,
            ),
            _textInput(
                updateNegBloc,
                responsive,
                _rucController,
                "RUC",
                Icon(
                  Icons.location_on,
                  color: Theme.of(context).primaryColor,
                ),
                id),
            Text(
              "Dirección",
              style: textlabel,
            ),
            _textInput(
                updateNegBloc,
                responsive,
                _direccionController,
                "Direccion",
                Icon(
                  Icons.location_on,
                  color: Theme.of(context).primaryColor,
                ),
                id),
            Text(
              "Celular",
              style: textlabel,
            ),
            _textInput(
                updateNegBloc,
                responsive,
                _celController,
                "celular",
                Icon(
                  Icons.phone,
                  color: Theme.of(context).primaryColor,
                ),
                id),
            Text(
              "Celular 2",
              style: textlabel,
            ),
            _textInput(
                updateNegBloc,
                responsive,
                _cel2Controller,
                "ceular2",
                Icon(
                  Icons.phone,
                  color: Theme.of(context).primaryColor,
                ),
                id),
            Text(
              "Coordenada X",
              style: textlabel,
            ),
            _textInput(
                updateNegBloc,
                responsive,
                _calleXController,
                "calleX",
                Icon(
                  Icons.phone,
                  color: Theme.of(context).primaryColor,
                ),
                id),
            Text(
              "Coordenada Y",
              style: textlabel,
            ),
            _textInput(
                updateNegBloc,
                responsive,
                _calleYController,
                "calleY",
                Icon(
                  Icons.phone,
                  color: Theme.of(context).primaryColor,
                ),
                id),
                Text(
              "Código corto",
              style: textlabel,
            ),
            _textInput(
                updateNegBloc,
                responsive,
                _shortcodeController,
                "codigo corto de empresa",
                Icon(
                  Icons.phone,
                  color: Theme.of(context).primaryColor,
                ),
                id),
                Text(
              "Horario de atención",
              style: textlabel,
            ),
            _textInput(
                updateNegBloc,
                responsive,
                _actOpeningHoursController,
                "Horas de Apertura",
                Icon(
                  Icons.phone,
                  color: Theme.of(context).primaryColor,
                ),
                id),
            _type(),
            _categoria(cBloc),
            _delivery(),
            _entrega(),
            _tarjeta(),
            //_botonRegistro(context, updateNegBloc),
          ],
        ),
      ),
    );
  }

  Widget _textInput(ActualizarNegocioBloc updateNegBloc, Responsive responsive,
      TextEditingController controller, String name, Icon icon, String id) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.left,
        readOnly: true,
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
            suffixIcon: icon),
        // onChanged: updateNegBloc.changeNameEmpresa,
        onTap: () {
          ngargumentsmodel.id = id;
          ngargumentsmodel.nombre = name;
          Navigator.pushNamed(context, "negocioActualizado",
              arguments: ngargumentsmodel);
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
                      csmodel.companyType = value;
                    });
                  }),
            )
          ],
        ));
  }

  Widget _categoria(CategoriaBloc bloc) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 2.0, left: 40.0, right: 40.0),
        child: Row(
          children: <Widget>[
            Text('Categoria'),
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
                      return DropdownButton(
                        value: csmodel.idCategory,
                        items: cat.map((e) {
                          return DropdownMenuItem<String>(
                            value: e.idCategory,
                            child: Text(
                              e.categoryName,
                              style: TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          csmodel.idCategory = value;
                          print(csmodel.idCategory);
                          this.setState(() {});
                        },
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

  Widget _delivery() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0, left: 24.0, right: 24.0),
      child: SwitchListTile(
          value: _d,
          title: Text('¿Realiza Delivery?'),
          activeColor: Colors.redAccent,
          onChanged: (value) {
            setState(() {
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
                _t = value;
                if (_t) {
                  csmodel.companyTarjeta = 'true';
                } else {
                  csmodel.companyTarjeta = '';
                }
              })),
    );
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
