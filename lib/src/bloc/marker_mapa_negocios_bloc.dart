import 'package:rxdart/rxdart.dart';

class MarkerMapaNegociosBloc {
  final _markerIdController = BehaviorSubject<AgentesResult>();

  Stream<AgentesResult> get markerIdStream => _markerIdController.stream;

  Function(AgentesResult) get changemarkerId => _markerIdController.sink.add;

  // Obtener el último valor ingresado a los streams
  AgentesResult get page => _markerIdController.value;

  dispose() {
    _markerIdController?.close();
  }
}

class AgentesResult {
  String posicion;
  String idAgente;

  AgentesResult({this.posicion, this.idAgente});
}
