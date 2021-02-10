import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/widgets/detalleBienesServicios.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetalleSubsidiary extends StatefulWidget {
  const DetalleSubsidiary({Key key}) : super(key: key);

  @override
  _DetalleSubsidiaryState createState() => _DetalleSubsidiaryState();
}

class _DetalleSubsidiaryState extends State<DetalleSubsidiary> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final SubsidiaryModel subsidiary =
        ModalRoute.of(context).settings.arguments;
    //final subsidiary = ModalRoute.of(context).settings.arguments;

    final subsidiaryBloc = ProviderBloc.listarsucursalPorId(context);
    subsidiaryBloc.obtenerSucursalporId(subsidiary.idSubsidiary);
    return Scaffold(
      body: StreamBuilder(
          stream: subsidiaryBloc.subsidiaryStream,
          builder: (context, snapshot) {
            return CustomScrollView(
              slivers: [
                _crearAppbar(responsive, subsidiary),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      _infoSucursal(responsive, subsidiary),
                      SizedBox(height: 30),
                      detailsBienesServicios(context, subsidiary, responsive),
                    ],
                  ),
                )
              ],
            );
          }),
      floatingActionButton: _buttonFloating(context, subsidiary, responsive),
    );
  }

  Widget _crearAppbar(Responsive responsive, SubsidiaryModel subsidiary) {
    return SliverAppBar(
      elevation: 5.0,
      backgroundColor: Colors.green,
      expandedHeight: responsive.hp(30),
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          '${subsidiary.subsidiaryName}',
          style: TextStyle(
            color: Colors.white,
            fontSize: responsive.ip(2.3),
          ),
        ),
        background: Stack(
          children: [
            Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.white),
            ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25)),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    //si pecacheManager: CustomCacheManager(),
                    placeholder: (context, url) => Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image(
                          image: AssetImage('assets/jar-loading.gif'),
                          fit: BoxFit.cover),
                    ),
                    errorWidget: (context, url, error) => Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Center(child: Icon(Icons.error))),
                    //imageUrl: '$apiBaseURL/${companyModel.companyImage}',
                    imageUrl:
                        'https://i.pinimg.com/564x/23/8f/6b/238f6b5ea5ab93832c281b42d3a1a853.jpg',
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.black.withOpacity(.1)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonFloating(BuildContext context, SubsidiaryModel subsidiary,Responsive responsive) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text("Guardar", textAlign: TextAlign.center),
                actions: [
                  Container(
                    
                    child: FlatButton(
                      color: Colors.red,
                      textColor: Colors.white,
                      child: Text(
                        "Productos",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, 'guardarProducto',
                            arguments: subsidiary.idSubsidiary);
                      },
                    ),
                  ),
                  FlatButton(
                    color: Colors.green,
                    textColor: Colors.white,
                    child: Text('Servicios',style: TextStyle(color: Colors.white, fontSize: 18)),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'guardarServicio',
                          arguments: subsidiary.idSubsidiary);
                    },
                  ),
                ],
                actionsPadding: EdgeInsets.symmetric(horizontal: responsive.wp(10)),);
          },
        );

        // Navigator.pushNamed(context, 'guardarProducto',
        //     arguments: subsidiary.idSubsidiary);
      },
      child: Icon(Icons.add),
    );
  }

  Widget _infoSucursal(Responsive responsive, SubsidiaryModel subsidiary) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Column(
        children: [
          Text(
            "Informacion",
            style: TextStyle(
                color: Colors.black,
                fontSize: responsive.ip(2.7),
                fontWeight: FontWeight.bold),
          ),
          Divider(color: Colors.grey),
          ListTile(
            leading: Text("Direccion:"),
            title: Text(subsidiary.subsidiaryAddress),
          ),
          ListTile(
            leading: Text("Horario de Atencion"),
            title: Text('${subsidiary.subsidiaryOpeningHours}'),
            //leading: Icon(FontAwesomeIcons.doorOpen, color: Colors.black),
          ),
          ListTile(
            leading: Text("Celular de contacto:"),
            //Icon(FontAwesomeIcons.phone, color: Colors.black),
            title: Text('${subsidiary.subsidiaryCellphone}'),
          ),
          ListTile(
            leading: Text("Otro:"),
            //Icon(FontAwesomeIcons.phone, color: Colors.black),
            title: Text('${subsidiary.subsidiaryCellphone2}'),
          ),
          ListTile(
            leading: Text("Correo:"),
            //Icon(FontAwesomeIcons.phone, color: Colors.black),
            title: Text('${subsidiary.subsidiaryEmail}'),
          ),
          ListTile(
            leading: Text("Local Principal:"),
            title: Text('${subsidiary.subsidiaryPrincipal}'),
          ),
          ListTile(
            leading: Text("Coordenada X:"),
            title: Text('${subsidiary.subsidiaryCoordX}'),
          ),
          ListTile(
            leading: Text("Coordenada Y:"),
            title: Text('${subsidiary.subsidiaryCoordY}'),
          ),
        ],
      ),
    );
  }
}
