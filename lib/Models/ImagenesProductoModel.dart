import 'package:siglo21/Entities/Facturas.dart';
import 'package:siglo21/Entities/Sesion.dart';
import 'package:siglo21/Models/MarcaModel.dart';
import 'package:siglo21/Models/NombreNivel3Model.dart';
import 'package:siglo21/Models/ParticipanteModel.dart';

import '../Entities/Facturas.dart';

class ImagenesProductoModel extends Object{

  final String? urlImagen;


  ImagenesProductoModel({this.urlImagen});

  factory ImagenesProductoModel.fromJson(Map<String, dynamic> json) {

     return ImagenesProductoModel(
         urlImagen: json['urlImagen'] ?? ''
    );
  }

}