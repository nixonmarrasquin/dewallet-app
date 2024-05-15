import 'package:floor/floor.dart';

@entity
class Series {
  @PrimaryKey(autoGenerate: true)
  final int? integer;
  final String? Serie;
  final String? FacturaS21;
  final String? CodigoCliente;
  final String? CodigoItem;
  final String? NombreItem;


  Series({this.integer, this.Serie, this.FacturaS21, this.CodigoCliente,
      this.CodigoItem, this.NombreItem});

  factory Series.fromJson(Map<String, dynamic> json) {

    return Series(
        Serie: json['Serie'] != null ? "${json['Serie']}".toUpperCase()  : '',
        FacturaS21: json['FacturaS21'] ?? '',
        CodigoCliente: json['CodigoCliente'] ?? '',
        CodigoItem: json['CodigoItem'] ?? '',
        NombreItem: json['NombreItem'] ?? ''

    );

  }

}

