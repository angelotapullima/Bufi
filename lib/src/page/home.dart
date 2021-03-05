import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/page/Tabs/Negocios/inicio/negociosPage.dart';
import 'package:bufi/src/page/Tabs/Points/pointsPage.dart';
import 'package:bufi/src/page/Tabs/Principal/PrincipalPage.dart';
import 'package:bufi/src/page/Tabs/Usuario/usuarioPage.dart';
import 'package:flutter/material.dart';

import 'Tabs/Carrito/carritoTab.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> listPages = List<Widget>();

  @override
  void initState() {
    listPages.add(PrincipalPage());
    listPages.add(PointsPage());
    listPages.add(CarritoPage());
    listPages.add(NegociosPage());
    listPages.add(UserPage());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final buttonBloc = ProviderBloc.tabs(context);
    buttonBloc.changePage(0);
    return Scaffold(
      
      body: StreamBuilder(
        stream: buttonBloc.selectPageStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return IndexedStack(
            index: buttonBloc.page,
            children: listPages,
          );
        },
      ),
      bottomNavigationBar: StreamBuilder(
          stream: buttonBloc.selectPageStream,
          builder: (context, snapshot) {
            return BottomNavigationBar(
              selectedItemColor: Theme.of(context).textSelectionColor,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                  ),
                  label: "Principal",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.data_usage),
                  label: "Points",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  label: "Carrito",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.business),
                  label: "Negocios",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.supervised_user_circle),
                  label: "Usuario",
                ),
              ],
              currentIndex: buttonBloc.page,
              onTap: (valor) {
                buttonBloc.changePage(valor);
              },
            );
          }),
    );
  }
}
