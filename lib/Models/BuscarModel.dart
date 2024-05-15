import 'package:siglo21/Entities/Facturas.dart';
import 'package:siglo21/Entities/Sesion.dart';
import 'package:siglo21/Models/MarcaModel.dart';
import 'package:siglo21/Models/NombreNivel3Model.dart';

import '../Entities/Facturas.dart';

class BuscarModel extends Object{

  final bool? sms;
  final List<MarcaModel>? marcas;
  final List<NombreNivel3>? nombreNivel3;


  BuscarModel({this.sms,this.marcas, this.nombreNivel3});

  factory BuscarModel.fromJson(Map<String, dynamic> json) {

    var listmarcas = json['marcas'] != null ? json['marcas'] as List : [];
    List<MarcaModel> mar = listmarcas!=null && listmarcas.length > 0 ? listmarcas.map((i) => MarcaModel.fromJson(i)).toList() : [];

    var listnombreNivel3 = json['NombreNivel3'] != null ? json['NombreNivel3'] as List : [];
    List<NombreNivel3> nombre = listnombreNivel3!=null && listnombreNivel3.length > 0 ? listnombreNivel3.map((i) => NombreNivel3.fromJson(i)).toList() : [];

     return BuscarModel(
        sms: json['sms'] ?? false,
         marcas: mar,
         nombreNivel3: nombre

    );
  }

}