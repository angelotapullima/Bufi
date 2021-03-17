import 'package:bufi/src/models/CompanySubsidiaryModel.dart';
import 'package:bufi/src/models/categoriaModel.dart';
import 'package:bufi/src/models/companyModel.dart';
import 'package:bufi/src/models/goodModel.dart';
import 'package:bufi/src/models/itemSubcategoryModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/models/serviceModel.dart';
import 'package:bufi/src/models/subcategoryModel.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/models/subsidiaryService.dart';

class BusquedaGeneralModel {
  BusquedaGeneralModel(
      {this.listBienes,
      this.listProducto,
      this.listSucursal,
      this.listCompany,
      this.listCategory,
      this.listSubcategory,
      this.listItemSubCateg,
      this.listService,
      this.listServicios});
  List<BienesModel> listBienes;
  List<ProductoModel> listProducto;
  List<SubsidiaryModel> listSucursal;
  List<CompanyModel> listCompany;
  List<CategoriaModel> listCategory;
  List<SubcategoryModel> listSubcategory;
  List<ItemSubCategoriaModel> listItemSubCateg;
  List<ServiciosModel> listService;
  List<SubsidiaryServiceModel> listServicios;
  //List<MarcaProductoModel> listMarca;

}

class BusquedaProductoModel {
  BusquedaProductoModel({
    this.listBienes,
    this.listProducto,
    this.listSucursal,
    this.listCompany,
    this.listCategory,
    this.listSubcategory,
    this.listItemSubCateg,
  });
  List<BienesModel> listBienes;
  List<ProductoModel> listProducto;
  List<SubsidiaryModel> listSucursal;
  List<CompanyModel> listCompany;
  List<CategoriaModel> listCategory;
  List<SubcategoryModel> listSubcategory;
  List<ItemSubCategoriaModel> listItemSubCateg;
}

class BusquedaServicioModel {
  BusquedaServicioModel(
      {this.listService,
      this.listServicios,
      this.listCompany,
      this.listSucursal,
      this.listCategory,
      this.listSubcategory,
      this.listItemSubCateg});
  List<ServiciosModel> listService;
  List<SubsidiaryServiceModel> listServicios;
  List<CompanyModel> listCompany;
  List<SubsidiaryModel> listSucursal;
  List<CategoriaModel> listCategory;
  List<SubcategoryModel> listSubcategory;
  List<ItemSubCategoriaModel> listItemSubCateg;
}

class BusquedaNegocioModel {
  BusquedaNegocioModel(
      {
      // this.listCompany, this.listSucursal,
      this.listCompanySubsidiary,
      this.listCategory});
  // List<CompanyModel> listCompany;
  // List<SubsidiaryModel> listSucursal;
  List<CompanySubsidiaryModel> listCompanySubsidiary;
  List<CategoriaModel> listCategory;
}

class BusquedaCategoriaModel {
  BusquedaCategoriaModel({
    // this.listCompany, this.listSucursal,
    this.listCompanySubsidiary,
    // this.listCategory
  });
  // List<CompanyModel> listCompany;
  // List<SubsidiaryModel> listSucursal;
  List<CompanySubsidiaryModel> listCompanySubsidiary;
  //List<CategoriaModel> listCategory;
}

class BusquedaSubcategoriaModel {
  BusquedaSubcategoriaModel(
      {this.listCompany,
      this.listSucursal,
      this.listCompanySubsidiary,
      this.listCategory});
  List<CompanyModel> listCompany;
  List<SubsidiaryModel> listSucursal;
  List<CompanySubsidiaryModel> listCompanySubsidiary;
  List<CategoriaModel> listCategory;
}

class BusquedaItemSubcategoriaModel {
  BusquedaItemSubcategoriaModel({this.listProducto});
  List<ProductoModel> listProducto;
}

//---------------------Por sucursal-----------------
class BusquedaPorSucursalModel {
  BusquedaPorSucursalModel({
    this.listProducto, this.listServicios
  });

  List<ProductoModel> listProducto;
  List<SubsidiaryServiceModel> listServicios;
}

class BusquedaServicioPorSucursalModel {
  BusquedaServicioPorSucursalModel({
    this.listService,
    this.listServicios,
  });
  List<ServiciosModel> listService;
  List<SubsidiaryServiceModel> listServicios;
}
