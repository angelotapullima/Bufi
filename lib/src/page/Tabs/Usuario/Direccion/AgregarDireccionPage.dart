import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:flutter/material.dart';

class AgregarDireccionPage extends StatefulWidget {
  AgregarDireccionPage({Key key}) : super(key: key);

  @override
  _AgregarDireccionPageState createState() => _AgregarDireccionPageState();
}

class _AgregarDireccionPageState extends State<AgregarDireccionPage> {
  TextEditingController _direccionController = TextEditingController();
  TextEditingController _referenciaController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  List<Provincia> provinciaList = [];
  String idQuenecesitas;
  @override
  Widget build(BuildContext context) {
    provinciaList = [Provincia('1', "Iquitos"), Provincia('2', "Belen"), Provincia('3', "Punchana"), Provincia('4', "San Juan ")];

    final responsive = Responsive.of(context);
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: responsive.wp(2),
          vertical: responsive.hp(5),
        ),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    BackButton(),
                    Text(
                      'Agrega una dirección',
                      style: TextStyle(fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: responsive.hp(3),
                ),
                Text(
                  'Dirección',
                  style: TextStyle(fontSize: responsive.ip(1.7), fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: _direccionController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: responsive.wp(2),
                    ),
                    fillColor: Theme.of(context).dividerColor,
                    hintText: 'Dirección',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[300]),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: responsive.hp(2),
                ),
                Text(
                  'Referencia',
                  style: TextStyle(fontSize: responsive.ip(1.7), fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: _referenciaController,
                  keyboardType: TextInputType.text,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Referencia',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[300]),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: responsive.hp(2),
                ),
                Text(
                  'Distrito',
                  style: TextStyle(fontSize: responsive.ip(1.7), fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: responsive.hp(1),
                    horizontal: responsive.wp(3),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: new DropdownButton<String>(
                      hint: new Text("Seleccionar Provincia"),
                      value: idQuenecesitas,
                      isDense: true,
                      isExpanded: true,
                      onChanged: (String newValue) {
                        setState(() {
                          idQuenecesitas = newValue;
                        });
                      },
                      items: provinciaList.map((Provincia map) {
                        return new DropdownMenuItem<String>(
                          value: map.ciudad,
                          child: new Text(
                            map.ciudad,
                            style: new TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(
                  height: responsive.hp(5),
                ),
                Center(
                  child: SizedBox(
                      width: responsive.wp(80),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_direccionController.text.length > 0) {
                            if (_referenciaController.text.length > 0) {
                              if (idQuenecesitas != null) {
                                agregarDireccion(context, _direccionController.text, _referenciaController.text, idQuenecesitas);
                              } else {
                                showToast(context, 'Por favor agregue un distrito');
                              }
                            } else {
                              showToast(context, 'Por favor agregue una referencia');
                            }
                          } else {
                            showToast(context, 'Por favor agregue una dirección');
                          }
                        },
                        child: Text(
                          "Añadir",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: responsive.ip(2.2),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            primary: Colors.red,
                            onPrimary: Colors.white),
                      )
                      // RaisedButton(
                      //   elevation: 3,
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(30.0),
                      //   ),
                      //   color: Colors.red,
                      //   onPressed: () {
                      //     if (_direccionController.text.length > 0) {
                      //       if (_referenciaController.text.length > 0) {
                      //         if (idQuenecesitas != null) {
                      //           agregarDireccion(
                      //               context,
                      //               _direccionController.text,
                      //               _referenciaController.text,
                      //               idQuenecesitas);
                      //         } else {
                      //           showToast(
                      //               context, 'Por favor agregue un distrito');
                      //         }
                      //       } else {
                      //         showToast(
                      //             context, 'Por favor agregue una referencia');
                      //       }
                      //     } else {
                      //       showToast(context, 'Por favor agregue una dirección');
                      //     }
                      //   },
                      //   child: Text(
                      //     "Añadir",
                      //     style: TextStyle(
                      //       color: Colors.white,
                      //       fontSize: responsive.ip(2.2),
                      //     ),
                      //   ),
                      // ),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Provincia {
  String id;
  String ciudad;
  @override
  String toString() {
    return '$id $ciudad';
  }

  Provincia(this.id, this.ciudad);
}
