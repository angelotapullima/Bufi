import 'package:bufi/src/api/pedidos/Pedido_api.dart';
import 'package:bufi/src/database/company_db.dart';
import 'package:bufi/src/database/detallePedido_database.dart';
import 'package:bufi/src/database/pedidos_db.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/database/subsidiary_db.dart';
import 'package:bufi/src/models/CompanySubsidiaryModel.dart';
import 'package:bufi/src/models/DetallePedidoModel.dart';
import 'package:bufi/src/models/PedidosModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:rxdart/subjects.dart';

class PedidoBloc {
  final pedidoDb = PedidosDatabase();
  final detallePedidoDb = DetallePedidoDatabase();
  final productoDb = ProductoDatabase();
  final subsidiaryDb = SubsidiaryDatabase();
  final companyDb = CompanyDatabase();
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
    _pedidoController.sink.add(await obtnerDetallePedidoXIdPedido());
  }

  //Funcion para recorrer las dos tablas
  Future<List<PedidosModel>> obtnerDetallePedidoXIdPedido() async {
    List<PedidosModel> listaGeneral = List<PedidosModel>();

    //obtener todos los pedidos de la bd
    final listPedidos = await pedidoDb.obtenerPedidos();

    //Recorremos la lista de todos los pedidos
    for (var i = 0; i < listPedidos.length; i++) {
      final pedidosModel = PedidosModel();

      pedidosModel.idPedido = listPedidos[i].idPedido;
      pedidosModel.idUser = listPedidos[i].idUser;
      pedidosModel.idCity = listPedidos[i].idCity;
      pedidosModel.idSubsidiary = listPedidos[i].idSubsidiary;
      pedidosModel.idCompany = listPedidos[i].idCompany;
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

      //funcion que llama desde la bd a todos los detalles del pedido pasando el idPedido como argumento
      final listdetallePedido = await detallePedidoDb.obtenerDetallePedidoxIdPedido(listPedidos[i].idPedido);
      //crear lista vacia para llenar el detalle del pedido
      final listDetallePedidoModel = List<DetallePedidoModel>();

      // recorrer la tabla de detalle de pedido
      for (var j = 0; j < listdetallePedido.length; j++) {
        final detallePedido = DetallePedidoModel();

        detallePedido.idDetallePedido = listdetallePedido[j].idDetallePedido;
        detallePedido.idPedido = listdetallePedido[j].idPedido;
        detallePedido.idProducto = listdetallePedido[j].idProducto;
        detallePedido.cantidad = listdetallePedido[j].cantidad;
        detallePedido.detallePedidoSubtotal =listdetallePedido[j].detallePedidoSubtotal;

        //crear lista vacia para el modelo de Producto
        final listProductosModel = List<ProductoModel>();

        final listProductos =
            await productoDb.obtenerProductoPorIdSubsidiaryGood(
                listdetallePedido[j].idProducto);
        //Recorrer la lista de la tabla productos para obtenr todos los datos
        for (var l = 0; l < listProductos.length; l++) {
          final productoModel = ProductoModel();

          productoModel.productoName = listProductos[0].productoName;
          productoModel.productoPrice = listProductos[0].productoPrice;
          productoModel.productoCurrency = listProductos[l].productoCurrency;
          productoModel.productoImage = listProductos[0].productoImage;
          productoModel.productoCharacteristics =
              listProductos[0].productoCharacteristics;
          productoModel.productoBrand = listProductos[0].productoBrand;
          productoModel.productoModel = listProductos[0].productoModel;
          productoModel.productoMeasure = listProductos[0].productoMeasure;

          listProductosModel.add(productoModel);
        }
        detallePedido.listProducto = listProductosModel;

        listDetallePedidoModel.add(detallePedido);
      }

      pedidosModel.detallePedido = listDetallePedidoModel;

      //------Recorrer la lista de compañías y sucursales---------

      //funcion que llama desde la bd a todas las sucursales y compañías
      final listCompanysucursal = await companyDb
          .obtenerCompanySubsidiaryPorId(listPedidos[i].idCompany);
      final listCompsucursalModel = List<CompanySubsidiaryModel>();

      for (var k = 0; k < listCompanysucursal.length; k++) {
        final compSucursalModel = CompanySubsidiaryModel();
        //Sucursal
        compSucursalModel.subsidiaryName =
            listCompanysucursal[k].subsidiaryName;
        compSucursalModel.subsidiaryAddress =
            listCompanysucursal[k].subsidiaryAddress;
        compSucursalModel.subsidiaryCellphone =
            listCompanysucursal[k].subsidiaryCellphone;
        compSucursalModel.subsidiaryCellphone2 =
            listCompanysucursal[k].subsidiaryCellphone2;
        compSucursalModel.subsidiaryEmail =
            listCompanysucursal[k].subsidiaryEmail;
        compSucursalModel.subsidiaryCoordX =
            listCompanysucursal[k].subsidiaryCoordX;
        compSucursalModel.subsidiaryCoordY =
            listCompanysucursal[k].subsidiaryCoordY;
        compSucursalModel.subsidiaryOpeningHours =
            listCompanysucursal[k].subsidiaryOpeningHours;
        compSucursalModel.subsidiaryPrincipal =
            listCompanysucursal[k].subsidiaryPrincipal;
        compSucursalModel.subsidiaryStatus =
            listCompanysucursal[k].subsidiaryStatus;

        //Company
        compSucursalModel.companyName = listCompanysucursal[k].companyName;
        compSucursalModel.companyRuc = listCompanysucursal[k].companyRuc;
        compSucursalModel.companyImage = listCompanysucursal[k].companyImage;
        compSucursalModel.companyType = listCompanysucursal[k].companyType;
        compSucursalModel.companyShortcode =
            listCompanysucursal[k].companyShortcode;
        compSucursalModel.companyDeliveryPropio =
            listCompanysucursal[k].companyDeliveryPropio;
        compSucursalModel.companyDelivery =
            listCompanysucursal[k].companyDelivery;
        compSucursalModel.companyEntrega =
            listCompanysucursal[k].companyEntrega;
        compSucursalModel.companyTarjeta =
            listCompanysucursal[k].companyTarjeta;
        compSucursalModel.companyVerified =
            listCompanysucursal[k].companyVerified;
        compSucursalModel.companyRating = listCompanysucursal[k].companyRating;
        compSucursalModel.companyCreatedAt =
            listCompanysucursal[k].companyCreatedAt;
        compSucursalModel.companyJoin = listCompanysucursal[k].companyJoin;
        compSucursalModel.companyStatus = listCompanysucursal[k].companyStatus;
        compSucursalModel.companyMt = listCompanysucursal[k].companyMt;

        listCompsucursalModel.add(compSucursalModel);
      }

      pedidosModel.listCompanySubsidiary = listCompsucursalModel;

      listaGeneral.add(pedidosModel);
    }

    
    return listaGeneral;
  }
}

//-------------Recorrer la lista de Sucursales---------------

// //funcion que llama desde la bd a todas las sucursales
// final listsubsidiary = await subsidiaryDb
//     .obtenerSubsidiaryPorId(listPedidos[i].idSubsidiary);
// final listSucursalModel = List<SubsidiaryModel>();

// for (var k = 0; k < listsubsidiary.length; k++) {
//   final sucursalModel = SubsidiaryModel();

//   sucursalModel.subsidiaryName = listsubsidiary[k].subsidiaryName;
//   sucursalModel.subsidiaryAddress = listsubsidiary[k].subsidiaryAddress;
//   sucursalModel.subsidiaryCellphone =
//       listsubsidiary[k].subsidiaryCellphone;
//   sucursalModel.subsidiaryCellphone2 =
//       listsubsidiary[k].subsidiaryCellphone2;
//   sucursalModel.subsidiaryEmail = listsubsidiary[k].subsidiaryEmail;
//   sucursalModel.subsidiaryCoordX = listsubsidiary[k].subsidiaryName;
//   sucursalModel.subsidiaryCoordY = listsubsidiary[k].subsidiaryAddress;
//   sucursalModel.subsidiaryOpeningHours =
//       listsubsidiary[k].subsidiaryCellphone;
//   sucursalModel.subsidiaryPrincipal =
//       listsubsidiary[k].subsidiaryCellphone2;
//   sucursalModel.subsidiaryStatus = listsubsidiary[k].subsidiaryEmail;

//   listSucursalModel.add(sucursalModel);
// }
//Agregar la lista de sucursales al modelo de pedidos
//pedidosModel.listSubsidiary = listSucursalModel;
