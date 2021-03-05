/* import 'dart:io';
import 'package:bufi/src/bloc/bienesServicios_bloc.dart';
import 'package:bufi/src/bloc/categoriaPrincipal/categoria_bloc.dart';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/api/productos/productos_api.dart';
import 'package:bufi/src/models/categoriaModel.dart';
import 'package:bufi/src/models/companyModel.dart';
import 'package:bufi/src/models/goodModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:bufi/src/utils/utils.dart' as utils;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class GuardarProducto extends StatefulWidget {
  GuardarProducto({Key key}) : super(key: key);

  @override
  _GuardarProductoState createState() => _GuardarProductoState();
}

class _GuardarProductoState extends State<GuardarProducto> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _marcaController = TextEditingController();
  TextEditingController _modeloController = TextEditingController();
  TextEditingController _sizeController = TextEditingController();
  TextEditingController _medidaController = TextEditingController();
  TextEditingController _monedaController = TextEditingController();
  TextEditingController _precioController = TextEditingController();
  TextEditingController _stockController = TextEditingController();
  final companyData = CompanyModel();
  final goodData = BienesModel();

  //Para validar el errortext del TexForm
  // bool validateCampo = false;

  //Key del form
  final _formKey = GlobalKey<FormState>();

  //Para acceder a la galeria o tomar una foto
  File foto;
  final picker = ImagePicker();
  bool _inProcess = false;

//widget para el cargando
  final _cargando = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final String idSubsidiary = ModalRoute.of(context).settings.arguments;
    Responsive responsive = Responsive.of(context);
    final categoriasBloc = ProviderBloc.categoria(context);
    categoriasBloc.obtenerCategorias();
    final bienesBloc = ProviderBloc.bienesServicios(context);
    bienesBloc.obtenerBienesAll();

    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: _cargando,
          builder: (BuildContext context, bool value, Widget child) {
            return SafeArea(
              child: Stack(children: [
                Container(
                  child: Column(
                    children: [
                      _titulo(responsive, isDark),
                      SizedBox(height: responsive.hp(3)),
                      _formRegistro(responsive, context, categoriasBloc,
                          bienesBloc, idSubsidiary),
                    ],
                  ),
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
              ]),
            );
          }),
    );
  }

  Widget _formRegistro(
      Responsive responsive,
      BuildContext context,
      CategoriaBloc categoriasBloc,
      BienesServiciosBloc bienesBloc,
      String idSubsidiary) {
    return Expanded(
      child: Form(
        key: _formKey,
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
                            icon: Icon(Icons.camera_alt_rounded,
                                color: Colors.red),
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
                                                getImage(ImageSource.gallery);
                                                //_seleccionarFoto();
                                              },
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                            ),
                                            GestureDetector(
                                              child: Text("Camara"),
                                              onTap: () {
                                                Navigator.pop(context);
                                                getImage(ImageSource.camera);

                                                //_tomarFoto();
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

                Text("Nombre de producto", style: textlabel),

                datoInput(context, responsive, _nameController,
                    TextInputType.text, 'Nombre de producto'),

                SizedBox(height: responsive.hp(1)),

                Text("Marca", style: textlabel),

                datoInput(context, responsive, _marcaController,
                    TextInputType.text, 'Marca'),

                SizedBox(height: responsive.hp(1)),

                Text("Modelo", style: textlabel),

                datoInput(context, responsive, _modeloController,
                    TextInputType.text, 'Modelo'),

                SizedBox(height: responsive.hp(1)),

                Text("Tamaño", style: textlabel),

                datoInput(context, responsive, _sizeController,
                    TextInputType.number, 'Tamaño'),

                SizedBox(height: responsive.hp(1)),

                Text("Medida", style: textlabel),

                datoInput(context, responsive, _medidaController,
                    TextInputType.number, 'Medida'),

                SizedBox(height: responsive.hp(1)),

                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Moneda", style: textlabel),
                        Container(
                          width: responsive.wp(40),
                          child: datoInput(context, responsive,
                              _monedaController, TextInputType.text, 'Moneda'),
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
                          child: datoInput(
                              context,
                              responsive,
                              _precioController,
                              TextInputType.number,
                              'Precio'),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: responsive.hp(1)),

                Text("Stock", style: textlabel),

                datoInput(context, responsive, _stockController,
                    TextInputType.number, 'Stock'),

                SizedBox(height: responsive.hp(1)),

                //Categoria

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

                //Bienes

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tipo de Bien", style: textlabel),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(5),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: _bien(bienesBloc),
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
      ),
    );
  }

  Widget _titulo(Responsive responsive, bool isDark) {
    return Row(
      children: [
        Padding(
          padding:
              EdgeInsets.only(left: responsive.wp(4), top: responsive.hp(5)),
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
          padding:
              EdgeInsets.only(left: responsive.wp(6), top: responsive.hp(6)),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: [
              Text(
                "Registrar Producto",
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

  // _procesarImagen(ImageSource origen) async {
  //   final picketfile = await picker.getImage(source: origen);
  //   foto = File(picketfile.path);

  //   if (foto != null) {}
  //   setState(() {});
  // }

  // _seleccionarFoto() async {
  //   _procesarImagen(ImageSource.gallery);
  // }

  // _tomarFoto() async {
  //   _procesarImagen(ImageSource.camera);
  // }

  //Recortar imagen
  getImage(ImageSource source) async {
    this.setState(() {
      _inProcess = true;
    });
    File image = await ImagePicker.pickImage(source: source);
    if (image != null) {
      File cropped = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatioPresets: Platform.isAndroid
              ? [
                  // CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  // CropAspectRatioPreset.original,
                  // CropAspectRatioPreset.ratio4x3,
                  // CropAspectRatioPreset.ratio16x9
                  
                ]
              : [
                  // CropAspectRatioPreset.original,
                  // CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  // CropAspectRatioPreset.ratio4x3,
                  // CropAspectRatioPreset.ratio5x3,
                  // CropAspectRatioPreset.ratio5x4,
                  // CropAspectRatioPreset.ratio7x5,
                  // CropAspectRatioPreset.ratio16x9
                ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Recortar',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true),
          iosUiSettings: IOSUiSettings(
            title: 'Imagen',
          ),
          
          // maxWidth: 20,
          // maxHeight: 30
          );

      this.setState(() {
        foto = cropped;
        _inProcess = false;
      });
    } else {
      this.setState(() {
        _inProcess = false;
      });
    }
  }

  Widget datoInput(BuildContext context, Responsive responsive,
      TextEditingController controlador, TextInputType algo, String nombre) {
    return TextFormField(
      controller: controlador,
      keyboardType: algo,
      // TextInputType.text,
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
      validator: (value) {
        if (value.isEmpty) {
          return 'Por favor llene este campo';
          // utils.showToast(context, 'Debe ingresar el campo $nombre');
        }
        return null;
      },
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

  Widget _bien(BienesServiciosBloc bloc) {
    return Row(
      children: <Widget>[
        //Text('Bien'),
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
                  return DropdownButtonHideUnderline(
                    child: DropdownButton(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                        size: 32,
                      ),
                      hint: Text("Seleccione un tipo de bien"),
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
          //Validar el estado de los controladores
          if (_formKey.currentState.validate()) {
            if (foto != null) {
              if (goodData.idGood != null) {
                if (companyData.idCategory != null) {

                  final productosApi = ProductosApi();
                  final companyModel = CompanyModel();
                  final bienModel = BienesModel();
                  final producModel = ProductoModel();

                  //llenar el modelo con el valor de los controllers
                  companyModel.idCategory = companyData.idCategory;
                  bienModel.idGood = goodData.idGood;
                  producModel.idSubsidiary = idSubsidiary;
                  producModel.productoName = _nameController.text;
                  producModel.productoPrice = _precioController.text;
                  producModel.productoCurrency = _monedaController.text;
                  producModel.productoMeasure = _medidaController.text;
                  producModel.productoBrand = _marcaController.text;
                  producModel.productoModel = _modeloController.text;
                  producModel.productoSize = _sizeController.text;
                  producModel.productoStock = _stockController.text;

                  _cargando.value = true;

                  final int code = await productosApi.guardarProducto(
                      foto, companyData, goodData, producModel);
                  
                  //Respuesta que da el servicio
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
                  } else {
                    print(code);
                  }

                  _cargando.value = false;
                  //
                } else {
                  utils.showToast(context, 'Debe seleccionar una categoría ');
                }
              } else {
                utils.showToast(context, 'Debe seleccionar un Tipo de Bien ');
              }
            } else {
              utils.showToast(context, 'Debe seleccionar una foto');
            }
          } else {
            utils.showToast(context, 'Debe ingresar el campo que falta');
          }
        },
      ),
    );
  }
}
 */