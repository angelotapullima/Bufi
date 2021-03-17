







import 'package:rxdart/rxdart.dart';

class MarkerMapaNegociosBloc {

  final _markerIdController = BehaviorSubject<int>();



  Stream<int> get markerIdStream    => _markerIdController.stream;

  Function(int) get changemarkerId    => _markerIdController.sink.add;  


  // Obtener el último valor ingresado a los streams
  int get page   => _markerIdController.value; 

  dispose() {
    _markerIdController?.close(); 
    
  }
}
