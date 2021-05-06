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
import 'package:rxdart/subjects.dart';

class PedidoBloc {
  final pedidoDb = PedidosDatabase();
  final detallePedidoDb = DetallePedidoDatabase();
  final productoDb = ProductoDatabase();
  final subsidiaryDb = SubsidiaryDatabase();
  final companyDb = CompanyDatabase();
  final pedidoApi = PedidoApi();

  final _pedidoController = BehaviorSubject<List<PedidosModel>>();
  final _pedidoIDController = BehaviorSubject<List<PedidosModel>>();
  final _pedidosEnviadoController = BehaviorSubject<List<PedidosModel>>();

  Stream<List<PedidosModel>> get pedidoStream => _pedidoController.stream;
  Stream<List<PedidosModel>> get pedidosEnviadoStream =>
      _pedidosEnviadoController.stream;
  Stream<List<PedidosModel>> get pedidoPorIdStream =>
      _pedidoIDController.stream;

  void dispose() {
    _pedidoController?.close();
    _pedidoIDController?.close();
    _pedidosEnviadoController?.close();
    //_detallePedidoController?.close();
  }

  void obtenerPedidosEnviados(String idEstado) async {
    print('Primera llamada a la db');
    _pedidosEnviadoController.sink
        .add(await obtnerDetallePedidosEnviados(idEstado));
    print('Llamada al API');
    pedidoApi.obtenerPedidosEnviados(idEstado);
    print('Segunda llamada a la db');
    _pedidosEnviadoController.sink
        .add(await obtnerDetallePedidosEnviados(idEstado));
  }

  void obtenerPedidosPorIdEstado(String idEstado) async {
    _pedidoController.sink.add(await obtnerDetallePedidosPorIdEstado());
    pedidoApi.obtenerPedidosEnviados(idEstado);
    _pedidoController.sink.add(await obtnerDetallePedidosPorIdEstado());
  }

  void obtenerPedidoPorId(String idPedido) async {
    _pedidoIDController.sink.add(await obtenerPedidosPorIdPedido(idPedido));
  }

  Future<List<PedidosModel>> obtenerPedidosPorIdPedido(String idPedido) async {
    List<PedidosModel> listaGeneral = List<PedidosModel>();

    //obtener todos los pedidos de la bd
    final listPedidos = await pedidoDb.obtenerPedidosXidPedido(idPedido);

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
      final listdetallePedido = await detallePedidoDb
          .obtenerDetallePedidoxIdPedido(listPedidos[i].idPedido);
      //crear lista vacia para llenar el detalle del pedido
      final listDetallePedidoModel = List<DetallePedidoModel>();

      // recorrer la tabla de detalle de pedido
      for (var j = 0; j < listdetallePedido.length; j++) {
        final detallePedido = DetallePedidoModel();

        detallePedido.idDetallePedido = listdetallePedido[j].idDetallePedido;
        detallePedido.idPedido = listdetallePedido[j].idPedido;
        detallePedido.idProducto = listdetallePedido[j].idProducto;
        detallePedido.cantidad = listdetallePedido[j].cantidad;
        detallePedido.detallePedidoMarca =
            listdetallePedido[j].detallePedidoMarca;
        detallePedido.detallePedidoModelo =
            listdetallePedido[j].detallePedidoModelo;
        detallePedido.detallePedidoTalla =
            listdetallePedido[j].detallePedidoTalla;
        detallePedido.detallePedidoValorado =
            listdetallePedido[j].detallePedidoValorado;
        detallePedido.detallePedidoSubtotal =
            listdetallePedido[j].detallePedidoSubtotal;

        //crear lista vacia para el modelo de Producto
        final listProductosModel = List<ProductoModel>();

        final listProductos =
            await productoDb.obtenerProductoPorIdSubsidiaryGood(
                listdetallePedido[j].idProducto);
        //Recorrer la lista de la tabla productos para obtenr todos los datos
        for (var l = 0; l < listProductos.length; l++) {
          final productoModel = ProductoModel();

          productoModel.idProducto = listProductos[0].idProducto;
          productoModel.idSubsidiary = listProductos[0].idSubsidiary;
          productoModel.productoName = listProductos[0].productoName;
          productoModel.productoPrice = listProductos[0].productoPrice;
          productoModel.productoCurrency = listProductos[l].productoCurrency;
          productoModel.productoImage = listProductos[0].productoImage;
          productoModel.productoCharacteristics =
              listProductos[0].productoCharacteristics;
          productoModel.productoBrand = listProductos[0].productoBrand;
          productoModel.productoModel = listProductos[0].productoModel;
          productoModel.productoSize = listProductos[0].productoSize;
          productoModel.productoStock = listProductos[0].productoStock;
          productoModel.productoStockStatus =
              listProductos[0].productoStockStatus;
          productoModel.productoMeasure = listProductos[0].productoMeasure;

          listProductosModel.add(productoModel);
        }
        detallePedido.listProducto = listProductosModel;

        listDetallePedidoModel.add(detallePedido);
      }

      pedidosModel.detallePedido = listDetallePedidoModel;

      //------Recorrer la lista de compañías y sucursales---------

      //funcion que llama desde la bd a todas las sucursales y compañías
      final listCompany =
          await companyDb.obtenerCompanyPorIdCompany(listPedidos[i].idCompany);
      final listSucursal = await subsidiaryDb
          .obtenerSubsidiaryPorId(listPedidos[i].idSubsidiary);
      final listCompsucursalModel = List<CompanySubsidiaryModel>();

      final compSucursalModel = CompanySubsidiaryModel();
      //Sucursal
      compSucursalModel.subsidiaryName = listSucursal[0].subsidiaryName;
      compSucursalModel.subsidiaryAddress = listSucursal[0].subsidiaryAddress;
      compSucursalModel.subsidiaryCellphone =
          listSucursal[0].subsidiaryCellphone;
      compSucursalModel.subsidiaryCellphone2 =
          listSucursal[0].subsidiaryCellphone2;
      compSucursalModel.subsidiaryEmail = listSucursal[0].subsidiaryEmail;
      compSucursalModel.subsidiaryCoordX = listSucursal[0].subsidiaryCoordX;
      compSucursalModel.subsidiaryCoordY = listSucursal[0].subsidiaryCoordY;
      compSucursalModel.subsidiaryOpeningHours =
          listSucursal[0].subsidiaryOpeningHours;
      compSucursalModel.subsidiaryPrincipal =
          listSucursal[0].subsidiaryPrincipal;
      compSucursalModel.subsidiaryStatus = listSucursal[0].subsidiaryStatus;

      //Company
      compSucursalModel.companyName = listCompany[0].companyName;
      compSucursalModel.companyRuc = listCompany[0].companyRuc;
      compSucursalModel.companyImage = listCompany[0].companyImage;
      compSucursalModel.companyType = listCompany[0].companyType;
      compSucursalModel.companyShortcode = listCompany[0].companyShortcode;
      compSucursalModel.companyDeliveryPropio =
          listCompany[0].companyDeliveryPropio;
      compSucursalModel.companyDelivery = listCompany[0].companyDelivery;
      compSucursalModel.companyEntrega = listCompany[0].companyEntrega;
      compSucursalModel.companyTarjeta = listCompany[0].companyTarjeta;
      compSucursalModel.companyVerified = listCompany[0].companyVerified;
      compSucursalModel.companyRating = listCompany[0].companyRating;
      compSucursalModel.companyCreatedAt = listCompany[0].companyCreatedAt;
      compSucursalModel.companyJoin = listCompany[0].companyJoin;
      compSucursalModel.companyStatus = listCompany[0].companyStatus;
      compSucursalModel.companyMt = listCompany[0].companyMt;

      listCompsucursalModel.add(compSucursalModel);

      pedidosModel.listCompanySubsidiary = listCompsucursalModel;

      listaGeneral.add(pedidosModel);
    }

    return listaGeneral;
  }

  //Funcion para recorrer las dos tablas
  Future<List<PedidosModel>> obtnerDetallePedidosPorIdEstado() async {
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
      final listdetallePedido = await detallePedidoDb
          .obtenerDetallePedidoxIdPedido(listPedidos[i].idPedido);
      //crear lista vacia para llenar el detalle del pedido
      final listDetallePedidoModel = List<DetallePedidoModel>();

      // recorrer la tabla de detalle de pedido
      for (var j = 0; j < listdetallePedido.length; j++) {
        final detallePedido = DetallePedidoModel();

        detallePedido.idDetallePedido = listdetallePedido[j].idDetallePedido;
        detallePedido.idPedido = listdetallePedido[j].idPedido;
        detallePedido.idProducto = listdetallePedido[j].idProducto;
        detallePedido.cantidad = listdetallePedido[j].cantidad;
        detallePedido.detallePedidoMarca =
            listdetallePedido[j].detallePedidoMarca;
        detallePedido.detallePedidoModelo =
            listdetallePedido[j].detallePedidoModelo;
        detallePedido.detallePedidoTalla =
            listdetallePedido[j].detallePedidoTalla;
        detallePedido.detallePedidoValorado =
            listdetallePedido[j].detallePedidoValorado;
        detallePedido.detallePedidoSubtotal =
            listdetallePedido[j].detallePedidoSubtotal;

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
          productoModel.productoSize = listProductos[0].productoSize;
          productoModel.productoStock = listProductos[0].productoStock;
          productoModel.productoStockStatus =
              listProductos[0].productoStockStatus;
          productoModel.productoMeasure = listProductos[0].productoMeasure;

          listProductosModel.add(productoModel);
        }
        detallePedido.listProducto = listProductosModel;

        listDetallePedidoModel.add(detallePedido);
      }

      pedidosModel.detallePedido = listDetallePedidoModel;

      //------Recorrer la lista de compañías y sucursales---------

      //funcion que llama desde la bd a todas las sucursales y compañías
      final listCompany =
          await companyDb.obtenerCompanyPorIdCompany(listPedidos[i].idCompany);
      final listSucursal = await subsidiaryDb
          .obtenerSubsidiaryPorId(listPedidos[i].idSubsidiary);
      final listCompsucursalModel = List<CompanySubsidiaryModel>();

      final compSucursalModel = CompanySubsidiaryModel();

      if (listSucursal.length > 0) {
        //Sucursal
        compSucursalModel.subsidiaryName = listSucursal[0].subsidiaryName;
        compSucursalModel.subsidiaryAddress = listSucursal[0].subsidiaryAddress;
        compSucursalModel.subsidiaryCellphone =
            listSucursal[0].subsidiaryCellphone;
        compSucursalModel.subsidiaryCellphone2 =
            listSucursal[0].subsidiaryCellphone2;
        compSucursalModel.subsidiaryEmail = listSucursal[0].subsidiaryEmail;
        compSucursalModel.subsidiaryCoordX = listSucursal[0].subsidiaryCoordX;
        compSucursalModel.subsidiaryCoordY = listSucursal[0].subsidiaryCoordY;
        compSucursalModel.subsidiaryOpeningHours =
            listSucursal[0].subsidiaryOpeningHours;
        compSucursalModel.subsidiaryPrincipal =
            listSucursal[0].subsidiaryPrincipal;
        compSucursalModel.subsidiaryStatus = listSucursal[0].subsidiaryStatus;
      } else {
        print('no hay sucursal');
      }

      if (listCompany.length > 0) {
        //Company
        compSucursalModel.companyName = listCompany[0].companyName;
        compSucursalModel.companyRuc = listCompany[0].companyRuc;
        compSucursalModel.companyImage = listCompany[0].companyImage;
        compSucursalModel.companyType = listCompany[0].companyType;
        compSucursalModel.companyShortcode = listCompany[0].companyShortcode;
        compSucursalModel.companyDeliveryPropio =
            listCompany[0].companyDeliveryPropio;
        compSucursalModel.companyDelivery = listCompany[0].companyDelivery;
        compSucursalModel.companyEntrega = listCompany[0].companyEntrega;
        compSucursalModel.companyTarjeta = listCompany[0].companyTarjeta;
        compSucursalModel.companyVerified = listCompany[0].companyVerified;
        compSucursalModel.companyRating = listCompany[0].companyRating;
        compSucursalModel.companyCreatedAt = listCompany[0].companyCreatedAt;
        compSucursalModel.companyJoin = listCompany[0].companyJoin;
        compSucursalModel.companyStatus = listCompany[0].companyStatus;
        compSucursalModel.companyMt = listCompany[0].companyMt;
      } else {
        print('no hay company');
      }

      listCompsucursalModel.add(compSucursalModel);

      pedidosModel.listCompanySubsidiary = listCompsucursalModel;

      listaGeneral.add(pedidosModel);
    }

    return listaGeneral;
  }

  Future<List<PedidosModel>> obtnerDetallePedidosEnviados(
      String idEstado) async {
    List<PedidosModel> listaGeneral = List<PedidosModel>();

    //obtener todos los pedidos de la bd
    final listPedidos = await pedidoDb.obtenerPedidosXidEstado(idEstado);
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
      final listdetallePedido = await detallePedidoDb
          .obtenerDetallePedidoxIdPedido(listPedidos[i].idPedido);
      //crear lista vacia para llenar el detalle del pedido
      final listDetallePedidoModel = List<DetallePedidoModel>();

      // recorrer la tabla de detalle de pedido
      for (var j = 0; j < listdetallePedido.length; j++) {
        final detallePedido = DetallePedidoModel();

        detallePedido.idDetallePedido = listdetallePedido[j].idDetallePedido;
        detallePedido.detallePedidoValorado = listdetallePedido[j].idPedido;
        detallePedido.idProducto = listdetallePedido[j].idProducto;
        detallePedido.cantidad = listdetallePedido[j].cantidad;
        detallePedido.detallePedidoMarca =
            listdetallePedido[j].detallePedidoMarca;
        detallePedido.detallePedidoModelo =
            listdetallePedido[j].detallePedidoModelo;
        detallePedido.detallePedidoTalla =
            listdetallePedido[j].detallePedidoTalla;
        detallePedido.detallePedidoValorado =
            listdetallePedido[j].detallePedidoValorado;
        detallePedido.detallePedidoSubtotal =
            listdetallePedido[j].detallePedidoSubtotal;

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
          productoModel.productoSize = listProductos[0].productoSize;
          productoModel.productoStock = listProductos[0].productoStock;
          productoModel.productoStockStatus =
              listProductos[0].productoStockStatus;
          productoModel.productoMeasure = listProductos[0].productoMeasure;

          listProductosModel.add(productoModel);
        }
        detallePedido.listProducto = listProductosModel;

        listDetallePedidoModel.add(detallePedido);
      }

      pedidosModel.detallePedido = listDetallePedidoModel;

      //------Recorrer la lista de compañías y sucursales---------

      //funcion que llama desde la bd a todas las sucursales y compañías
      final listCompany =
          await companyDb.obtenerCompanyPorIdCompany(listPedidos[i].idCompany);
      final listSucursal = await subsidiaryDb
          .obtenerSubsidiaryPorId(listPedidos[i].idSubsidiary);
      final listCompsucursalModel = List<CompanySubsidiaryModel>();

      final compSucursalModel = CompanySubsidiaryModel();

      if (listSucursal.length > 0) {
        //Sucursal
        compSucursalModel.subsidiaryName = listSucursal[0].subsidiaryName;
        compSucursalModel.subsidiaryAddress = listSucursal[0].subsidiaryAddress;
        compSucursalModel.subsidiaryCellphone =
            listSucursal[0].subsidiaryCellphone;
        compSucursalModel.subsidiaryCellphone2 =
            listSucursal[0].subsidiaryCellphone2;
        compSucursalModel.subsidiaryEmail = listSucursal[0].subsidiaryEmail;
        compSucursalModel.subsidiaryCoordX = listSucursal[0].subsidiaryCoordX;
        compSucursalModel.subsidiaryCoordY = listSucursal[0].subsidiaryCoordY;
        compSucursalModel.subsidiaryOpeningHours =
            listSucursal[0].subsidiaryOpeningHours;
        compSucursalModel.subsidiaryPrincipal =
            listSucursal[0].subsidiaryPrincipal;
        compSucursalModel.subsidiaryStatus = listSucursal[0].subsidiaryStatus;
      } else {
        print('no hay sucursal');
      }

      if (listCompany.length > 0) {
        //Company
        compSucursalModel.companyName = listCompany[0].companyName;
        compSucursalModel.companyRuc = listCompany[0].companyRuc;
        compSucursalModel.companyImage = listCompany[0].companyImage;
        compSucursalModel.companyType = listCompany[0].companyType;
        compSucursalModel.companyShortcode = listCompany[0].companyShortcode;
        compSucursalModel.companyDeliveryPropio =
            listCompany[0].companyDeliveryPropio;
        compSucursalModel.companyDelivery = listCompany[0].companyDelivery;
        compSucursalModel.companyEntrega = listCompany[0].companyEntrega;
        compSucursalModel.companyTarjeta = listCompany[0].companyTarjeta;
        compSucursalModel.companyVerified = listCompany[0].companyVerified;
        compSucursalModel.companyRating = listCompany[0].companyRating;
        compSucursalModel.companyCreatedAt = listCompany[0].companyCreatedAt;
        compSucursalModel.companyJoin = listCompany[0].companyJoin;
        compSucursalModel.companyStatus = listCompany[0].companyStatus;
        compSucursalModel.companyMt = listCompany[0].companyMt;
      } else {
        print('no hay company');
      }

      listCompsucursalModel.add(compSucursalModel);

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
