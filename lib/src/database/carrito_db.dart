

import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/carritoModel.dart';

class CarritoDb {
  final dbProvider = DatabaseProvider.db;

  insertarProducto(CarritoModel carritoModel) async {
    try {
      final db = await dbProvider.database;
      
      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Carrito (id_subsidiarygood,id_subsidiary,nombre,precio,marca, image,moneda,caracteristicas,stock,cantidad,estado_seleccionado) "
          "VALUES('${carritoModel.idSubsidiaryGood}','${carritoModel.idSubsidiary}','${carritoModel.nombre}','${carritoModel.precio}','${carritoModel.marca}','${carritoModel.image}','${carritoModel.moneda}','${carritoModel.caracteristicas}','${carritoModel.stock}',"
          "'${carritoModel.cantidad}','${carritoModel.estadoSeleccionado}')");

      return res;
    } catch (e) {
      print(" $e Error en la base de datossss");
      print(e); 
    }
  }



  Future<List<CarritoModel>> obtenerCarrito() async {
    final db = await dbProvider.database;
    //try {
      final res = await db.rawQuery("SELECT * FROM Carrito");

    List<CarritoModel> list= res.isNotEmpty
        ? res.map((c) => CarritoModel.fromJson(c)).toList()
        : [];

    return list;

  }



 


  Future<List<CarritoModel>> obtenerProductoXCarritoListHorizontal() async {
    final db = await dbProvider.database;
    //try {
      final res = await db.rawQuery("SELECT * FROM Carrito ORDER BY idCarrito DESC");

    List<CarritoModel> list= res.isNotEmpty
        ? res.map((c) => CarritoModel.fromJson(c)).toList()
        : [];

    return list;

  }


  Future<List<CarritoModel>> obtenerProductoXCarritoSeleccionado() async {
    final db = await dbProvider.database;
    try {
      final res = await db.rawQuery("SELECT * FROM Carrito where estado_seleccionado ='1'");

    List<CarritoModel> list= res.isNotEmpty
        ? res.map((c) => CarritoModel.fromJson(c)).toList()
        : [];

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

    List<CarritoModel> list= res.isNotEmpty
        ? res.map((c) => CarritoModel.fromJson(c)).toList()
        : [];

    return list;

     } catch (e) {
       print("Error $e");
       return [];
     }
  }


  Future<List<CarritoModel>> obtenerProductoXCarritoPorId(String id) async {
    final db = await dbProvider.database;
    //try {
      final res = await db.rawQuery("SELECT * FROM Carrito where id_subsidiarygood = '$id'");

    List<CarritoModel> list= res.isNotEmpty
        ? res.map((c) => CarritoModel.fromJson(c)).toList()
        : [];

    return list;

    // } catch (e) {
    //   print("Error");
    // }
  }

  Future<List<CarritoModel>> obtenerProductosAgrupados() async {
    final db = await dbProvider.database;
    //try {
      final res = await db.rawQuery("SELECT * FROM Carrito group by id_subsidiary");

    List<CarritoModel> list= res.isNotEmpty
        ? res.map((c) => CarritoModel.fromJson(c)).toList()
        : [];

    return list;

    // } catch (e) {
    //   print("Error");
    // }
  }



  Future<List<CarritoModel>> obtenerProductosSeleccionadoAgrupados() async {
    final db = await dbProvider.database;
    //try {
      final res = await db.rawQuery("SELECT * FROM Carrito where estado_seleccionado = '1' group by id_subsidiary");

    List<CarritoModel> list= res.isNotEmpty
        ? res.map((c) => CarritoModel.fromJson(c)).toList()
        : [];

    return list;

    // } catch (e) {obtenerProductoXCarritoSeleccionado
    //   print("Error");
    // }
  }



  deleteCarritoPorIdSudsidiaryGood(String idSubsidiaryGood) async {
    final db = await dbProvider.database;

    final res = await db.rawDelete("DELETE FROM Carrito where id_subsidiarygood = '$idSubsidiaryGood'");

    return res;
  }


  updateCarritoPorIdSudsidiaryGood(CarritoModel carritoModel) async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawUpdate(
          "UPDATE Carrito SET id_subsidiary='${carritoModel.idSubsidiary}', "
          "nombre='${carritoModel.nombre}',"
          "precio='${carritoModel.precio}',"
          "marca='${carritoModel.marca}',"
          "image='${carritoModel.image}',"
          "moneda='${carritoModel.moneda}',"
          "caracteristicas='${carritoModel.caracteristicas}',"
          "stock='${carritoModel.stock}',"
          "cantidad='${carritoModel.cantidad}',"
          "estado_seleccionado='${carritoModel.estadoSeleccionado}' "
          "WHERE id_subsidiarygood = '${carritoModel.idSubsidiaryGood}'");
      print(res);
      return res;
    } catch (exception) {
      print(exception);
    }
  }
  



  updateSeleccionado(String idProducto,String seleccion) async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawUpdate(
          "UPDATE Carrito SET "
          "estado_seleccionado='$seleccion' "
          "WHERE id_subsidiarygood = '$idProducto'");
      print(res);
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
