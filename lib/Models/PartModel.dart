import 'package:siglo21/Entities/Facturas.dart';
import 'package:siglo21/Entities/Sesion.dart';
import 'package:siglo21/Models/MarcaModel.dart';
import 'package:siglo21/Models/NombreNivel3Model.dart';

import '../Entities/Facturas.dart';
import 'DataModel.dart';
import 'ProdModel.dart';

class PartModel extends Object{

  final bool? msg;
  final int? total;
  final int? code;
  final List<ProdModel>? data;
  
  PartModel({this.msg, this.total, this.code, this.data});

  factory PartModel.fromJson(Map<String, dynamic> json) {

    var listData = json['data'] != null ? json['data'] as List : [];
    List<ProdModel> proModel = listData!=null && listData.length > 0 ? listData.map((i) => ProdModel.fromJson(i)).toList() : [];

     return PartModel(
         msg: json['msg'] ?? false,
         total: json['total'] ?? 0,
         code: json['code'] ?? 0,
         data: proModel

    );
  }

}