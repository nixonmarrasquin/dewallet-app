import 'package:siglo21/Entities/Premios.dart';
import 'package:siglo21/Entities/Facturas.dart';
import 'package:siglo21/Entities/Premios.dart';
import 'package:siglo21/Entities/Sesion.dart';

import '../Constants/Constants.dart';
import '../Entities/Facturas.dart';

class ParticipanteModel extends Object{

  final int? id;
  final String? url_image;
  final String? cod_producto;
  final String? descripcion;
  final String? valor_premio;
  final String? vigencia;


  ParticipanteModel({this.id, this.url_image, this.cod_producto,
      this.descripcion, this.valor_premio, this.vigencia});

  factory ParticipanteModel.fromJson(Map<String, dynamic> json) {

    var key_value = "valor_premio";
    if (App.LISTA_PRECIO > 1){
      key_value = "valor_premio${App.LISTA_PRECIO}";
    }

     return ParticipanteModel(
       id : json['id'] ?? 0,
       url_image : json['url_image'] ?? '',
       cod_producto : json['cod_producto'] ?? '',
       descripcion : json['descripcion'] ?? '',
       valor_premio : json['${key_value}'] ?? '',
       vigencia : json['vigencia'] ?? '',

    );
  }

}