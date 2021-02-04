import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/subsidiaryService.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/widgets/widgetServicios.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class ListarServiciosAll extends StatefulWidget {
  @override
  _ListarServiciosAllState createState() => _ListarServiciosAllState();
}

class _ListarServiciosAllState extends State<ListarServiciosAll> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
   
    final serviciosBloc = ProviderBloc.bienesServicios(context);
    //llamar a la funcion del bloc para servicios
    serviciosBloc.obtenerServiciosAllPorCiudad();

    return Scaffold(
        body: SafeArea(
      child: Container(
        child: Column(
          children: [
            Container(
              height: responsive.hp(5),
              child: Stack(
                children: [
                  BackButton(),
                  Container(
                    padding: EdgeInsets.only(left: responsive.wp(10)),
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'Todos los Servicios',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: responsive.ip(2.5),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                SizedBox(width: responsive.wp(2),),
                Expanded(child: Container(
                padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
                height: responsive.hp(5),
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(25)),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    Text(
                      'Buscar Servicios',
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
              ),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(icon: Icon(Icons.category), onPressed: () {}),
                    IconButton(
                        icon: Icon(Icons.filter),
                        onPressed: () {
                          /* if (data) {
                                            switchFiltro.value = false;
                                          } else {
                                            switchFiltro.value = true;
                                          } */
                        }),
                  ],
                ),
              ],
            ),
            
              SizedBox(height: responsive.hp(.5)),
            Expanded(
              child: StreamBuilder(
                stream: serviciosBloc.serviciosStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<SubsidiaryServiceModel>> snapshot) {
                  if (snapshot.hasData) {
                    final servicios = snapshot.data;
                    return GridView.builder(
                        padding: EdgeInsets.only(top:18),
                        controller: ScrollController(keepScrollOffset: false),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7
                        ),
                        itemCount: servicios.length,
                        itemBuilder: (context, index) {
                          return serviceWidget(
                              context, snapshot.data[index], responsive);
                        });
                  } else {
                    return Center(child: CupertinoActivityIndicator()
                        
                        );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ));
       
  }
}