import 'package:bufi/src/bloc/categoriaPrincipal/categoria_bloc.dart';
import 'package:bufi/src/bloc/negocio/registroNegocio_bloc.dart';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/categoriaModel.dart';
import 'package:bufi/src/models/companyModel.dart';
import 'package:bufi/src/page/Tabs/Negocios/registroNegocio/registro_negocio_bloc.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistroNegocio extends StatefulWidget {
  @override
  _RegistroNegocioState createState() => _RegistroNegocioState();
}

class _RegistroNegocioState extends State<RegistroNegocio> {
  CompanyModel data = CompanyModel();
  bool _d = false;
  bool _e = false;
  bool _t = false;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final categoriasBloc = ProviderBloc.categoria(context);

    categoriasBloc.obtenerCategorias();
    final provider =
        Provider.of<RegistroNegocioBlocListener>(context, listen: false);

    final regisNBloc = ProviderBloc.registroNegocio(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                ValueListenableBuilder<bool>(
                  valueListenable: provider.show,
                  builder: (_, value, __) {
                    return (value)
                        ? Container(
                            color: Colors.transparent,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: responsive.wp(5),
                              vertical: responsive.hp(1),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "Registro Negocio",
                                  style: TextStyle(
                                    fontSize: responsive.ip(3),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            color: Colors.transparent,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: responsive.wp(5),
                              vertical: responsive.hp(1),
                            ),
                            child: Text(
                              "Registro Negocio",
                              style: TextStyle(
                                fontSize: responsive.ip(3),
                              ),
                            ),
                          );
                  },
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    controller: provider.controller,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Registro Negocio",
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
                      _name(regisNBloc, responsive),
                      _direccion(regisNBloc, responsive),
                      _cel(regisNBloc, responsive),
                      _name(regisNBloc, responsive),
                      _direccion(regisNBloc, responsive),
                      _cel(regisNBloc, responsive),
                      _name(regisNBloc, responsive),
                      _direccion(regisNBloc, responsive),
                      _cel(regisNBloc, responsive),
                      _name(regisNBloc, responsive),
                      _direccion(regisNBloc, responsive),
                      _cel(regisNBloc, responsive),
                      _type(),
                      _categoria(categoriasBloc),
                      _delivery(),
                      _entrega(),
                      _tarjeta(),
                      _botonRegistro(context, regisNBloc),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _form(BuildContext context, CategoriaBloc cBloc,
      RegistroNegocioBloc regisNBloc, Responsive responsive) {}

  Widget _name(RegistroNegocioBloc regisNBloc, Responsive responsive) {
    return StreamBuilder(
      stream: regisNBloc.nameEmpresaStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 24.0, right: 24.0),
          child: TextField(
            textAlign: TextAlign.left,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                fillColor: Theme.of(context).dividerColor,
                hintText: 'Nombre de Empresa',
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
                )),
            onChanged: regisNBloc.changeNameEmpresa,
          ),
        );
      },
    );
  }

  Widget _direccion(RegistroNegocioBloc regisNBloc, Responsive responsive) {
    return StreamBuilder(
      stream: regisNBloc.direccionStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 24.0, right: 24.0),
          child: TextField(
            textAlign: TextAlign.left,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                fillColor: Theme.of(context).dividerColor,
                hintText: 'Dirección',
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
                )),
            onChanged: regisNBloc.changeDireccion,
          ),
        );
      },
    );
  }

  Widget _cel(RegistroNegocioBloc regisNBloc, Responsive responsive) {
    return StreamBuilder(
      stream: regisNBloc.celStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 24.0, right: 24.0),
          child: TextField(
            textAlign: TextAlign.left,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                fillColor: Theme.of(context).dividerColor,
                hintText: 'Celular',
                hintStyle: TextStyle(fontSize: responsive.ip(2)),
                //Theme.of(context).textTheme.display2,
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
                )),
            onChanged: regisNBloc.changecel,
          ),
        );
      },
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
                  value: data.companyType,
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
                      data.companyType = value;
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
                        value: data.idCategory,
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
                          data.idCategory = value;
                          print(data.idCategory);
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

  Widget _botonRegistro(BuildContext context, RegistroNegocioBloc regisNBloc) {
    return StreamBuilder(
        stream: regisNBloc.formValidStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 24.0, right: 24.0),
            child: SizedBox(
              width: double.infinity,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                padding: EdgeInsets.all(0.0),
                child: Text('Registrar Negocio'),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: (snapshot.hasData)
                    ? () {
                        print('llega');
                        _submit(context, regisNBloc);
                      }
                    : null,
              ),
            ),
          );
        });
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
                data.companyDelivery = 'true';
              } else {
                data.companyDelivery = '';
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
                  data.companyEntrega = 'true';
                } else {
                  data.companyEntrega = '';
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
                  data.companyTarjeta = 'true';
                } else {
                  data.companyTarjeta = '';
                }
              })),
    );
  }

  _submit(BuildContext context, RegistroNegocioBloc regisNBloc) async {
    data.companyName = regisNBloc.nameEmpresa;
    data.cell = regisNBloc.cel;
    data.direccion = regisNBloc.direccion;
    String sh;
    final List<String> tmp = data.companyName.split(" ");
    if (tmp.length == 1) {
      sh = data.companyName;
    } else {
      sh = data.companyName.replaceAll(" ", "_");
    }

    data.companyShortcode = 'www.guabba.com/$sh';

    final int code = await regisNBloc.registroNegocio(data);

    if (code == 1) {
      print(code);
      showToast(context, 'Negocio Registrado');
      Navigator.pop(context);
    } else if (code == 2) {
      print(code);
      showToast(context, 'Ocurrio un error');
    } else if (code == 3) {
      print(code);
      showToast(context, 'Shortcode incorrecto');
    } else if (code == 6) {
      print(code);
      showToast(context, 'Datos incorrectos');
    }
  }
}
