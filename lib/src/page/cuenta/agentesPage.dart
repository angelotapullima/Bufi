import 'package:bufi/src/bloc/marker_mapa_negocios_bloc.dart';
import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/models/agentesModel.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AgentesPage extends StatelessWidget {
  const AgentesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final agenteBloc = ProviderBloc.agentes(context);
    agenteBloc.obtenerAgentes();
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          "Agentes",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: agenteBloc.agenteStream,
        builder: (BuildContext context, AsyncSnapshot<List<AgenteModel>> snapshot) {
          List<AgenteModel> agente = snapshot.data;
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return MapaAgentes(
                agentes: agente,
              );
            } else {
              return Container(
                width: double.infinity,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Buscando Agentes'),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
            }
          } else {
            return Center(
              child: Text('No se encuentra ningún agente'),
            );
          }
        },
      ),
    );
  }
}

class MapaAgentes extends StatefulWidget {
  final List<AgenteModel> agentes;
  const MapaAgentes({Key key, @required this.agentes}) : super(key: key);

  @override
  _MapaNegociosState createState() => _MapaNegociosState();
}

class _MapaNegociosState extends State<MapaAgentes> {
  Map<String, Marker> markers = Map<String, Marker>();
  final _pageController = PageController(viewportFraction: 0.8, initialPage: 0);

  final ScrollController _scrollController = new ScrollController();

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-3.74912, -73.25383),
    zoom: 15,
  );

  /* @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await markersitos(context);
      },
    );

    super.initState();
  } */

  void _onMapCreated(BuildContext context, GoogleMapController controller) {
    final markerMapa = ProviderBloc.markerMapa(context);

    for (var i = 0; i < widget.agentes.length; i++) {
      var punto = LatLng(
        double.parse(widget.agentes[i].agenteCoordX),
        double.parse(widget.agentes[i].agenteCoordY),
      );

      final markerInicio = new Marker(
        onTap: () {
          _pageController.animateToPage(int.parse('${widget.agentes[i].posicion}') - 1, duration: Duration(milliseconds: 500), curve: Curves.decelerate);

          AgentesResult ne = AgentesResult();

          ne.posicion = '${widget.agentes[i].posicion}';
          ne.idAgente = '${widget.agentes[i].idAgente}';

          markerMapa.changemarkerId(ne);
        },
        anchor: Offset(0.0, 1.0),
        markerId: MarkerId('${widget.agentes[i].idAgente}'),
        position: punto,
        infoWindow: InfoWindow(
          title: '${widget.agentes[i].agenteNombre}',
          snippet: '${widget.agentes[i].agenteDireccion}',
        ),
      );

      markers['${widget.agentes[i].agenteNombre}'] = markerInicio;
    }
    _controller.complete(controller);
    setState(() {});
  }
  /* Future<Map<String, Marker>> markersitos(BuildContext context) async {
   
    

    return markers;
  } */

  @override
  Widget build(BuildContext context) {
    final markerMapa = ProviderBloc.markerMapa(context);
    final responsive = Responsive.of(context);

    return new Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: false,
            markers: markers.values.toSet(),
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (controller) => _onMapCreated(context, controller),
          ),
          Positioned(
            bottom: responsive.hp(5),
            left: 0,
            right: 0,
            child: Container(
              height: responsive.hp(25),
              child: StreamBuilder(
                stream: markerMapa.markerIdStream,
                builder: (context, AsyncSnapshot<AgentesResult> snapshot) {
                  /* _pageController.animateToPage(snapshot.data,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn); */
                  //scroll(responsive, snapshot.data);
                  //
                  return PageView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: _pageController,
                    itemCount: widget.agentes.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          /*  Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(milliseconds: 700),
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return DetalleNegocio(
                                        negocio: widget.negocios[index],
                                      );
                                    },
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                  ),
                                ); */
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            left: responsive.wp(2),
                            right: responsive.wp(2),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          width: responsive.wp(45),
                          child: Column(
                            children: [
                              Container(
                                height: responsive.hp(15),
                                child: Hero(
                                  tag: '${widget.agentes[index].idAgente}',
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: Image(image: AssetImage('assets/img/loading.gif'), fit: BoxFit.cover),
                                      ),
                                      errorWidget: (context, url, error) => Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: Center(
                                          child: Icon(Icons.error),
                                        ),
                                      ),
                                      imageUrl: '$apiBaseURL/${widget.agentes[index].agenteImagen}',
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
                              ),
                              Text('${widget.agentes[index].agenteNombre}')
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  void scroll(Responsive responsive, int position) {
    Future.delayed(
      Duration(milliseconds: 1),
      () {
        _scrollController.animateTo(
          (responsive.wp(40) * position) - responsive.wp(45),
          curve: Curves.ease,
          duration: const Duration(milliseconds: 100),
        );
      },
    );
  }
}

/****** return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.agentes.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            /*  Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(milliseconds: 700),
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return DetalleNegocio(
                                        negocio: widget.negocios[index],
                                      );
                                    },
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                  ),
                                ); */
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: responsive.wp(2),
                              right: responsive.wp(2),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            width: responsive.wp(45),
                            child: Column(
                              children: [
                                Container(
                                  height: responsive.hp(15),
                                  child: Hero(
                                    tag: '${widget.agentes[index].idAgente}',
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: CachedNetworkImage(
                                        cacheManager: CustomCacheManager(),
                                        placeholder: (context, url) =>
                                            Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          child: Image(
                                              image: AssetImage(
                                                  'assets/img/loading.gif'),
                                              fit: BoxFit.cover),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          child: Center(
                                            child: Icon(Icons.error),
                                          ),
                                        ),
                                        imageUrl:
                                            '$apiBaseURL/${widget.agentes[index].agenteImagen}',
                                        imageBuilder:
                                            (context, imageProvider) =>
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
                                ),
                                Text('${widget.agentes[index].agenteNombre}')
                              ],
                            ),
                          ),
                        );
                      },
                    );
                   ******/

/* return ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.agentes.length,
                      itemBuilder: (context, index) {
                        return (snapshot.data !=
                                int.parse('${widget.agentes[index].idAgente}'))
                            ? GestureDetector(
                                onTap: () {
                                  /* Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          transitionDuration:
                                              const Duration(milliseconds: 700),
                                          pageBuilder: (context, animation,
                                              secondaryAnimation) {
                                            return DetalleNegocio(
                                              negocio: widget.negocios[index],
                                            );
                                          },
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          },
                                        ),
                                      ); */
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: responsive.wp(2),
                                      right: responsive.wp(2),
                                      top: responsive.hp(4)),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  width: responsive.wp(45),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: responsive.hp(15),
                                        child: Hero(
                                          tag:
                                              '${widget.agentes[index].idAgente}',
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: CachedNetworkImage(
                                              cacheManager:
                                                  CustomCacheManager(),
                                              placeholder: (context, url) =>
                                                  Container(
                                                width: double.infinity,
                                                height: double.infinity,
                                                child: Image(
                                                    image: AssetImage(
                                                        'assets/img/loading.gif'),
                                                    fit: BoxFit.cover),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                width: double.infinity,
                                                height: double.infinity,
                                                child: Center(
                                                  child: Icon(Icons.error),
                                                ),
                                              ),
                                              imageUrl:
                                                  '$apiBaseURL/${widget.agentes[index].agenteImagen}',
                                              imageBuilder:
                                                  (context, imageProvider) =>
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
                                      ),
                                      Text(
                                          '${widget.agentes[index].agenteNombre}')
                                    ],
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  /* Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          transitionDuration:
                                              const Duration(milliseconds: 700),
                                          pageBuilder: (context, animation,
                                              secondaryAnimation) {
                                            return DetalleNegocio(
                                              negocio: widget.negocios[index],
                                            );
                                          },
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          },
                                        ),
                                      ); */
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                    left: responsive.wp(2),
                                    right: responsive.wp(2),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey[400],
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.8),
                                        spreadRadius: 7,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 4), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  width: responsive.wp(45),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: responsive.hp(16),
                                        child: Hero(
                                          tag:
                                              '${widget.agentes[index].idAgente}',
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: CachedNetworkImage(
                                              cacheManager:
                                                  CustomCacheManager(),
                                              placeholder: (context, url) =>
                                                  Container(
                                                width: double.infinity,
                                                height: double.infinity,
                                                child: Image(
                                                    image: AssetImage(
                                                        'assets/img/loading.gif'),
                                                    fit: BoxFit.cover),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                width: double.infinity,
                                                height: double.infinity,
                                                child: Center(
                                                  child: Icon(Icons.error),
                                                ),
                                              ),
                                              imageUrl:
                                                  '$apiBaseURL/${widget.agentes[index].agenteImagen}',
                                              imageBuilder:
                                                  (context, imageProvider) =>
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
                                      ),
                                      Text(
                                          '${widget.agentes[index].agenteNombre}'),
                                      Text(
                                          '${widget.agentes[index].agenteDireccion}'),
                                      /* Text(
                                              '${widget.agentes[index].agenteTelefono}'),
                                          Text(
                                              '${widget.agentes[index].agenteTipo}'), */
                                    ],
                                  ),
                                ),
                              );
                      },
                    );
                  */
