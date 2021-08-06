import 'package:bufi/src/models/notificacionModel.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart';
import 'package:flutter/material.dart';

class DetalleNotificacionesPage extends StatefulWidget {
  DetalleNotificacionesPage({Key key, @required this.noti}) : super(key: key);

  final NotificacionesModel noti;

  @override
  _DetalleNotificacionesPageState createState() => _DetalleNotificacionesPageState();
}

class _DetalleNotificacionesPageState extends State<DetalleNotificacionesPage> {
  @override
  Widget build(BuildContext context) {
    var fecha = obtenerFechaHora(widget.noti.notificacionDatetime);
    final responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Notificaciones"),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${widget.noti.notificacionMensaje}', style: TextStyle(color: Colors.black, fontSize: responsive.ip(2), fontWeight: FontWeight.bold)),
              Text('$fecha', style: TextStyle(color: Colors.black, fontSize: responsive.ip(2), fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
