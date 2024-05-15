import 'package:floor/floor.dart';

import '../Entities/Premios.dart';

@dao
abstract class PremiosDao {
  @Query('SELECT * FROM Premios')
  Future<List<Premios?>> findAllPremios();

  @Query('Select * from Premios order by integer desc limit 1')
  Future<Premios?> getMaxTPremios();

  @Query('SELECT * FROM Premios order by integer desc')
  Stream<List<Premios?>> fetchStreamData();

  @Query('SELECT * FROM Premios order by integer asc')
  Future<List<Premios?>> getPremios();

 @insert
  Future<void> insertPremios(Premios Premios);

  @update
  Future<int> updatePremios(Premios Premios);

  @insert
  Future<List<int>> insertAllPremios(List<Premios> Premios);

  @Query("delete from Premios where integer = :integer")
  Future<void> deletePremios(int integer);

  @Query("delete from Premios")
  Future<void> cleanPremios();

  @delete
  Future<int> deleteAll(List<Premios> list);
}