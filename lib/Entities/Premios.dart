import 'package:floor/floor.dart';

@entity
class Premios {
  @PrimaryKey(autoGenerate: true)
  final int? integer;
  final String? idtarjeta;
  final String? nombreTarjeta;
  final double? valor;
  final String? codCliente;
  final String? codVendedor;
  final String? fechaCanje;


  Premios({this.integer, this.idtarjeta, this.nombreTarjeta, this.valor,
      this.codCliente, this.codVendedor, this.fechaCanje});

  factory Premios.fromJson(Map<String, dynamic> json) {

    return Premios(
      idtarjeta: json['idtarjeta'] ?? '',
      nombreTarjeta: json['nombreTarjeta'] ?? '',
      valor: json['valor'] ?? 0,
      codCliente: json['codCliente'] ?? '',
      codVendedor: json['codVendedor'] ?? '',
      fechaCanje: json['fechaCanje'] ?? '',

    );

  }

}

