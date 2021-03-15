import 'package:bufi/src/api/agentes/agentes_api.dart';
import 'package:bufi/src/database/agentes_dabatabase.dart';
import 'package:bufi/src/database/company_db.dart';
import 'package:bufi/src/models/agentesModel.dart';
import 'package:bufi/src/models/companyModel.dart';
import 'package:rxdart/rxdart.dart';

class AgentesBloc {
  final agenteDatabase = AgentesDatabase();
  final companyDatabase = CompanyDatabase();
  final agenteApi = AgentesApi();

  final _agenteController = BehaviorSubject<List<AgenteModel>>();

  Stream<List<AgenteModel>> get agenteStream => _agenteController.stream;

  void dispose() {
    _agenteController?.close();
  }

  void obtenerAgentes() async {
     _agenteController.sink.add( await listarAgentes());
    await agenteApi.obtenerAgentes();
    _agenteController.sink.add( await listarAgentes());
  }

  Future<List<AgenteModel>> listarAgentes() async {
    List<AgenteModel> listaGeneral = List<AgenteModel>();

    //obtener todos los agentes de la bd
    final listAgentes = await agenteDatabase.obtenerAgentes();

    //Recorremos la lista de todos los agentes
    for (var i = 0; i < listAgentes.length; i++) {
      AgenteModel agenteModel = AgenteModel();

      agenteModel.idAgente = listAgentes[i].idAgente;
      agenteModel.idUser = listAgentes[i].idUser;
      agenteModel.idCuenta = listAgentes[i].idCuenta;
      agenteModel.idCity = listAgentes[i].idCity;
      agenteModel.agenteTipo = listAgentes[i].agenteTipo;
      agenteModel.agenteNombre = listAgentes[i].agenteNombre;
      agenteModel.agenteCodigo = listAgentes[i].agenteCodigo;
      agenteModel.agenteDireccion = listAgentes[i].agenteDireccion;
      agenteModel.agenteTelefono = listAgentes[i].agenteTelefono;
      agenteModel.agenteCoordX = listAgentes[i].agenteCoordX;
      agenteModel.agenteCoordY = listAgentes[i].agenteCoordY;
      agenteModel.agenteEstado = listAgentes[i].agenteEstado;
      agenteModel.idCuentaEmpresa = listAgentes[i].idCuentaEmpresa;
      agenteModel.cuentaeCodigo = listAgentes[i].cuentaeCodigo;
      agenteModel.cuentaeSaldo = listAgentes[i].cuentaeSaldo;
      agenteModel.cuentaeMoneda = listAgentes[i].cuentaeMoneda;
      agenteModel.cuentaeDate = listAgentes[i].cuentaeDate;
      agenteModel.cuentaeEstado = listAgentes[i].cuentaeEstado;
      agenteModel.idCompany = listAgentes[i].idCompany;

      //funcion que llama desde la bd a la lista de companys 
      final listCompany= await companyDatabase.obtenerCompanyPorIdCompany(listAgentes[i].idCompany);
      // lista vacia para llenar los datos de la Company
      final listcompanyModel = List<CompanyModel>();

      // recorrer la tabla company
      for (var j = 0; j < listCompany.length; j++) {
        final companyModel = CompanyModel();
        companyModel.idCompany = listCompany[j].idCompany;
          companyModel.companyName = listCompany[j].companyName;
          companyModel.idUser = listCompany[j].idUser;
          companyModel.idCity = listCompany[j].idCity;
          companyModel.idCategory = listCompany[j].idCategory;
          companyModel.companyImage = listCompany[j].companyImage;
          companyModel.companyRuc = listCompany[j].companyRuc;
          companyModel.companyType = listCompany[j].companyType;
          companyModel.companyShortcode =
              listCompany[j].companyShortcode;
          companyModel.companyDelivery =
              listCompany[j].companyDelivery;
          companyModel.companyEntrega = listCompany[j].companyEntrega;
          companyModel.companyTarjeta = listCompany[j].companyTarjeta;
          companyModel.companyVerified =
              listCompany[j].companyVerified;
          companyModel.companyRating = listCompany[j].companyRating;
          companyModel.companyCreatedAt =
              listCompany[j].companyCreatedAt;
          companyModel.companyJoin = listCompany[j].companyJoin;
          companyModel.companyStatus = listCompany[j].companyStatus;
          companyModel.companyMt = listCompany[j].companyMt;

        listcompanyModel.add(companyModel);
      }

      agenteModel.listCompany = listcompanyModel;

      listaGeneral.add(agenteModel);
    }
    return listaGeneral;
  }
}
