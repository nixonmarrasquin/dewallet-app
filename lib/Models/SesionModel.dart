
class SesionModel extends Object{

  final bool? sms;
  final String? mensaje;
  final int? local;
  final String? codigo_c;
  final String? codigo_v;
  final int? lista_precio;
  final int? dfa;

  SesionModel({this.sms, this.mensaje, this.local, this.codigo_c,this.codigo_v, this.lista_precio, this.dfa});

  factory SesionModel.fromJson(Map<String, dynamic> json) {
    return SesionModel(
        sms: json['sms'] ?? false,
        mensaje: json['mensaje'] ?? '',
        codigo_c: json['codigo_c'] ?? '',
        codigo_v: json['codigo_v'] ?? '',
        local: json['local'] ?? 0,
        lista_precio: json['lista_precio'] ?? 0,
        dfa: json['dfa'] ?? 0
    );
  }

}