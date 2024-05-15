import 'package:floor/floor.dart';

@entity
class Sesion {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final bool? sms;
  final String? mensaje;
  final int? local;
  final String? codigo_c;
  final String? codigo_v;
  final String? correo;
  final int? lista_precio;

  Sesion({this.id,this.sms, this.mensaje, this.local,this.codigo_v,this.codigo_c,this.correo, this.lista_precio});

  factory Sesion.fromJson(Map<String, dynamic> json) {

    return Sesion(
        sms: json['sms'] ?? false,
        mensaje: json['mensaje'] ?? '',
        codigo_c: json['codigo_c'] ?? '',
        codigo_v: json['codigo_v'] ?? '',
        local: json['local'] ?? 0,
        lista_precio: json['lista_precio'] ?? 0,
        correo: ""
    );

  }

}

