import 'dart:convert';
import 'dart:io';
import 'package:bufi/src/api/negocio/negocios_api.dart';
import 'package:bufi/src/bloc/bienesServicios_bloc.dart';
import 'package:bufi/src/bloc/categoriaPrincipal/categoria_bloc.dart';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/categoriaModel.dart';
import 'package:bufi/src/models/companyModel.dart';
import 'package:bufi/src/models/goodModel.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:bufi/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class GuardarProducto extends StatefulWidget {
  GuardarProducto({Key key}) : super(key: key);

  @override
  _GuardarProductoState createState() => _GuardarProductoState();
}

class _GuardarProductoState extends State<GuardarProducto> {
  final negApi = NegociosApi();
  CompanyModel companyData = CompanyModel();
  BienesModel goodData = BienesModel();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _marcaController = TextEditingController();
  TextEditingController _modeloController = TextEditingController();
  TextEditingController _sizeController = TextEditingController();
  TextEditingController _medidaController = TextEditingController();
  TextEditingController _monedaController = TextEditingController();
  TextEditingController _precioController = TextEditingController();
  TextEditingController _stockController = TextEditingController();
  File foto;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final String idSubsidiary = ModalRoute.of(context).settings.arguments;
    Responsive responsive = Responsive.of(context);
    final categoriasBloc = ProviderBloc.categoria(context);
    categoriasBloc.obtenerCategorias();
    final bienesBloc = ProviderBloc.bienesServicios(context);
    bienesBloc.obtenerBienesAll();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
          child: Column(
            children: [
              Text(
                "Registro de Producto",
                style: TextStyle(fontSize: responsive.ip(1.8)),
              ),
              Text(
                "Complete los campos",
                style: TextStyle(fontSize: responsive.ip(1.8)),
              ),
              Stack(
                children: [
                  _mostrarFoto(responsive),

                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                        //alignment: Alignment.centerRight,
                        icon: Icon(Icons.camera_alt_rounded, color: Colors.red),
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
              Text("Nombre de producto", style: textlabel),
              datoInput(
                context,
                responsive,
                _nameController,
                'Nombre de producto',
                Icon(
                  Icons.business,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              datoInput(
                context,
                responsive,
                _marcaController,
                'marca',
                Icon(
                  Icons.business,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              datoInput(
                context,
                responsive,
                _modeloController,
                'modelo',
                Icon(
                  Icons.store,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              datoInput(
                context,
                responsive,
                _sizeController,
                'tamaño',
                Icon(
                  Icons.format_size_outlined,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              datoInput(
                context,
                responsive,
                _medidaController,
                'medida',
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
                      _monedaController,
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
                _stockController,
                'stock',
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
                child: _bien(bienesBloc),
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
    return Container(
      //padding: EdgeInsets.only(bottom: responsive.hp(1.5)),
      padding: EdgeInsets.symmetric(vertical: responsive.hp(0.6), horizontal:responsive.hp(2) ),
      child: TextField(
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
              stream: bloc.bienesAllStream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<BienesModel>> snapshot) {
                if (snapshot.hasData) {
                  final bien = snapshot.data;
                  return DropdownButton(
                    value: goodData.idGood,
                    isExpanded: true,
                    items: bien.map((e) {
                      return DropdownMenuItem<String>(
                        value: e.idGood,
                        child: Text(
                          e.goodName,
                          style: TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      goodData.idGood = value;
                      print(goodData.idGood);
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
        child: Text("Registrar"),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        onPressed: () {
          if (_nameController.text.length > 0) {
            if (_marcaController.text.length > 0) {
              if (_modeloController.text.length > 0) {
                if (_sizeController.text.length > 0) {
                  if (_medidaController.text.length > 0) {
                    if (_monedaController.text.length > 0) {
                      if (_precioController.text.length > 0) {
                        if (_stockController.text.length > 0) {
                          if (foto != null) {
                            if (companyData.idCategory != null) {
                              if (goodData.idGood != null) {
                                uploadImage1(foto, idSubsidiary);
                                //_submit(context,idSubsidiary,foto);

                              } else {
                                utils.showToast(
                                    context, 'Debe seleccionar un bien ');
                              }
                            } else {
                              utils.showToast(
                                  context, 'Debe seleccionar una categoría ');
                            }
                          } else {
                            utils.showToast(
                                context, 'Debe seleccionaer una foto');
                          }
                          // _submit(context, idSubsidiary);
                        } else {
                          utils.showToast(context, 'Debe ingresar el stock');
                        }
                      } else {
                        utils.showToast(context, 'Debe ingresar el precio');
                      }
                    } else {
                      utils.showToast(
                          context, 'Debe ingresar el tipo de moneda');
                    }
                  } else {
                    utils.showToast(context, 'Debe ingresar la medida ');
                  }
                } else {
                  utils.showToast(
                      context, 'Debe ingresar el tamaño del producto');
                }
              } else {
                utils.showToast(context, 'Debe ingresar el numero de celular');
              }
            } else {
              utils.showToast(context, 'Debe ingresar la marca');
            }
          } else {
            utils.showToast(context, 'Debe ingresar el nombre del producto');
          }
        },
      ),
    );
  }

  /*  _submit(BuildContext context, String idSubsidiary, File imagen) async {
    String idGood = goodData.idGood;
    String categoria = companyData.idCategory;
    final int code = await negApi.guardarProducto(
        idSubsidiary,
        idGood,
        categoria,
        _nameController.text,
        _precioController.text,
        _monedaController.text,
        _medidaController.text,
        _marcaController.text,
        _modeloController.text,
        _sizeController.text,
        _stockController.text,
        imagen);

    if (code == 1) {
      print(code);
      utils.showToast(context, 'Producto Registrado');

      Navigator.pop(context);
    } else if (code == 2) {
      print(code);
      utils.showToast(context, 'Ocurrio un error');
    } else if (code == 6) {
      print(code);
      utils.showToast(context, 'Datos incorrectos');
    }
 */

  void uploadImage1(File _image, String idSubsidiary) async {
    final preferences = Preferences();

    // open a byteStream
    var stream = new http.ByteStream(Stream.castFrom(_image.openRead()));
    // get file length
    var length = await _image.length();

    // string to uri
    var uri = Uri.parse("$apiBaseURL/api/Negocio/guardar_producto");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // if you need more parameters to parse, add those like this. i added "user_id". here this "user_id" is a key of the API request
    request.fields["id_user"] = preferences.idUser;
    request.fields["id_sucursal"] = idSubsidiary;
    request.fields["id_good"] = goodData.idGood;
    request.fields["categoria"] = companyData.idCategory;
    request.fields["nombre"] = _nameController.text;
    request.fields["precio"] = _precioController.text;
    request.fields["currency"] = _monedaController.text;
    request.fields["measure"] = _medidaController.text;
    request.fields["marca"] = _marcaController.text;
    request.fields["modelo"] = _modeloController.text;
    request.fields["size"] = _sizeController.text;
    request.fields["stock"] = _stockController.text;

    // multipart that takes file.. here this "image_file" is a key of the API request
    var multipartFile = new http.MultipartFile('producto_img', stream, length,
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
