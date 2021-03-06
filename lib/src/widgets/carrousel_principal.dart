import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/publicidad_model.dart';
import 'package:bufi/src/page/Tabs/Negocios/producto/ListarProductosPorSucursal.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bufi/src/widgets/extentions.dart';

class CarrouselPrincipal extends StatelessWidget {
  final _pageController = PageController(viewportFraction: 0.9, initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    final publicidadBloc = ProviderBloc.publi(context);

    publicidadBloc.obtenerPublicidadBloc();

    return StreamBuilder(
      stream: publicidadBloc.publicidadListStream,
      builder: (BuildContext context,
          AsyncSnapshot<List<PublicidadModel>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return _buildPageView(responsive, snapshot.data);
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }

  _buildPageView(Responsive responsive, List<PublicidadModel> list) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: Colors.transparent,
      ),
      height: responsive.hp(19),
      child: PageView.builder(
          itemCount: list.length,
          controller: _pageController,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: responsive.wp(1)),
              //padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: GestureDetector(
                onTap: () {},
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    //cacheManager: CustomCacheManager(),
                    placeholder: (context, url) => Image(
                        image: AssetImage('assets/jar-loading.gif'),
                        fit: BoxFit.cover),
                    errorWidget: (context, url, error) => Image(
                        image: AssetImage('assets/carga_fallida.jpg'),
                        fit: BoxFit.cover),
                    imageUrl: "$apiBaseURL/${list[index].publicidadImg}",
                    //'https://plazaisabella.com/img/descuentos/descuentos-banner.jpg',
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
              ),
            ).ripple(
              () {
                Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return ListarProductosPorSucursalPage(
                      idSucursal: "${list[index].idSubsidiary}",
                    );
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    var begin = Offset(0.0, 1.0);
                    var end = Offset.zero;
                    var curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end).chain(
                      CurveTween(curve: curve),
                    );

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ));
              },
            );
          },
          onPageChanged: (int index) {}),
    );
  }
}
