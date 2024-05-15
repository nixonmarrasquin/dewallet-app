import 'package:siglo21/Entities/Premios.dart';
import 'package:siglo21/Entities/Facturas.dart';
import 'package:siglo21/Entities/Premios.dart';
import 'package:siglo21/Entities/Sesion.dart';

import '../Entities/Facturas.dart';

class CuponModel extends Object{

  final bool? msg;
  final String? data;
  final int? code;



  CuponModel({this.msg, this.code, this.data});

  factory CuponModel.fromJson(Map<String, dynamic> json) {

     return CuponModel(
         msg: json['msg'] ?? false,
         code: json['code'] ?? 0,
         data : json['data'] ?? '',
    );
  }

}