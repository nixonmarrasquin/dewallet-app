import 'package:siglo21/Entities/Facturas.dart';
import 'package:siglo21/Entities/Sesion.dart';
import 'package:siglo21/Models/MarcaModel.dart';
import 'package:siglo21/Models/NombreNivel3Model.dart';
import 'package:siglo21/Models/ParticipanteModel.dart';

import '../Entities/Facturas.dart';

class ProdModel extends Object{

  final String? cod_producto;
  final String? descripcion;
  final String? categoria1;
  final String? categoria2;
  final String? categoria3;
  final String? marca;
  final String? url_image;
  final double? valor_premio;


  ProdModel({this.cod_producto, this.descripcion, this.categoria1,
      this.categoria2, this.categoria3, this.marca, this.url_image, this.valor_premio});

  factory ProdModel.fromJson(Map<String, dynamic> json) {

     return ProdModel(
       cod_producto: json['cod_producto'] ?? '',
       descripcion: json['descripcion'] ?? '',
       categoria1: json['categoria1'] ?? '',
       categoria2: json['categoria2'] ?? '',
       categoria3: json['categoria3'] ?? '',
       marca: json['marca'] ?? '',
       url_image: json['url_image'] ?? '',
       valor_premio: json['valor_premio'] ?? 0.0,


    );
  }

}