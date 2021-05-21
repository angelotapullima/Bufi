import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:bufi/src/database/carrito_db.dart';
import 'package:bufi/src/database/pedidos_db.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/database/subsidiary_db.dart';
import 'package:bufi/src/models/PedidosModel.dart';
import 'package:bufi/src/models/carritoGeneralModel..dart';
import 'package:bufi/src/models/carritoModel.dart';
import 'package:bufi/src/database/company_db.dart';
import 'package:bufi/src/database/detallePedido_database.dart';
import 'package:bufi/src/database/good_db.dart';
import 'package:bufi/src/models/DetallePedidoModel.dart';
import 'package:bufi/src/models/companyModel.dart';
import 'package:bufi/src/models/goodModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class PedidoApi {
  final prefs = new Preferences();

  final pedidoDb = PedidosDatabase();
  final companyDb = CompanyDatabase();
  final detallePedidoDb = DetallePedidoDatabase();
  final sucursalDb = SubsidiaryDatabase();
  final goodDb = GoodDatabase();

  Future<dynamic> obtenerPedidosEnviados(String idEstado) async {
    final response = await http.post(
        Uri.parse("$apiBaseURL/api/Pedido/buscar_pedidos_enviados_ws"),
        body: {'estado': '$idEstado', 'tn': prefs.token, 'app': 'true'});

    final decodedData = json.decode(response.body);
//recorremos la lista de pedidos‹
    for (var i = 0; i < decodedData["result"].length; i++) {
      final pedidosModel = PedidosModel();

      pedidosModel.idPedido = decodedData["result"][i]['id_delivery'];
      pedidosModel.idUser = decodedData["result"][i]['id_user'];
      pedidosModel.idCity = decodedData["result"][i]['id_city'];
      pedidosModel.idSubsidiary = decodedData["result"][i]['id_subsidiary'];
      pedidosModel.idCompany = decodedData["result"][i]['id_company'];
      pedidosModel.deliveryNumber = decodedData["result"][i]['delivery_number'];
      pedidosModel.deliveryName = decodedData["result"][i]['delivery_name'];
      pedidosModel.deliveryEmail = decodedData["result"][i]['delivery_email'];
      pedidosModel.deliveryCel = decodedData["result"][i]['delivery_cel'];
      pedidosModel.deliveryAddress =
          decodedData["result"][i]['delivery_address'];
      pedidosModel.deliveryDescription =
          decodedData["result"][i]['delivery_description'];
      pedidosModel.deliveryCoordX =
          decodedData["result"][i]['delivery_coord_x'];
      pedidosModel.deliveryCoordY =
          decodedData["result"][i]['delivery_coord_y'];
      pedidosModel.deliveryAddInfo =
          decodedData["result"][i]['delivery_add_info'];
      pedidosModel.deliveryPrice = decodedData["result"][i]['delivery_price'];
      pedidosModel.deliveryTotalOrden =
          decodedData["result"][i]['delivery_total_orden'];
      pedidosModel.deliveryPayment =
          decodedData["result"][i]['delivery_payment'];
      pedidosModel.deliveryEntrega =
          decodedData["result"][i]['delivery_entrega'];
      pedidosModel.deliveryDatetime =
          decodedData["result"][i]['delivery_datetime'];
      pedidosModel.deliveryStatus = decodedData["result"][i]['delivery_status'];
      pedidosModel.deliveryMt = decodedData["result"][i]['delivery_mt'];
      //insertar a la tabla de Pedidos
      await pedidoDb.insertarPedido(pedidosModel);

      final sucursalModel = SubsidiaryModel();

      sucursalModel.idSubsidiary = decodedData["result"][i]['id_subsidiary'];
      sucursalModel.idCompany = decodedData["result"][i]['id_company'];
      sucursalModel.subsidiaryName =
          decodedData["result"][i]['subsidiary_name'];
      sucursalModel.subsidiaryAddress =
          decodedData["result"][i]['subsidiary_address'];
      sucursalModel.subsidiaryCellphone =
          decodedData["result"][i]['subsidiary_cellphone'];
      sucursalModel.subsidiaryCellphone2 =
          decodedData["result"][i]['subsidiary_cellphone2'];
      sucursalModel.subsidiaryEmail =
          decodedData["result"][i]['subsidiary_email'];
      sucursalModel.subsidiaryCoordX =
          decodedData["result"][i]['subsidiary_coord_x'];
      sucursalModel.subsidiaryCoordY =
          decodedData["result"][i]['subsidiary_coord_y'];
      sucursalModel.subsidiaryOpeningHours =
          decodedData["result"][i]['subsidiary_opening_hours'];
      sucursalModel.subsidiaryPrincipal =
          decodedData["result"][i]['subsidiary_principal'];
      sucursalModel.subsidiaryStatus =
          decodedData["result"][i]['subsidiary_status'];
      sucursalModel.subsidiaryImg = decodedData["result"][i]['subsidiary_img'];

      //Obtener la lista de sucursales para asignar a favoritos
      final list = await sucursalDb
          .obtenerSubsidiaryPorId(decodedData["result"][i]['id_subsidiary']);

      if (list.length > 0) {
        sucursalModel.subsidiaryFavourite = list[0].subsidiaryFavourite;
      } else {
        sucursalModel.subsidiaryFavourite = "0";
      }
      //insertar a la tabla sucursal
      await sucursalDb.insertarSubsidiary(sucursalModel);

      final companyModel = CompanyModel();
      companyModel.idCompany = decodedData["result"][i]['id_company'];
      companyModel.idUser = decodedData["result"][i]['id_user'];
      companyModel.idCity = decodedData["result"][i]['id_city'];
      companyModel.idCategory = decodedData["result"][i]['id_category'];
      companyModel.companyName = decodedData["result"][i]['company_name'];
      companyModel.companyRuc = decodedData["result"][i]['company_ruc'];
      companyModel.companyImage = decodedData["result"][i]['company_image'];
      companyModel.companyType = decodedData["result"][i]['company_type'];
      companyModel.companyShortcode =
          decodedData["result"][i]['company_shortcode'];
      companyModel.companyDeliveryPropio =
          decodedData["result"][i]['company_delivery_propio'];
      companyModel.companyDelivery =
          decodedData["result"][i]['company_delivery'];
      companyModel.companyEntrega = decodedData["result"][i]['company_entrega'];
      companyModel.companyTarjeta = decodedData["result"][i]['company_tarjeta'];
      companyModel.companyVerified =
          decodedData["result"][i]['company_verified'];
      companyModel.companyRating = decodedData["result"][i]['company_rating'];
      companyModel.companyCreatedAt =
          decodedData["result"][i]['company_created_at'];
      companyModel.companyJoin = decodedData["result"][i]['company_join'];
      companyModel.companyStatus = decodedData["result"][i]['company_status'];
      companyModel.companyMt = decodedData["result"][i]['company_mt'];
      companyModel.miNegocio = decodedData["result"][i]['mi_negocio'];

      //Obtener la lista de Company
      final listCompany = await companyDb
          .obtenerCompanyPorIdCompany(decodedData["result"][i]['id_company']);

      if (listCompany.length > 0) {
        companyModel.miNegocio = listCompany[0].miNegocio;
      } else {
        companyModel.miNegocio = "";
      }
      //insertar a la tabla de Company
      await companyDb.insertarCompany(companyModel);

      //recorremos la segunda lista de detalle de pedidos
      for (var j = 0;
          j < decodedData["result"][i]["detalle_pedido"].length;
          j++) {
        final detallePedido = DetallePedidoModel();
        detallePedido.idDetallePedido =
            decodedData["result"][i]["detalle_pedido"][j]["id_delivery_detail"];
        detallePedido.idPedido =
            decodedData["result"][i]["detalle_pedido"][j]["id_delivery"];
        detallePedido.idProducto =
            decodedData["result"][i]["detalle_pedido"][j]["id_subsidiarygood"];
        detallePedido.cantidad = decodedData["result"][i]["detalle_pedido"][j]
            ["delivery_detail_qty"];
        detallePedido.detallePedidoValorado = decodedData["result"][i]
                ["detalle_pedido"][j]["valorado"]
            .toString();
        detallePedido.detallePedidoSubtotal = decodedData["result"][i]
            ["detalle_pedido"][j]["delivery_detail_subtotal"];

        //insertamos en la bd los productos
        ProductoModel subsidiaryGoodModel = ProductoModel();
        final productoDb = ProductoDatabase();
        subsidiaryGoodModel.idProducto =
            decodedData["result"][i]["detalle_pedido"][j]['id_subsidiarygood'];
        subsidiaryGoodModel.idSubsidiary =
            decodedData["result"][i]["detalle_pedido"][j]['id_subsidiary'];
        subsidiaryGoodModel.idGood =
            decodedData["result"][i]["detalle_pedido"][j]['id_good'];
        subsidiaryGoodModel.productoName = decodedData["result"][i]
            ["detalle_pedido"][j]['subsidiary_good_name'];
        subsidiaryGoodModel.productoPrice = decodedData["result"][i]
            ["detalle_pedido"][j]['subsidiary_good_price'];
        subsidiaryGoodModel.productoCurrency = decodedData["result"][i]
            ["detalle_pedido"][j]['subsidiary_good_currency'];
        subsidiaryGoodModel.productoImage = decodedData["result"][i]
            ["detalle_pedido"][j]['subsidiary_good_image'];
        subsidiaryGoodModel.productoCharacteristics = decodedData["result"][i]
            ["detalle_pedido"][j]['subsidiary_good_characteristics'];
        subsidiaryGoodModel.productoBrand = decodedData["result"][i]
            ["detalle_pedido"][j]['subsidiary_good_brand'];
        subsidiaryGoodModel.productoModel = decodedData["result"][i]
            ["detalle_pedido"][j]['subsidiary_good_model'];
        subsidiaryGoodModel.productoType = decodedData["result"][i]
            ["detalle_pedido"][j]['subsidiary_good_type'];
        subsidiaryGoodModel.productoSize = decodedData["result"][i]
            ["detalle_pedido"][j]['subsidiary_good_size'];
        subsidiaryGoodModel.productoStock = decodedData["result"][i]
            ["detalle_pedido"][j]['subsidiary_good_stock'];
        subsidiaryGoodModel.productoMeasure = decodedData["result"][i]
            ["detalle_pedido"][j]['subsidiary_good_stock_measure'];
        subsidiaryGoodModel.productoRating = decodedData["result"][i]
            ["detalle_pedido"][j]['subsidiary_good_rating'];
        subsidiaryGoodModel.productoUpdated = decodedData["result"][i]
            ["detalle_pedido"][j]['subsidiary_good_updated'];
        subsidiaryGoodModel.productoStatus = decodedData["result"][i]
            ["detalle_pedido"][j]['subsidiary_good_status'];

        //Obtener la lista de Company
        final listProducto = await productoDb
            .obtenerProductoPorIdSubsidiaryGood(decodedData["result"][i]
                ["detalle_pedido"][j]['id_subsidiarygood']);

        if (listProducto.length > 0) {
          subsidiaryGoodModel.productoFavourite =
              listProducto[0].productoFavourite;
        } else {
          subsidiaryGoodModel.productoFavourite = "";
        }
        //insertar a la tabla Producto
        await productoDb.insertarProducto(subsidiaryGoodModel);

        //insertamos en la bd el bien
        final goodModel = BienesModel();
        goodModel.idGood =
            decodedData["result"][i]["detalle_pedido"][j]['id_good'];
        goodModel.goodName =
            decodedData["result"][i]["detalle_pedido"][j]['good_name'];
        goodModel.goodSynonyms =
            decodedData["result"][i]["detalle_pedido"][j]['good_synonyms'];
        //insertar a la tabla de Company
        await goodDb.insertarGood(goodModel);

        //insertar a la tabla de Detalle de Pedidos
        await detallePedidoDb.insertarDetallePedido(detallePedido);
      }
    }
    //print(decodedData);
    return 0;
  }

  Future<List<PedidosModel>> enviarPedido() async {
    final List<PedidosModel> listRespuesta = [];
    final listDePedidos = await carritoPorSucursalSeleccionado();

    String sucursales = '';
    for (var i = 0; i < listDePedidos.length; i++) {
      for (var i = 0; i < listDePedidos[0].car.length; i++) {
        String producto = '';

        //sucursales son los datos por sucursal (Id de la sucursal , monto de pedidos por sucursal , tipo de entrega, y la descripcion)
        sucursales = sucursales +
            '${listDePedidos[0].car[i].idSubsidiary},,,${listDePedidos[0].car[i].monto},,,1,,,descripcion,,,';

        //producto son los datos de los productos por sucursal
        for (var x = 0; x < listDePedidos[0].car[i].carrito.length; x++) {
          producto = producto +
              '${listDePedidos[0].car[i].carrito[x].idSubsidiaryGood}++++${listDePedidos[0].car[i].carrito[x].cantidad}++++${listDePedidos[0].car[i].carrito[x].marca}++++${listDePedidos[0].car[i].carrito[x].modelo}++++${listDePedidos[0].car[i].carrito[x].talla}';
          producto = producto + '.--.';
        }

        sucursales = sucursales + producto + './*';
      }
    }

    final response = await http.post(
      Uri.parse("$apiBaseURL/api/Pedido/pedir_orden_ws"),
      body: {
        'id_usuario': prefs.idUser,
        'id_ciudad': '1',
        'name': prefs.personName,
        'surname': prefs.personName,
        'email': prefs.userEmail,
        'cel': '978400573',
        'address': 'calle girasoles sin numero',
        'coord_x': '-3.859949494',
        'coord_y': '-73.859949494',
        'total': listDePedidos[0].montoGeneral.toString(),
        'payment': '',
        'add_info': '',
        //'entrega': '1',
        'pedidos': sucursales.toString(),
        'tn': prefs.token,
        'app': 'true'
      },
    );

    final decodedData = json.decode(response.body);

    final pedidosModel = PedidosModel();

    pedidosModel.idPedido =
        decodedData["result"]['pedido']['id_delivery'].toString();
    pedidosModel.idUser = decodedData["result"]['pedido']['id_user'];
    pedidosModel.idCity = decodedData["result"]['pedido']['id_city'];
    pedidosModel.idSubsidiary =
        decodedData["result"]['pedido']['id_subsidiary'];
    pedidosModel.idCompany =
        decodedData["result"]['pedido']["detalle_pedido"][0]['id_company'];
    pedidosModel.deliveryNumber =
        decodedData["result"]['pedido']['delivery_number'];
    pedidosModel.deliveryName =
        decodedData["result"]['pedido']['delivery_name'];
    pedidosModel.deliveryEmail =
        decodedData["result"]['pedido']['delivery_email'];
    pedidosModel.deliveryCel = decodedData["result"]['pedido']['delivery_cel'];
    pedidosModel.deliveryAddress =
        decodedData["result"]['pedido']['delivery_address'];
    pedidosModel.deliveryDescription =
        decodedData["result"]['pedido']['delivery_description'];
    pedidosModel.deliveryCoordX =
        decodedData["result"]['pedido']['delivery_coord_x'];
    pedidosModel.deliveryCoordY =
        decodedData["result"]['pedido']['delivery_coord_y'];
    pedidosModel.deliveryAddInfo =
        decodedData["result"]['pedido']['delivery_add_info'];
    pedidosModel.deliveryPrice =
        decodedData["result"]['pedido']['delivery_price'];
    pedidosModel.deliveryTotalOrden =
        decodedData["result"]['pedido']['delivery_total_orden'];
    pedidosModel.deliveryPayment =
        decodedData["result"]['pedido']['delivery_payment'];
    pedidosModel.deliveryEntrega =
        decodedData["result"]['pedido']['delivery_entrega'];
    pedidosModel.deliveryDatetime =
        decodedData["result"]['pedido']['delivery_datetime'];
    pedidosModel.deliveryStatus =
        decodedData["result"]['pedido']['delivery_status'];
    pedidosModel.deliveryMt = decodedData["result"]['pedido']['delivery_mt'];
    pedidosModel.respuestaApi = decodedData["result"]['code'].toString();
    //insertar a la tabla de Pedidos
    await pedidoDb.insertarPedido(pedidosModel);

    if (decodedData["result"]['pedido']['detalle_pedido'].length > 0) {
      for (var j = 0;
          j < decodedData["result"]['pedido']["detalle_pedido"].length;
          j++) {
        final detallePedido = DetallePedidoModel();
        detallePedido.idDetallePedido = decodedData["result"]['pedido']
            ["detalle_pedido"][j]["id_delivery_detail"];
        detallePedido.idPedido =
            decodedData["result"]['pedido']["detalle_pedido"][j]["id_delivery"];
        detallePedido.idProducto = decodedData["result"]['pedido']
            ["detalle_pedido"][j]["id_subsidiarygood"];
        detallePedido.cantidad = decodedData["result"]['pedido']
            ["detalle_pedido"][j]["delivery_detail_qty"];
        //agregado rcientemente
        detallePedido.detallePedidoMarca = decodedData["result"]['pedido']
            ["detalle_pedido"][j]["delivery_detail_brand"];
        detallePedido.detallePedidoModelo = decodedData["result"]['pedido']
            ["detalle_pedido"][j]["delivery_detail_model"];
        detallePedido.detallePedidoTalla = decodedData["result"]['pedido']
            ["detalle_pedido"][j]["delivery_detail_size"];
        //   detallePedido.detallePedidoValorado = decodedData["result"]['pedido']
        // ["detalle_pedido"][j]["valorado"];
        detallePedido.detallePedidoSubtotal = decodedData["result"]['pedido']
            ["detalle_pedido"][j]["delivery_detail_subtotal"];

        //insertamos en la bd los productos
        ProductoModel subsidiaryGoodModel = ProductoModel();
        final productoDb = ProductoDatabase();
        subsidiaryGoodModel.idProducto = decodedData["result"]['pedido']
            ["detalle_pedido"][j]['id_subsidiarygood'];
        subsidiaryGoodModel.idSubsidiary = decodedData["result"]['pedido']
            ["detalle_pedido"][j]['id_subsidiary'];
        subsidiaryGoodModel.productoName = decodedData["result"]['pedido']
            ["detalle_pedido"][j]['subsidiary_good_name'];
        subsidiaryGoodModel.productoPrice = decodedData["result"]['pedido']
            ["detalle_pedido"][j]['subsidiary_good_price'];
        subsidiaryGoodModel.productoCurrency = decodedData["result"]['pedido']
            ["detalle_pedido"][j]['subsidiary_good_currency'];
        subsidiaryGoodModel.productoImage = decodedData["result"]['pedido']
            ["detalle_pedido"][j]['subsidiary_good_image'];
        subsidiaryGoodModel.productoCharacteristics = decodedData["result"]
            ['pedido']["detalle_pedido"][j]['subsidiary_good_characteristics'];
        subsidiaryGoodModel.productoBrand = decodedData["result"]['pedido']
            ["detalle_pedido"][j]['subsidiary_good_brand'];
        subsidiaryGoodModel.productoModel = decodedData["result"]['pedido']
            ["detalle_pedido"][j]['subsidiary_good_model'];
        subsidiaryGoodModel.productoType = decodedData["result"]['pedido']
            ["detalle_pedido"][j]['subsidiary_good_type'];
        subsidiaryGoodModel.productoSize = decodedData["result"]['pedido']
            ["detalle_pedido"][j]['subsidiary_good_size'];
        subsidiaryGoodModel.productoStock = decodedData["result"]['pedido']
            ["detalle_pedido"][j]['subsidiary_good_stock'];
        subsidiaryGoodModel.productoMeasure = decodedData["result"]['pedido']
            ["detalle_pedido"][j]['subsidiary_good_stock_measure'];
        subsidiaryGoodModel.productoRating = decodedData["result"]['pedido']
            ["detalle_pedido"][j]['subsidiary_good_rating'];
        subsidiaryGoodModel.productoUpdated = decodedData["result"]['pedido']
            ["detalle_pedido"][j]['subsidiary_good_updated'];
        subsidiaryGoodModel.productoStatus = decodedData["result"]['pedido']
            ["detalle_pedido"][j]['subsidiary_good_status'];

        var productList = await productoDb.obtenerProductoPorIdSubsidiaryGood(
            decodedData["result"]['pedido']["detalle_pedido"][j]
                ['id_subsidiarygood']);

        if (productList.length > 0) {
          subsidiaryGoodModel.productoFavourite =
              productList[0].productoFavourite;
        } else {
          subsidiaryGoodModel.productoFavourite = '0';
        }

        //insertar a la tabla Producto
        await productoDb.insertarProducto(subsidiaryGoodModel);

        final sucursalModel = SubsidiaryModel();
        sucursalModel.idSubsidiary = decodedData["result"]['pedido']
            ["detalle_pedido"][j]['id_subsidiary'];
        sucursalModel.idCompany =
            decodedData["result"]['pedido']["detalle_pedido"][j]['id_company'];
        sucursalModel.subsidiaryName = decodedData["result"]['pedido']
            ["detalle_pedido"][j]['subsidiary_name'];
        sucursalModel.subsidiaryAddress = decodedData["result"]['pedido']
            ["detalle_pedido"][j]['subsidiary_address'];
        sucursalModel.subsidiaryCellphone = decodedData["result"]['pedido']
            ["detalle_pedido"][j]['subsidiary_cellphone'];
        sucursalModel.subsidiaryCellphone2 = decodedData["result"]['pedido']
            ["detalle_pedido"][j]['subsidiary_cellphone2'];
        sucursalModel.subsidiaryEmail = decodedData["result"]['pedido']
            ["detalle_pedido"][j]['subsidiary_email'];
        sucursalModel.subsidiaryCoordX = decodedData["result"]['pedido']
            ["detalle_pedido"][j]['subsidiary_coord_x'];
        sucursalModel.subsidiaryCoordY = decodedData["result"]['pedido']
            ["detalle_pedido"][j]['subsidiary_coord_y'];
        sucursalModel.subsidiaryOpeningHours = decodedData["result"]['pedido']
            ["detalle_pedido"][j]['subsidiary_opening_hours'];
        sucursalModel.subsidiaryPrincipal = decodedData["result"]['pedido']
            ["detalle_pedido"][j]['subsidiary_principal'];
        sucursalModel.subsidiaryStatus = decodedData["result"]['pedido']
            ["detalle_pedido"][j]['subsidiary_status'];
        sucursalModel.subsidiaryImg = decodedData["result"]['pedido']
            ["detalle_pedido"][j]['subsidiary_img'];

        //Obtener la lista de sucursales para asignar a favoritos
        final list = await sucursalDb.obtenerSubsidiaryPorId(
            decodedData["result"]['pedido']["detalle_pedido"][j]
                ['id_subsidiary']);

        if (list.length > 0) {
          sucursalModel.subsidiaryFavourite = list[0].subsidiaryFavourite;
        } else {
          sucursalModel.subsidiaryFavourite = "0";
        }
        //insertar a la tabla sucursal
        await sucursalDb.insertarSubsidiary(sucursalModel);

        //insertamos en la bd el bien
        final goodModel = BienesModel();
        goodModel.idGood =
            decodedData["result"]['pedido']["detalle_pedido"][j]['id_good'];
        goodModel.goodName =
            decodedData["result"]['pedido']["detalle_pedido"][j]['good_name'];
        goodModel.goodSynonyms = decodedData["result"]['pedido']
            ["detalle_pedido"][j]['good_synonyms'];
        //insertar a la tabla de Company
        await goodDb.insertarGood(goodModel);

        //insertar a la tabla de Detalle de Pedidos
        await detallePedidoDb.insertarDetallePedido(detallePedido);
      }
    }

    listRespuesta.add(pedidosModel);

    return listRespuesta;
  }

  Future<List<CarritoGeneralSuperior>> carritoPorSucursalSeleccionado() async {
    final List<CarritoGeneralSuperior> listaGeneralCarrito = [];
    final List<CarritoGeneralModel> listaGeneral = [];
    final carritoDb = CarritoDb();
    final List<String> listaDeStringDeIds = [];
    final subsidiary = SubsidiaryDatabase();

    double cantidadTotalSucursal = 0;
    double cantidadTotalGeneral = 0;

    int cantidad = 0;

    //funcion que trae los datos del carrito agrupados por iDSubsidiary para que no se repitan los IDSubsidiary
    final listCarritoAgrupados =
        await carritoDb.obtenerProductosSeleccionadoAgrupados();

    //llenamos la lista de String(listaDeStringDeIds) con los datos agrupados que llegan (listCarritoAgrupados)
    for (var i = 0; i < listCarritoAgrupados.length; i++) {
      var id = listCarritoAgrupados[i].idSubsidiary;
      listaDeStringDeIds.add(id);
    }

    //obtenemos todos los elementos del carrito
    final listCarrito = await carritoDb.obtenerProductoXCarritoSeleccionado();
    for (var x = 0; x < listaDeStringDeIds.length; x++) {
      //función para obtener los datos de la sucursal para despues usar el nombre
      final sucursal =
          await subsidiary.obtenerSubsidiaryPorId(listaDeStringDeIds[x]);

      final List<CarritoModel> listCarritoModel = [];

      CarritoGeneralModel carritoGeneralModel = CarritoGeneralModel();

      //agregamos el nombre de la sucursal con los datos antes obtenidos (sucursal)
      carritoGeneralModel.nombreSucursal = sucursal[0].subsidiaryName;
      carritoGeneralModel.idSubsidiary = sucursal[0].idSubsidiary;
      for (var y = 0; y < listCarrito.length; y++) {
        //cuando hay coincidencia de id's procede a agregar los datos a la lista
        if (listaDeStringDeIds[x] == listCarrito[y].idSubsidiary) {
          if (listCarrito[y].estadoSeleccionado == '1') {
            double precio = double.parse(listCarrito[y].precio);
            int cant = int.parse(listCarrito[y].cantidad);

            cantidadTotalSucursal = cantidadTotalSucursal + (precio * cant);
            cantidadTotalGeneral = cantidadTotalGeneral + (precio * cant);
          }

          CarritoModel c = CarritoModel();

          c.precio = listCarrito[y].precio;
          c.idSubsidiary = listCarrito[y].idSubsidiary;
          c.idSubsidiaryGood = listCarrito[y].idSubsidiaryGood;
          c.nombre = listCarrito[y].nombre;
          c.marca = listCarrito[y].marca;
          c.modelo = listCarrito[y].modelo;
          c.talla = listCarrito[y].talla;
          c.image = listCarrito[y].image;
          c.moneda = listCarrito[y].moneda;
          //c.size = listCarrito[y].size;
          c.caracteristicas = listCarrito[y].caracteristicas;
          c.estadoSeleccionado = listCarrito[y].estadoSeleccionado;
          c.cantidad = listCarrito[y].cantidad;

          listCarritoModel.add(c);
          cantidad++;
        }
      }

      carritoGeneralModel.carrito = listCarritoModel;
      carritoGeneralModel.monto = cantidadTotalSucursal.toString();

      cantidadTotalSucursal = 0;

      listaGeneral.add(carritoGeneralModel);
    }

    CarritoGeneralSuperior carritoGeneralSuperior = CarritoGeneralSuperior();
    carritoGeneralSuperior.car = listaGeneral;
    carritoGeneralSuperior.cantidadArticulos = cantidad.toString();
    carritoGeneralSuperior.montoGeneral = cantidadTotalGeneral.toString();

    listaGeneralCarrito.add(carritoGeneralSuperior);

    return listaGeneralCarrito;
  }

  Future<int> valoracion(File _image, String idProducto, String idPedido,
      String comentario, String valoracion) async {
    final preferences = Preferences();
    var multipartFile;
    // open a byteStream
    if (_image != null) {
      var stream = new http.ByteStream(Stream.castFrom(_image.openRead()));
      // get file length
      var length = await _image.length();
      multipartFile = new http.MultipartFile('imagen', stream, length,
          filename: basename(_image.path));
    }

    // string to uri
    var uri = Uri.parse("$apiBaseURL/api/Pedido/valorar_pedido");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // if you need more parameters to parse, add those like this. i added "user_id". here this "user_id" is a key of the API request
    request.fields["tn"] = preferences.token;
    request.fields["app"] = 'true';
    request.fields["id_subsidiary_good"] = idProducto;
    request.fields["id_delivery"] = idPedido;
    request.fields["valoracion"] = valoracion;
    request.fields["comentario"] = comentario;

    // multipart that takes file.. here this "image_file" is a key of the API request

    // add file to multipart
    if (_image != null) request.files.add(multipartFile);

    // send request to upload image
    await request.send().then((response) async {
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        // print(value);

        final decodedData = json.decode(value);
        final int code = decodedData;

        if (code == 1) {
          return 1;
        } else if (code == 2) {
          return 2;
        } else {
          return code;
        }
      });
    }).catchError((e) {
      print(e);
    });
    return 1;
  }
}
