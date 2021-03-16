
import 'package:bufi/src/api/bienes/bienes_api.dart';
import 'package:bufi/src/api/categorias_api.dart';
import 'package:bufi/src/api/servicios/services_api.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/database/subsidiaryService_db.dart';
import 'package:bufi/src/models/bienesServiciosModel.dart';
import 'package:rxdart/subjects.dart';

//bloc para llamar a los bienes y Servicios por id_itemsubcteg
class ItemCategoriaBloc {
  final bienApi = GoodApi();
  final servicioApi = ServiceApi();
  final categoriaApi = CategoriasApi();
    final productoDatabase = ProductoDatabase();
    final subServiceDb = SubsidiaryServiceDatabase();


  final _itemcontroller = BehaviorSubject<List<BienesServiciosModel>>();
  final _cargandoItems = BehaviorSubject<bool>();

  Stream<List<BienesServiciosModel>> get itemSubStream =>_itemcontroller.stream;
  Stream<bool> get cargandoItemsStream =>_cargandoItems.stream;

  void dispose() {
    _itemcontroller?.close(); 
    _cargandoItems?.close(); 
  } 

  void listarBienesServiciosXIdItemSubcategoria(String id) async {
    _itemcontroller.sink.add(await bienesServiciosPorIdItemSubcategoria(id));
    _cargandoItems.sink.add(true);
    await categoriaApi.obtenerProySerPorIdItemsubcategory(id);
    _cargandoItems.sink.add(false);
    _itemcontroller.sink.add(await bienesServiciosPorIdItemSubcategoria(id));
  }

  Future<List<BienesServiciosModel>> bienesServiciosPorIdItemSubcategoria( String id) async {

    final listGeneral = List<BienesServiciosModel>();
    final listSubgood = await productoDatabase.obtenerProductoXIdItemSubcategoria(id);
    final listSubservice = await subServiceDb.obtenerServicioXIdItemSubcategoria(id);

    for (var i = 0; i < listSubgood.length; i++) {
      final bienesServiciosModel = BienesServiciosModel();

      //Para Bienes
      bienesServiciosModel.idSubsidiarygood = listSubgood[i].idProducto;
      bienesServiciosModel.idSubsidiary = listSubgood[i].idSubsidiary;
      bienesServiciosModel.idGood = listSubgood[i].idGood;
      bienesServiciosModel.idItemsubcategory = listSubgood[i].idItemsubcategory;
      bienesServiciosModel.subsidiaryGoodName =listSubgood[i].productoName;
      bienesServiciosModel.subsidiaryGoodPrice =listSubgood[i].productoPrice;
      bienesServiciosModel.subsidiaryGoodCurrency = listSubgood[i].productoCurrency;
      bienesServiciosModel.subsidiaryGoodImage = listSubgood[i].productoImage;
      bienesServiciosModel.subsidiaryGoodCharacteristics = listSubgood[i].productoCharacteristics;
      bienesServiciosModel.subsidiaryGoodBrand = listSubgood[i].productoBrand;
      bienesServiciosModel.subsidiaryGoodModel = listSubgood[i].productoModel;
      bienesServiciosModel.subsidiaryGoodType = listSubgood[i].productoType;
      bienesServiciosModel.subsidiaryGoodSize = listSubgood[i].productoSize;
      bienesServiciosModel.subsidiaryGoodStock = listSubgood[i].productoStock;
      bienesServiciosModel.subsidiaryGoodMeasure = listSubgood[i].productoMeasure;
      bienesServiciosModel.subsidiaryGoodRating = listSubgood[i].productoRating;
      bienesServiciosModel.subsidiaryGoodUpdated =listSubgood[i].productoUpdated;
      bienesServiciosModel.subsidiaryGoodStatus =listSubgood[i].productoStatus;
      bienesServiciosModel.tipo = 'bienes';

      listGeneral.add(bienesServiciosModel);
    }
    //Servicios
    for (var j = 0; j < listSubservice.length; j++) {
      final bienesServiciosModel = BienesServiciosModel();

      bienesServiciosModel.idSubsidiaryservice =
          listSubservice[j].idSubsidiaryservice;
      bienesServiciosModel.idSubsidiary = listSubservice[j].idSubsidiary;
      bienesServiciosModel.idService = listSubservice[j].idService;
      bienesServiciosModel.subsidiaryServiceName =
          listSubservice[j].subsidiaryServiceName;
      bienesServiciosModel.subsidiaryServiceDescription =
          listSubservice[j].subsidiaryServiceDescription;
      bienesServiciosModel.subsidiaryServicePrice =
          listSubservice[j].subsidiaryServicePrice;
      bienesServiciosModel.subsidiaryServiceCurrency =
          listSubservice[j].subsidiaryServiceCurrency;
      bienesServiciosModel.subsidiaryServiceImage =
          listSubservice[j].subsidiaryServiceImage;
      bienesServiciosModel.subsidiaryServiceRating =
          listSubservice[j].subsidiaryServiceRating;
      bienesServiciosModel.subsidiaryServiceUpdated =
          listSubservice[j].subsidiaryServiceUpdated;
      bienesServiciosModel.subsidiaryServiceStatus =
          listSubservice[j].subsidiaryServiceStatus;
      bienesServiciosModel.tipo = 'servicios';

      listGeneral.add(bienesServiciosModel);
    }

    return listGeneral;
  }


  
}
