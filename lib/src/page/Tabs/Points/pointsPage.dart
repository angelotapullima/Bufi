import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PointsPage extends StatefulWidget {
  @override
  _PointsPageState createState() => _PointsPageState();
}

class _PointsPageState extends State<PointsPage> {
  @override
  Widget build(BuildContext context) {
    final pointsBloc = ProviderBloc.points(context);
    pointsBloc.obtenerPoints();

    final responsive = Responsive.of(context);
    return Scaffold(
      body: StreamBuilder(
        stream: pointsBloc.pointsStrema,
        builder: (BuildContext context,
            AsyncSnapshot<List<SubsidiaryModel>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: responsive.wp(45),
                      height: responsive.hp(15),
                      child: Stack(children: [
                        Hero(
                          tag:
                              '${snapshot.data[index].idSubsidiary}-subisdiary',
                          child: ClipRRect(
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
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: Colors.black.withOpacity(.4),
                            child: Text(
                              snapshot.data[index].subsidiaryName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: responsive.ip(2.5),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            top: 5,
                            right: 5,
                            child: IconButton(
                              icon:
                                  Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  quitarSubsidiaryFavorito(
                                      context, snapshot.data[index]);
                                });
                              },
                            ))
                      ]),
                    );
                  });
            } else {
              return Center(
                child: Text('No hay Points'),
              );
            }
          } else {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
        },
      ),
    );
  }

  void quitarSubsidiaryFavorito(BuildContext context, SubsidiaryModel data) {}
}
