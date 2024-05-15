import 'package:siglo21/Entities/Premios.dart';
import 'package:siglo21/Entities/Facturas.dart';
import 'package:siglo21/Entities/Premios.dart';
import 'package:siglo21/Entities/Sesion.dart';
import 'package:siglo21/Models/Model.dart';

import '../Entities/Facturas.dart';

class DisponibleModel extends Object{

  final bool? msg;
  final int? code;
  final List<SaldoModel>? data;


  DisponibleModel({this.msg, this.code, this.data});

  factory DisponibleModel.fromJson(Map<String, dynamic> json) {

    var listdata = json['data'] != null ? json['data'] as List : [];
    List<SaldoModel> datas = listdata!=null && listdata.length > 0 ? listdata.map((i) => SaldoModel.fromJson(i)).toList() : [];

    return DisponibleModel(
        msg: json['msg'] ?? false,
        code: json['code'] ?? 0,
        data : datas
    );
  }

}