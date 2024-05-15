import 'package:floor/floor.dart';

import '../Entities/Series.dart';

@dao
abstract class SeriesDao {
  @Query('SELECT * FROM Series')
  Future<List<Series?>> findAllSeries();

  @Query('Select * from Series order by integer desc limit 1')
  Future<Series?> getMaxTSeries();

  @Query('SELECT * FROM Series order by integer desc')
  Stream<List<Series?>> fetchStreamData();

  @Query('SELECT * FROM Series order by integer asc')
  Future<List<Series?>> getSeries();

  @Query('SELECT * FROM Series where Serie = :Serie order by integer asc')
  Future<List<Series?>> getSeriesByID(String Serie);

 @insert
  Future<void> insertSeries(Series Series);

  @update
  Future<int> updateSeries(Series Series);

  @insert
  Future<List<int>> insertAllSeries(List<Series> Series);

  @Query("delete from Series where integer = :integer")
  Future<void> deleteSeries(int integer);

  @Query("delete from Series")
  Future<void> cleanSeries();

  @delete
  Future<int> deleteAll(List<Series> list);
}