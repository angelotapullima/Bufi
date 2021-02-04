import 'package:bufi/src/api/negocio/negocios_api.dart';
import 'package:bufi/src/bloc/categoriaPrincipal/categoria_bloc.dart';
import 'package:bufi/src/bloc/negocio/ActualizarNegocio_bloc.dart';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/CompanySubsidiaryModel.dart';
import 'package:bufi/src/models/categoriaModel.dart';
import 'package:bufi/src/page/Tabs/Negocios/actualizarNegocio_page.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:flutter/material.dart';


class NegocioActualizado extends StatefulWidget {
  @override
  _NegocioActualizadoState createState() => _NegocioActualizadoState();
}

class _NegocioActualizadoState extends State<NegocioActualizado> {
  bool _d = false;
  bool _e = false;
  bool _t = false;
  int cant_item = 0;

  CompanySubsidiaryModel csmodel = CompanySubsidiaryModel();
  NegociosApi negocioApi = NegociosApi();

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
    //recibir id y nombre de la clase Negocio
    final NegocioArgumentos negArgumentos=ModalRoute.of(context).settings.arguments;
    final responsive = Responsive.of(context);
    final categoriasBloc = ProviderBloc.categoria(context);
    categoriasBloc.obtenerCategorias();
    final updateNegBloc = ProviderBloc.actualizarNeg(context);
    updateNegBloc.updateNegocio(negArgumentos.id);

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
                   _direccionController.text = snapshot.data[0].subsidiaryAddress;
                  _celController.text = snapshot.data[0].subsidiaryCellphone;
                  _cel2Controller.text = snapshot.data[0].subsidiaryCellphone2;
                  _calleXController.text = snapshot.data[0].subsidiaryCoordX;
                  _calleYController.text = snapshot.data[0].subsidiaryCoordY;
                  _shortcodeController.text = snapshot.data[0].companyShortcode;
                  _actOpeningHoursController.text =
                      snapshot.data[0].subsidiaryOpeningHours;

                  //switch de delivery
                  if (cant_item == 0) {
                    if (snapshot.data[0].companyDelivery == "1") {
                      _d = true;
                    } else {
                      _d = false;
                    }
                  }

                  //switch de entrega
                  if (cant_item == 0) {
                    if (snapshot.data[0].companyEntrega == "1") {
                      _e = true;
                    } else {
                      _e = false;
                    }
                  }
                  //switch de tarjeta
                  if (cant_item == 0) {
                    if (snapshot.data[0].companyTarjeta == "1") {
                      _t = true;
                    } else {
                      _t = false;
                    }
                  }

                  //poner un ValueListenableBuilder
                  return Stack(
                    children: [
                      _form(context, categoriasBloc, updateNegBloc, responsive,
                          negArgumentos, snapshot),
                      BackButton(
                        color: Colors.black,
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

  Widget _form(
      BuildContext context,
      CategoriaBloc cBloc,
      ActualizarNegocioBloc updateNegBloc,
      Responsive responsive,
      NegocioArgumentos negArgumentos,
      AsyncSnapshot snapshot) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "ACTUALIZAR",
                style: TextStyle(fontSize: responsive.ip(3)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 32.0),
              child: Text(
                "Complete los campos",
                style: TextStyle(fontSize: responsive.ip(2)),

                //Theme.of(context).textTheme.subtitle,
              ),
            ),
            //_name(updateNegBloc, responsive),
            (negArgumentos.nombre == 'Nombre de empresa')
                ? _textInput(
                    updateNegBloc,
                    responsive,
                    _nameController,
                    "Nombre de empresa",
                    Icon(
                      Icons.store,
                      color: Theme.of(context).primaryColor,
                    ))
                : Container(),
            (negArgumentos.nombre == 'RUC')
                ? _textInput(
                    updateNegBloc,
                    responsive,
                    _rucController,
                    "RUC",
                    Icon(
                      Icons.location_on,
                      color: Theme.of(context).primaryColor,
                    ))
                : Container(),
            (negArgumentos.nombre == 'Direccion')
                ? _textInput(
                    updateNegBloc,
                    responsive,
                    _direccionController,
                    "Direccion",
                    Icon(
                      Icons.location_on,
                      color: Theme.of(context).primaryColor,
                    ))
                : Container(),
            (negArgumentos.nombre == 'celular')
                ? _textInput(
                    updateNegBloc,
                    responsive,
                    _celController,
                    "ceular",
                    Icon(
                      Icons.phone,
                      color: Theme.of(context).primaryColor,
                    ))
                : Container(),
            (negArgumentos.nombre == 'celular2')
                ? _textInput(
                    updateNegBloc,
                    responsive,
                    _cel2Controller,
                    "ceular2",
                    Icon(
                      Icons.phone,
                      color: Theme.of(context).primaryColor,
                    ))
                : Container(),
            (negArgumentos.nombre == 'calleX')
                ? _textInput(
                    updateNegBloc,
                    responsive,
                    _calleXController,
                    "calleX",
                    Icon(
                      Icons.phone,
                      color: Theme.of(context).primaryColor,
                    ))
                : Container(),
            (negArgumentos.nombre == 'calleY')
                ? _textInput(
                    updateNegBloc,
                    responsive,
                    _calleYController,
                    "calleY",
                    Icon(
                      Icons.phone,
                      color: Theme.of(context).primaryColor,
                    ))
                : Container(),
            (negArgumentos.nombre == 'codigo corto de empresa')
                ? _textInput(
                    updateNegBloc,
                    responsive,
                    _shortcodeController,
                    "codigo corto de empresa",
                    Icon(
                      Icons.phone,
                      color: Theme.of(context).primaryColor,
                    ))
                : Container(),
            (negArgumentos.nombre == 'Horas de Apertura')
                ? _textInput(
                    updateNegBloc,
                    responsive,
                    _actOpeningHoursController,
                    "Horas de Apertura",
                    Icon(
                      Icons.phone,
                      color: Theme.of(context).primaryColor,
                    ))
                : Container(),
            _type(),
            _categoria(cBloc, snapshot.data),
            _delivery(),
            _entrega(),
            _tarjeta(),
            _botonRegistro(context, negArgumentos, snapshot)
            //_botonRegistro(context, updateNegBloc),
          ],
        ),
      ),
    );
  }

  Widget _textInput(ActualizarNegocioBloc updateNegBloc, Responsive responsive,
      TextEditingController controller, String name, Icon icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0, left: 10),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.left,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            fillColor: Theme.of(context).dividerColor,
            hintText: name,
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
            //errorText: snapshot.error,
            suffixIcon: icon),
        // onChanged: updateNegBloc.changeNameEmpresa,
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

  String datoCategory;
  Widget _categoria(
      CategoriaBloc bloc, List<CompanySubsidiaryModel> listsnapshot) {
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
                  builder: (BuildContext context, AsyncSnapshot<List<CategoriaModel>> snapshot) {
                    var listALgo = List<String>();
                    for (var i = 0; i < snapshot.data.length; i++) {
                      if (snapshot.data[i].idCategory ==listsnapshot[0].idCategory) {
                        datoCategory = snapshot.data[i].categoryName;
                      }

                      listALgo.add(snapshot.data[i].categoryName);
                    }
                    if (snapshot.hasData) {
                      return DropdownButton(
                        value: datoCategory,
                        items: listALgo.map((e) {
                          return DropdownMenuItem<String>(
                            value: e,
                            child: Text(
                              e,
                              style: TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) async {
                          //csmodel.idCategory = await ;
                          datoCategory = value;
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
              cant_item++;
              _d = value;
              //_d = value;s
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
                cant_item++;
                _e = value;
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
                cant_item++;
                _t = value;
              })),
    );
  }

  Widget _botonRegistro(BuildContext context, NegocioArgumentos negArgumentos,
      AsyncSnapshot snapshot) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 24.0, right: 24.0),
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            padding: EdgeInsets.all(0.0),
            child: Text('Actualizar'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: () {
              //print('llega');
              _submit(context, negArgumentos, snapshot);
            }),
      ),
    );
  }

  _submit(BuildContext context, NegocioArgumentos negArgumentos,
      AsyncSnapshot snapshot) async {
    final List<CompanySubsidiaryModel> listdata = snapshot.data;

    String sh;
    final List<String> tmp = _nameController.text.split(" ");
    if (tmp.length == 1) {
      sh = csmodel.companyName;
    } else {
      sh = csmodel.companyName.replaceAll(" ", "_");
    }

    csmodel.companyShortcode = 'www.guabba.com/$sh';

    if (negArgumentos.nombre == 'Nombre de empresa') {
      csmodel.companyName = _nameController.text;
      csmodel..companyRuc = listdata[0].companyRuc;
      csmodel.subsidiaryAddress = listdata[0].subsidiaryAddress;
      csmodel.subsidiaryCellphone = listdata[0].subsidiaryCellphone;
      csmodel.subsidiaryCellphone2 = listdata[0].subsidiaryCellphone2;
      csmodel.subsidiaryCoordX = listdata[0].subsidiaryCoordX;
      csmodel.subsidiaryCoordY = listdata[0].subsidiaryCoordY;
      csmodel.companyShortcode = listdata[0].companyShortcode;
      csmodel.subsidiaryOpeningHours = listdata[0].subsidiaryOpeningHours;
      //csmodel.companyDelivery =

    } else if (negArgumentos.nombre == 'RUC') {
      csmodel.companyName = listdata[0].companyName;
      csmodel..companyRuc = _rucController.text;
      csmodel.subsidiaryAddress = listdata[0].subsidiaryAddress;
      csmodel.subsidiaryCellphone = listdata[0].subsidiaryCellphone;
      csmodel.subsidiaryCellphone2 = listdata[0].subsidiaryCellphone2;
      csmodel.subsidiaryCoordX = listdata[0].subsidiaryCoordX;
      csmodel.subsidiaryCoordY = listdata[0].subsidiaryCoordY;
      csmodel.companyShortcode = listdata[0].companyShortcode;
      csmodel.subsidiaryOpeningHours = listdata[0].subsidiaryOpeningHours;
    } else if (negArgumentos.nombre == 'Direccion') {
      csmodel.companyName = listdata[0].companyName;
      csmodel..companyRuc = listdata[0].companyRuc;
      csmodel.subsidiaryAddress = _direccionController.text;
      csmodel.subsidiaryCellphone = listdata[0].subsidiaryCellphone;
      csmodel.subsidiaryCellphone2 = listdata[0].subsidiaryCellphone2;
      csmodel.subsidiaryCoordX = listdata[0].subsidiaryCoordX;
      csmodel.subsidiaryCoordY = listdata[0].subsidiaryCoordY;
      csmodel.companyShortcode = listdata[0].companyShortcode;
      csmodel.subsidiaryOpeningHours = listdata[0].subsidiaryOpeningHours;
    } else if (negArgumentos.nombre == 'celular') {
      csmodel.companyName = listdata[0].companyName;
      csmodel..companyRuc = listdata[0].companyRuc;
      csmodel.subsidiaryAddress = listdata[0].companyRuc;
      csmodel.subsidiaryCellphone = _celController.text;
      csmodel.subsidiaryCellphone2 = listdata[0].subsidiaryCellphone2;
      csmodel.subsidiaryCoordX = listdata[0].subsidiaryCoordX;
      csmodel.subsidiaryCoordY = listdata[0].subsidiaryCoordY;
      csmodel.companyShortcode = listdata[0].companyShortcode;
      csmodel.subsidiaryOpeningHours = listdata[0].subsidiaryOpeningHours;
    } else if (negArgumentos.nombre == 'celular2') {
      csmodel.companyName = listdata[0].companyName;
      csmodel..companyRuc = listdata[0].companyRuc;
      csmodel.subsidiaryAddress = listdata[0].companyRuc;
      csmodel.subsidiaryCellphone = listdata[0].subsidiaryCellphone;
      csmodel.subsidiaryCellphone2 = _cel2Controller.text;
      csmodel.subsidiaryCoordX = listdata[0].subsidiaryCoordX;
      csmodel.subsidiaryCoordY = listdata[0].subsidiaryCoordY;
      csmodel.companyShortcode = listdata[0].companyShortcode;
      csmodel.subsidiaryOpeningHours = listdata[0].subsidiaryOpeningHours;
    } else if (negArgumentos.nombre == 'calleX') {
      csmodel.companyName = listdata[0].companyName;
      csmodel..companyRuc = listdata[0].companyRuc;
      csmodel.subsidiaryAddress = listdata[0].companyRuc;
      csmodel.subsidiaryCellphone = listdata[0].subsidiaryCellphone;
      csmodel.subsidiaryCellphone2 = listdata[0].subsidiaryCellphone2;
      csmodel.subsidiaryCoordX = _calleXController.text;
      csmodel.subsidiaryCoordY = listdata[0].subsidiaryCoordY;
      csmodel.companyShortcode = listdata[0].companyShortcode;
      csmodel.subsidiaryOpeningHours = listdata[0].subsidiaryOpeningHours;
    } else if (negArgumentos.nombre == 'calleY') {
      csmodel.companyName = listdata[0].companyName;
      csmodel..companyRuc = listdata[0].companyRuc;
      csmodel.subsidiaryAddress = listdata[0].companyRuc;
      csmodel.subsidiaryCellphone = listdata[0].subsidiaryCellphone;
      csmodel.subsidiaryCellphone2 = listdata[0].subsidiaryCellphone2;
      csmodel.subsidiaryCoordX = listdata[0].subsidiaryCoordX;
      csmodel.subsidiaryCoordY = _calleYController.text;
      csmodel.companyShortcode = listdata[0].companyShortcode;
      csmodel.subsidiaryOpeningHours = listdata[0].subsidiaryOpeningHours;
    } else if (negArgumentos.nombre == 'codigo corto de empresa') {
      csmodel.companyName = listdata[0].companyName;
      csmodel..companyRuc = listdata[0].companyRuc;
      csmodel.subsidiaryAddress = listdata[0].companyRuc;
      csmodel.subsidiaryCellphone = listdata[0].subsidiaryCellphone;
      csmodel.subsidiaryCellphone2 = listdata[0].subsidiaryCellphone2;
      csmodel.subsidiaryCoordX = listdata[0].subsidiaryCoordX;
      csmodel.subsidiaryCoordY = listdata[0].subsidiaryCoordY;
      csmodel.companyShortcode = _shortcodeController.text;
      csmodel.subsidiaryOpeningHours = listdata[0].subsidiaryOpeningHours;
    } else if (negArgumentos.nombre == 'Horas de Apertura') {
      csmodel.companyName = listdata[0].companyName;
      csmodel..companyRuc = listdata[0].companyRuc;
      csmodel.subsidiaryAddress = listdata[0].companyRuc;
      csmodel.subsidiaryCellphone = listdata[0].subsidiaryCellphone;
      csmodel.subsidiaryCellphone2 = listdata[0].subsidiaryCellphone2;
      csmodel.subsidiaryCoordX = listdata[0].subsidiaryCoordX;
      csmodel.subsidiaryCoordY = listdata[0].subsidiaryCoordY;
      csmodel.companyShortcode = listdata[0].companyShortcode;
      csmodel.subsidiaryOpeningHours = _actOpeningHoursController.text;
    }

    await negocioApi.updateNegocio(csmodel);
  }
}
