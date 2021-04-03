import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/page/busqueda/buquedaGeneralHechoPorAngeloMasNaiki.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:flutter/material.dart';

class BusquedaGeneralWidget extends StatelessWidget {
  const BusquedaGeneralWidget({
    Key key,
    @required this.responsive,
  }) : super(key: key);

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 700),
            pageBuilder: (context, animation, secondaryAnimation) {
              final selectorTabBusqueda = ProviderBloc.busquedaAngelo(context);
              selectorTabBusqueda.changePage(0);
              return BusquedaDeLaPtmr();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );

        //showSearch(context: context, delegate: BusquedaGeneral());
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
        height: responsive.hp(5),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(25)),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.search),
              color: Colors.black,
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 700),
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return BusquedaDeLaPtmr();
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                );
                //showSearch(context: context, delegate: BusquedaGeneral());
              },
            ),
            Text(
              'Buscar',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
