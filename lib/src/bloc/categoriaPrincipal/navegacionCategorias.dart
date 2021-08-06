import 'package:rxdart/rxdart.dart';

class CategoriasNaviBloc {
  final _categoriasPageController = BehaviorSubject<String>();

  Stream<String> get categoriasIndexStream => _categoriasPageController.stream;

  Function(String) get changeIndexPage => _categoriasPageController.sink.add;

  // Obtener el último valor ingresado a los streams
  String get index => _categoriasPageController.value;

  dispose() {
    _categoriasPageController?.close();
  }
}
