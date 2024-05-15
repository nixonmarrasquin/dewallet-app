
class ModelObject extends Object{
  
  final bool? error;
  final String? mensaje;
  final Object? respuesta;

  ModelObject({this.error, this.mensaje, this.respuesta});

  factory ModelObject.fromJson(Map<String, dynamic> json, { String nameResponse = 'Respuesta' }) {
    return ModelObject(
      error: json['Error'] ?? true,
      mensaje: json['Mensaje'] ?? '',
      respuesta: json[nameResponse]
    );
  }

}