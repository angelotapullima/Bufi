import 'dart:convert';
import 'dart:io';

import 'package:bufi/src/api/servicios/services_api.dart';
import 'package:bufi/src/bloc/bienesServicios_bloc.dart';
import 'package:bufi/src/bloc/categoriaPrincipal/categoria_bloc.dart';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/categoriaModel.dart';
import 'package:bufi/src/models/companyModel.dart';
import 'package:bufi/src/models/serviceModel.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
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
      body: Column(
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
                      "Registro del Producto",
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
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        _mostrarFoto(responsive),

                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                              //alignment: Alignment.centerRight,
                              icon: Icon(Icons.camera_alt_rounded),
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
                    SizedBox(
                      height: responsive.hp(1),
                    ),
                    datoInput(
                      context,
                      responsive,
                      _nameController,
                      'Nombre del Servicio',
                      Icon(
                        Icons.business,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: responsive.wp(45),
                          child: datoInput(
                            context,
                            responsive,
                            _currencyController,
                            'moneda',
                            Icon(
                              Icons.stay_current_landscape,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: responsive.wp(45),
                          child: datoInput(
                            context,
                            responsive,
                            _precioController,
                            'precio',
                            Icon(
                              Icons.business,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    datoInput(
                      context,
                      responsive,
                      _descripcionController,
                      'descripcion',
                      Icon(
                        Icons.stay_current_landscape,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(5),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.grey[300]),
                      child: _categoria(categoriasBloc),
                    ),
                    SizedBox(
                      height: responsive.hp(2),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(5),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.grey[300]),
                      child: _bien(serviciosBloc),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    _btnRegistrar(context, idSubsidiary),
                    SizedBox(
                      height: responsive.hp(10),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mostrarFoto(Responsive responsive) {
    if (foto != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image(
          image: AssetImage(foto.path),
          height: responsive.hp(35),
          fit: BoxFit.cover,
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image(
          image: AssetImage('assets/no-image.png'),
          height: responsive.hp(35),
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
      TextEditingController controlador, String nombre, Widget icon) {
    return TextField(
      controller: controlador,
      keyboardType: TextInputType.text,
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
    return Row(
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
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        )
      ],
    );
  }

  Widget _bien(BienesServiciosBloc bloc) {
    return Row(
      children: <Widget>[
        Text('Bien'),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: StreamBuilder(
              stream: bloc.serviciosAllStream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<ServiciosModel>> snapshot) {
                if (snapshot.hasData) {
                  final bien = snapshot.data;
                  return DropdownButton(
                    value: serviceData.idService,
                    isExpanded: true,
                    items: bien.map((e) {
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
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        )
      ],
    );
  }

  Widget _btnRegistrar(BuildContext context, String idSubsidiary) {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        child: Text("Registraaar"),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        onPressed: () {
          if (_nameController.text.length > 0) {
            if (_currencyController.text.length > 0) {
              if (_precioController.text.length > 0) {
                if (_descripcionController.text.length > 0) {
                  if (foto != null) {
                    if (companyData.idCategory != null) {
                      if (serviceData.idService != null) {
                        uploadImage1(foto, idSubsidiary);
                        //_submit(context,idSubsidiary,foto);

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
                  // _submit(context, idSubsidiary);
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

  void uploadImage1(File _image, String idSubsidiary) async {
    final preferences = Preferences();

    // open a byteStream
    var stream = new http.ByteStream(Stream.castFrom(_image.openRead()));
    // get file length
    var length = await _image.length();

    // string to uri
    var uri = Uri.parse("$apiBaseURL/api/Negocio/guardar_servicio");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // if you need more parameters to parse, add those like this. i added "user_id". here this "user_id" is a key of the API request
    request.fields["id_user"] = preferences.idUser;
    request.fields["id_sucursal2"] = idSubsidiary;
    request.fields["id_servicio"] = serviceData.idService;
    request.fields["categoria_s"] = companyData.idCategory;
    request.fields["nombre_s"] = _nameController.text;
    request.fields["precio_s"] = _precioController.text;
    request.fields["currency_s"] = _currencyController.text;
    request.fields["descripcion"] = _descripcionController.text;

    // multipart that takes file.. here this "image_file" is a key of the API request
    var multipartFile = new http.MultipartFile('servicio_img', stream, length,
        filename: basename(_image.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send request to upload image
    await request.send().then((response) async {
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);

        final decodedData = json.decode(value);
        if (decodedData['result']['code'] == 1) {
          print('amonos');
        }
      });
    }).catchError((e) {
      print(e);
    });
  }
}
