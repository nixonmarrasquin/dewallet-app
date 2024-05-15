import 'package:siglo21/Entities/Sesion.dart';

import '../Entities/Productos.dart';

class ProductosModel extends Object{

  final bool? sms;
  final Productos? data;


  ProductosModel({this.sms, this.data});

  factory ProductosModel.fromJson(Map<String, dynamic> json) {
    var isString = false;
    if (json['data'] is String){
      isString = true;
    }


    return ProductosModel(
        sms: json['sms'] ?? false,
        data:  isString == true ? null : json['data'] != null ? Productos.fromJson(json['data'][0]) : null,

    );
  }

}