import 'package:floor/floor.dart';

@entity
class DetalleFacturas {
  @PrimaryKey(autoGenerate: true)
  final int? integer;
  final String? id_numOrder;
  final String? codCliente;
  final String? itemCodigo;
  final String? descripcion;
  final String? serie;
  final String? numFactura;
  final double? precioUnitario;
  final double? iva;
  final double? valorPremio;
  final String? created_at;


  DetalleFacturas({
      this.integer,
      this.id_numOrder,
      this.codCliente,
      this.itemCodigo,
      this.descripcion,
      this.serie,
      this.numFactura,
      this.precioUnitario,
      this.iva,
      this.valorPremio,
      this.created_at});

  factory DetalleFacturas.fromJson(Map<String, dynamic> json) {

    return DetalleFacturas(
      id_numOrder: json['id_numOrder'] ?? '',
      codCliente: json['codCliente'] ?? '',
      itemCodigo: json['itemCodigo'] ?? '',
      descripcion: json['descripcion'] ?? '',
      serie: json['serie'] ?? '',
      numFactura: json['numFactura'] ?? '',
      precioUnitario: json['precioUnitario'] ?? 0.0,
      iva: json['iva'] ?? 0.0,
      valorPremio: json['valorPremio'] ?? 0.0,
      created_at: json['created_at'] ?? '',


    );

  }

}

