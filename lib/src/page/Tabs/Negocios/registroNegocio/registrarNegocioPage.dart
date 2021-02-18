import 'dart:ui';

import 'package:bufi/src/bloc/categoriaPrincipal/categoria_bloc.dart';
import 'package:bufi/src/bloc/negocio/registroNegocio_bloc.dart';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/categoriaModel.dart';
import 'package:bufi/src/models/companyModel.dart';
import 'package:bufi/src/page/Tabs/Negocios/registroNegocio/registro_negocio_bloc.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/textStyle.dart';
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

    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
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
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          (isDark) ? Colors.white : Colors.red,
                                    ),
                                    child: BackButton(
                                      color: (isDark)
                                          ? Colors.black
                                          : Colors.white,
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: responsive.wp(6),
                                      top: responsive.hp(3.5)),
                                  child: Column(
                                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "Registro del Negocio",
                                        style: TextStyle(
                                          fontSize: responsive.ip(3),
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Text("Complete los campos",
                                          style: TextStyle(
                                              fontSize: responsive.ip(2)))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                  },
                ),
                SizedBox(height: 15),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: responsive.wp(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Nombre de Empresa", style: textlabel),
                          _name(regisNBloc, responsive),
                          SizedBox(height: 10),
                          Text(
                            "Dirección",
                            style: textlabel,
                          ),
                          _direccion(regisNBloc, responsive),
                          SizedBox(height: 10),
                          Text(
                            "Celular",
                            style: textlabel,
                          ),
                          _cel(regisNBloc, responsive),
                          SizedBox(height: 15),
                          _type(responsive),
                          SizedBox(height: 10),
                          _categoria(categoriasBloc, responsive),
                          SizedBox(height: 10),
                          _delivery(responsive),
                          _entrega(responsive),
                          _tarjeta(responsive),
                          SizedBox(height: 10),
                          _botonRegistro(context, regisNBloc),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _name(RegistroNegocioBloc regisNBloc, Responsive responsive) {
    return StreamBuilder(
      stream: regisNBloc.nameEmpresaStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return TextField(
          cursorColor: Colors.black,
          textAlign: TextAlign.left,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: "Nombre",
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]),
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            errorText: snapshot.error,
          ),
          onChanged: regisNBloc.changeNameEmpresa,
        );
      },
    );
  }

  Widget _direccion(RegistroNegocioBloc regisNBloc, Responsive responsive) {
    return StreamBuilder(
      stream: regisNBloc.direccionStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return TextField(
          textAlign: TextAlign.left,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            //fillColor: Theme.of(context).dividerColor,
            hintText: 'Dirección',
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]),
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            errorText: snapshot.error,
          ),
          onChanged: regisNBloc.changeDireccion,
        );
      },
    );
  }

  Widget _cel(RegistroNegocioBloc regisNBloc, Responsive responsive) {
    return StreamBuilder(
      stream: regisNBloc.celStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return TextField(
          textAlign: TextAlign.left,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            //fillColor: Theme.of(context).dividerColor,
            hintText: 'Celular',
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[200]),
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            //errorText: snapshot.error,
          ),
          onChanged: regisNBloc.changecel,
        );
      },
    );
  }

  Widget _type(Responsive responsive) {
    return Padding(
        padding: EdgeInsets.only(bottom: 2.0, right: 3),
        child: Row(
          children: <Widget>[
            Text('Tipo', style: textlabel),
            SizedBox(
              width:responsive.wp(11),
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

                        //elevation: 16,
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
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Widget _categoria(CategoriaBloc bloc, Responsive responsive) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.0, right: 3),
      child: Row(
        children: <Widget>[
          Text('Categoría', style: textlabel),
          SizedBox(
            width:responsive.wp(2),
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
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            hint: Text("Seleccione una categoría"),
                            value: data.idCategory,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                              size: 32,
                            ),
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
      ),
    );
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
                child: Text('REGISTRAR', style: TextStyle(fontSize: 20)),
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

  Widget _delivery(Responsive responsive) {
    return Padding(
      padding: EdgeInsets.only(left: responsive.ip(8)),
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

  Widget _entrega(Responsive responsive) {
    return Padding(
      padding:  EdgeInsets.only(left: responsive.ip(8)),
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

  Widget _tarjeta(Responsive responsive) {
    return Padding(
      padding: EdgeInsets.only(left: responsive.ip(8)),
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
