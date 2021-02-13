import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static Database _database;
  static final DatabaseProvider db = DatabaseProvider._();

  DatabaseProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'bufi.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Category ('
          'id_category VARCHAR  PRIMARY KEY,'
          'category_name VARCHAR'
          ')');

      await db.execute('CREATE TABLE Subcategory ('
          'id_subcategory VARCHAR  PRIMARY KEY,'
          'id_category VARCHAR,'
          'subcategory_name VARCHAR'
          ')');

      await db.execute('CREATE TABLE ItemSubcategorias ('
          'id_itemsubcategory VARCHAR  PRIMARY KEY,'
          'id_subcategory VARCHAR,'
          'itemsubcategory_name VARCHAR'
          ')');

      await db.execute('CREATE TABLE Producto ('
          'id_producto VARCHAR  PRIMARY KEY,'
          'id_subsidiary VARCHAR,'
          'id_good VARCHAR,'
          'id_itemsubcategory VARCHAR,'
          'producto_name VARCHAR,'
          'producto_price VARCHAR,'
          'producto_currency VARCHAR,'
          'producto_image VARCHAR,'
          'producto_characteristics VARCHAR,'
          'producto_brand VARCHAR,'
          'producto_model VARCHAR,'
          'producto_type VARCHAR,'
          'producto_size VARCHAR,'
          'producto_stock VARCHAR,'
          'producto_measure VARCHAR,'
          'producto_rating VARCHAR,'
          'producto_updated VARCHAR,'
          'producto_status VARCHAR,'
          'producto_favourite VARCHAR'
          ')');

      await db.execute('CREATE TABLE Subsidiaryservice ('
          'id_subsidiaryservice VARCHAR  PRIMARY KEY,'
          'id_subsidiary VARCHAR,'
          'id_service VARCHAR,'
          'id_itemsubcategory VARCHAR,'
          'subsidiary_service_name VARCHAR,'
          'subsidiary_service_description VARCHAR,'
          'subsidiary_service_price VARCHAR,'
          'subsidiary_service_currency VARCHAR,'
          'subsidiary_service_image VARCHAR,'
          'subsidiary_service_rating VARCHAR,'
          'subsidiary_service_updated VARCHAR,'
          'subsidiary_service_status VARCHAR,'
          'subsidiary_service_favourite VARCHAR'
          ')');

      await db.execute('CREATE TABLE Service ('
          'id_service VARCHAR  PRIMARY KEY,'
          'service_name VARCHAR,'
          'service_synonyms VARCHAR'
          ')');

      await db.execute('CREATE TABLE Good ('
          'id_good VARCHAR  PRIMARY KEY,'
          'good_name VARCHAR,'
          'good_synonyms VARCHAR'
          ')');

      await db.execute('CREATE TABLE Company ('
          'id_company VARCHAR  PRIMARY KEY,'
          'id_user VARCHAR,'
          'id_city VARCHAR,'
          'id_category VARCHAR,'
          'company_name VARCHAR,'
          'company_ruc VARCHAR,'
          'company_image VARCHAR,'
          'company_type VARCHAR,'
          'company_shortcode VARCHAR,'
          'company_delivery VARCHAR,'
          'company_entrega VARCHAR,'
          'company_tarjeta VARCHAR,'
          'company_verified VARCHAR,'
          'company_rating VARCHAR,'
          'company_created_at VARCHAR,'
          'company_join VARCHAR,'
          'company_status VARCHAR,'
          'company_mt VARCHAR,'
          ' mi_negocio VARCHAR'
          ')');

      await db.execute('CREATE TABLE Subsidiary ('
          'id_subsidiary VARCHAR PRIMARY KEY,'
          'id_company VARCHAR,'
          'subsidiary_name VARCHAR,'
          'subsidiary_address VARCHAR,'
          'subsidiary_cellphone VARCHAR,'
          'subsidiary_cellphone_2 VARCHAR,'
          'subsidiary_email VARCHAR,'
          'subsidiary_coord_x VARCHAR,'
          'subsidiary_coord_y VARCHAR,'
          'subsidiary_opening_hours VARCHAR,'
          'subsidiary_principal VARCHAR,'
          'subsidiary_status VARCHAR,'
          'subsidiary_favourite VARCHAR'
          ')');

      await db.execute('CREATE TABLE Carrito ('
          'idCarrito INTEGER PRIMARY KEY AUTOINCREMENT,'
          'id_subsidiarygood VARCHAR ,'
          'id_subsidiary VARCHAR,'
          'nombre VARCHAR,'
          'precio VARCHAR,'
          'marca VARCHAR,'
          'image VARCHAR,'
          'moneda VARCHAR,'
          'caracteristicas VARCHAR,'
          'stock VARCHAR,'
          'cantidad VARCHAR,'
          'estado_seleccionado VARCHAR'
          ')');

          await db.execute('CREATE TABLE Cuenta ('
          'id_cuenta VARCHAR PRIMARY KEY,'
          'id_user VARCHAR,'
          'cuenta_codigo VARCHAR,'
          'cuenta_saldo VARCHAR,'
          'cuenta_moneda VARCHAR,'
          'cuenta_date VARCHAR,'
          'cuenta_estado VARCHAR'
          ')');

      await db.execute('CREATE TABLE Point ('
          'id_point VARCHAR PRIMARY KEY,'
          'id_user VARCHAR,'
          'id_subsidiary VARCHAR,'
          'id_company VARCHAR,'
          'subsidiary_name VARCHAR,'
          'subsidiary_address VARCHAR,'
          'subsidiary_cellphone VARCHAR,'
          'subsidiary_cellphone_2 VARCHAR,'
          'subsidiary_email VARCHAR,'
          'subsidiary_coord_x VARCHAR,'
          'subsidiary_coord_y VARCHAR,'
          'subsidiary_opening_hours VARCHAR,'
          'subsidiary_principal VARCHAR,'
          'subsidiary_status VARCHAR,'
          'id_city VARCHAR,'
          'id_category VARCHAR,'
          'company_name VARCHAR,'
          'company_ruc VARCHAR,'
          'company_image VARCHAR,'
          'company_type VARCHAR,'
          'company_shortcode VARCHAR,'
          'company_delivery VARCHAR,'
          'company_entrega VARCHAR,'
          'company_tarjeta VARCHAR,'
          'company_verified VARCHAR,'
          'company_rating VARCHAR,'
          'company_created_at VARCHAR,'
          'company_join VARCHAR,'
          'company_status VARCHAR,'
          'company_mt VARCHAR,'
          'category_name VARCHAR'
          ')');

      await db.execute('CREATE TABLE SugerenciaBusqueda ('
          'id_busqueda INTEGER PRIMARY KEY AUTOINCREMENT,'
          'id_itemsubcategory VARCHAR,'
          'nombre_producto VARCHAR,'
          'id_producto VARCHAR,'
          'tipo VARCHAR'
          ')');
    });
  }
}
