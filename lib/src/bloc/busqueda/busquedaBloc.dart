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
import 'package:bufi/src/models/CompanySubsidiaryModel.dart';
import 'package:bufi/src/models/busquedaModel.dart';
import 'package:bufi/src/models/categoriaModel.dart';
import 'package:bufi/src/models/companyModel.dart';
import 'package:bufi/src/models/goodModel.dart';
import 'package:bufi/src/models/itemSubcategoryModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/models/serviceModel.dart';
import 'package:bufi/src/models/subcategoryModel.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/models/subsidiaryService.dart';
import 'package:rxdart/rxdart.dart';

class BusquedaBloc {
  final busquedaApi = BusquedaApi();
  final productoDatabase = ProductoDatabase();
  final subisdiaryServiceDb = SubsidiaryServiceDatabase();
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

  Stream<List<BusquedaGeneralModel>> get busquedaGeneralStream =>
      busquedaGeneralController.stream;

  final busquedaProductoController =
      BehaviorSubject<List<BusquedaProductoModel>>();
 
  final busquedaServicioController =
      BehaviorSubject<List<BusquedaServicioModel>>();
  final busquedaNegocioController =
      BehaviorSubject<List<BusquedaNegocioModel>>();
  
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

    // await busquedaApi.busquedaProducto(query);

    // busquedaProductoController.sink
    //     .add(await obtnerResultBusquedaProducto(query));
  }
  

  void obtenerBusquedaServicio(String query) async {
    busquedaServicioController.sink
        .add(await obtnerResultBusquedaServicio(query));
  }

  void obtenerBusquedaNegocio(String query) async {
    busquedaNegocioController.sink
        .add(await obtnerResultBusquedaNegocio(query));
  }

  Future<List<BusquedaProductoModel>> obtnerResultBusquedaProducto(
      String query) async {
    List<BusquedaProductoModel> listaGeneral = List<BusquedaProductoModel>();
    final listaGeneralModel = BusquedaProductoModel();
    final listProductos = await productoDb.consultarProductoPorQuery(query);
    final listProductoModel = List<ProductoModel>();

    for (var i = 0; i < listProductos.length; i++) {
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

    if (listProductos.length > 0) {
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
        companyModel.idCountry = listCompany[m].idCountry;
        companyModel.cityName = listCompany[m].cityName;
        companyModel.distancia = listCompany[m].distancia;

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
    }

    return listaGeneral;
  }

  Future<List<ProductoModel>> obtnerResultBusquedaProducto2(
      String query) async {
    List<ProductoModel> listaGeneral = List<ProductoModel>();

    final listProductos = await productoDb.consultarProductoPorQuery(query);

    //Recorremos la lista general
    for (var i = 0; i < listProductos.length; i++) {
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

      listaGeneral.add(productoModel);
    }
    return listaGeneral;
  }

  Future<List<BusquedaServicioModel>> obtnerResultBusquedaServicio(
      String query) async {
    List<BusquedaServicioModel> listaGeneral = List<BusquedaServicioModel>();
    final busquedaServicioModel = BusquedaServicioModel();
    final listServicios =
        await subisdiaryServiceDb.consultarServicioPorQuery(query);
    final listServicioModel = List<SubsidiaryServiceModel>();

    //Recorremos la lista general
    for (var i = 0; i < listServicios.length; i++) {
      final servicioModel = SubsidiaryServiceModel();
      servicioModel.idSubsidiaryservice = listServicios[i].idSubsidiaryservice;
      servicioModel.idSubsidiary = listServicios[i].idSubsidiary;
      servicioModel.idService = listServicios[i].idService;
      servicioModel.subsidiaryServiceName =
          listServicios[i].subsidiaryServiceName;
      servicioModel.subsidiaryServiceDescription =
          listServicios[i].subsidiaryServiceDescription;
      servicioModel.subsidiaryServicePrice =
          listServicios[i].subsidiaryServicePrice;
      servicioModel.subsidiaryServiceCurrency =
          listServicios[i].subsidiaryServiceCurrency;
      servicioModel.subsidiaryServiceImage =
          listServicios[i].subsidiaryServiceImage;
      servicioModel.subsidiaryServiceRating =
          listServicios[i].subsidiaryServiceRating;
      servicioModel.subsidiaryServiceUpdated =
          listServicios[i].subsidiaryServiceUpdated;
      servicioModel.subsidiaryServiceStatus =
          listServicios[i].subsidiaryServiceStatus;
      servicioModel.subsidiaryServiceFavourite =
          listServicios[i].subsidiaryServiceFavourite;

      listServicioModel.add(servicioModel);
    }

    if (listServicios.length > 0) {
      //------------------Servicios-----------------------

      //funcion que llama desde la bd a la lista
      final listService = await serviceDatabase
          .obtenerServicePorIdService(listServicios[0].idService);
      //crear lista vacia
      final listServiceModel = List<ServiciosModel>();

      for (var j = 0; j < listService.length; j++) {
        ServiciosModel serviciomodel = ServiciosModel();
        serviciomodel.idService = listService[j].idService;
        serviciomodel.serviceName = listService[j].serviceName;
        serviciomodel.serviceSynonyms = listService[j].serviceSynonyms;

        listServiceModel.add(serviciomodel);
      }

//------------------Sucursales-----------------------
      //funcion que llama desde la bd a la Lista de Sucursales
      final listsucursal = await subsidiaryDb
          .obtenerSubsidiaryPorId(listServicios[0].idSubsidiary);

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
        companyModel.idCountry = listCompany[m].idCountry;
        companyModel.cityName = listCompany[m].cityName;
        companyModel.distancia = listCompany[m].distancia;

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
              listServicios[0].idItemsubcategory);
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

      busquedaServicioModel.listServicios = listServicioModel;
      busquedaServicioModel.listService = listServiceModel;
      busquedaServicioModel.listSucursal = listSucursalModel;
      busquedaServicioModel.listCompany = listcompanyModel;
      busquedaServicioModel.listCategory = listcategModel;
      busquedaServicioModel.listSubcategory = listsubcategModel;
      busquedaServicioModel.listItemSubCateg = listItemsubcategModel;

      listaGeneral.add(busquedaServicioModel);
    }

    return listaGeneral;
  }

  Future<List<BusquedaNegocioModel>> obtnerResultBusquedaNegocio(
      String query) async {
    List<BusquedaNegocioModel> listaGeneral = List<BusquedaNegocioModel>();
    final busquedaNegocioModel = BusquedaNegocioModel();
    final listCompany = await companyDb.consultarCompanyPorQuery(query);
    final listCompanySubModel = List<CompanySubsidiaryModel>();

    //Recorremos la lista general
    for (var i = 0; i < listCompany.length; i++) {
      final companySubsidiaryModel = CompanySubsidiaryModel();

      companySubsidiaryModel.idCompany = listCompany[i].idCompany;
      companySubsidiaryModel.idCategory = listCompany[i].idCategory;
      companySubsidiaryModel.companyName = listCompany[i].companyName;
      companySubsidiaryModel.companyRuc = listCompany[i].companyRuc;
      companySubsidiaryModel.companyImage = listCompany[i].companyImage;
      companySubsidiaryModel.companyType = listCompany[i].companyType;
      companySubsidiaryModel.companyShortcode = listCompany[i].companyShortcode;
      companySubsidiaryModel.companyDelivery = listCompany[i].companyDelivery;
      companySubsidiaryModel.companyEntrega = listCompany[i].companyEntrega;
      companySubsidiaryModel.companyTarjeta = listCompany[i].companyTarjeta;
      companySubsidiaryModel.idUser = listCompany[i].idUser;
      companySubsidiaryModel.idCity = listCompany[i].idCity;
      companySubsidiaryModel.idCategory = listCompany[i].idCategory;
      companySubsidiaryModel.companyVerified = listCompany[i].companyVerified;
      companySubsidiaryModel.companyRating = listCompany[i].companyRating;
      companySubsidiaryModel.companyCreatedAt = listCompany[i].companyCreatedAt;
      companySubsidiaryModel.companyJoin = listCompany[i].companyJoin;
      companySubsidiaryModel.companyStatus = listCompany[i].companyStatus;
      companySubsidiaryModel.companyMt = listCompany[i].companyMt;
      companySubsidiaryModel.idCountry = listCompany[i].idCountry;
      companySubsidiaryModel.cityName = listCompany[i].cityName;
      companySubsidiaryModel.distancia = listCompany[i].distancia;

      listCompanySubModel.add(companySubsidiaryModel);
    }

    if (listCompany.length > 0) {
//------------------Sucursales-----------------------
      //funcion que llama desde la bd a la Lista de Sucursales
      final listsucursal = await subsidiaryDb
          .obtenerSubsidiaryPorIdCompany(listCompany[0].idCompany);

      //crear lista vacia
      //final listSucursalModel = List<SubsidiaryModel>();

      for (var l = 0; l < listsucursal.length; l++) {
        final companySubsidiaryModel = CompanySubsidiaryModel();

        companySubsidiaryModel.idSubsidiary = listsucursal[l].idSubsidiary;
        companySubsidiaryModel.idCompany = listsucursal[l].idCompany;
        companySubsidiaryModel.subsidiaryName = listsucursal[l].subsidiaryName;
        companySubsidiaryModel.subsidiaryCellphone =
            listsucursal[l].subsidiaryCellphone;
        companySubsidiaryModel.subsidiaryCellphone2 =
            listsucursal[l].subsidiaryCellphone2;
        companySubsidiaryModel.subsidiaryEmail =
            listsucursal[l].subsidiaryEmail;
        companySubsidiaryModel.subsidiaryCoordX =
            listsucursal[l].subsidiaryCoordX;
        companySubsidiaryModel.subsidiaryCoordY =
            listsucursal[l].subsidiaryCoordY;
        companySubsidiaryModel.subsidiaryOpeningHours =
            listsucursal[l].subsidiaryOpeningHours;
        companySubsidiaryModel.subsidiaryPrincipal =
            listsucursal[l].subsidiaryPrincipal;
        companySubsidiaryModel.subsidiaryStatus =
            listsucursal[l].subsidiaryStatus;
        companySubsidiaryModel.subsidiaryFavourite =
            listsucursal[l].subsidiaryFavourite;

        listCompanySubModel.add(companySubsidiaryModel);
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

      busquedaNegocioModel.listCompanySubsidiary = listCompanySubModel;
      busquedaNegocioModel.listCategory = listcategModel;

      listaGeneral.add(busquedaNegocioModel);
    }
    return listaGeneral;
  }
}
