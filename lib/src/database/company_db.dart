

import 'package:bufi/src/database/databaseProvider.dart';
import 'package:bufi/src/models/CompanySubsidiaryModel.dart';
import 'package:bufi/src/models/companyModel.dart';

class CompanyDatabase {
  final dbProvider = DatabaseProvider.db;
  
  insertarCompany(CompanyModel companyModel) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Company (id_company,id_user,id_city,id_category,company_name,company_ruc,"
          "company_image,company_type,company_shortcode,company_delivery,company_entrega,company_tarjeta,"
          "company_verified,company_rating,company_created_at,company_join,company_status,company_mt, mi_negocio) "
          "VALUES('${companyModel.idCompany}', '${companyModel.idUser}', '${companyModel.idCity}', '${companyModel.idCategory}', "
          "'${companyModel.companyName}', '${companyModel.companyRuc}', '${companyModel.companyImage}', '${companyModel.companyType}', "
          "'${companyModel.companyShortcode}', '${companyModel.companyDelivery}', '${companyModel.companyEntrega}', "
          "'${companyModel.companyTarjeta}', '${companyModel.companyVerified}', '${companyModel.companyRating}', "
          "'${companyModel.companyCreatedAt}', '${companyModel.companyJoin}', '${companyModel.companyStatus}',  '${companyModel.companyMt}', '${companyModel.miNegocio}')"
          );

      return res;
    } catch (e) {
      print("Error en la base de datos");
    }
  }

  Future<List<CompanyModel>> obtenerCompany() async {
    final db = await dbProvider.database;
    final res = await db.rawQuery("SELECT * FROM Company order by id_company ");

    List<CompanyModel> list =
        res.isNotEmpty ? res.map((c) => CompanyModel.fromJson(c)).toList() : [];
    return list;
  }  

  Future<List<CompanySubsidiaryModel>> obtenerCompanySubsidiaryPorId(String idCompany) async {
    //CREAR OTRO MODELO DE COMPANY Y SUBSIDIARY
    final db = await dbProvider.database;
    final res = await db.rawQuery("SELECT * FROM Company c inner join Subsidiary s on c.id_company= s.id_company  where c.id_company = '$idCompany'");
  //CAMBIAR LA CONSULTA POR INNER JOIN
    List<CompanySubsidiaryModel> list =
        res.isNotEmpty ? res.map((c) => CompanySubsidiaryModel.fromJson(c)).toList() : [];
    return list;
  }  

   

  Future<List<CompanyModel>> obtenerCompanyPorId(String idCompany) async {
    
    final db = await dbProvider.database;
    final res = await db.rawQuery("SELECT * FROM Company WHERE id_company= '$idCompany'");
  
    List<CompanyModel> list =
        res.isNotEmpty ? res.map((c) => CompanyModel.fromJson(c)).toList() : [];
    return list;
  }  

  

}
