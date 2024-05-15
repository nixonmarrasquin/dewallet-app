import 'package:floor/floor.dart';

import '../Entities/Sesion.dart';

@dao
abstract class SesionDao {
  @Query('SELECT * FROM Sesion')
  Future<List<Sesion?>> findAllSesion();

  @Query('Select * from Sesion order by id desc limit 1')
  Future<Sesion?> getMaxTSesion();

  @Query('SELECT * FROM Sesion order by id desc')
  Stream<List<Sesion?>> fetchStreamData();

  @Query('SELECT * FROM Sesion order by id asc')
  Future<List<Sesion?>> getSesion();

 @insert
  Future<void> insertSesion(Sesion Sesion);

  @update
  Future<int> updateSesion(Sesion Sesion);

  @insert
  Future<List<int>> insertAllSesion(List<Sesion> Sesion);

  @Query("delete from Sesion where id = :id")
  Future<void> deleteSesion(int id);

  @Query("delete from Sesion")
  Future<void> cleanSesion();

  @delete
  Future<int> deleteAll(List<Sesion> list);
}