import 'dart:async';

import 'package:floor/floor.dart';
import 'package:siglo21/Dao/CuponesDao.dart';
import 'package:siglo21/Dao/DetalleFacturasDao.dart';
import 'package:siglo21/Dao/FacturasDao.dart';
import 'package:siglo21/Dao/PremiosDao.dart';
import 'package:siglo21/Dao/ProductosDao.dart';
import 'package:siglo21/Dao/SeriesDao.dart';
import 'package:siglo21/Entities/Cupones.dart';
import 'package:siglo21/Entities/DetalleFacturas.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../Dao/CategoriasDao.dart';
import '../Entities/Facturas.dart';
import '../Entities/Premios.dart';
import '../Entities/Productos.dart';
import '../Entities/Series.dart';
import '../Entities/Sesion.dart';
part 'app_database.g.dart';

@Database(version: 3,entities: [
                                  Sesion,
                                  Cupones,
                                  Series,
                                  Productos,
                                  Facturas,
                                  DetalleFacturas,
                                  Premios
                                ])

abstract class AppDatabase extends FloorDatabase {
  SesionDao get sesionDao;
  CuponesDao get cuponesDao;
  SeriesDao get seriesDao;
  ProductosDao get productosDao;
  FacturasDao get facturasDao;
  DetalleFacturasDao get detalleFacturasDao;
  PremiosDao get premiosDao;

}


