import 'package:siglo21/Entities/Facturas.dart';
import 'package:siglo21/Entities/Sesion.dart';

import '../Entities/Facturas.dart';

class FacturasModel extends Object{

  final bool? msg;
  final int? code;
  final List<Facturas>? data;


  FacturasModel({this.msg, this.code, this.data});

  factory FacturasModel.fromJson(Map<String, dynamic> json) {

    var listdata = json['data'] != null ? json['data'] as List : [];
    List<Facturas> datas = listdata!=null && listdata.length > 0 ? listdata.map((i) => Facturas.fromJson(i)).toList() : [];

     return FacturasModel(
         msg: json['msg'] ?? false,
         code: json['code'] ?? 0,
         data : datas
    );
  }

}