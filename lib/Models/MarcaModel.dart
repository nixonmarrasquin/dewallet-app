import 'package:siglo21/Entities/Premios.dart';
import 'package:siglo21/Entities/Facturas.dart';
import 'package:siglo21/Entities/Premios.dart';
import 'package:siglo21/Entities/Sesion.dart';

import '../Entities/Facturas.dart';

class MarcaModel extends Object{

  final String? marca;

  MarcaModel({this.marca});

  factory MarcaModel.fromJson(Map<String, dynamic> json) {

     return MarcaModel(
     marca : json['marca'] ?? '',
    );
  }

}