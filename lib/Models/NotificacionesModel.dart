import 'package:siglo21/Entities/Facturas.dart';
import 'package:siglo21/Entities/Sesion.dart';
import 'package:siglo21/Models/MarcaModel.dart';
import 'package:siglo21/Models/NombreNivel3Model.dart';

import '../Entities/Facturas.dart';

class NotificacionesModel extends Object{

  final int? MensajePushId;
  final String? NombreMensaje;
  final String? DescripcionMensaje;
  final String? FechaInicio;
  final String? FechaFin;
  final String? FechaRegistro;
  final bool? Estado;


  NotificacionesModel({
      this.MensajePushId,
      this.NombreMensaje,
      this.DescripcionMensaje,
      this.FechaInicio,
      this.FechaFin,
      this.FechaRegistro,
      this.Estado});

  factory NotificacionesModel.fromJson(Map<String, dynamic> json) {

     return NotificacionesModel(
         MensajePushId: json['MensajePushId'] ?? 0,
         NombreMensaje: json['NombreMensaje'] ?? '',
         DescripcionMensaje: json['DescripcionMensaje'] ?? '',
         FechaInicio: json['FechaInicio'] ?? '',
         FechaFin: json['FechaFin'] ?? '',
         FechaRegistro: json['FechaRegistro'] ?? '',
         Estado: json['Estado'] ?? false,


    );
  }

}