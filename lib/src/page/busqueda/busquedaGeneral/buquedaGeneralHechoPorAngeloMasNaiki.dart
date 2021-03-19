import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/busquedaModel.dart';
import 'package:bufi/src/models/companyModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/models/subsidiaryService.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/detalleProducto.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusquedaDeLaPtmr extends StatefulWidget {
  const BusquedaDeLaPtmr({Key key}) : super(key: key);

  @override
  _BusquedaDeLaPtmrState createState() => _BusquedaDeLaPtmrState();
}

class _BusquedaDeLaPtmrState extends State<BusquedaDeLaPtmr> {
  TextEditingController _controllerBusquedaAngelo = TextEditingController();

  final listOpciones = [
    ItemsBusqueda(titulo: 'Productos', index: 1),
    ItemsBusqueda(titulo: 'Servicios', index: 2),
    ItemsBusqueda(titulo: 'Negocios', index: 3),
    ItemsBusqueda(titulo: 'Sucursales', index: 4),
    ItemsBusqueda(titulo: 'Categorías', index: 5),
    ItemsBusqueda(titulo: 'Itemsubcategorías', index: 6),
  ];

  @override
  void dispose() {
    _controllerBusquedaAngelo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final busquedaGeneralBloc = ProviderBloc.busquedaGeneral(context);
    final selectorTabBusqueda = ProviderBloc.busquedaAngelo(context);
    //selectorTabBusqueda.changePage(0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
          stream: selectorTabBusqueda.selectPageStream,
          builder: (context, _) {
            return SafeArea(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BackButton(),
                       
                        Expanded(
                          child: TextField(
                              controller: _controllerBusquedaAngelo,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'Buscame papi',
                                hintStyle: TextStyle(
                                  fontSize: responsive.ip(1.6),
                                ),
                                /* border: OutlineInputBorder(
                              //borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                                
                              ),
                            ), */
                                filled: true,
                                contentPadding: EdgeInsets.all(16),
                              ),
                              onChanged: (value) {
                                print('$value');

                                busquedaGeneralBloc
                                    .obtenerResultadosBusquedaPorQuery(
                                        '$value');
                              }),
                        ),
                        IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              _controllerBusquedaAngelo.text = '';
                            }),
                        SizedBox(
                          width: responsive.wp(3),
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder(
                    stream: busquedaGeneralBloc.busquedaGeneralStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<BusquedaGeneralModel>> snapshot) {


                      if (snapshot.hasData) {
                        final resultBusqueda = snapshot.data;

                        if (snapshot.data.length > 0) {


                          final listOpcionesValidadasYa = List<ItemsBusqueda>();


                          if(snapshot.data[0].listProducto.length>0){

                            ItemsBusqueda itemsBusqueda = ItemsBusqueda();
                            itemsBusqueda.titulo='Productos';
                            itemsBusqueda.index=1;
                            itemsBusqueda.cantidad=snapshot.data[0].listProducto.length.toString();

                            listOpcionesValidadasYa.add(itemsBusqueda);

                          }
                           if(snapshot.data[0].listProducto.length>0){

                            ItemsBusqueda itemsBusqueda = ItemsBusqueda();
                            itemsBusqueda.titulo='Servicios';
                            itemsBusqueda.index=2;
                            itemsBusqueda.cantidad=snapshot.data[0].listServicios.length.toString();

                            listOpcionesValidadasYa.add(itemsBusqueda);

                          }
                           if(snapshot.data[0].listProducto.length>0){

                            ItemsBusqueda itemsBusqueda = ItemsBusqueda();
                            itemsBusqueda.titulo='Negocios';
                            itemsBusqueda.index=3;
                            itemsBusqueda.cantidad=snapshot.data[0].listCompany.length.toString();

                            listOpcionesValidadasYa.add(itemsBusqueda);

                          }
                           if(snapshot.data[0].listProducto.length>0){

                            ItemsBusqueda itemsBusqueda = ItemsBusqueda();
                            itemsBusqueda.titulo='Sucursales';
                            itemsBusqueda.index=4;
                            itemsBusqueda.cantidad=snapshot.data[0].listSucursal.length.toString();

                            listOpcionesValidadasYa.add(itemsBusqueda);

                          }


                          return Expanded(
                            child: Column(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    height: responsive.hp(5),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: listOpcionesValidadasYa.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            selectorTabBusqueda
                                                .changePage(index);
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: responsive.hp(.8),
                                              ),
                                              Stack(
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal:
                                                          responsive.wp(4),
                                                    ),
                                                    child: Container(
                                                      height:
                                                          responsive.hp(2.5),
                                                      child: Center(
                                                        child: Text(
                                                          ('${listOpcionesValidadasYa[index].titulo} '),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .blue[900],
                                                              fontSize:
                                                                  responsive
                                                                      .ip(1.4),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    right: responsive.wp(1),
                                                    child: CircleAvatar(
                                                      child: Text(
                                                        '${listOpcionesValidadasYa[index].cantidad}',
                                                        style: TextStyle(
                                                          fontSize:
                                                              responsive.ip(1),
                                                        ),
                                                      ),
                                                      radius: responsive.ip(.8),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: responsive.hp(.5),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CircleAvatar(
                                                    radius: responsive.ip(.4),
                                                    backgroundColor:
                                                        (selectorTabBusqueda
                                                                    .page ==
                                                                index)
                                                            ? Colors.blue[900]
                                                            : Colors.white,
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    )),
                                Divider(),
                                Expanded(
                                    child: (selectorTabBusqueda.page == 0)
                                        ? ListaProductos(
                                            productos:
                                                resultBusqueda[0].listProducto,
                                          )
                                        : (selectorTabBusqueda.page == 1)
                                            ? ListaServicios(
                                                servicios: resultBusqueda[0]
                                                    .listServicios)
                                            : (selectorTabBusqueda.page == 2)
                                                ? ListaNegocios(
                                                    companys: resultBusqueda[0]
                                                        .listCompany)
                                                : (selectorTabBusqueda.page ==
                                                        3)
                                                    ? ListaSucursales(
                                                        sucursales:
                                                            resultBusqueda[0]
                                                                .listSucursal)
                                                    : (selectorTabBusqueda
                                                                .page ==
                                                            4)
                                                        ? ListaServicios(
                                                            servicios:
                                                                resultBusqueda[
                                                                        0]
                                                                    .listServicios)
                                                        : Container),
                              ],
                            ),
                          );
                        } else {
                          return Column(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  height: responsive.hp(5),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: listOpciones.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          selectorTabBusqueda.changePage(index);
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: responsive.hp(.8),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: responsive.wp(2.5),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  ('${listOpciones[index].titulo} '),
                                                  style: TextStyle(
                                                      color: Colors.blue[900],
                                                      fontSize:
                                                          responsive.ip(1.4),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: responsive.hp(.5),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  radius: responsive.ip(.4),
                                                  backgroundColor:
                                                      (selectorTabBusqueda
                                                                  .page ==
                                                              index)
                                                          ? Colors.blue[900]
                                                          : Colors.white,
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  )),
                              Divider(),
                              Center(
                                child:
                                    Text("No hay resultados para la búsqueda"),
                              ),
                            ],
                          );
                        }
                      } else {
                        return Column(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                height: responsive.hp(5),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: listOpciones.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        selectorTabBusqueda.changePage(index);
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: responsive.hp(.8),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: responsive.wp(2.5),
                                            ),
                                            child: Center(
                                              child: Text(
                                                ('${listOpciones[index].titulo} '),
                                                style: TextStyle(
                                                    color: Colors.blue[900],
                                                    fontSize:
                                                        responsive.ip(1.4),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: responsive.hp(.5),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: responsive.ip(.4),
                                                backgroundColor:
                                                    (selectorTabBusqueda.page ==
                                                            index)
                                                        ? Colors.blue[900]
                                                        : Colors.white,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                )),
                            Divider(),
                            Center(child: CupertinoActivityIndicator()),
                          ],
                        );
                      }
                    },
                  )
                ],
              ),
            );
          }),
    );
  }
}

class ListaProductos extends StatelessWidget {
  final List<ProductoModel> productos;
  const ListaProductos({Key key, @required this.productos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return ListView.builder(
        shrinkWrap: true,
        itemCount: productos.length,
        itemBuilder: (BuildContext context, int i) {
          return ListTile(
            leading: FadeInImage(
              placeholder: AssetImage('assets/no-image.png'),
              image: NetworkImage(
                '$apiBaseURL/${productos[i].productoImage}',
              ),
              width: responsive.wp(5),
              fit: BoxFit.contain,
            ),
            title: Text('${productos[i].productoName}'),
            subtitle: Text('${productos[i].productoCurrency}'),
            onTap: () {
              //close(context, null);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalleProductos(
                    producto: productos[i],
                  ),
                ),
              );
            },
          );
        });
  }
}

class ListaServicios extends StatelessWidget {
  final List<SubsidiaryServiceModel> servicios;
  const ListaServicios({Key key, @required this.servicios}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return ListView.builder(
        shrinkWrap: true,
        itemCount: servicios.length,
        itemBuilder: (BuildContext context, int i) {
          return ListTile(
            leading: FadeInImage(
              placeholder: AssetImage('assets/no-image.png'),
              image: NetworkImage(
                '$apiBaseURL/${servicios[i].subsidiaryServiceImage}',
              ),
              width: responsive.wp(5),
              fit: BoxFit.contain,
            ),
            title: Text('${servicios[i].subsidiaryServiceName}'),
            subtitle: Text(
                '${servicios[i].subsidiaryServiceCurrency} ${servicios[i].subsidiaryServicePrice}'),
            onTap: () {
              //close(context, null);

              /* Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalleProductos(
                    producto: servicios[i],
                  ),
                ),
              ); */
            },
          );
        });
  }
}

class ListaSucursales extends StatelessWidget {
  final List<SubsidiaryModel> sucursales;
  const ListaSucursales({Key key, @required this.sucursales}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: sucursales.length,
        itemBuilder: (BuildContext context, int i) {
          return ListTile(
            /* leading: FadeInImage(
              placeholder: AssetImage('assets/no-image.png'),
              image: NetworkImage(
                '$apiBaseURL/${sucursales[i].subsidiaryName}',
              ),
              width: responsive.wp(5),
              fit: BoxFit.contain,
            ), */
            title: Text('${sucursales[i].subsidiaryName}'),
            subtitle: Text('${sucursales[i].subsidiaryAddress} '),
            onTap: () {
              //close(context, null);

              /* Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalleProductos(
                    producto: servicios[i],
                  ),
                ),
              ); */
            },
          );
        });
  }
}

class ListaNegocios extends StatelessWidget {
  final List<CompanyModel> companys;
  const ListaNegocios({Key key, @required this.companys}) : super(key: key);

  @override
  Widget build(BuildContext context) { 
    return ListView.builder(
        shrinkWrap: true,
        itemCount: companys.length,
        itemBuilder: (BuildContext context, int i) {
          return ListTile(
            /* leading: FadeInImage(
              placeholder: AssetImage('assets/no-image.png'),
              image: NetworkImage(
                '$apiBaseURL/${companys[i].companyName}',
              ),
              width: responsive.wp(5),
              fit: BoxFit.contain,
            ), */
            title: Text('${companys[i].companyName}'),
            subtitle: Text('${companys[i].cityName} '),
            onTap: () {
              //close(context, null);

              /* Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalleProductos(
                    producto: servicios[i],
                  ),
                ),
              ); */
            },
          );
        });
  }
}

class ItemsBusqueda {
  ItemsBusqueda({this.titulo, this.index,this.cantidad});

  String titulo;
  int index;
  String cantidad;
}
