import 'package:bufi/src/api/categorias_api.dart';
import 'package:bufi/src/database/category_db.dart';
import 'package:bufi/src/database/subcategory_db.dart';
import 'package:bufi/src/models/categoriaModel.dart';
import 'package:bufi/src/models/subcategoryModel.dart';
import 'package:rxdart/rxdart.dart';

class CategoriaBloc {
  final categoriaApi = CategoriasApi();
  final categoryDatabase = CategoryDatabase();
  final categoriaController = BehaviorSubject<List<CategoriaModel>>();

  //controlador para las subcategorias
  final _subcategoryController = BehaviorSubject<List<SubcategoryModel>>();
  final _cargandoProductosController = BehaviorSubject<bool>();

  Stream<List<CategoriaModel>> get categoriaStream => categoriaController.stream;
  Stream<List<SubcategoryModel>> get subcategoriaStream => _subcategoryController.stream;

  //Estado de carga
  Stream<bool> get cargandoProductosStream => _cargandoProductosController.stream;

  dispose() {
    categoriaController?.close();
    _subcategoryController?.close();
    _cargandoProductosController?.close();
  }

  void cargandoProductosFalse() {
    _cargandoProductosController.sink.add(false);
  }

//Muestra todas las categorias
  void obtenerCategorias() async {
    _cargandoProductosController.sink.add(true);
    categoriaController.sink.add(await categoryDatabase.obtenerCategorias());
    /* await categoriaApi.obtenerCategorias();
    categoriaController.sink.add(await categoryDatabase.obtenerCategorias());
   */
  }

  void obtenerSubcategoriaPorIdCategoria(String id) async {
    _cargandoProductosController.sink.add(true);

    final List<SubcategoryModel> listGeneral = [];

    final subCategoriaDb = SubcategoryDatabase();
    final listSubcategoria = await subCategoriaDb.obtenerSubcategoriasPorIdCategoria(id);

    for (var i = 0; i < listSubcategoria.length; i++) {
      final subCategoriaModel = SubcategoryModel();
      subCategoriaModel.idSubcategory = listSubcategoria[i].idSubcategory;
      subCategoriaModel.idCategory = listSubcategoria[i].idCategory;
      subCategoriaModel.subcategoryName = listSubcategoria[i].subcategoryName;

      listGeneral.add(subCategoriaModel);
    }

    _subcategoryController.sink.add(listGeneral);
    _cargandoProductosController.sink.add(false);
  }
}
