import 'package:siglo21/Entities/Facturas.dart';
import 'package:siglo21/Entities/Sesion.dart';
import 'package:siglo21/Models/MarcaModel.dart';
import 'package:siglo21/Models/NombreNivel3Model.dart';
import 'package:siglo21/Models/ParticipanteModel.dart';

import '../Entities/Facturas.dart';

class DataModel extends Object{

  final List<ParticipanteModel>? data;
  final String? path;
  final int? per_page;
  final String? next_page_url;
  final String? prev_page_url;


  DataModel({this.data, this.path, this.per_page, this.next_page_url,
      this.prev_page_url});

  factory DataModel.fromJson(Map<String, dynamic> json) {

    var listData = json['data'] != null ? json['data'] as List : [];
    List<ParticipanteModel> nombre = listData!=null && listData.length > 0 ? listData.map((i) => ParticipanteModel.fromJson(i)).toList() : [];

     return DataModel(
         data: nombre,
         path: json['path'] ?? '',
       per_page: json['per_page'] ?? 0,
       next_page_url: json['next_page_url'] ?? '',
       prev_page_url: json['prev_page_url'] ?? '',


    );
  }

}