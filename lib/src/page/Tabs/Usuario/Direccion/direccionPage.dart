import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/direccionModel.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bufi/src/widgets/extentions.dart';

class DireccionDeliveryPage extends StatelessWidget {
  const DireccionDeliveryPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    final direccionesBloc = ProviderBloc.direc(context);
    direccionesBloc.obtenerDirecciones();
    return Scaffold(
      body: StreamBuilder(
          stream: direccionesBloc.direccionesStream,
          builder: (context, AsyncSnapshot<List<DireccionModel>> snapshot) {

            if(snapshot.hasData){


              return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        BackButton(),
                        Container(
                          child: Text(
                            "Direcciónes de entrega",
                            style: TextStyle(
                                fontSize: responsive.ip(2),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: responsive.wp(30),
                          padding: EdgeInsets.symmetric(
                              vertical: responsive.hp(.5),
                              horizontal: responsive.wp(2)),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(35),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              Expanded(
                                child: Text(
                                  'Agregar una dirección',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ).ripple(
                          () {
                            Navigator.pushNamed(context, 'agregarDireccion');
                          },
                        ),
                        Container(
                          width: responsive.wp(30),
                          padding: EdgeInsets.symmetric(
                              vertical: responsive.hp(.5),
                              horizontal: responsive.wp(2)),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(35),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              Expanded(
                                child: Text(
                                  'Eliminar direcciones',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ).ripple(
                          () {},
                        ),
                      ],
                    ),
                    (snapshot.data.length > 0) ? Container() : Container()
                  ],
                ),
              ),
            );
          
          

            }else{
              return Center(child: CupertinoActivityIndicator(),);
            }
            }),
    );
  }
}
