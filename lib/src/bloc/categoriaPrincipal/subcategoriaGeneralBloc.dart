

import 'package:bufi/src/api/categorias_api.dart';
import 'package:bufi/src/database/itemSubcategory_db.dart';
import 'package:bufi/src/database/subcategory_db.dart';
import 'package:bufi/src/models/categoriaGeneralModel.dart';
import 'package:bufi/src/models/itemSubcategoryModel.dart';
import 'package:rxdart/subjects.dart';

class SubCategoriaGeneralBloc {
  final categoriApi = CategoriasApi();
    final subCategoriaDb = SubcategoryDatabase();
  final _subCategoriaGeneralcontroller =
      BehaviorSubject<List<SubCategoriaGeneralModel>>();

  Stream<List<SubCategoriaGeneralModel>> get subCategoriaGeneralStream =>
      _subCategoriaGeneralcontroller.stream;

  void dispose() {
    _subCategoriaGeneralcontroller?.close();
  }

  void obtenerSubcategoriaXIdCategoria( String id) async {
    _subCategoriaGeneralcontroller.sink.add(await itemSubcategXCategoria(id));
    /* await categoriApi.obtenerCategorias();
    _subCategoriaGeneralcontroller.sink.add(await itemSubcategXCategoria(id)); */
  }

  Future<List<SubCategoriaGeneralModel>> itemSubcategXCategoria(
      String id) async {
    //Lista que almacenara todos los nombres de subategorias
    final listGeneral = List<SubCategoriaGeneralModel>();
    //funcion para obtener todas las subcategorias
    final listSubcategoria = await subCategoriaDb.obtenerSubcategoriasPorIdCategoria(id);

    for (var i = 0; i < listSubcategoria.length; i++) {
      final subCategGeneralModel = SubCategoriaGeneralModel();

      subCategGeneralModel.nombre = listSubcategoria[i].subcategoryName;

      subCategGeneralModel.itemSubcategoria =
          await listItems(listSubcategoria[i].idSubcategory);
      listGeneral.add(subCategGeneralModel);
    }
    return listGeneral;
  }

  Future<List<ItemSubCategoriaModel>> listItems(String id) async {
    //obtener todos los items
    final listItem = List<ItemSubCategoriaModel>();
    final itemSubcategoriaDb = ItemsubCategoryDatabase();
    final listItemSubcategoria =  await itemSubcategoriaDb.obtenerItemSubCategoriaXIdSubcategoria(id);

    for (var x = 0; x < listItemSubcategoria.length; x++) {
      final itemModel = ItemSubCategoriaModel();
      itemModel.idItemsubcategory = listItemSubcategoria[x].idItemsubcategory;
      itemModel.idSubcategory = listItemSubcategoria[x].idSubcategory;
      itemModel.itemsubcategoryName = listItemSubcategoria[x].itemsubcategoryName;
      itemModel.itemsubcategoryImage = listItemSubcategoria[x].itemsubcategoryImage;

      listItem.add(itemModel);
    }

    return listItem;
  }
}
