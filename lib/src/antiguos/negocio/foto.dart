/* import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Fotos extends StatefulWidget {
  Fotos({Key key}) : super(key: key);

  @override
  _FotosState createState() => _FotosState();
}

class _FotosState extends State<Fotos> {
  File foto;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("producto"),
        actions: [
          IconButton(
              icon: Icon(Icons.photo_size_select_actual_outlined),
              onPressed: () {
                _seleccionarFoto();
              }),
          IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () {
                _tomarFoto();
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            _mostrarFoto(),
            TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                fillColor: Theme.of(context).dividerColor,
                hintText: "nombre de producto",
              ),
            ),
            TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                fillColor: Theme.of(context).dividerColor,
                hintText: "Precio",
              ),
            ),

            RaisedButton(
            child: Text("Guardar"),
            //color: Theme.of(context).primaryColor,
            onPressed: (){
              
            },
            )
          ],
        ),
      ),
    );
  }

  Widget _mostrarFoto() {
    if (foto != null) {
      return Image(
        image: AssetImage(foto?.path ?? 'assets/no-image.png'),
        height: 300,
        fit: BoxFit.cover,
      );
    } else {
      return Image(
        image: AssetImage(foto?.path ?? 'assets/no-image.png'),
        height: 300,
        fit: BoxFit.cover,
      );
    }
  }

  _procesarImagen(ImageSource origen) async {
    foto = await ImagePicker.pickImage(source: origen);

    if (foto != null) {}
    setState(() {});
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
    
  }
  _tomarFoto() async {
      _procesarImagen(ImageSource.camera);
    }
}
 */