import 'package:floor/floor.dart';

import '../Entities/Facturas.dart';

@dao
abstract class FacturasDao {
  @Query('SELECT * FROM Facturas')
  Future<List<Facturas?>> findAllFacturas();

  @Query('Select * from Facturas order by integer desc limit 1')
  Future<Facturas?> getMaxTFacturas();

  @Query('SELECT * FROM Facturas order by integer desc')
  Stream<List<Facturas?>> fetchStreamData();

  @Query('SELECT * FROM Facturas order by integer desc')
  Future<List<Facturas?>> getFacturas();

 @insert
  Future<void> insertFacturas(Facturas Facturas);

  @update
  Future<int> updateFacturas(Facturas Facturas);

  @insert
  Future<List<int>> insertAllFacturas(List<Facturas> Facturas);

  @Query("delete from Facturas where integer = :integer")
  Future<void> deleteFacturas(int integer);

  @Query("delete from Facturas")
  Future<void> cleanFacturas();

  @delete
  Future<int> deleteAll(List<Facturas> list);
}