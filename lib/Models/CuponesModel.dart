import 'package:siglo21/Entities/Sesion.dart';

import '../Entities/Cupones.dart';

class CuponesModel extends Object{

  final bool? sms;
  final String? mensaje;
  final List<Cupones>? promos;
  final List<Cupones>? mispromos;


  CuponesModel({this.sms, this.mensaje, this.promos, this.mispromos});

  factory CuponesModel.fromJson(Map<String, dynamic> json) {

    var listpromos = json['promos'] != null ? json['promos'] as List : [];
    List<Cupones> promos = listpromos!=null && listpromos.length > 0 ? listpromos.map((i) => Cupones.fromJson(i)).toList() : [];

    var listmispromos = json['mispromos'] != null ? json['mispromos'] as List : [];
    List<Cupones> mispromos = listmispromos!=null && listmispromos.length > 0 ? listmispromos.map((i) => Cupones.fromJson(i)).toList() : [];

    return CuponesModel(
        sms: json['sms'] ?? false,
        mensaje: json['mensaje'] ?? '',
        promos : promos,
        mispromos : mispromos
    );
  }

}