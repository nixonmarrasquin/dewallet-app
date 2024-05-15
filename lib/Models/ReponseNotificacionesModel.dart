import 'package:siglo21/Entities/Facturas.dart';
import 'package:siglo21/Entities/Sesion.dart';
import 'package:siglo21/Models/MarcaModel.dart';
import 'package:siglo21/Models/NombreNivel3Model.dart';

import '../Entities/Facturas.dart';
import 'NotificacionesModel.dart';

class ReponseNotificacionesModel extends Object{

  final int? code;
  final bool? msg;
  final List<NotificacionesModel>? data;

  ReponseNotificacionesModel({this.code, this.msg, this.data});

  factory ReponseNotificacionesModel.fromJson(Map<String, dynamic> json) {

    var listmarcas = json['data'] != null ? json['data'] as List : [];
    List<NotificacionesModel> mar = listmarcas!=null && listmarcas.length > 0 ? listmarcas.map((i) => NotificacionesModel.fromJson(i)).toList() : [];

     return ReponseNotificacionesModel(
         code: json['code'] ?? 0,
         msg: json['msg'] ?? false,
         data: mar

    );
  }

}