import 'package:siglo21/Entities/Premios.dart';
import 'package:siglo21/Entities/Facturas.dart';
import 'package:siglo21/Entities/Premios.dart';
import 'package:siglo21/Entities/Sesion.dart';

import '../Entities/Facturas.dart';
import 'ImagenesProductoModel.dart';

class ProductoCanjeModel extends Object{

  final String? id;
  final int? id_local;
  final String? nombre;
  final String? descripcion;
  final String? categoria;
  final String? marca;
  final double? valor;
  final int? stock;
  final List<ImagenesProductoModel>? imagenes;


  ProductoCanjeModel({this.id, this.id_local, this.nombre, this.descripcion,
      this.categoria, this.marca, this.valor, this.stock, this.imagenes});

  factory ProductoCanjeModel.fromJson(Map<String, dynamic> json) {

    var listData = json['imagenes'] != null ? json['imagenes'] as List : [];
    List<ImagenesProductoModel> imagenes = listData!=null && listData.length > 0 ? listData.map((i) => ImagenesProductoModel.fromJson(i)).toList() : [];


    return ProductoCanjeModel(
       id: json['id'] ?? '',
       id_local: json['id_local'] ?? 0,
       nombre : json['nombre'] ?? '',
       descripcion : json['descripcion'] ?? '',
       categoria : json['categoria'] ?? '',
       marca : json['marca'] ?? '',
       valor : json['valor'] ?? 0.0,
       stock : json['stock'] ?? 0,
      imagenes : imagenes
    );
  }

}