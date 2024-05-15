import 'package:siglo21/Entities/DetalleFacturas.dart';
import 'package:siglo21/Entities/Facturas.dart';
import 'package:siglo21/Entities/Sesion.dart';

import '../Entities/Facturas.dart';

class DetalleFacturasModel extends Object{

  final bool? msg;
  final int? code;
  final List<DetalleFacturas>? data;


  DetalleFacturasModel({this.msg, this.code, this.data});

  factory DetalleFacturasModel.fromJson(Map<String, dynamic> json) {

    var listdata = json['data'] != null ? json['data'] as List : [];
    List<DetalleFacturas> datas = listdata!=null && listdata.length > 0 ? listdata.map((i) => DetalleFacturas.fromJson(i)).toList() : [];

     return DetalleFacturasModel(
         msg: json['msg'] ?? false,
         code: json['code'] ?? 0,
         data : datas
    );
  }

}