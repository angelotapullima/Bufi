
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/widgets/busquedas/busquedaNegocio.dart';
import 'package:flutter/material.dart';


class BusquedaNegocioWidget extends StatelessWidget {
  const BusquedaNegocioWidget({
    Key key,
    @required this.responsive,
  }) : super(key: key);

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          onTap: () {
            showSearch(context: context, delegate: BusquedaNegocioPage());
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
            height: responsive.hp(5),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(25)),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.search),
                  color: Colors.black,
                  onPressed: () {
                    showSearch(context: context, delegate: BusquedaNegocioPage());
                  },
                ),
                Text(
                  'Buscar Negocio',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        );
  }
}
