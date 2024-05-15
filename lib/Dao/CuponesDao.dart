import 'package:floor/floor.dart';

import '../Entities/Cupones.dart';

@dao
abstract class CuponesDao {
  @Query('SELECT * FROM Cupones')
  Future<List<Cupones?>> findAllCupones();

  @Query('Select * from Cupones order by integer desc limit 1')
  Future<Cupones?> getMaxTCupones();

  @Query('SELECT * FROM Cupones order by integer desc')
  Stream<List<Cupones?>> fetchStreamData();

  @Query('SELECT * FROM Cupones order by integer asc')
  Future<List<Cupones?>> getCupones();

 @insert
  Future<void> insertCupones(Cupones Cupones);

  @update
  Future<int> updateCupones(Cupones Cupones);

  @insert
  Future<List<int>> insertAllCupones(List<Cupones> Cupones);

  @Query("delete from Cupones where integer = :integer")
  Future<void> deleteCupones(int integer);

  @Query("delete from Cupones")
  Future<void> cleanCupones();

  @delete
  Future<int> deleteAll(List<Cupones> list);
}