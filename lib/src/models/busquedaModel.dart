import 'package:bufi/src/models/categoriaModel.dart';
import 'package:bufi/src/models/companyModel.dart';
import 'package:bufi/src/models/goodModel.dart';
import 'package:bufi/src/models/itemSubcategoryModel.dart';
import 'package:bufi/src/models/marcaProductoModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/models/serviceModel.dart';
import 'package:bufi/src/models/subcategoryModel.dart';
import 'package:bufi/src/models/subsidiaryModel.dart';
import 'package:bufi/src/models/subsidiaryService.dart';

class BusquedaGeneralModel {
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
  List<BienesModel> listBienes;
  List<ProductoModel> listProducto;
   List<SubsidiaryModel> listSucursal;
  List<CompanyModel> listCompany;
  List<CategoriaModel> listCategory;
  List<SubcategoryModel> listSubcategory;
  List<ItemSubCategoriaModel> listItemSubCateg;
}

class BusquedaServicioModel {
  List<ServiciosModel> listService;
  List<SubsidiaryServiceModel> listServicios;
  List<SubsidiaryModel> listSucursal;
  List<CompanyModel> listCompany;
  List<CategoriaModel> listCategory;
  List<SubcategoryModel> listSubcategory;
  List<ItemSubCategoriaModel> listItemSubCateg;
}

class BusquedaNegocioModel {
  List<CompanyModel> listCompany;
   List<SubsidiaryModel> listSucursal;
  List<CategoriaModel> listCategory;
  
}
