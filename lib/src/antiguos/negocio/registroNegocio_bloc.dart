/*  
import 'package:bufi/src/api/negocio/negocios_api.dart';
import 'package:bufi/src/bloc/validators.dart';
import 'package:bufi/src/models/companyModel.dart';
import 'package:rxdart/rxdart.dart';

class RegistroNegocioBloc with Validators {
  final registroProviders = NegociosApi();

  final registroNegocioApi = NegociosApi();

  final _nameEmpresaController = BehaviorSubject<String>();
  final _direccionController = BehaviorSubject<String>();
  final _celController = BehaviorSubject<String>();
  final _cargandoRegistroNegocioController = new BehaviorSubject<bool>();
  
  //Recuperaer los datos del Stream
  Stream<String> get nameEmpresaStream =>
      _nameEmpresaController.stream.transform(validarname);
  Stream<String> get direccionStream =>
      _direccionController.stream.transform(validarsurname);
  Stream<String> get celStream => _celController.stream.transform(validarcel);
  Stream<bool> get cargando => _cargandoRegistroNegocioController.stream;
  
  Stream<bool> get formValidStream => Rx.combineLatest3(
      nameEmpresaStream,
      direccionStream,
      celStream,
      (
        e,
        p,
        n,
      ) =>
          true);

  //inserta valores al Stream
  Function(String) get changeNameEmpresa => _nameEmpresaController.sink.add;
  Function(String) get changeDireccion => _direccionController.sink.add;
  Function(String) get changecel => _celController.sink.add;
  Function(bool) get changeCargando => _cargandoRegistroNegocioController.sink.add;

  //obtener el ultimo valor ingresado a los stream
  String get nameEmpresa => _nameEmpresaController.value;
  String get direccion => _direccionController.value;
  String get cel => _celController.value;

  dispose() {
    _nameEmpresaController?.close();
    _direccionController?.close();
    _celController?.close();
    _cargandoRegistroNegocioController?.close();
    
  }

  void cargandoFalse() {
    _cargandoRegistroNegocioController.sink.add(false);
  }

  Future<int> registroNegocio(CompanyModel data) async {
    _cargandoRegistroNegocioController.sink.add(true);
    final resp = await registroNegocioApi.registrarNegocio(data);
    _cargandoRegistroNegocioController.sink.add(false);
    return resp;
  }

  // Future<int> updateNegocio(UpdateNegocioData data) async {
  //   _cargandoRegistroNegocioController.sink.add(true);
  //   final resp = await registroNegocioApi.updateNegocio(data);
  //   _cargandoRegistroNegocioController.sink.add(false);
  //   return resp;
  // }
}
 */