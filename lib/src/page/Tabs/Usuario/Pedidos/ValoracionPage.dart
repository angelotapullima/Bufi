import 'package:flutter/material.dart';

class PendientesValoracionPage extends StatelessWidget {
  const PendientesValoracionPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Center(
            child: Container(
       child: Text("Pedidos pendientes de valoración"),
      ),
          ),
    );
  }
}