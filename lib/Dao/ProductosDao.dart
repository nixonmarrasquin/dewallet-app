import 'package:floor/floor.dart';

import '../Entities/Productos.dart';

@dao
abstract class ProductosDao {
  @Query('SELECT * FROM Productos')
  Future<List<Productos?>> findAllProductos();

  @Query('Select * from Productos order by integer desc limit 1')
  Future<Productos?> getMaxTProductos();

  @Query('SELECT * FROM Productos order by integer desc')
  Stream<List<Productos?>> fetchStreamData();

  @Query('SELECT * FROM Productos order by integer asc')
  Future<List<Productos?>> getProductos();

  @Query('SELECT * FROM Productos where Serie = :Serie order by integer asc')
  Future<List<Productos?>> getProductosByID(String Serie);

 @insert
  Future<void> insertProductos(Productos Productos);

  @update
  Future<int> updateProductos(Productos Productos);

  @insert
  Future<List<int>> insertAllProductos(List<Productos> Productos);

  @Query("delete from Productos where integer = :integer")
  Future<void> deleteProductos(int integer);

  @Query("delete from Productos")
  Future<void> cleanProductos();

  @delete
  Future<int> deleteAll(List<Productos> list);
}