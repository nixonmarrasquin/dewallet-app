import 'package:siglo21/Entities/Premios.dart';
import 'package:siglo21/Entities/Facturas.dart';
import 'package:siglo21/Entities/Premios.dart';
import 'package:siglo21/Entities/Sesion.dart';

import '../Entities/Facturas.dart';

class SaldoModel extends Object{

  final double? cupo;

  SaldoModel({this.cupo});

  factory SaldoModel.fromJson(Map<String, dynamic> json) {

     return SaldoModel(
       cupo: json['CUPO'] ?? 0.0,
    );
  }

}