import 'package:bufi/src/api/negocio/negocios_api.dart';
import 'package:bufi/src/database/category_db.dart';
import 'package:bufi/src/database/company_db.dart';
import 'package:bufi/src/database/subsidiary_db.dart';
import 'package:bufi/src/models/CompanySubsidiaryModel.dart';
import 'package:rxdart/rxdart.dart';

class ActualizarNegocioBloc {
  final updateNegocioApi = NegociosApi();
  final companyDatabase = CompanyDatabase();

  final _negController = BehaviorSubject<List<CompanySubsidiaryModel>>();

  Stream<List<CompanySubsidiaryModel>> get negControllerStream =>
      _negController.stream;

  void dispose() {
    _negController?.close();
  }

  void updateNegocio(String id) async {
    _negController.sink.add(await obtenerDetalleNegocio(id));
  }

  Future<List<CompanySubsidiaryModel>> obtenerDetalleNegocio(
      String idCompany) async {
    final listGeneral = List<CompanySubsidiaryModel>();
    final sucursalDb = SubsidiaryDatabase();
    final companyDb = CompanyDatabase();
    final categoriaDb = CategoryDatabase();

    final listSucursales =await sucursalDb.obtenerSubsidiaryPorIdCompany(idCompany);
    final listCompany = await companyDb.obtenerCompanyPorId(idCompany);

    CompanySubsidiaryModel modelGeneral = CompanySubsidiaryModel();
    modelGeneral.idCompany = listSucursales[0].idCompany;
    modelGeneral.subsidiaryName = listSucursales[0].subsidiaryName;
    modelGeneral.subsidiaryEmail = listSucursales[0].subsidiaryEmail;
    modelGeneral.subsidiaryPrincipal = listSucursales[0].subsidiaryPrincipal;
    modelGeneral.subsidiaryStatus = listSucursales[0].subsidiaryStatus;
    modelGeneral.idSubsidiary = listSucursales[0].idSubsidiary;
    modelGeneral.subsidiaryCellphone = listSucursales[0].subsidiaryCellphone;
    modelGeneral.subsidiaryCellphone2 = listSucursales[0].subsidiaryCellphone2;
    modelGeneral.subsidiaryCoordX = listSucursales[0].subsidiaryCoordX;
    modelGeneral.subsidiaryCoordY = listSucursales[0].subsidiaryCoordY;
    modelGeneral.subsidiaryOpeningHours =listSucursales[0].subsidiaryOpeningHours;
    modelGeneral.subsidiaryAddress = listSucursales[0].subsidiaryAddress;

//Obtener datos de company
    modelGeneral.idCompany = listCompany[0].idCompany;
    modelGeneral.idCategory = listCompany[0].idCategory;
    modelGeneral.companyName = listCompany[0].companyName;
    modelGeneral.companyRuc = listCompany[0].companyRuc;
    modelGeneral.companyImage = listCompany[0].companyImage;
    modelGeneral.companyType = listCompany[0].companyType;
    modelGeneral.companyShortcode = listCompany[0].companyShortcode;
    modelGeneral.companyDelivery = listCompany[0].companyDelivery;
    modelGeneral.companyEntrega = listCompany[0].companyEntrega;
    modelGeneral.companyTarjeta = listCompany[0].companyTarjeta;
    modelGeneral.idCompany = listCompany[0].idCompany;
    modelGeneral.idUser = listCompany[0].idUser;
    modelGeneral.idCity = listCompany[0].idCity;
    modelGeneral.idCategory = listCompany[0].idCategory;
    modelGeneral.companyVerified = listCompany[0].companyVerified;
    modelGeneral.companyRating = listCompany[0].companyRating;
    modelGeneral.companyCreatedAt = listCompany[0].companyCreatedAt;
    modelGeneral.companyJoin = listCompany[0].companyJoin;
    modelGeneral.companyStatus = listCompany[0].companyStatus;
    modelGeneral.companyMt = listCompany[0].companyMt;
    modelGeneral.miNegocio = listCompany[0].miNegocio;

    final listCateg =await categoriaDb.obtenerCategoriasporID(listCompany[0].idCategory);
    modelGeneral.categoriaName = listCateg[0].categoryName;

    listGeneral.add(modelGeneral);

    return listGeneral;
  }
}
