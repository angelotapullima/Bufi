

import 'package:bufi/src/database/subcategory_db.dart';
import 'package:bufi/src/models/subcategoryModel.dart';
import 'package:rxdart/rxdart.dart';

class SubcategoriaBloc {
  final _subcatgoryController = BehaviorSubject<List<SubcategoryModel>>();
  final subcategoryDb = SubcategoryDatabase();

  Stream<List<SubcategoryModel>> get subcatgoryStream =>
      _subcatgoryController.stream;

  void dispose() {
    _subcatgoryController?.close();
  }

  void obtenerSubcategoria() async {
    _subcatgoryController.sink.add( await subcategoryDb.obtenerSubcategorias());
 
  }
}
