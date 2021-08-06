import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/publicidad_model.dart';

class PublicidadDatabase {
  final dbProvider = DatabaseProvider.db;

  insertarPublicidad(PublicidadModel publicidadModel) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawInsert("INSERT OR REPLACE INTO Publicidad (id_publicidad,id_city,id_subsidiary,"
          "publicidad_img,publicidad_orden,publicidad_estado,publicidad_datetime,id_pago) "
          "VALUES('${publicidadModel.idPublicidad}', '${publicidadModel.idCity}', "
          "'${publicidadModel.idSubsidiary}', '${publicidadModel.publicidadImg}', "
          "'${publicidadModel.publicidadOrden}', '${publicidadModel.publicidadEstado}', "
          "'${publicidadModel.publicidadDatetime}','${publicidadModel.publicidadEstado}')");

      return res;
    } catch (e) {
      print("$e Error en la base de datos");
    }
  }

  Future<List<PublicidadModel>> obtenerPublicidad() async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM Publicidad where publicidad_estado ='1' order by publicidad_orden");

      List<PublicidadModel> list = res.isNotEmpty ? res.map((c) => PublicidadModel.fromJson(c)).toList() : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }
}
