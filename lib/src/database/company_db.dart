import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/companyModel.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';

class CompanyDatabase {
  final dbProvider = DatabaseProvider.db;
  final pref = Preferences();

  insertarCompany(CompanyModel companyModel) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Company (id_company,id_user,id_city,id_category,company_name,company_ruc,"
          "company_image,company_type,company_shortcode,company_delivery_propio,company_delivery,company_entrega,company_tarjeta,"
          "company_verified,company_rating,company_created_at,company_join,company_status,company_mt, mi_negocio) "
          "VALUES('${companyModel.idCompany}', '${companyModel.idUser}', '${companyModel.idCity}', '${companyModel.idCategory}', "
          "'${companyModel.companyName}', '${companyModel.companyRuc}', '${companyModel.companyImage}', '${companyModel.companyType}', "
          "'${companyModel.companyShortcode}', '${companyModel.companyDeliveryPropio}','${companyModel.companyDelivery}', '${companyModel.companyEntrega}', "
          "'${companyModel.companyTarjeta}', '${companyModel.companyVerified}', '${companyModel.companyRating}', "
          "'${companyModel.companyCreatedAt}', '${companyModel.companyJoin}', '${companyModel.companyStatus}',  '${companyModel.companyMt}', '${companyModel.miNegocio}')");

      return res;
    } catch (e) {
      print("$e Error en la base de datos");
    }
  }

  updateCompany(CompanyModel companyModel) async {
    try {
      final db = await dbProvider.database;

      final res = await db
          .rawUpdate("UPDATE Company SET id_user='${companyModel.idUser}', "
              "id_city='${companyModel.idCity}',"
              "id_category='${companyModel.idCategory}',"
              "company_name='${companyModel.companyName}',"
              "company_ruc='${companyModel.companyRuc}',"
              "company_image='${companyModel.companyImage}',"
              "company_type='${companyModel.companyType}',"
              "company_shortcode='${companyModel.companyShortcode}',"
              "company_delivery_propio='${companyModel.companyDeliveryPropio}',"
              "company_delivery='${companyModel.companyDelivery}',"
              "company_entrega='${companyModel.companyEntrega}', "
              "company_tarjeta='${companyModel.companyTarjeta}',"
              "company_verified='${companyModel.companyVerified}',"
              "company_rating='${companyModel.companyRating}', "
              "company_created_at='${companyModel.companyCreatedAt}', "
              "company_join='${companyModel.companyJoin}',"
              "company_status='${companyModel.companyStatus}',"
              "company_mt='${companyModel.companyMt}', "
              "mi_negocio='${companyModel.miNegocio}'"
              "WHERE id_company = '${companyModel.idCompany}'");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  Future<List<CompanyModel>> obtenerCompany() async {
    try {
      final db = await dbProvider.database;
      final res =
          await db.rawQuery("SELECT * FROM Company order by id_company ");

      List<CompanyModel> list = res.isNotEmpty
          ? res.map((c) => CompanyModel.fromJson(c)).toList()
          : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  /* Future<List<CompanySubsidiaryModel>> obtenerCompanySubsidiaryPorId(
      String idCompany) async {
    //CREAR OTRO MODELO DE COMPANY Y SUBSIDIARY
    final db = await dbProvider.database;
    final res = await db.rawQuery(
        "SELECT * FROM Company c inner join Subsidiary s on c.id_company= s.id_company  where c.id_company = '$idCompany'");
    //CAMBIAR LA CONSULTA POR INNER JOIN
    List<CompanySubsidiaryModel> list = res.isNotEmpty
        ? res.map((c) => CompanySubsidiaryModel.fromJson(c)).toList()
        : [];
    return list;
  } */

  Future<List<CompanyModel>> obtenerCompanyPorIdCompany(
      String idCompany) async {
    try {
      final db = await dbProvider.database;
      final res = await db
          .rawQuery("SELECT * FROM Company WHERE id_company= '$idCompany'");

      List<CompanyModel> list = res.isNotEmpty
          ? res.map((c) => CompanyModel.fromJson(c)).toList()
          : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  //Se utiliza para la busqueda de Negocio
  Future<List<CompanyModel>> consultarCompanyPorQuery(String query) async {
    try {
      final db = await dbProvider.database;
      final res = await db
          .rawQuery("SELECT * FROM Company WHERE company_name LIKE '%$query%'");

      List<CompanyModel> list = res.isNotEmpty
          ? res.map((c) => CompanyModel.fromJson(c)).toList()
          : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }

  // para la busqueda por categorias
  Future<List<CompanyModel>> consultarCompanyPorIdCategoria(
      String idCategoria) async {
    try {
      final db = await dbProvider.database;
      final res = await db
          .rawQuery("SELECT * FROM Company WHERE id_category= '$idCategoria'");

      List<CompanyModel> list = res.isNotEmpty
          ? res.map((c) => CompanyModel.fromJson(c)).toList()
          : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }
}
