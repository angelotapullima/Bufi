import 'package:flutter/material.dart';

class TabProductosNegocioPage extends StatelessWidget {
  const TabProductosNegocioPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
         Center(child: Text("Info de la sucursal"));
        // GridView.builder(
        //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //       childAspectRatio: 0.7,
        //       crossAxisCount: 2,
        //     ),
        //     itemBuilder: (BuildContext context, int index) {
        //       return Container(child: Text("data2"));
        //     });
  }
}
