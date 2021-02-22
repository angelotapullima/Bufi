import 'dart:io';
import 'dart:ui';

import 'package:bufi/src/api/Cuenta/cuenta_api.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class SubirVaucher extends StatefulWidget {
  const SubirVaucher({Key key}) : super(key: key);

  @override
  _SubirVaucherState createState() => _SubirVaucherState();
}

class _SubirVaucherState extends State<SubirVaucher> {
  final _cargando = ValueNotifier<bool>(false);
  File foto;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: _cargando,
          builder: (BuildContext context, bool dataToque, Widget child) {
            return Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Color(0xff303c59),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: responsive.hp(7),
                      bottom: responsive.hp(10),
                      left: responsive.wp(5),
                      right: responsive.wp(5)),
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: responsive.hp(.6),
                          left: responsive.wp(3),
                        ),
                        width: responsive.ip(3),
                        height: responsive.ip(3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Icon(
                          Icons.close,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: responsive.hp(4),
                          bottom: responsive.hp(3),
                          left: responsive.wp(5),
                          right: responsive.wp(5),
                        ),
                        width: double.infinity,
                        height: responsive.hp(55),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: (foto == null)
                            ? GestureDetector(
                                onTap: () {
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
                                                    getImage(
                                                        ImageSource.gallery);
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
                                                    getImage(
                                                        ImageSource.camera);

                                                    //_tomarFoto();
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.photo,
                                      size: responsive.ip(10),
                                    ),
                                    Text('presione para agregar foto')
                                  ],
                                ),
                              )
                            : Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image(
                                        image: AssetImage(foto.path),
                                        height: responsive.hp(38),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: responsive.wp(3),
                                    top: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          foto = null;
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          top: responsive.hp(.6),
                                          left: responsive.wp(3),
                                        ),
                                        width: responsive.ip(3),
                                        height: responsive.ip(3),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(999),
                                          border:
                                              Border.all(color: Colors.grey),
                                        ),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(4),
                        ),
                        child: Text(
                            ' El vaucher sirve para la validación del pago realizado por la solicitud de recarga'),
                      ),
                      SizedBox(
                        height: responsive.hp(2),
                      ),
                      Row(
                        children: [
                          Spacer(),
                          GestureDetector(
                            onTap: () async {
                              if (foto == null) {
                                print('Por favor seleccione una imágen');
                              } else {
                                 _cargando.value = true;
                                final cuentaApi = CuentaApi();

                                final res = await cuentaApi.subirVoucher(foto);

                                if (res == 1) {
                                  print('subida correcta');
                                } else {
                                  print('Fallo la operación');
                                }
                                 _cargando.value = false;
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Subir vaucher',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: responsive.wp(5),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                (dataToque)
                    ? Center(
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
                                image: AssetImage('assets/loading.gif'),
                                fit: BoxFit.contain),
                          ),
                        ),
                      )
                    : Container()
              ],
            );
          }),
    );
  }

  getImage(ImageSource source) async {
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
      });
    } else {}
  }
}
