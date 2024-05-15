import 'package:siglo21/Entities/Premios.dart';
import 'package:siglo21/Entities/Facturas.dart';
import 'package:siglo21/Entities/Premios.dart';
import 'package:siglo21/Entities/Sesion.dart';

import '../Entities/Facturas.dart';

class NombreNivel3 extends Object{

  final String? NombreNivel3T;

  NombreNivel3({this.NombreNivel3T});

  factory NombreNivel3.fromJson(Map<String, dynamic> json) {

     return NombreNivel3(
       NombreNivel3T : json['NombreNivel3'] ?? '',
    );
  }

}