import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/carritoModel.dart';

class CarritoDb {
  final dbProvider = DatabaseProvider.db;

  insertarProducto(CarritoModel carritoModel) async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawInsert("INSERT OR REPLACE INTO Carrito (id_subsidiarygood,id_subsidiary,nombre,"
          "precio,marca,modelo,talla,image,moneda,caracteristicas,stock,cantidad,estado_seleccionado) "
          "VALUES('${carritoModel.idSubsidiaryGood}','${carritoModel.idSubsidiary}','${carritoModel.nombre}',"
          "'${carritoModel.precio}','${carritoModel.marca}','${carritoModel.modelo}','${carritoModel.talla}',"
          "'${carritoModel.image}','${carritoModel.moneda}','${carritoModel.caracteristicas}','${carritoModel.stock}',"
          "'${carritoModel.cantidad}','${carritoModel.estadoSeleccionado}')");

      return res;
    } catch (e) {
      print(" $e Error en la base de datossss");
    }
  }

  Future<List<CarritoModel>> obtenerCarrito() async {
    try {
      final db = await dbProvider.database;
      //try {
      final res = await db.rawQuery("SELECT * FROM Carrito");

      List<CarritoModel> list = res.isNotEmpty ? res.map((c) => CarritoModel.fromJson(c)).toList() : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  Future<List<CarritoModel>> obtenerProductoXCarritoListHorizontal() async {
    try {
      final db = await dbProvider.database;
      //try {
      final res = await db.rawQuery("SELECT * FROM Carrito ORDER BY idCarrito DESC");

      List<CarritoModel> list = res.isNotEmpty ? res.map((c) => CarritoModel.fromJson(c)).toList() : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  Future<List<CarritoModel>> obtenerProductoXCarritoSeleccionado() async {
    final db = await dbProvider.database;
    try {
      final res = await db.rawQuery("SELECT * FROM Carrito where estado_seleccionado ='1'");

      List<CarritoModel> list = res.isNotEmpty ? res.map((c) => CarritoModel.fromJson(c)).toList() : [];

      return list;
    } catch (e) {
      print("Error $e");
      return [];
    }
  }

  Future<List<CarritoModel>> obtenerCarritoPorSucursalSeleccionado(String idSubsi) async {
    final db = await dbProvider.database;
    try {
      final res = await db.rawQuery("SELECT * FROM Carrito where id_subsidiary = '$idSubsi' and estado_seleccionado ='1'");

      List<CarritoModel> list = res.isNotEmpty ? res.map((c) => CarritoModel.fromJson(c)).toList() : [];

      return list;
    } catch (e) {
      print("Error $e");
      return [];
    }
  }

  Future<List<CarritoModel>> obtenerProductoXCarritoPorId(String id) async {
    try {
      final db = await dbProvider.database;
      //try {
      final res = await db.rawQuery("SELECT * FROM Carrito where id_subsidiarygood = '$id'");

      List<CarritoModel> list = res.isNotEmpty ? res.map((c) => CarritoModel.fromJson(c)).toList() : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }

    // } catch (e) {
    //   print("Error");
    // }
  }

  Future<List<CarritoModel>> obtenerProductoXCarritoPorIdProductoTalla(String idProducto, String talla, String modelo, String marca) async {
    try {
      final db = await dbProvider.database;
      //try {
      final res = await db.rawQuery("SELECT * FROM Carrito WHERE id_subsidiarygood = '$idProducto' AND talla= '$talla' AND modelo='$modelo' AND marca= '$marca'");

      List<CarritoModel> list = res.isNotEmpty ? res.map((c) => CarritoModel.fromJson(c)).toList() : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  Future<List<CarritoModel>> obtenerProductosAgrupados() async {
    try {
      final db = await dbProvider.database;
      //try {
      final res = await db.rawQuery("SELECT * FROM Carrito group by id_subsidiary");

      List<CarritoModel> list = res.isNotEmpty ? res.map((c) => CarritoModel.fromJson(c)).toList() : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }

    // } catch (e) {
    //   print("Error");
    // }
  }

  Future<List<CarritoModel>> obtenerProductosSeleccionadoAgrupados() async {
    try {
      final db = await dbProvider.database;
      //try {
      final res = await db.rawQuery("SELECT * FROM Carrito where estado_seleccionado = '1' group by id_subsidiary");

      List<CarritoModel> list = res.isNotEmpty ? res.map((c) => CarritoModel.fromJson(c)).toList() : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }

    // } catch (e) {obtenerProductoXCarritoSeleccionado
    //   print("Error");
    // }
  }

  deleteCarritoPorIdSudsidiaryGood(String idSubsidiaryGood) async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawDelete("DELETE FROM Carrito where id_subsidiarygood = '$idSubsidiaryGood'");

      return res;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  deleteCarritoPorIdProductoTalla(String idSubsidiaryGood, String talla, String modelo, String marca) async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawDelete("DELETE FROM Carrito where id_subsidiarygood = '$idSubsidiaryGood' and talla='$talla' and modelo='$modelo' and marca='$marca'");

      return res;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  deleteCarritoPorIdProductoEstadoSeleccion(String idSubsidiaryGood) async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawDelete("DELETE FROM Carrito WHERE id_subsidiarygood = '$idSubsidiaryGood' AND estado_seleccionado = '1' ");

      return res;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  deleteCarritoPorEstadoSeleccion() async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawDelete("DELETE FROM Carrito WHERE estado_seleccionado = '1' ");

      return res;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  updateCarritoPorIdSudsidiaryGood(CarritoModel carritoModel) async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawUpdate("UPDATE Carrito SET id_subsidiary='${carritoModel.idSubsidiary}', "
          "nombre='${carritoModel.nombre}',"
          "precio='${carritoModel.precio}',"
          "marca='${carritoModel.marca}',"
          "modelo='${carritoModel.modelo}',"
          "talla='${carritoModel.talla}',"
          "image='${carritoModel.image}',"
          "moneda='${carritoModel.moneda}',"
          "caracteristicas='${carritoModel.caracteristicas}',"
          "stock='${carritoModel.stock}',"
          "cantidad='${carritoModel.cantidad}',"
          "estado_seleccionado='${carritoModel.estadoSeleccionado}' "
          "WHERE id_subsidiarygood = '${carritoModel.idSubsidiaryGood}'");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  updateCarritoPorIdSudsidiaryGoodTalla(CarritoModel carritoModel) async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawUpdate("UPDATE Carrito SET id_subsidiary='${carritoModel.idSubsidiary}', "
          "nombre='${carritoModel.nombre}',"
          "precio='${carritoModel.precio}',"
          "marca='${carritoModel.marca}',"
          "modelo='${carritoModel.modelo}',"
          "talla='${carritoModel.talla}',"
          "image='${carritoModel.image}',"
          "moneda='${carritoModel.moneda}',"
          "caracteristicas='${carritoModel.caracteristicas}',"
          "stock='${carritoModel.stock}',"
          "cantidad='${carritoModel.cantidad}',"
          "estado_seleccionado='${carritoModel.estadoSeleccionado}' "
          "WHERE id_subsidiarygood = '${carritoModel.idSubsidiaryGood}' and marca= '${carritoModel.marca}' and modelo= '${carritoModel.modelo}' and talla= '${carritoModel.talla}'");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  updateSeleccionado(String idProducto, String seleccion, String talla, String modelo, String marca) async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawUpdate("UPDATE Carrito SET "
          "estado_seleccionado='$seleccion' "
          "WHERE id_subsidiarygood = '$idProducto' and talla = '$talla' and modelo ='$modelo' and marca='$marca' ");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  // Future<List<CarritoModel>> obtProductoPorSubsidiary() async {
  //   final db = await dbProvider.database;
  //   try {
  //     final res = await db.rawQuery("SELECT * FROM Carrito c inner join Subsidiarygood sg ON c.id_subsidiarygood= sg.id_subsidiarygood");

  //   List<CarritoModel> list= res.isNotEmpty
  //       ? res.map((c) => CarritoModel.fromJson(c)).toList()
  //       : [];

  //   return list;

  //   } catch (e) {
  //     print("Error");
  //   }
  // }

}
