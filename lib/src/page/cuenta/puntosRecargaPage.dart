import 'package:flutter/material.dart';

class PuntosRecargaPage extends StatelessWidget {
  const PuntosRecargaPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar( 
        title:Text("Puntos de Recarga") 
      ), 
      body: ListView.builder( 
        itemCount: 5, 
        itemBuilder: (BuildContext context,int index){ 
          return ListTile( 
            leading: Icon(Icons.list), 
            trailing: Text("GFG", 
                           style: TextStyle( 
                             color: Colors.green,fontSize: 15),), 
            title:Text("Lista $index") 
            ); 
        } 
        ), 
    );
  }
}