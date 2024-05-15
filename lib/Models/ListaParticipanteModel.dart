import 'package:siglo21/Entities/Facturas.dart';
import 'package:siglo21/Entities/Sesion.dart';
import 'package:siglo21/Models/MarcaModel.dart';
import 'package:siglo21/Models/NombreNivel3Model.dart';

import '../Entities/Facturas.dart';
import 'DataModel.dart';

class ListaParticipanteModel extends Object{

  final bool? sms;
  final DataModel? data;


  ListaParticipanteModel({this.sms, this.data});

  factory ListaParticipanteModel.fromJson(Map<String, dynamic> json) {

    var objq = json['data'];
    DataModel? q;
    if (objq != null){
      q =  DataModel.fromJson(objq);
    }

     return ListaParticipanteModel(
        sms: json['sms'] ?? false,
         data: q

    );
  }

}