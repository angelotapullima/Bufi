



import 'package:flutter/material.dart';

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    path.lineTo(00.0, 15);
    path.relativeArcToPoint(const Offset(0, 30),
        radius: const Radius.circular(10.0), largeArc: true);

    path.lineTo(00.0, size.height - 10);


    path.quadraticBezierTo(0.0, size.height, 10.0, size.height);

    //linea inferior
    path.lineTo(size.width -10.00, size.height);


    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - 10);
    path.lineTo(size.width, 48);

    
    path.arcToPoint(Offset(size.width, 16),
        radius: const Radius.circular(15.0), largeArc: true,);
    path.lineTo(size.width, 10.0);
    path.quadraticBezierTo(size.width, 0.0, size.width - 10.0, 0.0);
    path.lineTo(10.0, 0.0);
    path.quadraticBezierTo(0.0, 0.0, 0.0, 10.0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class ExtendedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    path.lineTo(0.0, 55);
    //path.relativeArcToPoint(const Offset(0, 40), radius: const Radius.circular(10.0), largeArc: true);
    path.lineTo(0.0, size.height - 10);
    path.quadraticBezierTo(0.0, size.height, 10.0, size.height);
    path.lineTo(size.width - 10.0, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - 10);
    path.lineTo(size.width, 95);
    //path.arcToPoint(Offset(size.width, 55),radius: const Radius.circular(10.0), clockwise: true);
    path.lineTo(size.width, 10.0);
    path.quadraticBezierTo(size.width, 0.0, size.width - 10.0, 0.0);
    path.lineTo(10.0, 0.0);
    path.quadraticBezierTo(0.0, 0.0, 0.0, 10.0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}





class MySeparator extends StatelessWidget {

  const MySeparator({this.height = 1, this.color = Colors.black});
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double boxWidth = constraints.constrainWidth();
        const double dashWidth = 6.0;
        final double dashHeight = height;
        final int dashCount = (boxWidth / (1.5 * dashWidth)).floor();
        return Flex(
          children: List<Widget>.generate(dashCount-10, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
