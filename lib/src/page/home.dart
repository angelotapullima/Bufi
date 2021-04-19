import 'package:bufi/src/bloc/principal_bloc.dart';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/carritoGeneralModel..dart';
import 'package:bufi/src/page/Tabs/Negocios/inicio/negociosPage.dart';
import 'package:bufi/src/page/Tabs/Points/pointsPage.dart';
import 'package:bufi/src/page/Tabs/Principal/PrincipalPage.dart';
import 'package:bufi/src/page/Tabs/Usuario/usuarioPage.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:flutter/material.dart';

import 'Tabs/Carrito/carritoTab.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> listPages = [];

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
    final Responsive responsive = new Responsive.of(context);
    final buttonBloc = ProviderBloc.tabs(context);
    final carritoBloc = ProviderBloc.productosCarrito(context);
    carritoBloc.obtenerCarritoPorSucursal();
    //buttonBloc.changePage(0);
    return Scaffold(
      body: StreamBuilder(
        stream: buttonBloc.selectPageStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(buttonBloc.page);
          return IndexedStack(
            index: buttonBloc.page,
            children: listPages,
          );
        },
      ),
      bottomNavigationBar: StreamBuilder(
        stream: carritoBloc.carritoGeneralStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<CarritoGeneralSuperior>> snapshot) {
          int cantidadCarrito = 0;
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              for (int i = 0; i < snapshot.data.length; i++) {
                for (int x = 0; x < snapshot.data[i].car.length; x++) {
                  print('Cantidad carrito $cantidadCarrito');
                  cantidadCarrito =
                      cantidadCarrito + snapshot.data[i].car[x].carrito.length;
                }

                // for (int x = 0; i < snapshot.data.length; x++) {
                //   cantidadCarrito = snapshot.data[i].car[x].carrito.length;
                // }
              }
              return bottonNaviga(responsive, cantidadCarrito, buttonBloc);
            } else {
              return bottonNaviga(responsive, cantidadCarrito, buttonBloc);
            }
          } else {
            return bottonNaviga(responsive, cantidadCarrito, buttonBloc);
          }
        },

        /*stream: buttonBloc.selectPageStream,
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
              final preferences = Preferences();
              var fecha = DateTime.now();
              var hora = fecha.hour;
              if (hora >= 18) {
                preferences.saludo = 'Buenas noches';
              } else if (hora >= 12) {
                preferences.saludo = 'Buenas tardes';
              } else {
                preferences.saludo = 'Buenos días';
              }
              buttonBloc.changePage(valor);
            },
          );
        },*/
      ),
    );
  }

  Widget bottonNaviga(
      Responsive responsive, int cantidad, TabNavigationBloc bottomBloc) {
    return StreamBuilder(
      stream: bottomBloc.selectPageStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return BottomNavigationBar(
          elevation: 0.0,
          selectedItemColor: Theme.of(context).textSelectionColor,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: responsive.ip(3),
              ),
              label: 'Principal',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.data_usage,
                size: responsive.ip(2.7),
              ),
              label: 'Points',
            ),
            BottomNavigationBarItem(
              icon: (cantidad != 0)
                  ? Stack(
                      children: <Widget>[
                        Icon(
                          Icons.shopping_cart,
                          size: responsive.ip(3),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            child: Text(
                              cantidad.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: responsive.ip(1)),
                            ),
                            alignment: Alignment.center,
                            width: responsive.ip(1.6),
                            height: responsive.ip(1.6),
                            decoration: BoxDecoration(
                                color: Colors.green, shape: BoxShape.circle),
                          ),
                          //child: Icon(Icons.brightness_1, size: 8,color: Colors.redAccent,  )
                        )
                      ],
                    )
                  : Icon(
                      Icons.shopping_cart,
                      size: responsive.ip(3),
                    ),
              label: 'Carrito',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.business,
                size: responsive.ip(3),
              ),
              label: 'Negocios',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.supervised_user_circle,
                size: responsive.ip(3),
              ),
              label: 'Usuario',
            )
          ],
          currentIndex: bottomBloc.page,
          onTap: (index) => {
            bottomBloc.changePage(index),
          },
        );
      },
    );
  }
}
