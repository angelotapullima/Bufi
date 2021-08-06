import 'package:bufi/src/bloc/provider_bloc.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Agregarcarrito extends StatefulWidget {
  final String urlImage;
  const Agregarcarrito({Key key, @required this.urlImage}) : super(key: key);

  @override
  _AgregarcarritoState createState() => _AgregarcarritoState();
}

class _AgregarcarritoState extends State<Agregarcarrito> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animationButton1;
  Animation _animationMovementIn;
  Animation _animationMovementOut;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _animationButton1 = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.3),
      ),
    );
    _animationMovementIn = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.45, 0.6),
      ),
    );
    _animationMovementOut = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.6, 1.0, curve: Curves.elasticIn),
      ),
    );

    Future<void>.delayed(Duration(milliseconds: 700), () {
      _controller.forward();
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushNamedAndRemoveUntil('home', (Route<dynamic> route) => false);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    final buttonBloc = ProviderBloc.tabs(context);
    buttonBloc.changePage(2);

    return Material(
      color: Colors.transparent,
      child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final buttonSize = (responsive.wp(30) * _animationButton1.value).clamp(
              responsive.ip(6),
              responsive.wp(30),
            );
            return Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: Colors.black.withOpacity(.8),
                    ),
                  ),
                ),
                Positioned.fill(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Stack(
                    children: [
                      if (_animationMovementIn.value != 1)
                        Positioned(
                          top: responsive.hp(45) + (_animationMovementIn.value * responsive.hp(43.9)),
                          left: responsive.wp(50) -
                              (responsive.wp(100) * _animationButton1.value).clamp(
                                    responsive.ip(6),
                                    responsive.wp(100),
                                  ) /
                                  2,
                          width: (responsive.wp(100) * _animationButton1.value).clamp(
                            responsive.ip(6),
                            responsive.wp(100),
                          ),
                          child: buildPanel(responsive),
                        ),
                      Positioned(
                        bottom: 40 - (_animationMovementOut.value * 100),
                        left: responsive.wp(50) - buttonSize / 2,
                        child: TweenAnimationBuilder(
                          duration: Duration(milliseconds: 600),
                          curve: Curves.easeIn,
                          tween: Tween(begin: 1.0, end: 0.0),
                          builder: (context, value, child) {
                            return Transform.translate(
                                offset: Offset(
                                  0.0,
                                  value * responsive.hp(25),
                                ),
                                child: child);
                          },
                          child: GestureDetector(
                            onTap: () {
                              _controller.forward();
                            },

                            //ancho del boton == responsive.wp(30)
                            //ancho del circular == responsive.wp(10)
                            child: Container(
                              width: buttonSize,
                              height: (responsive.hp(5) * _animationButton1.value).clamp(
                                responsive.ip(6),
                                responsive.wp(30),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: responsive.hp(.5),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadiusDirectional.circular(100),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Icon(
                                      Icons.shopping_cart,
                                      color: Colors.white,
                                    ),
                                  ),
                                  if (_animationButton1.value == 1) ...[
                                    SizedBox(
                                      width: responsive.wp(2),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Cesta',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: responsive.ip(2),
                                        ),
                                      ),
                                    )
                                  ]
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }

  Widget buildPanel(Responsive responsive) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600),
      curve: Curves.easeIn,
      tween: Tween(begin: 1.0, end: 0.0),
      builder: (context, value, child) {
        return Transform.translate(
            offset: Offset(
              0.0,
              value * responsive.hp(55),
            ),
            child: child);
      },
      child: Container(
        height: (responsive.hp(55) * _animationButton1.value).clamp(responsive.ip(6), responsive.hp(55)),
        width: (responsive.wp(100) * _animationButton1.value).clamp(responsive.ip(6), responsive.wp(100)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomLeft: (_animationButton1.value == 1) ? Radius.circular(0) : Radius.circular(30),
            bottomRight: (_animationButton1.value == 1) ? Radius.circular(0) : Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: (responsive.hp(25) * _animationButton1.value).clamp(responsive.ip(4.5), responsive.hp(25)),
                  width: (responsive.wp(35) * _animationButton1.value).clamp(responsive.ip(4.5), responsive.wp(35)),
                  child: Stack(
                    children: [
                      Container(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Image(image: AssetImage('assets/jar-loading.gif'), fit: BoxFit.cover),
                          errorWidget: (context, url, error) => Image(image: AssetImage('assets/carga_fallida.jpg'), fit: BoxFit.cover),
                          imageUrl: widget.urlImage,
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
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
