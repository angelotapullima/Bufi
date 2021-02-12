import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/CompanySubsidiaryModel.dart';
import 'package:bufi/src/models/companyModel.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TabInfoNegocioPage extends StatelessWidget {
  const TabInfoNegocioPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CompanySubsidiaryModel company = ModalRoute.of(context).settings.arguments;
    final detallenegocio = ProviderBloc.negocios(context);
    detallenegocio.obtenernegociosporID(company.idCompany);
    final responsive = Responsive.of(context);
    return Scaffold(
      body: Scrollbar(
        child: StreamBuilder(
          stream: detallenegocio.detalleNegStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            List<CompanyModel> negocio = snapshot.data;
            if (snapshot.hasData) {
              return Padding(
                padding:  EdgeInsets.only(top:18.0),
                child: Column(
                  children: [
                    Text("Descripcion de la empresa"),
                    SizedBox(height: responsive.hp(2)),
                    _listSucursal(context, responsive, company.idCompany),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return snapshot.error;
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
        // _listSucursal(context, responsive, company.idCompany)
      ),
    );
  }

  Widget _listSucursal(BuildContext context, Responsive responsive, String id) {
    final sucursalNegocio = ProviderBloc.sucursal(context);
    sucursalNegocio.obtenerSucursalporIdCompany(id);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        
        children: [
          Text("Sucursales", style: TextStyle(fontSize: responsive.ip(3)),),
          Divider(color: Colors.grey),
          SizedBox(height: responsive.hp(1)),
          Container(
            padding: EdgeInsets.only(
              left: responsive.wp(2),
              right: responsive.wp(2),
              bottom: responsive.hp(2),
            ),
            height: responsive.hp(25),
            child: StreamBuilder(
                stream: sucursalNegocio.sucursalStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length > 0) {
                      List<SubsidiaryModel> sedes = snapshot.data;
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: sedes.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, 'detalleSubsidiary',
                                  arguments: sedes[index]);
                            },
                            child: Container(
                              width: responsive.wp(45),
                              child: Stack(children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    //cacheManager: CustomCacheManager(),
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
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    color: Colors.black.withOpacity(.4),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            sedes[index].subsidiaryName,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: responsive.ip(2.5),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        //Id subsidiary
                                        Text(
                                          sedes[index].idSubsidiary,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: responsive.ip(2.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: (sedes[index].subsidiaryFavourite == "0")
                                      ? IconButton(
                                          icon: Icon(FontAwesomeIcons.heart,
                                              color: Colors.red),
                                          onPressed: () {
                                            guardarSubsidiaryFavorito(
                                                context, sedes[index]);
                                          },
                                        )
                                      : IconButton(
                                          icon: Icon(FontAwesomeIcons.solidHeart,
                                              color: Colors.red),
                                          onPressed: () {
                                            quitarSubsidiaryFavorito(
                                                context, sedes[index]);
                                          },
                                        ),
                                )
                              ]),
                            ),
                          );

                          //https://i.pinimg.com/564x/23/8f/6b/238f6b5ea5ab93832c281b42d3a1a853.jpg
                        },
                      );
                    } else {
                      return Center(child: Text("Aun no se registran sucursales"));
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
