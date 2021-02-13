import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rating_bar/rating_bar.dart';

class TabProductosSucursalPage extends StatelessWidget {
  const TabProductosSucursalPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final SubsidiaryModel subsidiary =
        ModalRoute.of(context).settings.arguments;
    return _infoSucursal(responsive, subsidiary);
  }

  Widget _infoSucursal(Responsive responsive, SubsidiaryModel subsidiary) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: responsive.hp(3),  left: responsive.wp(3)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: responsive.wp(30),
                    child: RatingBar.readOnly(
                      size: 20,
                      initialRating: double.parse('${subsidiary.subsidiaryStatus}'),
                      isHalfAllowed: true,
                      halfFilledIcon: Icons.star_half,
                      filledIcon: Icons.star,
                      emptyIcon: Icons.star_border,
                      filledColor: Colors.yellow,
                    ),
                  ),
                  Text('${subsidiary.subsidiaryStatus}'),
                ],
              ),
              SizedBox(height: responsive.hp(3)),
              Text(
                "Información",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: responsive.ip(2.7),
                    fontWeight: FontWeight.bold),
              ),
              Divider(color: Colors.grey),
              Row(
                children: [
                  Icon(Icons.location_on, size: 28, color: Colors.red[700]),
                  SizedBox(width: responsive.wp(2)),
                  Text('${subsidiary.subsidiaryAddress}',
                      style: TextStyle(fontSize: responsive.ip(2))),
                ],
              ),
              SizedBox(height: responsive.hp(2.5)),
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.clock,
                    color: Colors.red,
                    size: 22,
                  ),
                  SizedBox(width: responsive.wp(2)),
                  Text('${subsidiary.subsidiaryOpeningHours}',
                      style: TextStyle(fontSize: responsive.ip(2))),
                ],
              ),
              SizedBox(height: responsive.hp(2.5)),
              Row(
                children: [
                  Icon(FontAwesomeIcons.phoneAlt,
                      color: Colors.red[700], size: 22),
                  SizedBox(width: responsive.wp(2)),
                  Text('${subsidiary.subsidiaryCellphone}',
                      style: TextStyle(fontSize: responsive.ip(2))),
                ],
              ),
              SizedBox(height: responsive.hp(2.5)),
              Row(
                children: [
                  Icon(Icons.mail, size: 28, color: Colors.red[700]),
                  SizedBox(width: responsive.wp(2)),
                  
                  Text('${subsidiary.subsidiaryEmail}',
                      style: TextStyle(fontSize: responsive.ip(2))),
                ],
              ),
              SizedBox(height: responsive.hp(2.5)),
              Row(
                children: [
                  Icon(FontAwesomeIcons.home, color: Colors.red, size: 22),
                  SizedBox(width: responsive.wp(2)),
                  Text('${subsidiary.subsidiaryPrincipal}',
                      style: TextStyle(fontSize: responsive.ip(2))),
                ],
              ),
              SizedBox(height: responsive.hp(2.5)),
              Row(
                children: [
                  Icon(FontAwesomeIcons.home, color: Colors.red[800], size: 22),
                  SizedBox(width: responsive.wp(2)),
                  Text('${subsidiary.subsidiaryCoordX}',
                      style: TextStyle(fontSize: responsive.ip(2))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
