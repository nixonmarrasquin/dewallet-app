import 'package:floor/floor.dart';

import '../Entities/DetalleFacturas.dart';

@dao
abstract class DetalleFacturasDao {
  @Query('SELECT * FROM DetalleFacturas')
  Future<List<DetalleFacturas?>> findAllDetalleFacturas();

  @Query('Select * from DetalleFacturas order by integer desc limit 1')
  Future<DetalleFacturas?> getMaxTDetalleFacturas();

  @Query('SELECT * FROM DetalleFacturas order by integer desc')
  Stream<List<DetalleFacturas?>> fetchStreamData();

  @Query('SELECT * FROM DetalleFacturas order by integer asc')
  Future<List<DetalleFacturas?>> getDetalleFacturas();

 @insert
  Future<void> insertDetalleFacturas(DetalleFacturas DetalleFacturas);

  @update
  Future<int> updateDetalleFacturas(DetalleFacturas DetalleFacturas);

  @insert
  Future<List<int>> insertAllDetalleFacturas(List<DetalleFacturas> DetalleFacturas);

  @Query("delete from DetalleFacturas where integer = :integer")
  Future<void> deleteDetalleFacturas(int integer);

  @Query("delete from DetalleFacturas")
  Future<void> cleanDetalleFacturas();

  @delete
  Future<int> deleteAll(List<DetalleFacturas> list);
}