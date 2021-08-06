import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/CompanySubsidiaryModel.dart';
import 'package:bufi/src/bloc/subsidiary/negocio_bloc.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/widgets/busquedas/widgetBusquNegocio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NegociosPage extends StatefulWidget {
  @override
  _NegociosPageState createState() => _NegociosPageState();
}

class _NegociosPageState extends State<NegociosPage> {
  @override
  Widget build(BuildContext context) {
    final negociosBloc = ProviderBloc.negocios(context);
    negociosBloc.listarnegocios();
    final responsive = Responsive.of(context);

    final provider = Provider.of<NegociosBlocListener>(context, listen: false);

    return StreamBuilder(
        stream: negociosBloc.listarNeg,
        builder: (context, AsyncSnapshot<List<CompanySubsidiaryModel>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              List<CompanySubsidiaryModel> negocio = snapshot.data;
              return Scaffold(
                backgroundColor: Colors.white,
                body: SafeArea(
                  child: ValueListenableBuilder(
                      valueListenable: provider.showFiltro,
                      builder: (BuildContext context, bool data, Widget child) {
                        return Column(
                          children: [
                            ValueListenableBuilder<bool>(
                              valueListenable: provider.showNegocios,
                              builder: (_, value, __) {
                                return (value)
                                    ? HeaderWidget(
                                        responsive: responsive,
                                      )
                                    : Container(
                                        color: Colors.white,
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: responsive.wp(5),
                                          vertical: responsive.hp(1),
                                        ),
                                        child: Text(
                                          'Negocios',
                                          style: TextStyle(color: Colors.white, fontSize: responsive.ip(2.5), fontWeight: FontWeight.w700),
                                        ),
                                      );
                              },
                            ),
                            Expanded(
                              child: ListView.builder(
                                controller: provider.controller,
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    return HeaderWidget(
                                      responsive: responsive,
                                    );
                                  }

                                  return (!data)
                                      ? GridView.builder(
                                          shrinkWrap: true,
                                          physics: ClampingScrollPhysics(),
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                                          itemCount: negocio.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return GestureDetector(
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: Card(
                                                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                    child: Container(
                                                      height: responsive.hp(40),
                                                      child: Stack(
                                                        children: <Widget>[
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.circular(10),
                                                            child: CachedNetworkImage(
                                                              placeholder: (context, url) => Image(image: AssetImage('assets/jar-loading.gif'), fit: BoxFit.cover),
                                                              errorWidget: (context, url, error) => Image(image: AssetImage('assets/carga_fallida.jpg'), fit: BoxFit.cover),
                                                              imageUrl: '$apiBaseURL/${negocio[index].companyImage}',
                                                              imageBuilder: (context, imageProvider) => Container(
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
                                                            right: 0,
                                                            left: 0,
                                                            bottom: 0,
                                                            child: Container(
                                                              width: double.infinity,
                                                              padding: EdgeInsets.symmetric(
                                                                vertical: responsive.hp(.5),
                                                                //horizontal: responsive.wp(2)
                                                              ),
                                                              decoration: BoxDecoration(
                                                                color: Colors.black.withOpacity(.5),
                                                                borderRadius: BorderRadius.circular(10),
                                                              ),
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    '${negocio[index].companyName}',
                                                                    style: TextStyle(color: Colors.white, fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.pushNamed(context, 'detalleNegocio', arguments: negocio[index]);
                                                });
                                          })
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: negocio.length,
                                          physics: ClampingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(context, 'detalleNegocio', arguments: negocio[index]);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey.withOpacity(0.5),
                                                      spreadRadius: 1,
                                                      blurRadius: 2,
                                                      offset: Offset(3, 2), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                                margin: EdgeInsets.all(
                                                  responsive.ip(1),
                                                ),
                                                height: responsive.hp(15),
                                                child: Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(10),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(8),
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey.withOpacity(0.5),
                                                              spreadRadius: 1,
                                                              blurRadius: 1,
                                                              offset: Offset(0, 2), // changes position of shadow
                                                            ),
                                                          ],
                                                        ),
                                                        width: responsive.wp(42),
                                                        child: Stack(
                                                          children: <Widget>[
                                                            CachedNetworkImage(
                                                              /* cacheManager:
                                                                  CustomCacheManager(), */
                                                              placeholder: (context, url) => Image(image: AssetImage('assets/jar-loading.gif'), fit: BoxFit.cover),
                                                              errorWidget: (context, url, error) => Image(image: AssetImage('assets/carga_fallida.jpg'), fit: BoxFit.cover),
                                                              imageUrl: '$apiBaseURL/${negocio[index].companyImage}',
                                                              imageBuilder: (context, imageProvider) => Container(
                                                                decoration: BoxDecoration(
                                                                  image: DecorationImage(
                                                                    image: imageProvider,
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              right: 0,
                                                              left: 0,
                                                              bottom: 0,
                                                              child: Container(
                                                                width: double.infinity,
                                                                padding: EdgeInsets.symmetric(
                                                                  vertical: responsive.hp(.5),
                                                                  //horizontal: responsive.wp(2)
                                                                ),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.black.withOpacity(.5),
                                                                  borderRadius: BorderRadius.circular(10),
                                                                ),
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      '${negocio[index].companyName}',
                                                                      style: TextStyle(color: Colors.white, fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: responsive.wp(53),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            '${negocio[index].companyName}',
                                                            style: TextStyle(fontSize: responsive.ip(2.3), fontWeight: FontWeight.w600),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                          Text('${negocio[index].subsidiaryAddress}'),
                                                          Text('${negocio[index].companyRating}'),
                                                          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                                            Icon(
                                                              Icons.star,
                                                              color: Colors.yellow,
                                                            ),
                                                            SizedBox(width: 5),
                                                            //Text('${data[index].subsidiaryGoodRating}'),
                                                            Text('bien'),
                                                            SizedBox(width: 10),
                                                          ])
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                },
                                itemCount: 2,
                              ),
                            ),
                          ],
                        );
                      }),
                ),
              );
            } else {
              return Center(
                child: Text('No hay Negocios'),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    Key key,
    @required this.responsive,
  }) : super(key: key);

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NegociosBlocListener>(context, listen: false);

    return Column(
      children: [
        Container(
          color: Colors.white,
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: responsive.wp(2),
            vertical: responsive.hp(1),
          ),
          child: Row(
            children: [
              Text(
                'Negocios',
                style: TextStyle(color: Colors.black, fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
              ),
              Spacer(),
              IconButton(
                  icon: Icon(Icons.category, color: Colors.red),
                  onPressed: () {
                    provider.lptmr();
                  }),
            ],
          ),
        ),
        BusquedaNegocioWidget(
          responsive: responsive,
        )
      ],
    );
  }
}
