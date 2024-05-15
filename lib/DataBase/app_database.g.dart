// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  SesionDao? _sesionDaoInstance;

  CuponesDao? _cuponesDaoInstance;

  SeriesDao? _seriesDaoInstance;

  ProductosDao? _productosDaoInstance;

  FacturasDao? _facturasDaoInstance;

  DetalleFacturasDao? _detalleFacturasDaoInstance;

  PremiosDao? _premiosDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 3,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Sesion` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `sms` INTEGER, `mensaje` TEXT, `local` INTEGER, `codigo_c` TEXT, `codigo_v` TEXT, `correo` TEXT, `lista_precio` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Cupones` (`integer` INTEGER PRIMARY KEY AUTOINCREMENT, `id` INTEGER, `id_local` INTEGER, `nombre` TEXT, `descripcion` TEXT, `valor` TEXT, `fecha_ini` TEXT, `fecha_fin` TEXT, `url_imagen` TEXT, `created_at` TEXT, `updated_at` TEXT, `deleted_at` TEXT, `user_updated` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Series` (`integer` INTEGER PRIMARY KEY AUTOINCREMENT, `Serie` TEXT, `FacturaS21` TEXT, `CodigoCliente` TEXT, `CodigoItem` TEXT, `NombreItem` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Productos` (`integer` INTEGER PRIMARY KEY AUTOINCREMENT, `cod_producto` TEXT, `nombre` TEXT, `valor` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Facturas` (`integer` INTEGER PRIMARY KEY AUTOINCREMENT, `numOrder` TEXT, `codCliente` TEXT, `numFactura` TEXT, `mail` TEXT, `subtotalFac` REAL, `totalFac` REAL, `valorPremio` REAL, `created_at` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `DetalleFacturas` (`integer` INTEGER PRIMARY KEY AUTOINCREMENT, `id_numOrder` TEXT, `codCliente` TEXT, `itemCodigo` TEXT, `descripcion` TEXT, `serie` TEXT, `numFactura` TEXT, `precioUnitario` REAL, `iva` REAL, `valorPremio` REAL, `created_at` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Premios` (`integer` INTEGER PRIMARY KEY AUTOINCREMENT, `idtarjeta` TEXT, `nombreTarjeta` TEXT, `valor` REAL, `codCliente` TEXT, `codVendedor` TEXT, `fechaCanje` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  SesionDao get sesionDao {
    return _sesionDaoInstance ??= _$SesionDao(database, changeListener);
  }

  @override
  CuponesDao get cuponesDao {
    return _cuponesDaoInstance ??= _$CuponesDao(database, changeListener);
  }

  @override
  SeriesDao get seriesDao {
    return _seriesDaoInstance ??= _$SeriesDao(database, changeListener);
  }

  @override
  ProductosDao get productosDao {
    return _productosDaoInstance ??= _$ProductosDao(database, changeListener);
  }

  @override
  FacturasDao get facturasDao {
    return _facturasDaoInstance ??= _$FacturasDao(database, changeListener);
  }

  @override
  DetalleFacturasDao get detalleFacturasDao {
    return _detalleFacturasDaoInstance ??=
        _$DetalleFacturasDao(database, changeListener);
  }

  @override
  PremiosDao get premiosDao {
    return _premiosDaoInstance ??= _$PremiosDao(database, changeListener);
  }
}

class _$SesionDao extends SesionDao {
  _$SesionDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _sesionInsertionAdapter = InsertionAdapter(
            database,
            'Sesion',
            (Sesion item) => <String, Object?>{
                  'id': item.id,
                  'sms': item.sms == null ? null : (item.sms! ? 1 : 0),
                  'mensaje': item.mensaje,
                  'local': item.local,
                  'codigo_c': item.codigo_c,
                  'codigo_v': item.codigo_v,
                  'correo': item.correo,
                  'lista_precio': item.lista_precio
                },
            changeListener),
        _sesionUpdateAdapter = UpdateAdapter(
            database,
            'Sesion',
            ['id'],
            (Sesion item) => <String, Object?>{
                  'id': item.id,
                  'sms': item.sms == null ? null : (item.sms! ? 1 : 0),
                  'mensaje': item.mensaje,
                  'local': item.local,
                  'codigo_c': item.codigo_c,
                  'codigo_v': item.codigo_v,
                  'correo': item.correo,
                  'lista_precio': item.lista_precio
                },
            changeListener),
        _sesionDeletionAdapter = DeletionAdapter(
            database,
            'Sesion',
            ['id'],
            (Sesion item) => <String, Object?>{
                  'id': item.id,
                  'sms': item.sms == null ? null : (item.sms! ? 1 : 0),
                  'mensaje': item.mensaje,
                  'local': item.local,
                  'codigo_c': item.codigo_c,
                  'codigo_v': item.codigo_v,
                  'correo': item.correo,
                  'lista_precio': item.lista_precio
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Sesion> _sesionInsertionAdapter;

  final UpdateAdapter<Sesion> _sesionUpdateAdapter;

  final DeletionAdapter<Sesion> _sesionDeletionAdapter;

  @override
  Future<List<Sesion?>> findAllSesion() async {
    return _queryAdapter.queryList('SELECT * FROM Sesion',
        mapper: (Map<String, Object?> row) => Sesion(
            id: row['id'] as int?,
            sms: row['sms'] == null ? null : (row['sms'] as int) != 0,
            mensaje: row['mensaje'] as String?,
            local: row['local'] as int?,
            codigo_v: row['codigo_v'] as String?,
            codigo_c: row['codigo_c'] as String?,
            correo: row['correo'] as String?,
            lista_precio: row['lista_precio'] as int?));
  }

  @override
  Future<Sesion?> getMaxTSesion() async {
    return _queryAdapter.query('Select * from Sesion order by id desc limit 1',
        mapper: (Map<String, Object?> row) => Sesion(
            id: row['id'] as int?,
            sms: row['sms'] == null ? null : (row['sms'] as int) != 0,
            mensaje: row['mensaje'] as String?,
            local: row['local'] as int?,
            codigo_v: row['codigo_v'] as String?,
            codigo_c: row['codigo_c'] as String?,
            correo: row['correo'] as String?,
            lista_precio: row['lista_precio'] as int?));
  }

  @override
  Stream<List<Sesion?>> fetchStreamData() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM Sesion order by id desc',
        mapper: (Map<String, Object?> row) => Sesion(
            id: row['id'] as int?,
            sms: row['sms'] == null ? null : (row['sms'] as int) != 0,
            mensaje: row['mensaje'] as String?,
            local: row['local'] as int?,
            codigo_v: row['codigo_v'] as String?,
            codigo_c: row['codigo_c'] as String?,
            correo: row['correo'] as String?,
            lista_precio: row['lista_precio'] as int?),
        queryableName: 'Sesion',
        isView: false);
  }

  @override
  Future<List<Sesion?>> getSesion() async {
    return _queryAdapter.queryList('SELECT * FROM Sesion order by id asc',
        mapper: (Map<String, Object?> row) => Sesion(
            id: row['id'] as int?,
            sms: row['sms'] == null ? null : (row['sms'] as int) != 0,
            mensaje: row['mensaje'] as String?,
            local: row['local'] as int?,
            codigo_v: row['codigo_v'] as String?,
            codigo_c: row['codigo_c'] as String?,
            correo: row['correo'] as String?,
            lista_precio: row['lista_precio'] as int?));
  }

  @override
  Future<void> deleteSesion(int id) async {
    await _queryAdapter
        .queryNoReturn('delete from Sesion where id = ?1', arguments: [id]);
  }

  @override
  Future<void> cleanSesion() async {
    await _queryAdapter.queryNoReturn('delete from Sesion');
  }

  @override
  Future<void> insertSesion(Sesion Sesion) async {
    await _sesionInsertionAdapter.insert(Sesion, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertAllSesion(List<Sesion> Sesion) {
    return _sesionInsertionAdapter.insertListAndReturnIds(
        Sesion, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateSesion(Sesion Sesion) {
    return _sesionUpdateAdapter.updateAndReturnChangedRows(
        Sesion, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteAll(List<Sesion> list) {
    return _sesionDeletionAdapter.deleteListAndReturnChangedRows(list);
  }
}

class _$CuponesDao extends CuponesDao {
  _$CuponesDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _cuponesInsertionAdapter = InsertionAdapter(
            database,
            'Cupones',
            (Cupones item) => <String, Object?>{
                  'integer': item.integer,
                  'id': item.id,
                  'id_local': item.id_local,
                  'nombre': item.nombre,
                  'descripcion': item.descripcion,
                  'valor': item.valor,
                  'fecha_ini': item.fecha_ini,
                  'fecha_fin': item.fecha_fin,
                  'url_imagen': item.url_imagen,
                  'created_at': item.created_at,
                  'updated_at': item.updated_at,
                  'deleted_at': item.deleted_at,
                  'user_updated': item.user_updated
                },
            changeListener),
        _cuponesUpdateAdapter = UpdateAdapter(
            database,
            'Cupones',
            ['integer'],
            (Cupones item) => <String, Object?>{
                  'integer': item.integer,
                  'id': item.id,
                  'id_local': item.id_local,
                  'nombre': item.nombre,
                  'descripcion': item.descripcion,
                  'valor': item.valor,
                  'fecha_ini': item.fecha_ini,
                  'fecha_fin': item.fecha_fin,
                  'url_imagen': item.url_imagen,
                  'created_at': item.created_at,
                  'updated_at': item.updated_at,
                  'deleted_at': item.deleted_at,
                  'user_updated': item.user_updated
                },
            changeListener),
        _cuponesDeletionAdapter = DeletionAdapter(
            database,
            'Cupones',
            ['integer'],
            (Cupones item) => <String, Object?>{
                  'integer': item.integer,
                  'id': item.id,
                  'id_local': item.id_local,
                  'nombre': item.nombre,
                  'descripcion': item.descripcion,
                  'valor': item.valor,
                  'fecha_ini': item.fecha_ini,
                  'fecha_fin': item.fecha_fin,
                  'url_imagen': item.url_imagen,
                  'created_at': item.created_at,
                  'updated_at': item.updated_at,
                  'deleted_at': item.deleted_at,
                  'user_updated': item.user_updated
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Cupones> _cuponesInsertionAdapter;

  final UpdateAdapter<Cupones> _cuponesUpdateAdapter;

  final DeletionAdapter<Cupones> _cuponesDeletionAdapter;

  @override
  Future<List<Cupones?>> findAllCupones() async {
    return _queryAdapter.queryList('SELECT * FROM Cupones',
        mapper: (Map<String, Object?> row) => Cupones(
            integer: row['integer'] as int?,
            id: row['id'] as int?,
            id_local: row['id_local'] as int?,
            nombre: row['nombre'] as String?,
            descripcion: row['descripcion'] as String?,
            valor: row['valor'] as String?,
            fecha_ini: row['fecha_ini'] as String?,
            fecha_fin: row['fecha_fin'] as String?,
            url_imagen: row['url_imagen'] as String?,
            created_at: row['created_at'] as String?,
            updated_at: row['updated_at'] as String?,
            deleted_at: row['deleted_at'] as String?,
            user_updated: row['user_updated'] as int?));
  }

  @override
  Future<Cupones?> getMaxTCupones() async {
    return _queryAdapter.query(
        'Select * from Cupones order by integer desc limit 1',
        mapper: (Map<String, Object?> row) => Cupones(
            integer: row['integer'] as int?,
            id: row['id'] as int?,
            id_local: row['id_local'] as int?,
            nombre: row['nombre'] as String?,
            descripcion: row['descripcion'] as String?,
            valor: row['valor'] as String?,
            fecha_ini: row['fecha_ini'] as String?,
            fecha_fin: row['fecha_fin'] as String?,
            url_imagen: row['url_imagen'] as String?,
            created_at: row['created_at'] as String?,
            updated_at: row['updated_at'] as String?,
            deleted_at: row['deleted_at'] as String?,
            user_updated: row['user_updated'] as int?));
  }

  @override
  Stream<List<Cupones?>> fetchStreamData() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM Cupones order by integer desc',
        mapper: (Map<String, Object?> row) => Cupones(
            integer: row['integer'] as int?,
            id: row['id'] as int?,
            id_local: row['id_local'] as int?,
            nombre: row['nombre'] as String?,
            descripcion: row['descripcion'] as String?,
            valor: row['valor'] as String?,
            fecha_ini: row['fecha_ini'] as String?,
            fecha_fin: row['fecha_fin'] as String?,
            url_imagen: row['url_imagen'] as String?,
            created_at: row['created_at'] as String?,
            updated_at: row['updated_at'] as String?,
            deleted_at: row['deleted_at'] as String?,
            user_updated: row['user_updated'] as int?),
        queryableName: 'Cupones',
        isView: false);
  }

  @override
  Future<List<Cupones?>> getCupones() async {
    return _queryAdapter.queryList('SELECT * FROM Cupones order by integer asc',
        mapper: (Map<String, Object?> row) => Cupones(
            integer: row['integer'] as int?,
            id: row['id'] as int?,
            id_local: row['id_local'] as int?,
            nombre: row['nombre'] as String?,
            descripcion: row['descripcion'] as String?,
            valor: row['valor'] as String?,
            fecha_ini: row['fecha_ini'] as String?,
            fecha_fin: row['fecha_fin'] as String?,
            url_imagen: row['url_imagen'] as String?,
            created_at: row['created_at'] as String?,
            updated_at: row['updated_at'] as String?,
            deleted_at: row['deleted_at'] as String?,
            user_updated: row['user_updated'] as int?));
  }

  @override
  Future<void> deleteCupones(int integer) async {
    await _queryAdapter.queryNoReturn('delete from Cupones where integer = ?1',
        arguments: [integer]);
  }

  @override
  Future<void> cleanCupones() async {
    await _queryAdapter.queryNoReturn('delete from Cupones');
  }

  @override
  Future<void> insertCupones(Cupones Cupones) async {
    await _cuponesInsertionAdapter.insert(Cupones, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertAllCupones(List<Cupones> Cupones) {
    return _cuponesInsertionAdapter.insertListAndReturnIds(
        Cupones, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateCupones(Cupones Cupones) {
    return _cuponesUpdateAdapter.updateAndReturnChangedRows(
        Cupones, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteAll(List<Cupones> list) {
    return _cuponesDeletionAdapter.deleteListAndReturnChangedRows(list);
  }
}

class _$SeriesDao extends SeriesDao {
  _$SeriesDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _seriesInsertionAdapter = InsertionAdapter(
            database,
            'Series',
            (Series item) => <String, Object?>{
                  'integer': item.integer,
                  'Serie': item.Serie,
                  'FacturaS21': item.FacturaS21,
                  'CodigoCliente': item.CodigoCliente,
                  'CodigoItem': item.CodigoItem,
                  'NombreItem': item.NombreItem
                },
            changeListener),
        _seriesUpdateAdapter = UpdateAdapter(
            database,
            'Series',
            ['integer'],
            (Series item) => <String, Object?>{
                  'integer': item.integer,
                  'Serie': item.Serie,
                  'FacturaS21': item.FacturaS21,
                  'CodigoCliente': item.CodigoCliente,
                  'CodigoItem': item.CodigoItem,
                  'NombreItem': item.NombreItem
                },
            changeListener),
        _seriesDeletionAdapter = DeletionAdapter(
            database,
            'Series',
            ['integer'],
            (Series item) => <String, Object?>{
                  'integer': item.integer,
                  'Serie': item.Serie,
                  'FacturaS21': item.FacturaS21,
                  'CodigoCliente': item.CodigoCliente,
                  'CodigoItem': item.CodigoItem,
                  'NombreItem': item.NombreItem
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Series> _seriesInsertionAdapter;

  final UpdateAdapter<Series> _seriesUpdateAdapter;

  final DeletionAdapter<Series> _seriesDeletionAdapter;

  @override
  Future<List<Series?>> findAllSeries() async {
    return _queryAdapter.queryList('SELECT * FROM Series',
        mapper: (Map<String, Object?> row) => Series(
            integer: row['integer'] as int?,
            Serie: row['Serie'] as String?,
            FacturaS21: row['FacturaS21'] as String?,
            CodigoCliente: row['CodigoCliente'] as String?,
            CodigoItem: row['CodigoItem'] as String?,
            NombreItem: row['NombreItem'] as String?));
  }

  @override
  Future<Series?> getMaxTSeries() async {

    return _queryAdapter.query(
        'Select * from Series order by integer desc limit 1',
        mapper: (Map<String, Object?> row) => Series(
            integer: row['integer'] as int?,
            Serie: row['Serie'] as String?,
            FacturaS21: row['FacturaS21'] as String?,
            CodigoCliente: row['CodigoCliente'] as String?,
            CodigoItem: row['CodigoItem'] as String?,
            NombreItem: row['NombreItem'] as String?));
  }

  @override
  Stream<List<Series?>> fetchStreamData() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM Series order by integer desc',
        mapper: (Map<String, Object?> row) => Series(
            integer: row['integer'] as int?,
            Serie: row['Serie'] as String?,
            FacturaS21: row['FacturaS21'] as String?,
            CodigoCliente: row['CodigoCliente'] as String?,
            CodigoItem: row['CodigoItem'] as String?,
            NombreItem: row['NombreItem'] as String?),
        queryableName: 'Series',
        isView: false);
  }

  @override
  Future<List<Series?>> getSeries() async {
    return _queryAdapter.queryList('SELECT * FROM Series order by integer asc',
        mapper: (Map<String, Object?> row) => Series(
            integer: row['integer'] as int?,
            Serie: row['Serie'] as String?,
            FacturaS21: row['FacturaS21'] as String?,
            CodigoCliente: row['CodigoCliente'] as String?,
            CodigoItem: row['CodigoItem'] as String?,
            NombreItem: row['NombreItem'] as String?));
  }

  @override
  Future<List<Series?>> getSeriesByID(String Serie) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Series where Serie = ?1 order by integer asc',
        mapper: (Map<String, Object?> row) => Series(
            integer: row['integer'] as int?,
            Serie: row['Serie'] as String?,
            FacturaS21: row['FacturaS21'] as String?,
            CodigoCliente: row['CodigoCliente'] as String?,
            CodigoItem: row['CodigoItem'] as String?,
            NombreItem: row['NombreItem'] as String?),
        arguments: [Serie]);
  }

  @override
  Future<void> deleteSeries(int integer) async {
    await _queryAdapter.queryNoReturn('delete from Series where integer = ?1',
        arguments: [integer]);
  }

  @override
  Future<void> cleanSeries() async {
    await _queryAdapter.queryNoReturn('delete from Series');
  }

  @override
  Future<void> insertSeries(Series Series) async {
    await _seriesInsertionAdapter.insert(Series, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertAllSeries(List<Series> Series) {
    return _seriesInsertionAdapter.insertListAndReturnIds(
        Series, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateSeries(Series Series) {
    return _seriesUpdateAdapter.updateAndReturnChangedRows(
        Series, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteAll(List<Series> list) {
    return _seriesDeletionAdapter.deleteListAndReturnChangedRows(list);
  }
}

class _$ProductosDao extends ProductosDao {
  _$ProductosDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _productosInsertionAdapter = InsertionAdapter(
            database,
            'Productos',
            (Productos item) => <String, Object?>{
                  'integer': item.integer,
                  'cod_producto': item.cod_producto,
                  'nombre': item.nombre,
                  'valor': item.valor
                },
            changeListener),
        _productosUpdateAdapter = UpdateAdapter(
            database,
            'Productos',
            ['integer'],
            (Productos item) => <String, Object?>{
                  'integer': item.integer,
                  'cod_producto': item.cod_producto,
                  'nombre': item.nombre,
                  'valor': item.valor
                },
            changeListener),
        _productosDeletionAdapter = DeletionAdapter(
            database,
            'Productos',
            ['integer'],
            (Productos item) => <String, Object?>{
                  'integer': item.integer,
                  'cod_producto': item.cod_producto,
                  'nombre': item.nombre,
                  'valor': item.valor
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Productos> _productosInsertionAdapter;

  final UpdateAdapter<Productos> _productosUpdateAdapter;

  final DeletionAdapter<Productos> _productosDeletionAdapter;

  @override
  Future<List<Productos?>> findAllProductos() async {
    return _queryAdapter.queryList('SELECT * FROM Productos',
        mapper: (Map<String, Object?> row) => Productos(
            integer: row['integer'] as int?,
            cod_producto: row['cod_producto'] as String?,
            nombre: row['nombre'] as String?,
            valor: row['valor'] as String?));
  }

  @override
  Future<Productos?> getMaxTProductos() async {
    return _queryAdapter.query(
        'Select * from Productos order by integer desc limit 1',
        mapper: (Map<String, Object?> row) => Productos(
            integer: row['integer'] as int?,
            cod_producto: row['cod_producto'] as String?,
            nombre: row['nombre'] as String?,
            valor: row['valor'] as String?));
  }

  @override
  Stream<List<Productos?>> fetchStreamData() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM Productos order by integer desc',
        mapper: (Map<String, Object?> row) => Productos(
            integer: row['integer'] as int?,
            cod_producto: row['cod_producto'] as String?,
            nombre: row['nombre'] as String?,
            valor: row['valor'] as String?),
        queryableName: 'Productos',
        isView: false);
  }

  @override
  Future<List<Productos?>> getProductos() async {
    return _queryAdapter.queryList(
        'SELECT * FROM Productos order by integer asc',
        mapper: (Map<String, Object?> row) => Productos(
            integer: row['integer'] as int?,
            cod_producto: row['cod_producto'] as String?,
            nombre: row['nombre'] as String?,
            valor: row['valor'] as String?));
  }

  @override
  Future<List<Productos?>> getProductosByID(String Serie) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Productos where Serie = ?1 order by integer asc',
        mapper: (Map<String, Object?> row) => Productos(
            integer: row['integer'] as int?,
            cod_producto: row['cod_producto'] as String?,
            nombre: row['nombre'] as String?,
            valor: row['valor'] as String?),
        arguments: [Serie]);
  }

  @override
  Future<void> deleteProductos(int integer) async {
    await _queryAdapter.queryNoReturn(
        'delete from Productos where integer = ?1',
        arguments: [integer]);
  }

  @override
  Future<void> cleanProductos() async {
    await _queryAdapter.queryNoReturn('delete from Productos');
  }

  @override
  Future<void> insertProductos(Productos Productos) async {
    await _productosInsertionAdapter.insert(
        Productos, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertAllProductos(List<Productos> Productos) {
    return _productosInsertionAdapter.insertListAndReturnIds(
        Productos, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateProductos(Productos Productos) {
    return _productosUpdateAdapter.updateAndReturnChangedRows(
        Productos, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteAll(List<Productos> list) {
    return _productosDeletionAdapter.deleteListAndReturnChangedRows(list);
  }
}

class _$FacturasDao extends FacturasDao {
  _$FacturasDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _facturasInsertionAdapter = InsertionAdapter(
            database,
            'Facturas',
            (Facturas item) => <String, Object?>{
                  'integer': item.integer,
                  'numOrder': item.numOrder,
                  'codCliente': item.codCliente,
                  'numFactura': item.numFactura,
                  'mail': item.mail,
                  'subtotalFac': item.subtotalFac,
                  'totalFac': item.totalFac,
                  'valorPremio': item.valorPremio,
                  'created_at': item.created_at
                },
            changeListener),
        _facturasUpdateAdapter = UpdateAdapter(
            database,
            'Facturas',
            ['integer'],
            (Facturas item) => <String, Object?>{
                  'integer': item.integer,
                  'numOrder': item.numOrder,
                  'codCliente': item.codCliente,
                  'numFactura': item.numFactura,
                  'mail': item.mail,
                  'subtotalFac': item.subtotalFac,
                  'totalFac': item.totalFac,
                  'valorPremio': item.valorPremio,
                  'created_at': item.created_at
                },
            changeListener),
        _facturasDeletionAdapter = DeletionAdapter(
            database,
            'Facturas',
            ['integer'],
            (Facturas item) => <String, Object?>{
                  'integer': item.integer,
                  'numOrder': item.numOrder,
                  'codCliente': item.codCliente,
                  'numFactura': item.numFactura,
                  'mail': item.mail,
                  'subtotalFac': item.subtotalFac,
                  'totalFac': item.totalFac,
                  'valorPremio': item.valorPremio,
                  'created_at': item.created_at
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Facturas> _facturasInsertionAdapter;

  final UpdateAdapter<Facturas> _facturasUpdateAdapter;

  final DeletionAdapter<Facturas> _facturasDeletionAdapter;

  @override
  Future<List<Facturas?>> findAllFacturas() async {
    return _queryAdapter.queryList('SELECT * FROM Facturas',
        mapper: (Map<String, Object?> row) => Facturas(
            integer: row['integer'] as int?,
            numOrder: row['numOrder'] as String?,
            codCliente: row['codCliente'] as String?,
            numFactura: row['numFactura'] as String?,
            mail: row['mail'] as String?,
            subtotalFac: row['subtotalFac'] as double?,
            totalFac: row['totalFac'] as double?,
            valorPremio: row['valorPremio'] as double?,
            created_at: row['created_at'] as String?));
  }

  @override
  Future<Facturas?> getMaxTFacturas() async {
    return _queryAdapter.query(
        'Select * from Facturas order by integer desc limit 1',
        mapper: (Map<String, Object?> row) => Facturas(
            integer: row['integer'] as int?,
            numOrder: row['numOrder'] as String?,
            codCliente: row['codCliente'] as String?,
            numFactura: row['numFactura'] as String?,
            mail: row['mail'] as String?,
            subtotalFac: row['subtotalFac'] as double?,
            totalFac: row['totalFac'] as double?,
            valorPremio: row['valorPremio'] as double?,
            created_at: row['created_at'] as String?));
  }

  @override
  Stream<List<Facturas?>> fetchStreamData() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM Facturas order by integer desc',
        mapper: (Map<String, Object?> row) => Facturas(
            integer: row['integer'] as int?,
            numOrder: row['numOrder'] as String?,
            codCliente: row['codCliente'] as String?,
            numFactura: row['numFactura'] as String?,
            mail: row['mail'] as String?,
            subtotalFac: row['subtotalFac'] as double?,
            totalFac: row['totalFac'] as double?,
            valorPremio: row['valorPremio'] as double?,
            created_at: row['created_at'] as String?),
        queryableName: 'Facturas',
        isView: false);
  }

  @override
  Future<List<Facturas?>> getFacturas() async {
    return _queryAdapter.queryList(
        'SELECT * FROM Facturas order by integer desc',
        mapper: (Map<String, Object?> row) => Facturas(
            integer: row['integer'] as int?,
            numOrder: row['numOrder'] as String?,
            codCliente: row['codCliente'] as String?,
            numFactura: row['numFactura'] as String?,
            mail: row['mail'] as String?,
            subtotalFac: row['subtotalFac'] as double?,
            totalFac: row['totalFac'] as double?,
            valorPremio: row['valorPremio'] as double?,
            created_at: row['created_at'] as String?));
  }

  @override
  Future<void> deleteFacturas(int integer) async {
    await _queryAdapter.queryNoReturn('delete from Facturas where integer = ?1',
        arguments: [integer]);
  }

  @override
  Future<void> cleanFacturas() async {
    await _queryAdapter.queryNoReturn('delete from Facturas');
  }

  @override
  Future<void> insertFacturas(Facturas Facturas) async {
    await _facturasInsertionAdapter.insert(Facturas, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertAllFacturas(List<Facturas> Facturas) {
    return _facturasInsertionAdapter.insertListAndReturnIds(
        Facturas, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateFacturas(Facturas Facturas) {
    return _facturasUpdateAdapter.updateAndReturnChangedRows(
        Facturas, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteAll(List<Facturas> list) {
    return _facturasDeletionAdapter.deleteListAndReturnChangedRows(list);
  }
}

class _$DetalleFacturasDao extends DetalleFacturasDao {
  _$DetalleFacturasDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _detalleFacturasInsertionAdapter = InsertionAdapter(
            database,
            'DetalleFacturas',
            (DetalleFacturas item) => <String, Object?>{
                  'integer': item.integer,
                  'id_numOrder': item.id_numOrder,
                  'codCliente': item.codCliente,
                  'itemCodigo': item.itemCodigo,
                  'descripcion': item.descripcion,
                  'serie': item.serie,
                  'numFactura': item.numFactura,
                  'precioUnitario': item.precioUnitario,
                  'iva': item.iva,
                  'valorPremio': item.valorPremio,
                  'created_at': item.created_at
                },
            changeListener),
        _detalleFacturasUpdateAdapter = UpdateAdapter(
            database,
            'DetalleFacturas',
            ['integer'],
            (DetalleFacturas item) => <String, Object?>{
                  'integer': item.integer,
                  'id_numOrder': item.id_numOrder,
                  'codCliente': item.codCliente,
                  'itemCodigo': item.itemCodigo,
                  'descripcion': item.descripcion,
                  'serie': item.serie,
                  'numFactura': item.numFactura,
                  'precioUnitario': item.precioUnitario,
                  'iva': item.iva,
                  'valorPremio': item.valorPremio,
                  'created_at': item.created_at
                },
            changeListener),
        _detalleFacturasDeletionAdapter = DeletionAdapter(
            database,
            'DetalleFacturas',
            ['integer'],
            (DetalleFacturas item) => <String, Object?>{
                  'integer': item.integer,
                  'id_numOrder': item.id_numOrder,
                  'codCliente': item.codCliente,
                  'itemCodigo': item.itemCodigo,
                  'descripcion': item.descripcion,
                  'serie': item.serie,
                  'numFactura': item.numFactura,
                  'precioUnitario': item.precioUnitario,
                  'iva': item.iva,
                  'valorPremio': item.valorPremio,
                  'created_at': item.created_at
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<DetalleFacturas> _detalleFacturasInsertionAdapter;

  final UpdateAdapter<DetalleFacturas> _detalleFacturasUpdateAdapter;

  final DeletionAdapter<DetalleFacturas> _detalleFacturasDeletionAdapter;

  @override
  Future<List<DetalleFacturas?>> findAllDetalleFacturas() async {
    return _queryAdapter.queryList('SELECT * FROM DetalleFacturas',
        mapper: (Map<String, Object?> row) => DetalleFacturas(
            integer: row['integer'] as int?,
            id_numOrder: row['id_numOrder'] as String?,
            codCliente: row['codCliente'] as String?,
            itemCodigo: row['itemCodigo'] as String?,
            descripcion: row['descripcion'] as String?,
            serie: row['serie'] as String?,
            numFactura: row['numFactura'] as String?,
            precioUnitario: row['precioUnitario'] as double?,
            iva: row['iva'] as double?,
            valorPremio: row['valorPremio'] as double?,
            created_at: row['created_at'] as String?));
  }

  @override
  Future<DetalleFacturas?> getMaxTDetalleFacturas() async {
    return _queryAdapter.query(
        'Select * from DetalleFacturas order by integer desc limit 1',
        mapper: (Map<String, Object?> row) => DetalleFacturas(
            integer: row['integer'] as int?,
            id_numOrder: row['id_numOrder'] as String?,
            codCliente: row['codCliente'] as String?,
            itemCodigo: row['itemCodigo'] as String?,
            descripcion: row['descripcion'] as String?,
            serie: row['serie'] as String?,
            numFactura: row['numFactura'] as String?,
            precioUnitario: row['precioUnitario'] as double?,
            iva: row['iva'] as double?,
            valorPremio: row['valorPremio'] as double?,
            created_at: row['created_at'] as String?));
  }

  @override
  Stream<List<DetalleFacturas?>> fetchStreamData() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM DetalleFacturas order by integer desc',
        mapper: (Map<String, Object?> row) => DetalleFacturas(
            integer: row['integer'] as int?,
            id_numOrder: row['id_numOrder'] as String?,
            codCliente: row['codCliente'] as String?,
            itemCodigo: row['itemCodigo'] as String?,
            descripcion: row['descripcion'] as String?,
            serie: row['serie'] as String?,
            numFactura: row['numFactura'] as String?,
            precioUnitario: row['precioUnitario'] as double?,
            iva: row['iva'] as double?,
            valorPremio: row['valorPremio'] as double?,
            created_at: row['created_at'] as String?),
        queryableName: 'DetalleFacturas',
        isView: false);
  }

  @override
  Future<List<DetalleFacturas?>> getDetalleFacturas() async {
    return _queryAdapter.queryList(
        'SELECT * FROM DetalleFacturas order by integer asc',
        mapper: (Map<String, Object?> row) => DetalleFacturas(
            integer: row['integer'] as int?,
            id_numOrder: row['id_numOrder'] as String?,
            codCliente: row['codCliente'] as String?,
            itemCodigo: row['itemCodigo'] as String?,
            descripcion: row['descripcion'] as String?,
            serie: row['serie'] as String?,
            numFactura: row['numFactura'] as String?,
            precioUnitario: row['precioUnitario'] as double?,
            iva: row['iva'] as double?,
            valorPremio: row['valorPremio'] as double?,
            created_at: row['created_at'] as String?));
  }

  @override
  Future<void> deleteDetalleFacturas(int integer) async {
    await _queryAdapter.queryNoReturn(
        'delete from DetalleFacturas where integer = ?1',
        arguments: [integer]);
  }

  @override
  Future<void> cleanDetalleFacturas() async {
    await _queryAdapter.queryNoReturn('delete from DetalleFacturas');
  }

  @override
  Future<void> insertDetalleFacturas(DetalleFacturas DetalleFacturas) async {
    await _detalleFacturasInsertionAdapter.insert(
        DetalleFacturas, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertAllDetalleFacturas(
      List<DetalleFacturas> DetalleFacturas) {
    return _detalleFacturasInsertionAdapter.insertListAndReturnIds(
        DetalleFacturas, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateDetalleFacturas(DetalleFacturas DetalleFacturas) {
    return _detalleFacturasUpdateAdapter.updateAndReturnChangedRows(
        DetalleFacturas, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteAll(List<DetalleFacturas> list) {
    return _detalleFacturasDeletionAdapter.deleteListAndReturnChangedRows(list);
  }
}

class _$PremiosDao extends PremiosDao {
  _$PremiosDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _premiosInsertionAdapter = InsertionAdapter(
            database,
            'Premios',
            (Premios item) => <String, Object?>{
                  'integer': item.integer,
                  'idtarjeta': item.idtarjeta,
                  'nombreTarjeta': item.nombreTarjeta,
                  'valor': item.valor,
                  'codCliente': item.codCliente,
                  'codVendedor': item.codVendedor,
                  'fechaCanje': item.fechaCanje
                },
            changeListener),
        _premiosUpdateAdapter = UpdateAdapter(
            database,
            'Premios',
            ['integer'],
            (Premios item) => <String, Object?>{
                  'integer': item.integer,
                  'idtarjeta': item.idtarjeta,
                  'nombreTarjeta': item.nombreTarjeta,
                  'valor': item.valor,
                  'codCliente': item.codCliente,
                  'codVendedor': item.codVendedor,
                  'fechaCanje': item.fechaCanje
                },
            changeListener),
        _premiosDeletionAdapter = DeletionAdapter(
            database,
            'Premios',
            ['integer'],
            (Premios item) => <String, Object?>{
                  'integer': item.integer,
                  'idtarjeta': item.idtarjeta,
                  'nombreTarjeta': item.nombreTarjeta,
                  'valor': item.valor,
                  'codCliente': item.codCliente,
                  'codVendedor': item.codVendedor,
                  'fechaCanje': item.fechaCanje
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Premios> _premiosInsertionAdapter;

  final UpdateAdapter<Premios> _premiosUpdateAdapter;

  final DeletionAdapter<Premios> _premiosDeletionAdapter;

  @override
  Future<List<Premios?>> findAllPremios() async {
    return _queryAdapter.queryList('SELECT * FROM Premios',
        mapper: (Map<String, Object?> row) => Premios(
            integer: row['integer'] as int?,
            idtarjeta: row['idtarjeta'] as String?,
            nombreTarjeta: row['nombreTarjeta'] as String?,
            valor: row['valor'] as double?,
            codCliente: row['codCliente'] as String?,
            codVendedor: row['codVendedor'] as String?,
            fechaCanje: row['fechaCanje'] as String?));
  }

  @override
  Future<Premios?> getMaxTPremios() async {
    return _queryAdapter.query(
        'Select * from Premios order by integer desc limit 1',
        mapper: (Map<String, Object?> row) => Premios(
            integer: row['integer'] as int?,
            idtarjeta: row['idtarjeta'] as String?,
            nombreTarjeta: row['nombreTarjeta'] as String?,
            valor: row['valor'] as double?,
            codCliente: row['codCliente'] as String?,
            codVendedor: row['codVendedor'] as String?,
            fechaCanje: row['fechaCanje'] as String?));
  }

  @override
  Stream<List<Premios?>> fetchStreamData() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM Premios order by integer desc',
        mapper: (Map<String, Object?> row) => Premios(
            integer: row['integer'] as int?,
            idtarjeta: row['idtarjeta'] as String?,
            nombreTarjeta: row['nombreTarjeta'] as String?,
            valor: row['valor'] as double?,
            codCliente: row['codCliente'] as String?,
            codVendedor: row['codVendedor'] as String?,
            fechaCanje: row['fechaCanje'] as String?),
        queryableName: 'Premios',
        isView: false);
  }

  @override
  Future<List<Premios?>> getPremios() async {
    return _queryAdapter.queryList('SELECT * FROM Premios order by integer asc',
        mapper: (Map<String, Object?> row) => Premios(
            integer: row['integer'] as int?,
            idtarjeta: row['idtarjeta'] as String?,
            nombreTarjeta: row['nombreTarjeta'] as String?,
            valor: row['valor'] as double?,
            codCliente: row['codCliente'] as String?,
            codVendedor: row['codVendedor'] as String?,
            fechaCanje: row['fechaCanje'] as String?));
  }

  @override
  Future<void> deletePremios(int integer) async {
    await _queryAdapter.queryNoReturn('delete from Premios where integer = ?1',
        arguments: [integer]);
  }

  @override
  Future<void> cleanPremios() async {
    await _queryAdapter.queryNoReturn('delete from Premios');
  }

  @override
  Future<void> insertPremios(Premios Premios) async {
    await _premiosInsertionAdapter.insert(Premios, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertAllPremios(List<Premios> Premios) {
    return _premiosInsertionAdapter.insertListAndReturnIds(
        Premios, OnConflictStrategy.abort);
  }

  @override
  Future<int> updatePremios(Premios Premios) {
    return _premiosUpdateAdapter.updateAndReturnChangedRows(
        Premios, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteAll(List<Premios> list) {
    return _premiosDeletionAdapter.deleteListAndReturnChangedRows(list);
  }
}
