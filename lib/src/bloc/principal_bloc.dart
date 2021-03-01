import 'package:rxdart/rxdart.dart';

class TabNavigationBloc {
  //instancia que captura el ultimo elemento agregado al controlador
  final selectTab = BehaviorSubject<int>();

  Stream<int> get selectPageStream => selectTab.stream;

  Function(int) get changePage => selectTab.sink.add;

  int get page => selectTab.value;

  dispose() {
    selectTab?.close();
  }



}
