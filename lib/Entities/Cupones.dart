import 'package:floor/floor.dart';

@entity
class Cupones {
  @PrimaryKey(autoGenerate: true)
  final int? integer;
  final int? id;
  final int? id_local;
  final String? nombre;
  final String? descripcion;
  final String? valor;
  final String? fecha_ini;
  final String? fecha_fin;
  final String? url_imagen;
  final String? created_at;
  final String? updated_at;
  final String? deleted_at;
  final int? user_updated;


  Cupones({
      this.integer,
      this.id,
      this.id_local,
      this.nombre,
      this.descripcion,
      this.valor,
      this.fecha_ini,
      this.fecha_fin,
      this.url_imagen,
      this.created_at,
      this.updated_at,
      this.deleted_at,
      this.user_updated});

  factory Cupones.fromJson(Map<String, dynamic> json) {

    return Cupones(
        id: json['id'] ?? 0,
        id_local: json['id_local'] ?? 0,
        nombre: json['nombre'] ?? '',
        descripcion: json['descripcion'] ?? '',
        valor: json['valor'] ?? '',
        fecha_ini: json['fecha_ini'] ?? '',
        fecha_fin: json['fecha_fin'] ?? '',
        url_imagen: json['url_imagen'] ?? '',
        created_at: json['created_at'] ?? '',
        deleted_at: json['deleted_at'] ?? '',
        user_updated: json['user_updated'] ?? 0
    );

  }

}

