
import 'package:bufi/src/api/negocio/negocios_api.dart';
import 'package:bufi/src/database/company_db.dart';
import 'package:bufi/src/models/CompanySubsidiaryModel.dart';
import 'package:rxdart/rxdart.dart';

class ActualizarNegocioBloc {
  final updateNegocioApi = NegociosApi();
  final updateDatabase = CompanyDatabase();

  final _negController = BehaviorSubject<List<CompanySubsidiaryModel>>();

  Stream<List<CompanySubsidiaryModel>> get negControllerStream =>
      _negController.stream;

  void dispose() {
    _negController?.close();
  }

  void updateNegocio(String id) async {
    _negController.sink
        .add(await updateDatabase.obtenerCompanySubsidiaryPorId(id));
    // await updateNegocioApi.updateNegocio(csmodel);
    // _negController.sink
    //     .add(await updateDatabase.obtenerCompanySubsidiaryPorId(id));
  }
}
