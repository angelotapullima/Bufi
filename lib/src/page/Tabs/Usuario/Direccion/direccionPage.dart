import 'package:bufi/src/utils/responsive.dart';
import 'package:flutter/material.dart';

class DireccionDeliveryPage extends StatelessWidget {
  const DireccionDeliveryPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            child: Text("No tiene registrada ninguna dirección"),
          ),
          Center(
            child: SizedBox(
              width: responsive.wp(80),
              child: RaisedButton(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                color: Colors.red,
                onPressed: () {
                  Navigator.pushNamed(context, 'agregarDireccion' );
                },
                child: Text("Añadir dirección",
                    style: TextStyle(
                        color: Colors.white, fontSize: responsive.ip(2.2))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
