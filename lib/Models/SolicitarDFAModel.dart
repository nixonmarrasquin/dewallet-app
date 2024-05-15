import 'package:siglo21/Entities/Productos.dart';
import 'package:siglo21/Entities/Sesion.dart';

import '../Entities/Series.dart';


class SolicitarDFAModel extends Object {

  final String? Message;


  SolicitarDFAModel({this.Message});

  factory SolicitarDFAModel.fromJson(Map<String, dynamic> json) {

    return SolicitarDFAModel(
        Message: json['Message'] ?? ''

    );
  }



}