import 'package:bufi/src/api/servicios/services_api.dart';
import 'package:bufi/src/database/company_db.dart';
import 'package:bufi/src/database/subsidiaryService_db.dart';
import 'package:bufi/src/database/subsidiary_db.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/models/subsidiaryService.dart';
import 'package:rxdart/subjects.dart';

class ServiciosBloc {
  final subservicesDatabase = SubsidiaryServiceDatabase();
  final subservicesModel = SubsidiaryServiceModel();
  final serviciosApi = ServiceApi();
  final subsidiaryDb = SubsidiaryDatabase();
  final companyDb = CompanyDatabase();

  final _servicioController = BehaviorSubject<List<SubsidiaryServiceModel>>();

  final _detailServicioController =
      BehaviorSubject<List<SubsidiaryServiceModel>>();

  Stream<List<SubsidiaryServiceModel>> get serviciostream =>
      _servicioController.stream;

  Stream<List<SubsidiaryServiceModel>> get detailServiciostream =>
      _detailServicioController.stream;

  void dispose() {
    _servicioController?.close();
    _detailServicioController?.close();
  }

  void listarServiciosPorSucursal(String id) async {
    _servicioController.sink
        .add(await subservicesDatabase.obtenerServiciosPorIdSucursal(id));
    await serviciosApi.listarServiciosPorSucursal(id);
    _servicioController.sink
        .add(await subservicesDatabase.obtenerServiciosPorIdSucursal(id));
  }

  void detalleServicioPorIdSubsidiaryService(String id) async {
    _detailServicioController.sink.add(await obtenerDetalleServicio(id));
    await serviciosApi.detalleSerivicioPorIdSubsidiaryService(id);
    _detailServicioController.sink.add(await obtenerDetalleServicio(id));
  }

  Future<List<SubsidiaryServiceModel>> obtenerDetalleServicio(String id) async {
    List<SubsidiaryServiceModel> listaGeneral = [];
    final listServicio =
        await subservicesDatabase.obtenerServiciosPorIdSucursalService(id);

    for (var i = 0; i < listServicio.length; i++) {
      final servicioModel = SubsidiaryServiceModel();
      servicioModel.idSubsidiaryservice = listServicio[i].idSubsidiaryservice;
      servicioModel.idSubsidiary = listServicio[i].idSubsidiary;
      servicioModel.idService = listServicio[i].idService;
      servicioModel.idItemsubcategory = listServicio[i].idItemsubcategory;
      servicioModel.subsidiaryServiceName =
          listServicio[i].subsidiaryServiceName;
      servicioModel.subsidiaryServiceDescription =
          listServicio[i].subsidiaryServiceDescription;
      servicioModel.subsidiaryServicePrice =
          listServicio[i].subsidiaryServicePrice;
      servicioModel.subsidiaryServiceCurrency =
          listServicio[i].subsidiaryServiceCurrency;
      servicioModel.subsidiaryServiceImage =
          listServicio[i].subsidiaryServiceImage;
      servicioModel.subsidiaryServiceRating =
          listServicio[i].subsidiaryServiceRating;
      servicioModel.subsidiaryServiceUpdated =
          listServicio[i].subsidiaryServiceUpdated;
      servicioModel.subsidiaryServiceStatus =
          listServicio[i].subsidiaryServiceStatus;
      servicioModel.subsidiaryServiceFavourite =
          listServicio[i].subsidiaryServiceFavourite;

      final listSucursal = await subsidiaryDb
          .obtenerSubsidiaryPorId(listServicio[i].idSubsidiary);
      final List<SubsidiaryModel> listsubModel = [];
      for (var j = 0; j < listSucursal.length; j++) {
        final sucursalModel = SubsidiaryModel();
        sucursalModel.idSubsidiary = listSucursal[j].idSubsidiary;
        sucursalModel.idCompany = listSucursal[j].idCompany;
        sucursalModel.subsidiaryName = listSucursal[j].subsidiaryName;
        sucursalModel.idSubsidiary = listSucursal[j].idSubsidiary;
        sucursalModel.subsidiaryImg = listSucursal[j].subsidiaryImg;
        sucursalModel.subsidiaryAddress = listSucursal[j].subsidiaryAddress;
        sucursalModel.subsidiaryCellphone = listSucursal[j].subsidiaryCellphone;
        sucursalModel.subsidiaryCellphone2 =
            listSucursal[j].subsidiaryCellphone2;
        sucursalModel.subsidiaryEmail = listSucursal[j].subsidiaryEmail;
        sucursalModel.subsidiaryCoordX = listSucursal[j].subsidiaryCoordX;
        sucursalModel.subsidiaryCoordY = listSucursal[j].subsidiaryCoordY;
        sucursalModel.subsidiaryOpeningHours =
            listSucursal[j].subsidiaryOpeningHours;
        sucursalModel.subsidiaryPrincipal = listSucursal[j].subsidiaryPrincipal;
        sucursalModel.subsidiaryStatus = listSucursal[j].subsidiaryStatus;
        sucursalModel.subsidiaryFavourite = listSucursal[j].subsidiaryFavourite;

        listsubModel.add(sucursalModel);
      }
      servicioModel.listSubsidiary = listsubModel;

      listaGeneral.add(servicioModel);
    }

    return listaGeneral;
  }
}
