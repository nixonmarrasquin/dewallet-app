import 'package:siglo21/Entities/Premios.dart';
import 'package:siglo21/Entities/Facturas.dart';
import 'package:siglo21/Entities/Premios.dart';
import 'package:siglo21/Entities/Sesion.dart';

import '../Entities/Facturas.dart';

class PremiosModel extends Object{

  final bool? msg;
  final int? code;
  final List<Premios>? data;


  PremiosModel({this.msg, this.code, this.data});

  factory PremiosModel.fromJson(Map<String, dynamic> json) {

    var listdata = json['data'] != null ? json['data'] as List : [];
    List<Premios> datas = listdata!=null && listdata.length > 0 ? listdata.map((i) => Premios.fromJson(i)).toList() : [];

     return PremiosModel(
         msg: json['msg'] ?? false,
         code: json['code'] ?? 0,
         data : datas
    );
  }

}