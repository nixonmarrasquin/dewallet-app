import 'package:siglo21/Entities/Sesion.dart';

import '../Entities/Cupones.dart';

class InsertarCabeModel extends Object{

  final bool? msg;
  final int? code;
  final String? data;


  InsertarCabeModel({this.msg, this.code, this.data});

  factory InsertarCabeModel.fromJson(Map<String, dynamic> json) {

    return InsertarCabeModel(
        msg: json['msg'] ?? false,
        code: json['code'] ?? 0,
        data: json['data'] ?? ''
    );
  }

}