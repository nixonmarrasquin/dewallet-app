import 'package:siglo21/Entities/Facturas.dart';
import 'package:siglo21/Entities/Sesion.dart';
import 'package:siglo21/Models/MarcaModel.dart';
import 'package:siglo21/Models/NombreNivel3Model.dart';

import '../Entities/Facturas.dart';
import 'DataModel.dart';
import 'ProdModel.dart';

class UpdateDFAModel extends Object{

  final bool? sms;
  final String? mensaje;
  
  UpdateDFAModel({this.sms, this.mensaje});

  factory UpdateDFAModel.fromJson(Map<String, dynamic> json) {

     return UpdateDFAModel(
         sms: json['sms'] ?? false,
         mensaje: json['mensaje'] ?? ""

    );
  }

}