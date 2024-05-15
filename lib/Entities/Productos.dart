import 'package:floor/floor.dart';

@entity
class Productos {
  @PrimaryKey(autoGenerate: true)
  final int? integer;
  final String? cod_producto;
  final String? nombre;
  final String? valor;


  Productos({this.integer, this.cod_producto, this.nombre, this.valor});

  factory Productos.fromJson(Map<String, dynamic> json) {

    return Productos(
        cod_producto: json['cod_producto'] ?? '',
        nombre: json['nombre'] ?? '',
        valor: json['valor'] ?? ''

    );

  }

}

