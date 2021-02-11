import 'dart:convert';
import 'dart:io';

import 'package:bufi/src/api/servicios/services_api.dart';
import 'package:bufi/src/bloc/bienesServicios_bloc.dart';
import 'package:bufi/src/bloc/categoriaPrincipal/categoria_bloc.dart';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/categoriaModel.dart';
import 'package:bufi/src/models/companyModel.dart';
import 'package:bufi/src/models/serviceModel.dart';
import 'package:bufi/src/models/subsidiaryService.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:bufi/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class GuardarServicio extends StatefulWidget {
  @override
  _GuardarServicioState createState() => _GuardarServicioState();
}

class _GuardarServicioState extends State<GuardarServicio> {
  final servApi = ServiceApi();
  CompanyModel companyData = CompanyModel();
  ServiciosModel serviceData = ServiciosModel();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _currencyController = TextEditingController();
  TextEditingController _precioController = TextEditingController();
  TextEditingController _descripcionController = TextEditingController();
  File foto;
  final picker = ImagePicker();

//widget para el cargando
  final _cargando = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final String idSubsidiary = ModalRoute.of(context).settings.arguments;
    Responsive responsive = Responsive.of(context);
    final categoriasBloc = ProviderBloc.categoria(context);
    categoriasBloc.obtenerCategorias();
    final serviciosBloc = ProviderBloc.bienesServicios(context);
    serviciosBloc.obtenerServiciosAll();

    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: _cargando,
          builder: (BuildContext context, bool value, Widget child) {
            return Stack(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: responsive.wp(4), top: responsive.hp(5)),
                          child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (isDark) ? Colors.white : Colors.red,
                              ),
                              child: BackButton(
                                color: (isDark) ? Colors.black : Colors.white,
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: responsive.wp(6), top: responsive.hp(6)),
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.spaceAround,

                            children: [
                              Text(
                                "Registrar Servicio",
                                style: TextStyle(
                                  fontSize: responsive.ip(3),
                                ),
                              ),
                              SizedBox(height: 12),
                              Text("Complete los campos",
                                  style: TextStyle(fontSize: responsive.ip(2))),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: responsive.hp(3)),
                    _formServicio(responsive, context, categoriasBloc,
                        serviciosBloc, idSubsidiary),
                  ],
                ),
                (value)
                    ? Container(
                      height: double.infinity,
                      color: Colors.white54,
                      child: Center(
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
                                  image: AssetImage('assets/cargando.gif'),
                                  fit: BoxFit.contain),
                            ),
                          ),
                        ),
                    )
                    : Container()
              ],
            );
          }),
    );
  }

  Widget _formServicio(
      Responsive responsive,
      BuildContext context,
      CategoriaBloc categoriasBloc,
      BienesServiciosBloc serviciosBloc,
      String idSubsidiary) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsive.wp(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    _mostrarFoto(responsive),

                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                          icon: Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Seleccione"),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          GestureDetector(
                                            child: Text("Galeria"),
                                            onTap: () {
                                              Navigator.pop(context);

                                              _seleccionarFoto();
                                            },
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                          ),
                                          GestureDetector(
                                            child: Text("Camara"),
                                            onTap: () {
                                              Navigator.pop(context);

                                              _tomarFoto();
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }),
                    ),

                    //Seleccionar Foto
                  ],
                ),
              ),
              SizedBox(
                height: responsive.hp(3),
              ),

              Text("Nombre del servicio", style: textlabel),
              datoInput(context, responsive, _nameController,
                  TextInputType.text, 'Nombre del Servicio'),
              SizedBox(height: responsive.hp(1)),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Moneda", style: textlabel),
                      Container(
                        width: responsive.wp(40),
                        child: datoInput(
                            context,
                            responsive,
                            _currencyController,
                            TextInputType.number,
                            'Moneda'),
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Precio", style: textlabel),
                      Container(
                        width: responsive.wp(40),
                        child: datoInput(context, responsive, _precioController,
                            TextInputType.number, 'Precio'),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: responsive.hp(1)),

              Text("Descripción", style: textlabel),
              descripcion(
                  context, responsive, _descripcionController, 'descripcion'),
              SizedBox(height: responsive.hp(1)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Categoría", style: textlabel),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.wp(5),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: _categoria(categoriasBloc),
                  ),
                ],
              ),

              SizedBox(
                height: responsive.hp(2),
              ),

              //Servicio
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Tipo de Servicio", style: textlabel),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.wp(5),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: _servicio(serviciosBloc),
                  ),
                ],
              ),
              SizedBox(height: responsive.hp(3)),
              _btnRegistrar(context, idSubsidiary),
              SizedBox(
                height: responsive.hp(10),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _mostrarFoto(Responsive responsive) {
    if (foto != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image(
          image: AssetImage(foto.path),
          height: responsive.hp(38),
          fit: BoxFit.cover,
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image(
          image: AssetImage('assets/no-image.png'),
          height: responsive.hp(38),
          fit: BoxFit.cover,
        ),
      );
    }
  }

  _procesarImagen(ImageSource origen) async {
    final picketfile = await picker.getImage(source: origen);
    foto = File(picketfile.path);

    if (foto != null) {}
    setState(() {});
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  Widget datoInput(BuildContext context, Responsive responsive,
      TextEditingController controlador, TextInputType teclado, String nombre) {
    return TextField(
      controller: controlador,
      keyboardType: teclado,
      decoration: InputDecoration(
        hintText: nombre,
        hintStyle: TextStyle(fontSize: responsive.ip(2)),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        filled: true,
        contentPadding: EdgeInsets.all(16),
      ),
    );
  }

  Widget descripcion(BuildContext context, Responsive responsive,
      TextEditingController controlador, String nombre) {
    return TextField(
      controller: controlador,
      keyboardType: TextInputType.text,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: nombre,
        hintStyle: TextStyle(fontSize: responsive.ip(2)),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        filled: true,
        contentPadding: EdgeInsets.all(16),
      ),
    );
  }

  Widget _categoria(CategoriaBloc bloc) {
    return StreamBuilder(
        stream: bloc.categoriaStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<CategoriaModel>> snapshot) {
          if (snapshot.hasData) {
            final cat = snapshot.data;
            return DropdownButtonHideUnderline(
              child: DropdownButton(
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                  size: 32,
                ),
                hint: Text("Seleccione una categoría"),
                isExpanded: true,
                value: companyData.idCategory,
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
                  companyData.idCategory = value;
                  print(companyData.idCategory);
                  this.setState(() {});
                },
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _servicio(BienesServiciosBloc bloc) {
    return Row(
      children: [
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: StreamBuilder(
              stream: bloc.serviciosAllStream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<ServiciosModel>> snapshot) {
                if (snapshot.hasData) {
                  final servicio = snapshot.data;
                  return DropdownButtonHideUnderline(
                    child: DropdownButton(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                        size: 32,
                      ),
                      hint: Text("Seleccione un Servicio"),
                      value: serviceData.idService,
                      isExpanded: true,
                      items: servicio.map((e) {
                        return DropdownMenuItem<String>(
                          value: e.idService,
                          child: Text(
                            e.serviceName,
                            style: TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        serviceData.idService = value;
                        print(serviceData.idService);
                        this.setState(() {});
                      },
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ],
    );
  }

  Widget _btnRegistrar(BuildContext context, String idSubsidiary) {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        child: Text("Registrar"),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        onPressed: () async {
          if (_nameController.text.length > 0) {
            if (_currencyController.text.length > 0) {
              if (_precioController.text.length > 0) {
                if (_descripcionController.text.length > 0) {
                  if (foto != null) {
                    if (companyData.idCategory != null) {
                      if (serviceData.idService != null) {
                        //Submit
                        _submit(idSubsidiary);

                      } else {
                        utils.showToast(
                            context, 'Debe seleccionar un servicio ');
                      }
                    } else {
                      utils.showToast(
                          context, 'Debe seleccionar una categoría ');
                    }
                  } else {
                    utils.showToast(context, 'Debe seleccionaer una foto');
                  }
                } else {
                  utils.showToast(context, 'Debe ingresar la descripcion');
                }
              } else {
                utils.showToast(context, 'Debe ingresar el precio');
              }
            } else {
              utils.showToast(context, 'Debe ingresar el tipo de moneda');
            }
          } else {
            utils.showToast(context, 'Debe ingresar el nombre ');
          }
        },
      ),
    );
  }

  void _submit(String idSubsidiary) async {
    final servicioApi = ServiceApi();
    //Para obtener el id y tipo de servicio general
    final serviceData = ServiciosModel();
    final companyModel = CompanyModel();

    //Obtener el nombre y caracteristicas del servicio
    final servicioModel = SubsidiaryServiceModel();

    servicioModel.idSubsidiary = idSubsidiary;
    serviceData.idService = serviceData.idService;
    companyModel.idCategory = companyData.idCategory;
    servicioModel.subsidiaryServiceName = _nameController.text;
    servicioModel.subsidiaryServicePrice = _precioController.text;
    servicioModel.subsidiaryServiceCurrency = _currencyController.text;
    servicioModel.subsidiaryServiceDescription = _descripcionController.text;

    _cargando.value = true;

//Lamada a la api
    final int code = await servicioApi.guardarServicio(foto, companyModel, serviceData, servicioModel);

    if (code == 1) {
      print(code);
      utils.showToast(context, 'Servicio Registrado');
      Navigator.pushNamed(context, "detalleSubsidiary");
    } else if (code == 2) {
      print(code);
      utils.showToast(context, 'Ocurrio un error');
    } else if (code == 6) {
      print(code);
      utils.showToast(context, 'Datos incorrectos');
    } else {
      print(code);
    }

    _cargando.value = true;
  }
}
