import 'package:floor/floor.dart';

@entity
class Facturas {
  @PrimaryKey(autoGenerate: true)
  final int? integer;
  final String? numOrder;
  final String? codCliente;
  final String? numFactura;
  final String? mail;
  final double? subtotalFac;
  final double? totalFac;
  final double? valorPremio;
  final String? created_at;


  Facturas({
      this.integer,
      this.numOrder,
      this.codCliente,
      this.numFactura,
      this.mail,
      this.subtotalFac,
      this.totalFac,
      this.valorPremio,
      this.created_at});

  factory Facturas.fromJson(Map<String, dynamic> json) {

    return Facturas(
      numOrder: json['numOrder'] ?? '',
      codCliente: json['codCliente'] ?? '',
      numFactura: json['numFactura'] ?? '',
      mail: json['mail'] ?? '',
      subtotalFac: json['subtotalFac'] ?? 0.0,
      totalFac: json['totalFac'] ?? 0.0,
      valorPremio: json['valorPremio'] ?? 0.0,
      created_at: json['created_at'] ?? '',

    );

  }

}

