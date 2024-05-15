import 'package:siglo21/Entities/Facturas.dart';
import 'package:siglo21/Entities/Sesion.dart';
import 'package:siglo21/Models/MarcaModel.dart';
import 'package:siglo21/Models/NombreNivel3Model.dart';
import 'package:siglo21/Models/ParticipanteModel.dart';

import '../Entities/Facturas.dart';
import 'ProductoCanjeModel.dart';

class DataProModel extends Object{

  final List<ProductoCanjeModel>? data;
  final bool? msg;
  final int? code;

  DataProModel({this.data, this.msg, this.code});

  factory DataProModel.fromJson(Map<String, dynamic> json) {

    var listData = json['data'] != null ? json['data'] as List : [];
    List<ProductoCanjeModel> nombre = listData!=null && listData.length > 0 ? listData.map((i) => ProductoCanjeModel.fromJson(i)).toList() : [];

     return DataProModel(
         data: nombre,
       msg: json['msg'] ?? false,
       code: json['code'] ?? 0,


    );
  }

}