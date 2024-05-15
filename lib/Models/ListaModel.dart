import 'package:siglo21/Entities/Productos.dart';
import 'package:siglo21/Entities/Sesion.dart';

import '../Entities/Series.dart';


class ListaModel extends Object {

  final Series? serie;
  final Productos? producto;
  final String? valor;


  ListaModel({this.serie, this.producto, this.valor});


}