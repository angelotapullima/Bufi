import 'package:bufi/src/utils/responsive.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';

class AgregarDireccionPage extends StatefulWidget {
  AgregarDireccionPage({Key key}) : super(key: key);

  @override
  _AgregarDireccionPageState createState() => _AgregarDireccionPageState();
}

class _AgregarDireccionPageState extends State<AgregarDireccionPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _direccionController = TextEditingController();
  TextEditingController _referenciaController = TextEditingController();
  
  String _myActivity = '';

  String _myActivityResult = '';

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(
            horizontal: responsive.wp(2), vertical: responsive.hp(5)),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TextField(
                //     controller: _nameController,
                //     keyboardType: TextInputType.text,
                //     decoration: InputDecoration(
                //       hintText: 'Nombre completo',
                //     )),
                TextField(
                    controller: _direccionController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Dirección',
                    )),
                    SizedBox(height: responsive.hp(2)),
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
                    )),
                DropDownFormField(
                  titleText: "Distrito",
                  hintText: 'Seleccione una opción',
                  value: _myActivity,
                  dataSource: [
                    {
                      "display": "San Juan",
                      "value": "San Juan",
                    },
                    {
                      "display": "Belén",
                      "value": "Belén",
                    },
                    {
                      "display": "Punchana",
                      "value": "Punchana",
                    }
                  ],
                  textField: 'display',
                  valueField: 'value',
                  onSaved: (value) {
                    setState(() {
                      _myActivity = value;
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      _myActivity = value;
                    });
                  },
                ),
                SizedBox(height: responsive.hp(5)),
                Center(
                  child: SizedBox(
                    width: responsive.wp(80),
                    child: RaisedButton(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      color: Colors.red,
                      onPressed: () {
                        
                      },
                      child: Text("Añadir",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: responsive.ip(2.2))),
                    ),
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
