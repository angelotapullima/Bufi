import 'dart:convert';
import 'package:bufi/src/database/carrito_db.dart';
import 'package:bufi/src/database/pedidos_db.dart';
import 'package:bufi/src/database/subsidiary_db.dart';
import 'package:bufi/src/models/PedidosModel.dart';
import 'package:bufi/src/models/carritoGeneralModel..dart';
import 'package:bufi/src/models/carritoModel.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class PedidoApi {
  final prefs = new Preferences();

  final pedidoDb = PedidosDatabase();

  Future<dynamic> obtenerPedidosEnviados(
      String fechaInicial, String fechaFinal) async {
    final response = await http
        .post("$apiBaseURL/api/Pedido/buscar_pedidos_enviados_ws", body: {
      'fecha_i': '$fechaInicial',
      'fecha_f': '$fechaFinal',
      'estado': '99',
      'tn': prefs.token,
      'app': 'true'
    });

    final decodedData = json.decode(response.body);

    for (var i = 0; i < decodedData["result"]; i++) {
      final pedidosModel = PedidosModel();

      pedidosModel.idPedido = decodedData[i]['id_delivery'];
      pedidosModel.idUser = decodedData[i]['id_user'];
      pedidosModel.idCity = decodedData[i]['id_city'];
      pedidosModel.idSubsidiary = decodedData[i]['id_subsidiary'];
      pedidosModel.deliveryNumber = decodedData[i]['delivery_number'];
      pedidosModel.deliveryName = decodedData[i]['delivery_name'];
      pedidosModel.deliveryEmail = decodedData[i]['delivery_email'];
      pedidosModel.deliveryCel = decodedData[i]['delivery_cel'];
      pedidosModel.deliveryAddress = decodedData[i]['delivery_address'];
      pedidosModel.deliveryDescription = decodedData[i]['delivery_description'];
      pedidosModel.deliveryCoordX = decodedData[i]['delivery_coord_x'];
      pedidosModel.deliveryCoordY = decodedData[i]['delivery_coord_y'];
      pedidosModel.deliveryAddInfo = decodedData[i]['delivery_add_info'];
      pedidosModel.deliveryPrice = decodedData[i]['delivery_price'];
      pedidosModel.deliveryTotalOrden = decodedData[i]['delivery_total_orden'];
      pedidosModel.deliveryPayment = decodedData[i]['delivery_payment'];
      pedidosModel.deliveryEntrega = decodedData[i]['delivery_entrega'];
      pedidosModel.deliveryDatetime = decodedData[i]['delivery_datetime'];
      pedidosModel.deliveryStatus = decodedData[i]['delivery_status'];
      pedidosModel.deliveryMt = decodedData[i]['delivery_mt'];

      await pedidoDb.insertarPedido(pedidosModel);
    }
    return 0;
  }

  Future<dynamic> enviarPedido() async {
    final listDePedidos = await carritoPorSucursalSeleccionado();

    String sucursales = '';
    for (var i = 0; i < listDePedidos.length; i++) {
      for (var i = 0; i < listDePedidos[0].car.length; i++) {
        String producto = '';
        sucursales = sucursales +
            '${listDePedidos[0].car[i].idSubsidiary},,,${listDePedidos[0].car[i].monto},,,descripcion,,,';

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
      'payment': '',
      'add_info': '',
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

    double cantidadTotal = 0;
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

            cantidadTotal = cantidadTotal + (precio * cant);

            print('tamare $cantidadTotal');
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
      carritoGeneralModel.monto = cantidadTotal.toString();

      cantidadTotal = 0;

      listaGeneral.add(carritoGeneralModel);
    }

    CarritoGeneralSuperior carritoGeneralSuperior = CarritoGeneralSuperior();
    carritoGeneralSuperior.car = listaGeneral;
    carritoGeneralSuperior.cantidadArticulos = cantidad.toString();
    carritoGeneralSuperior.montoGeneral = cantidadTotal.toString();

    listaGeneralCarrito.add(carritoGeneralSuperior);

    return listaGeneralCarrito;
  }
}
