import 'package:rxdart/rxdart.dart';

class ContadorPaginaProductosBloc {
  final _selectContadorController = BehaviorSubject<int>();

  Stream<int> get selectContadorStream => _selectContadorController.stream;

  Function(int) get changeContador => _selectContadorController.sink.add;

  final _selectContadorFotoController = BehaviorSubject<int>();

  Stream<int> get selectContadorFotoStream =>
      _selectContadorFotoController.stream;

  Function(int) get changeContadorfoto =>
      _selectContadorFotoController.sink.add;

  // Obtener el último valor ingresado a los streams
  int get pageContador => _selectContadorController.value;

  int get pageContadorFoto => _selectContadorFotoController.value;

  dispose() {
    _selectContadorController?.close();
    _selectContadorFotoController?.close();
  }
}


