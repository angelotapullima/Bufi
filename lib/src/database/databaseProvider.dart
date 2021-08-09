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
          'category_name VARCHAR,'
          'category_estado VARCHAR,'
          'category_img VARCHAR'
          ')');

      await db.execute('CREATE TABLE Subcategory ('
          'id_subcategory VARCHAR  PRIMARY KEY,'
          'id_category VARCHAR,'
          'subcategory_name VARCHAR'
          ')');

      await db.execute('CREATE TABLE ItemSubcategorias ('
          'id_itemsubcategory VARCHAR  PRIMARY KEY,'
          'id_subcategory VARCHAR,'
          'itemsubcategory_img VARCHAR,'
          'itemsubcategory_estado VARCHAR,'
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
          'producto_stock_status VARCHAR,'
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
          'company_delivery_propio VARCHAR,'
          'company_delivery VARCHAR,'
          'company_entrega VARCHAR,'
          'company_tarjeta VARCHAR,'
          'company_verified VARCHAR,'
          'company_rating VARCHAR,'
          'company_created_at VARCHAR,'
          'company_join VARCHAR,'
          'company_status VARCHAR,'
          'company_mt VARCHAR,'
          'id_country VARCHAR,'
          'city_name VARCHAR,'
          'distancia VARCHAR,'
          'mi_negocio VARCHAR'
          ')');

      await db.execute('CREATE TABLE Subsidiary ('
          'id_subsidiary VARCHAR PRIMARY KEY,'
          'id_company VARCHAR,'
          'subsidiary_name VARCHAR,'
          'subsidiary_description VARCHAR,'
          'subsidiary_address VARCHAR,'
          'subsidiary_img VARCHAR,'
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
          'modelo VARCHAR,'
          'talla VARCHAR,'
          'image VARCHAR,'
          'moneda VARCHAR,'
          'caracteristicas VARCHAR,'
          'stock VARCHAR,'
          'cantidad VARCHAR,'
          'estado_seleccionado VARCHAR'
          ')');

      await db.execute('CREATE TABLE CarritoDelivery ('
          'id_subsidiary VARCHAR PRIMARY KEY,'
          'tipo_delivery_seleccionado VARCHAR'
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

      await db.execute(' CREATE TABLE MisMovimientos('
          ' nroOperacion TEXT PRIMARY KEY,'
          ' concepto TEXT,'
          ' tipoPago TEXT,'
          ' monto TEXT,'
          ' comision TEXT,'
          ' fecha TEXT,'
          ' soloFecha TEXT,'
          ' ind TEXT'
          ')');

      await db.execute(' CREATE TABLE TiposPago('
          ' id_tipo_pago TEXT PRIMARY KEY,'
          ' tipo_pago_nombre TEXT,'
          ' tipo_pago_img TEXT,'
          ' tipo_pago_msj TEXT,'
          ' seleccionado TEXT,'
          ' tipo_pago_estado TEXT'
          ')');

      await db.execute(' CREATE TABLE Pedidos('
          ' id_pedido TEXT PRIMARY KEY,'
          ' id_user TEXT,'
          ' id_city TEXT,'
          ' id_subsidiary TEXT,'
          ' id_company TEXT,'
          ' delivery_number TEXT,'
          ' delivery_name TEXT,'
          ' delivery_email TEXT,'
          ' delivery_cel TEXT,'
          ' delivery_address TEXT,'
          ' delivery_description TEXT,'
          ' delivery_coord_x TEXT,'
          ' delivery_coord_y TEXT,'
          ' delivery_add_info TEXT,'
          ' delivery_price TEXT,'
          ' delivery_total_orden TEXT,'
          ' delivery_payment TEXT,'
          ' delivery_entrega TEXT,'
          ' delivery_datetime TEXT,'
          ' delivery_status TEXT,'
          ' delivery_mt TEXT'

          ')');

      await db.execute(' CREATE TABLE DetallePedido('
          ' id_detalle_pedido TEXT PRIMARY KEY,'
          ' id_pedido TEXT,'
          ' id_producto TEXT,'
          ' cantidad TEXT,'
          ' detalle_pedido_marca TEXT,'
          ' detalle_pedido_modelo TEXT,'
          ' detalle_pedido_talla TEXT,'
          ' detalle_pedido_valorado TEXT,'
          ' delivery_detail_subtotal TEXT'
          ')');

      await db.execute(' CREATE TABLE Direccion('
          ' id_direccion INTEGER PRIMARY KEY AUTOINCREMENT,'
          ' address TEXT,'
          ' referencia TEXT,'
          ' distrito TEXT,'
          ' coord_x TEXT,'
          ' coord_y TEXT,'
          ' estado TEXT'
          ')');

      await db.execute(' CREATE TABLE galeriaProducto('
          ' id_producto_galeria TEXT PRIMARY KEY,'
          ' id_producto TEXT,'
          ' galeria_foto TEXT,'
          ' estado TEXT'
          ')');

      await db.execute(' CREATE TABLE Publicidad('
          ' id_publicidad TEXT PRIMARY KEY,'
          ' id_city TEXT,'
          ' id_subsidiary TEXT,'
          ' publicidad_img TEXT,'
          ' publicidad_orden TEXT,'
          ' publicidad_estado TEXT,'
          ' publicidad_datetime TEXT,'
          ' id_pago TEXT'
          ')');

      await db.execute(' CREATE TABLE Agentes('
          ' id_agente TEXT PRIMARY KEY,'
          ' id_user TEXT,'
          ' id_cuenta TEXT,'
          ' id_city TEXT,'
          ' agente_tipo TEXT,'
          ' agente_nombre TEXT,'
          ' agente_codigo TEXT,'
          ' agente_direccion TEXT,'
          ' agente_telefono TEXT,'
          ' agente_imagen TEXT,'
          ' agente_coord_x TEXT,'
          ' agente_coord_y TEXT,'
          ' agente_estado TEXT,'
          ' id_cuenta_empresa TEXT,'
          ' id_company TEXT,'
          ' cuentae_codigo TEXT,'
          ' cuentae_saldo TEXT,'
          ' cuentae_moneda TEXT,'
          ' cuentae_date TEXT,'
          ' posicion TEXT,'
          ' cuentae_estado TEXT'
          ')');

      await db.execute(' CREATE TABLE Notificaciones('
          ' id_notificacion TEXT PRIMARY KEY,'
          ' id_usuario TEXT,'
          ' notificacion_tipo TEXT,'
          ' notificacion_id_rel TEXT,'
          ' notificacion_mensaje TEXT,'
          ' notificacion_imagen TEXT,'
          ' notificacion_datetime TEXT,'
          ' notificacion_estado TEXT'
          ')');

      await db.execute(' CREATE TABLE Valoracion('
          ' id_valoracion TEXT PRIMARY KEY,'
          ' id_pedido TEXT,'
          ' id_producto TEXT,'
          ' valoracion_rating TEXT,'
          ' valoracion_comentario TEXT,'
          ' valoracion_imagen TEXT,'
          ' valoracion_datetime TEXT'
          ')');

      await db.execute('CREATE TABLE SearchHistory ('
          'id_busqueda VARCHAR  PRIMARY KEY,'
          'nombre_busqueda VARCHAR,'
          'tipo_busqueda VARCHAR,'
          'img VARCHAR,'
          'fecha VARCHAR'
          ')');
      await db.execute('CREATE TABLE Historial ('
          'text VARCHAR PRIMARY KEY,'
          'fecha VARCHAR,'
          'page_busqueda VARCHAR'
          ')');


           await db.execute('CREATE TABLE PantallaPrincipal ('
          'idPantalla VARCHAR PRIMARY KEY,'
          'nombre VARCHAR,'
          'tipo VARCHAR'
          ')');
    });
  }
}
