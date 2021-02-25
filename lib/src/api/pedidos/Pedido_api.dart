import 'dart:convert';
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
  final detallePedidoDb = DetallePedidoDatabase();

  Future<dynamic> obtenerPedidosEnviados(String idEstado) async {
    final response = await http
        .post("$apiBaseURL/api/Pedido/buscar_pedidos_enviados_ws", body: {
      'estado': '99',
      'tn': prefs.token,
      'app': 'true'
    });

    final decodedData = json.decode(response.body);

//recorremos la lista de pedidos
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
      pedidosModel.deliveryAddress = decodedData["result"][i]['delivery_address'];
      pedidosModel.deliveryDescription = decodedData["result"][i]['delivery_description'];
      pedidosModel.deliveryCoordX = decodedData["result"][i]['delivery_coord_x'];
      pedidosModel.deliveryCoordY = decodedData["result"][i]['delivery_coord_y'];
      pedidosModel.deliveryAddInfo = decodedData["result"][i]['delivery_add_info'];
      pedidosModel.deliveryPrice = decodedData["result"][i]['delivery_price'];
      pedidosModel.deliveryTotalOrden = decodedData["result"][i]['delivery_total_orden'];
      pedidosModel.deliveryPayment = decodedData["result"][i]['delivery_payment'];
      pedidosModel.deliveryEntrega = decodedData["result"][i]['delivery_entrega'];
      pedidosModel.deliveryDatetime = decodedData["result"][i]['delivery_datetime'];
      pedidosModel.deliveryStatus = decodedData["result"][i]['delivery_status'];
      pedidosModel.deliveryMt = decodedData["result"][i]['delivery_mt'];
      //insertar a la tabla de Pedidos
      await pedidoDb.insertarPedido(pedidosModel);

      final sucursalModel = SubsidiaryModel();
      final sucursalDb = SubsidiaryDatabase();
      sucursalModel.subsidiaryName = decodedData["result"][i]['subsidiary_name'];
      sucursalModel.subsidiaryAddress = decodedData["result"][i]['subsidiary_address'];
      sucursalModel.subsidiaryCellphone =
          decodedData["result"][i]['subsidiary_cellphone'];
      sucursalModel.subsidiaryCellphone2 =
          decodedData["result"][i]['subsidiary_cellphone2'];
      sucursalModel.subsidiaryEmail = decodedData["result"][i]['subsidiary_email'];
      sucursalModel.subsidiaryCoordX = decodedData["result"][i]['subsidiary_coord_x'];
      sucursalModel.subsidiaryCoordY = decodedData["result"][i]['subsidiary_coord_y'];
      sucursalModel.subsidiaryOpeningHours =
          decodedData["result"][i]['subsidiary_opening_hours'];
      sucursalModel.subsidiaryPrincipal =
          decodedData["result"][i]['subsidiary_principal'];
      sucursalModel.subsidiaryStatus = decodedData["result"][i]['subsidiary_status'];
       //insertar a la tabla sucursal
      await sucursalDb.insertarSubsidiary(sucursalModel);

      final companyModel = CompanyModel();
      final companyDb = CompanyDatabase();
      companyModel.idCategory = decodedData["result"][i]['id_category'];
      companyModel.companyName = decodedData["result"][i]['company_name'];
      companyModel.companyRuc = decodedData["result"][i]['company_ruc'];
      companyModel.companyImage = decodedData["result"][i]['company_image'];
      companyModel.companyType = decodedData["result"][i]['company_type'];
      companyModel.companyShortcode = decodedData["result"][i]['company_shortcode'];
      companyModel.companyDeliveryPropio = decodedData["result"][i]['company_delivery_propio'];
      companyModel.companyDelivery = decodedData["result"][i]['company_delivery'];
      companyModel.companyEntrega = decodedData["result"][i]['company_entrega'];
      companyModel.companyTarjeta = decodedData["result"][i]['company_tarjeta'];
      companyModel.companyVerified = decodedData["result"][i]['company_verified'];
      companyModel.companyRating = decodedData["result"][i]['company_rating'];
      companyModel.companyCreatedAt = decodedData["result"][i]['company_created_at'];
      companyModel.companyJoin = decodedData["result"][i]['company_join'];
      companyModel.companyStatus = decodedData["result"][i]['company_status'];
      companyModel.companyMt = decodedData["result"][i]['company_mt'];
       //insertar a la tabla de Company
      await companyDb.insertarCompany(companyModel);

      //recorremos la segunda lista de detalle de pedidos
      for (var j = 0; j < decodedData["result"][i]["detalle_pedido"].length; j++) {
        final detallePedido = DetallePedidoModel();
        detallePedido.idDetallePedido =decodedData["result"][i]["detalle_pedido"][j]["id_delivery_detail"];
        detallePedido.idPedido =decodedData["result"][i]["detalle_pedido"][j]["id_delivery"];
        detallePedido.idProducto =decodedData["result"][i]["detalle_pedido"][j]["id_subsidiarygood"];
        detallePedido.cantidad =decodedData["result"][i]["detalle_pedido"][j]["delivery_detail_qty"];
        detallePedido.detallePedidoSubtotal =decodedData["result"][i]["detalle_pedido"][j]["delivery_detail_subtotal"];

        //insertamos en la bd los productos
         ProductoModel subsidiaryGoodModel = ProductoModel();
         final productoDb = ProductoDatabase();
         subsidiaryGoodModel.productoName = decodedData["result"][i]["detalle_pedido"][j]['subsidiary_good_name'];
        subsidiaryGoodModel.productoPrice = decodedData["result"][i]["detalle_pedido"][j]['subsidiary_good_price'];
        subsidiaryGoodModel.productoCurrency =
            decodedData["result"][i]["detalle_pedido"][j]['subsidiary_good_currency'];
        subsidiaryGoodModel.productoImage = decodedData["result"][i]["detalle_pedido"][j]['subsidiary_good_image'];
        subsidiaryGoodModel.productoCharacteristics =
            decodedData["result"][i]["detalle_pedido"][j]['subsidiary_good_characteristics'];
        subsidiaryGoodModel.productoBrand = decodedData["result"][i]["detalle_pedido"][j]['subsidiary_good_brand'];
        subsidiaryGoodModel.productoModel = decodedData["result"][i]["detalle_pedido"][j]['subsidiary_good_model'];
        subsidiaryGoodModel.productoType = decodedData["result"][i]["detalle_pedido"][j]['subsidiary_good_type'];
        subsidiaryGoodModel.productoSize = decodedData["result"][i]["detalle_pedido"][j]['subsidiary_good_size'];
        subsidiaryGoodModel.productoStock = decodedData["result"][i]["detalle_pedido"][j]['subsidiary_good_stock'];
        subsidiaryGoodModel.productoMeasure =
            decodedData["result"][i]["detalle_pedido"][j]['subsidiary_good_stock_measure'];
        subsidiaryGoodModel.productoRating =
            decodedData["result"][i]["detalle_pedido"][j]['subsidiary_good_rating'];
        subsidiaryGoodModel.productoUpdated =
            decodedData["result"][i]["detalle_pedido"][j]['subsidiary_good_updated'];
        subsidiaryGoodModel.productoStatus =
            decodedData["result"][i]["detalle_pedido"][j]['subsidiary_good_status'];

      //insertar a la tabla Producto
      await productoDb.insertarProducto(subsidiaryGoodModel);

      //insertamos en la bd el bien
      final goodModel = BienesModel();
      final goodDb = GoodDatabase();
      goodModel.idGood = decodedData["result"][i]['id_good'];
      goodModel.goodName = decodedData["result"][i]['good_name'];
      goodModel.goodSynonyms = decodedData["result"][i]['good_synonyms'];
      //insertar a la tabla de Company
      await goodDb.insertarGood(goodModel);

        //insertar a la tabla de Detalle de Pedidos
      await detallePedidoDb.insertarDetallePedido(detallePedido);
      }
    }
    //print(decodedData);
    return 0;
  }

  Future<dynamic> enviarPedido() async {
    final listDePedidos = await carritoPorSucursalSeleccionado();

    String sucursales = '';
    for (var i = 0; i < listDePedidos.length; i++) {
      for (var i = 0; i < listDePedidos[0].car.length; i++) {
        String producto = '';
        sucursales = sucursales +
            '${listDePedidos[0].car[i].idSubsidiary},,,${listDePedidos[0].car[i].monto},,,1,,,descripcion,,,';

        //producto =  listDePedidos[0].car[i].carrito[0].idSubsidiaryGood;

        for (var x = 0; x < listDePedidos[0].car[i].carrito.length; x++) {
          producto = producto + '${listDePedidos[0].car[i].carrito[x].idSubsidiaryGood}++++${listDePedidos[0].car[i].carrito[x].cantidad}';
          producto = producto + '.-.';
        }

        sucursales = sucursales + producto + './*';
      }

      print(sucursales);
    }

    final response =
        await http.post("$apiBaseURL/api/Pedido/pedir_orden_ws", body: {
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
    });

    final decodedData = json.decode(response.body);

   
    return decodedData;
  }

  Future<List<CarritoGeneralSuperior>> carritoPorSucursalSeleccionado() async {
    final listaGeneralCarrito = List<CarritoGeneralSuperior>();
    final listaGeneral = List<CarritoGeneralModel>();
    final carritoDb = CarritoDb();
    final listaDeStringDeIds = List<String>();
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

      final listCarritoModel = List<CarritoModel>();

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

            print('tamare $cantidadTotalSucursal');
          }

          CarritoModel c = CarritoModel();

          c.precio = listCarrito[y].precio;
          c.idSubsidiary = listCarrito[y].idSubsidiary;
          c.idSubsidiaryGood = listCarrito[y].idSubsidiaryGood;
          c.nombre = listCarrito[y].nombre;
          c.marca = listCarrito[y].marca;
          c.image = listCarrito[y].image;
          c.moneda = listCarrito[y].moneda;
          c.size = listCarrito[y].size;
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
}
