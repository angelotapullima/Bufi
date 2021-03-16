import 'package:bufi/src/api/busqueda/busqueda_api.dart';
import 'package:bufi/src/database/category_db.dart';
import 'package:bufi/src/database/company_db.dart';
import 'package:bufi/src/database/good_db.dart';
import 'package:bufi/src/database/itemSubcategory_db.dart';
import 'package:bufi/src/database/producto_bd.dart';
import 'package:bufi/src/database/service_db.dart';
import 'package:bufi/src/database/subcategory_db.dart';
import 'package:bufi/src/database/subsidiaryService_db.dart';
import 'package:bufi/src/database/subsidiary_db.dart';
import 'package:bufi/src/models/busquedaModel.dart';
import 'package:bufi/src/models/categoriaModel.dart';
import 'package:bufi/src/models/companyModel.dart';
import 'package:bufi/src/models/goodModel.dart';
import 'package:bufi/src/models/itemSubcategoryModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/models/subcategoryModel.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:rxdart/rxdart.dart';

class BusquedaBloc {
  final busquedaApi = BusquedaApi();
  final productoDatabase = ProductoDatabase();
  final subisdiaryServiceDatabase = SubsidiaryServiceDatabase();
  final goodDb = GoodDatabase();
  final productoDb = ProductoDatabase();
  final serviceDatabase = ServiceDatabase();
  final subsidiaryDb = SubsidiaryDatabase();
  final companyDb = CompanyDatabase();
  final subCategoriaDb = SubcategoryDatabase();
  final categoriaDb = CategoryDatabase();
  final itemSubcategoriaDb = ItemsubCategoryDatabase();

  final busquedaGeneralController =
      BehaviorSubject<List<BusquedaGeneralModel>>();
  final busquedaProductoController =
      BehaviorSubject<List<BusquedaProductoModel>>();
  final busquedaServicioController =
      BehaviorSubject<List<BusquedaServicioModel>>();
  final busquedaNegocioController =
      BehaviorSubject<List<BusquedaNegocioModel>>();

  Stream<List<BusquedaGeneralModel>> get busquedaGeneralStream =>
      busquedaGeneralController.stream;
  Stream<List<BusquedaProductoModel>> get busquedaProductoStream =>
      busquedaProductoController.stream;
  Stream<List<BusquedaServicioModel>> get busquedaServicioStream =>
      busquedaServicioController.stream;
  Stream<List<BusquedaNegocioModel>> get busquedaNegocioStream =>
      busquedaNegocioController.stream;

  void dispose() {
    busquedaGeneralController?.close();
    busquedaProductoController?.close();
    busquedaServicioController?.close();
    busquedaNegocioController?.close();
  }

//Para la busqueda General
  void obtenerResultadosBusquedaPorQuery(String query) async {
    // bienesBusquedaController.sink
    //     .add(await productoDatabase.consultarProductoPorQuery('$query'));
    busquedaGeneralController.sink
        .add(await busquedaApi.busquedaGeneral(query));
    // bienesBusquedaController.sink
    //     .add(await productoDatabase.consultarProductoPorQuery('$query'));
  }

  void obtenerBusquedaProducto(String query) async {
    busquedaProductoController.sink
        .add(await obtnerResultBusquedaProducto(query));

    await busquedaApi.busquedaProducto(query);

    busquedaProductoController.sink
        .add(await obtnerResultBusquedaProducto(query));
  }

  void obtenerBusquedaServicio(String query) async {
    busquedaServicioController.sink
        .add(await busquedaApi.busquedaServicio(query));
  }

  void obtenerBusquedaNegocio(String query) async {
    busquedaNegocioController.sink
        .add(await busquedaApi.busquedaNegocio(query));
  }

  Future<List<BusquedaProductoModel>> obtnerResultBusquedaProducto(
      String query) async {
    List<BusquedaProductoModel> listaGeneral = List<BusquedaProductoModel>();
    final listaGeneralModel = BusquedaProductoModel();
    final listProductos = await productoDb.consultarProductoPorQuery(query);
    final listProductoModel = List<ProductoModel>();

    //Recorremos la lista general
    for (var i = 0;i < listProductos.length;i++) {
      //obtener todos los productos de la bd
     // final listProductos = await productoDb.consultarProductoPorQuery(query);
      //final listProductoModel = List<ProductoModel>();

    // for (var i = 0; i < listProductos.length; i++) {
        final productoModel = ProductoModel();
        productoModel.idProducto = listProductos[i].idProducto;
        productoModel.idSubsidiary = listProductos[i].idSubsidiary;
        productoModel.idGood = listProductos[i].idGood;
        productoModel.idItemsubcategory = listProductos[i].idItemsubcategory;
        productoModel.productoName = listProductos[i].productoName;
        productoModel.productoPrice = listProductos[i].productoPrice;
        productoModel.productoCurrency = listProductos[i].productoCurrency;
        productoModel.productoImage = listProductos[i].productoImage;
        productoModel.productoCharacteristics =
            listProductos[i].productoCharacteristics;
        productoModel.productoBrand = listProductos[i].productoBrand;
        productoModel.productoModel = listProductos[i].productoModel;
        productoModel.productoType = listProductos[i].productoType;
        productoModel.productoSize = listProductos[i].productoSize;
        productoModel.productoMeasure = listProductos[i].productoMeasure;
        productoModel.productoStock = listProductos[i].productoStock;
        productoModel.productoRating = listProductos[i].productoRating;
        productoModel.productoUpdated = listProductos[i].productoUpdated;
        productoModel.productoStatus = listProductos[i].productoStatus;

        listProductoModel.add(productoModel);
     }

      //------------------Bienes-----------------------

      //funcion que llama desde la bd a la lista
      final listBienes =
          await goodDb.obtenerGoodPorIdGood(listProductos[0].idGood);
      //crear lista vacia
      final listBienesModel = List<BienesModel>();

      for (var j = 0; j < listBienes.length; j++) {
        BienesModel goodmodel = BienesModel();
        goodmodel.idGood = listBienes[j].idGood;
        goodmodel.goodName = listBienes[j].goodName;
        goodmodel.goodSynonyms = listBienes[j].goodSynonyms;

        listBienesModel.add(goodmodel);
      }

//------------------Sucursales-----------------------
      //funcion que llama desde la bd a la Lista de Sucursales
      final listsucursal = await subsidiaryDb
          .obtenerSubsidiaryPorId(listProductos[0].idSubsidiary);

      //crear lista vacia
      final listSucursalModel = List<SubsidiaryModel>();

      for (var l = 0; l < listsucursal.length; l++) {
        final subModel = SubsidiaryModel();

        subModel.idSubsidiary = listsucursal[l].idSubsidiary;
        subModel.idCompany = listsucursal[l].idCompany;
        subModel.subsidiaryName = listsucursal[l].subsidiaryName;
        subModel.subsidiaryCellphone = listsucursal[l].subsidiaryCellphone;
        subModel.subsidiaryCellphone2 = listsucursal[l].subsidiaryCellphone2;
        subModel.subsidiaryEmail = listsucursal[l].subsidiaryEmail;
        subModel.subsidiaryCoordX = listsucursal[l].subsidiaryCoordX;
        subModel.subsidiaryCoordY = listsucursal[l].subsidiaryCoordY;
        subModel.subsidiaryOpeningHours =
            listsucursal[l].subsidiaryOpeningHours;
        subModel.subsidiaryPrincipal = listsucursal[l].subsidiaryPrincipal;
        subModel.subsidiaryStatus = listsucursal[l].subsidiaryStatus;
        subModel.subsidiaryFavourite = listsucursal[l].subsidiaryFavourite;

        listSucursalModel.add(subModel);
      }

//------------------Company-----------------------
      //funcion que llama desde la bd a la lista de companys
      final listCompany =
          await companyDb.obtenerCompanyPorIdCompany(listsucursal[0].idCompany);
      // lista vacia para llenar los datos de la Company
      final listcompanyModel = List<CompanyModel>();

      // recorrer la tabla company
      for (var m = 0; m < listCompany.length; m++) {
        final companyModel = CompanyModel();
        companyModel.idCompany = listCompany[m].idCompany;
        companyModel.companyName = listCompany[m].companyName;
        companyModel.idUser = listCompany[m].idUser;
        companyModel.idCity = listCompany[m].idCity;
        companyModel.idCategory = listCompany[m].idCategory;
        companyModel.companyImage = listCompany[m].companyImage;
        companyModel.companyRuc = listCompany[m].companyRuc;
        companyModel.companyType = listCompany[m].companyType;
        companyModel.companyShortcode = listCompany[m].companyShortcode;
        companyModel.companyDelivery = listCompany[m].companyDelivery;
        companyModel.companyEntrega = listCompany[m].companyEntrega;
        companyModel.companyTarjeta = listCompany[m].companyTarjeta;
        companyModel.companyVerified = listCompany[m].companyVerified;
        companyModel.companyRating = listCompany[m].companyRating;
        companyModel.companyCreatedAt = listCompany[m].companyCreatedAt;
        companyModel.companyJoin = listCompany[m].companyJoin;
        companyModel.companyStatus = listCompany[m].companyStatus;
        companyModel.companyMt = listCompany[m].companyMt;

        listcompanyModel.add(companyModel);
      }

//------------------Categoria-----------------------
      final listCategoria =
          await categoriaDb.obtenerCategoriasporID(listCompany[0].idCategory);
      // lista vacia para llenar los datos de la Company
      final listcategModel = List<CategoriaModel>();

      for (var i = 0; i < listCategoria.length; i++) {
        final categoriaModel = CategoriaModel();
        categoriaModel.idCategory = listCategoria[i].idCategory;
        categoriaModel.categoryName = listCategoria[i].categoryName;

        listcategModel.add(categoriaModel);
      }

//------------------Subcategoria-----------------------
      final listSubcategoria = await subCategoriaDb
          .obtenerSubcategoriasPorIdCategoria(listCompany[0].idCategory);
      // lista vacia para llenar los datos de la Company
      final listsubcategModel = List<SubcategoryModel>();

      for (var i = 0; i < listSubcategoria.length; i++) {
        final subCategoriaModel = SubcategoryModel();
        subCategoriaModel.idSubcategory = listSubcategoria[i].idSubcategory;
        subCategoriaModel.idCategory = listSubcategoria[i].idCategory;
        subCategoriaModel.subcategoryName = listSubcategoria[i].subcategoryName;

        listsubcategModel.add(subCategoriaModel);
      }

      //------------------ItemSubcategoria-----------------------
      final listItemsubcategoria =
          await itemSubcategoriaDb.obtenerItemSubCategoriaXIdItemSubcategoria(
              listProductos[0].idItemsubcategory);
      // lista vacia para llenar los datos de la Company
      final listItemsubcategModel = List<ItemSubCategoriaModel>();

      for (var i = 0; i < listItemsubcategoria.length; i++) {
        final itemSubcategoriaModel = ItemSubCategoriaModel();
        itemSubcategoriaModel.idItemsubcategory =
            listItemsubcategoria[i].idItemsubcategory;
        itemSubcategoriaModel.idSubcategory =
            listItemsubcategoria[i].idSubcategory;
        itemSubcategoriaModel.itemsubcategoryName =
            listItemsubcategoria[i].itemsubcategoryName;

        listItemsubcategModel.add(itemSubcategoriaModel);
      }
      listaGeneralModel.listProducto = listProductoModel;
      listaGeneralModel.listBienes = listBienesModel;
      listaGeneralModel.listSucursal = listSucursalModel;
      listaGeneralModel.listCompany = listcompanyModel;
      listaGeneralModel.listCategory = listcategModel;
      listaGeneralModel.listSubcategory = listsubcategModel;
      listaGeneralModel.listItemSubCateg = listItemsubcategModel;

      listaGeneral.add(listaGeneralModel);
      
    
    
    return listaGeneral;
  }
}
