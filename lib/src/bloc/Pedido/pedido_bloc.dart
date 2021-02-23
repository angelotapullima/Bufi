import 'package:bufi/src/api/pedidos/Pedido_api.dart';
import 'package:bufi/src/database/pedidos_db.dart';
import 'package:bufi/src/models/DetallePedidoModel.dart';
import 'package:bufi/src/models/PedidosModel.dart';
import 'package:rxdart/subjects.dart';

class PedidoBloc {
  final pedidoDb = PedidosDatabase();
  final pedidoApi = PedidoApi();

  final _pedidoController = BehaviorSubject<List<PedidosModel>>();
  //final _detallePedidoController = BehaviorSubject<List<DetallePedidoModel>>();

  Stream<List<PedidosModel>> get pedidoStream => _pedidoController.stream;
  // Stream<List<DetallePedidoModel>> get detallePedidoStream =>
  //     _detallePedidoController.stream;

  void dispose() {
    _pedidoController?.close();
    //_detallePedidoController?.close();
  }

  void obtenerPedidosAll() async {
    _pedidoController.sink.add(await obtnerDetallePedidoXIdPedido());
    pedidoApi.obtenerPedidosEnviados();
  }

  //Funcion para recorrer las dos tablas
  Future<List<PedidosModel>> obtnerDetallePedidoXIdPedido() async {
    List listaGeneral = List<PedidosModel>();

    //obtener todos los pedidos de la bd
    final listPedidos = await pedidoDb.obtenerPedidos();

    //Recorremos la lista de todos los pedidos
    for (var i = 0; i < listPedidos.length; i++) {
      final pedidosModel = PedidosModel();

      pedidosModel.idPedido = listPedidos[i].idPedido;
      pedidosModel.idUser = listPedidos[i].idUser;
      pedidosModel.idCity = listPedidos[i].idCity;
      pedidosModel.idSubsidiary = listPedidos[i].idSubsidiary;
      pedidosModel.deliveryNumber = listPedidos[i].deliveryNumber;
      pedidosModel.deliveryName = listPedidos[i].deliveryName;
      pedidosModel.deliveryEmail = listPedidos[i].deliveryEmail;
      pedidosModel.deliveryCel = listPedidos[i].deliveryCel;
      pedidosModel.deliveryAddress = listPedidos[i].deliveryAddress;
      pedidosModel.deliveryDescription = listPedidos[i].deliveryDescription;
      pedidosModel.deliveryCoordX = listPedidos[i].deliveryCoordX;
      pedidosModel.deliveryCoordY = listPedidos[i].deliveryCoordY;
      pedidosModel.deliveryAddInfo = listPedidos[i].deliveryAddInfo;
      pedidosModel.deliveryPrice = listPedidos[i].deliveryPrice;
      pedidosModel.deliveryTotalOrden = listPedidos[i].deliveryTotalOrden;
      pedidosModel.deliveryPayment = listPedidos[i].deliveryPayment;
      pedidosModel.deliveryEntrega = listPedidos[i].deliveryEntrega;
      pedidosModel.deliveryDatetime = listPedidos[i].deliveryDatetime;
      pedidosModel.deliveryStatus = listPedidos[i].deliveryStatus;
      pedidosModel.deliveryMt = listPedidos[i].deliveryMt;

      //lista para llenar el detalle del pedido
      final listDetallePedido = List<DetallePedidoModel>();

      // recorrer la tabla de detalle de pedido
      for (var j = 0; j < listDetallePedido.length; i++) {
        final detallePedido = DetallePedidoModel();

        detallePedido.idDetallePedido = listDetallePedido[j].idDetallePedido;
        detallePedido.idPedido = listDetallePedido[j].idPedido;
        detallePedido.idProducto = listDetallePedido[j].idProducto;
        detallePedido.cantidad = listDetallePedido[j].cantidad;
        //detallePedido.estado = listDetallePedido[j].estado;
        detallePedido.detallePedidoSubtotal =
            listDetallePedido[j].detallePedidoSubtotal;

        listDetallePedido.add(detallePedido);
      }
      pedidosModel.detallePedido = listDetallePedido;

      listaGeneral.add(pedidosModel);
    }
    return listaGeneral;
  }
}
