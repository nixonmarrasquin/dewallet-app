import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:siglo21/Models/BuscarModel.dart';
import 'package:siglo21/Models/DisponibleModel.dart';
import 'package:siglo21/Models/PremiosModel.dart';
import 'package:siglo21/Models/SeriesModel.dart';
import 'package:siglo21/Models/SesionModel.dart';

import '../Constants/Constants.dart';
import '../Models/CuponModel.dart';
import '../Models/CuponesModel.dart';
import '../Models/DataProModel.dart';
import '../Models/DetalleFacturrasModel.dart';
import '../Models/EventObject.dart';
import '../Models/FacturrasModel.dart';
import '../Models/InsertarCabeModel.dart';
import '../Models/ListaParticipanteModel.dart';
import '../Models/Model_Object.dart';
import '../Models/PartModel.dart';
import '../Models/ProductosModel.dart';
import '../Models/ReponseNotificacionesModel.dart';
import '../Models/SolicitarDFAModel.dart';
import '../Models/UpdateDFAModel.dart';

    const TIMEOUT = const Duration(milliseconds: 120000);
    const TIMEOUTSECOND = const Duration(milliseconds: 120000);
    const encoding = URLS.X_WWW_FORM_URLENCODED;

    class Response{
      final http.Response? responseHttp;
      final int statusCode;
      Response({this.responseHttp, required this.statusCode});
    }

    Future<Response> callServicePost(String url, dynamic bodyRequest) async{
      String auth = "kHOPd7kYhe+NlFotZ0SB0gI4yRPHfS/sBnMATknEHxE=";
      try {
        HttpClient client = new HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
        var ioClient = new IOClient(client);
        final response = await ioClient.post(Uri.parse(url),  headers:{
          "Authorization": "$auth",
          "Content-Type": "application/x-www-form-urlencoded"

        }, body: bodyRequest,
            encoding: Encoding.getByName("utf-8"));
        return Response(responseHttp: response, statusCode: response.statusCode);
      } on SocketException {
        return Response(responseHttp: null, statusCode: HttpStatus.NO_INTERNET_CONNECTION);
      } on Exception{
        return Response(responseHttp: null, statusCode: HttpStatus.NOT_FOUND);
      }
    }



Future<Response> callServicePost2(String url, dynamic bodyRequest) async {
  String auth = "kHOPd7kYhe+NlFotZ0SB0gI4yRPHfS/sBnMATknEHxE=";
  try {
    HttpClient client = new HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    var ioClient = new IOClient(client);

    // Convertir el objeto bodyRequest a JSON
    String requestBody = jsonEncode(bodyRequest);

    final response = await ioClient.post(
      Uri.parse(url),
      headers: {
        "Authorization": "$auth",
        "Content-Type": "application/json", // Cambiar la codificación a JSON
      },
      body: requestBody, // Enviar el objeto JSON como cuerpo
      encoding: Encoding.getByName("utf-8"),
    );
    return Response(responseHttp: response, statusCode: response.statusCode);
  } on SocketException {
    return Response(responseHttp: null, statusCode: HttpStatus.NO_INTERNET_CONNECTION);
  } on Exception {
    return Response(responseHttp: null, statusCode: HttpStatus.NOT_FOUND);
  }
}


Future<Response> callServicePostJSON(String url, dynamic bodyRequest) async{
      try {
        HttpClient client = new HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
        var ioClient = new IOClient(client);
        final response = await ioClient.post(Uri.parse(url),  headers:{"Content-Type": "application/json"}, body: json.encode(bodyRequest), encoding: Encoding.getByName("utf-8"));
        return Response(responseHttp: response, statusCode: response.statusCode);
      } on SocketException {
        return Response(responseHttp: null, statusCode: HttpStatus.NO_INTERNET_CONNECTION);
      } on Exception{
        return Response(responseHttp: null, statusCode: HttpStatus.NOT_FOUND);
      }
    }



Future<Response> callServicePostHeaderJSON(String url, dynamic bodyRequest) async{
  try {
    String auth = "kHOPd7kYhe+NlFotZ0SB0gI4yRPHfS/sBnMATknEHxE=";
    HttpClient client = new HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    var ioClient = new IOClient(client);
    final response = await ioClient.post(Uri.parse(url),  headers:{
      "Authorization": "$auth",
      "Content-Type": "application/json"
    }, body: json.encode(bodyRequest), encoding: Encoding.getByName("utf-8"));
    return Response(responseHttp: response, statusCode: response.statusCode);
  } on SocketException {
    return Response(responseHttp: null, statusCode: HttpStatus.NO_INTERNET_CONNECTION);
  } on Exception{
    return Response(responseHttp: null, statusCode: HttpStatus.NOT_FOUND);
  }
}

Future<Response> callServicePostJSON2(String url, dynamic bodyRequest) async{
  try {
    String auth = "kHOPd7kYhe+NlFotZ0SB0gI4yRPHfS/sBnMATknEHxE=";
    HttpClient client = new HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    var ioClient = new IOClient(client);
    print("--------------------------------------");
    print( json.encode(bodyRequest));
    final response = await ioClient.post(Uri.parse(url),
        headers:{
          "Authorization": "$auth",
      "Content-Type": "application/json"
        }, body:  json.encode(bodyRequest), encoding: Encoding.getByName("utf-8"));
    return Response(responseHttp: response, statusCode: response.statusCode);
  } on SocketException {
    return Response(responseHttp: null, statusCode: HttpStatus.NO_INTERNET_CONNECTION);
  } on Exception{
    return Response(responseHttp: null, statusCode: HttpStatus.NOT_FOUND);
  }
}

    Future<Response> callServiceGet(String url) async{
      try {
        final response = await http.get(Uri.parse(url));
        return Response(responseHttp: response, statusCode: response.statusCode);
      } on SocketException {
        return Response(responseHttp: null, statusCode: HttpStatus.NO_INTERNET_CONNECTION);
      } on Exception{
        return Response(responseHttp: null, statusCode: HttpStatus.NOT_FOUND);
      }
    }



//METHOD WEB SERVICE LOGIN
Future<EventObject> login(dynamic bodyRequest) async {

  try {
    String url = "${URLS.BASE_URL}/login";

    Response response = await callServicePost(url, bodyRequest).timeout(TIMEOUT);
    if(response != null){
      if (response.statusCode == HttpStatus.SC_OK && response.responseHttp!.body != null) {
        var responseObject = SesionModel.fromJson(json.decode(response.responseHttp!.body));
        return new EventObject(id: HttpStatus.SC_OK, object: responseObject);
      }else{
        if(response.statusCode==HttpStatus.NO_INTERNET_CONNECTION){
          return new EventObject(id: HttpStatus.NO_INTERNET_CONNECTION);
        } else if(response.statusCode==HttpStatus.BAD_REQUEST){
          var responseObject = ModelObject.fromJson(json.decode(response.responseHttp!.body));
          return new EventObject(id: HttpStatus.BAD_REQUEST, object: responseObject);
        } else if(response.statusCode==HttpStatus.NOT_FOUND){
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }  else if(response.statusCode==HttpStatus.UNAUTHORIZED){
          return new EventObject(id: HttpStatus.UNAUTHORIZED);
        }else{
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }
      }
    }else
      return new EventObject(id: HttpStatus.NOT_FOUND);
  } on TimeoutException {
    return new EventObject(id: HttpStatus.CANCELED_CALL_TIME);
  } on Exception {
    return new EventObject(id: HttpStatus.NOT_FOUND);
  }
}

Future<EventObject> getCupones(dynamic bodyRequest) async {

  try {
    String url = "${URLS.BASE_URL}/promocion";

    Response response = await callServicePost(url, bodyRequest).timeout(TIMEOUT);
    if(response != null){
      if (response.statusCode == HttpStatus.SC_OK && response.responseHttp!.body != null) {
        var responseObject = CuponesModel.fromJson(json.decode(response.responseHttp!.body));
        return new EventObject(id: HttpStatus.SC_OK, object: responseObject);
      }else{
        if(response.statusCode==HttpStatus.NO_INTERNET_CONNECTION){
          return new EventObject(id: HttpStatus.NO_INTERNET_CONNECTION);
        } else if(response.statusCode==HttpStatus.BAD_REQUEST){
          var responseObject = ModelObject.fromJson(json.decode(response.responseHttp!.body));
          return new EventObject(id: HttpStatus.BAD_REQUEST, object: responseObject);
        } else if(response.statusCode==HttpStatus.NOT_FOUND){
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }  else if(response.statusCode==HttpStatus.UNAUTHORIZED){
          return new EventObject(id: HttpStatus.UNAUTHORIZED);
        }else{
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }
      }
    }else
      return new EventObject(id: HttpStatus.NOT_FOUND);
  } on TimeoutException {
    return new EventObject(id: HttpStatus.CANCELED_CALL_TIME);
  } on Exception {
    return new EventObject(id: HttpStatus.NOT_FOUND);
  }

}



Future<EventObject> getProductosPromo(dynamic bodyRequest) async {

  try {
    String url = "http://201.218.2.21:8055/api/v2/promocionProductos";

    Response response = await callServicePost(url, bodyRequest).timeout(TIMEOUT);
    if(response != null){
      if (response.statusCode == HttpStatus.SC_OK && response.responseHttp!.body != null) {
        var responseObject = DataProModel.fromJson(json.decode(response.responseHttp!.body));
        return new EventObject(id: HttpStatus.SC_OK, object: responseObject);
      }else{
        if(response.statusCode==HttpStatus.NO_INTERNET_CONNECTION){
          return new EventObject(id: HttpStatus.NO_INTERNET_CONNECTION);
        } else if(response.statusCode==HttpStatus.BAD_REQUEST){
          var responseObject = ModelObject.fromJson(json.decode(response.responseHttp!.body));
          return new EventObject(id: HttpStatus.BAD_REQUEST, object: responseObject);
        } else if(response.statusCode==HttpStatus.NOT_FOUND){
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }  else if(response.statusCode==HttpStatus.UNAUTHORIZED){
          return new EventObject(id: HttpStatus.UNAUTHORIZED);
        }else{
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }
      }
    }else
      return new EventObject(id: HttpStatus.NOT_FOUND);
  } on TimeoutException {
    return new EventObject(id: HttpStatus.CANCELED_CALL_TIME);
  } on Exception {
    return new EventObject(id: HttpStatus.NOT_FOUND);
  }

}


Future<EventObject> getSeries(dynamic bodyRequest) async {

  try {
    String url = "${URLS.BASE_URL_SERIE}/Series";

    Response response = await callServicePostHeaderJSON(url, bodyRequest).timeout(TIMEOUT);
    if(response != null){
      if (response.statusCode == HttpStatus.SC_OK && response.responseHttp!.body != null) {
        var responseObject = SeriesModel.fromJson(json.decode(response.responseHttp!.body));
        return new EventObject(id: HttpStatus.SC_OK, object: responseObject);
      }else{
        if(response.statusCode==HttpStatus.NO_INTERNET_CONNECTION){
          return new EventObject(id: HttpStatus.NO_INTERNET_CONNECTION);
        } else if(response.statusCode==HttpStatus.BAD_REQUEST){
          var responseObject = ModelObject.fromJson(json.decode(response.responseHttp!.body));
          return new EventObject(id: HttpStatus.BAD_REQUEST, object: responseObject);
        } else if(response.statusCode==HttpStatus.NOT_FOUND){
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }  else if(response.statusCode==HttpStatus.UNAUTHORIZED){
          return new EventObject(id: HttpStatus.UNAUTHORIZED);
        }else{
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }
      }
    }else
      return new EventObject(id: HttpStatus.NOT_FOUND);
  } on TimeoutException {
    return new EventObject(id: HttpStatus.CANCELED_CALL_TIME);
  } on Exception {
    return new EventObject(id: HttpStatus.NOT_FOUND);
  }

}



Future<EventObject> insertCabecera(dynamic bodyRequest) async {

  try {
    String url = "${URLS.BASE_URL_SERIE}/InsertarCabeceraFac";

    Response response = await callServicePostHeaderJSON(url, bodyRequest).timeout(TIMEOUT);
    if(response != null){
      if (response.statusCode == HttpStatus.SC_OK && response.responseHttp!.body != null) {
        var responseObject = InsertarCabeModel.fromJson(json.decode(response.responseHttp!.body));
        return new EventObject(id: HttpStatus.SC_OK, object: responseObject);
      }else{
        if(response.statusCode==HttpStatus.NO_INTERNET_CONNECTION){
          return new EventObject(id: HttpStatus.NO_INTERNET_CONNECTION);
        } else if(response.statusCode==HttpStatus.BAD_REQUEST){
          var responseObject = ModelObject.fromJson(json.decode(response.responseHttp!.body));
          return new EventObject(id: HttpStatus.BAD_REQUEST, object: responseObject);
        } else if(response.statusCode==HttpStatus.NOT_FOUND){
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }  else if(response.statusCode==HttpStatus.UNAUTHORIZED){
          return new EventObject(id: HttpStatus.UNAUTHORIZED);
        }else{
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }
      }
    }else
      return new EventObject(id: HttpStatus.NOT_FOUND);
  } on TimeoutException {
    return new EventObject(id: HttpStatus.CANCELED_CALL_TIME);
  } on Exception {
    return new EventObject(id: HttpStatus.NOT_FOUND);
  }

}


Future<EventObject> insertCabeceraSerie(dynamic bodyRequest) async {

  try {
    String url = "${URLS.BASE_URL_SERIE}/InsertarCabeceraSerie";

    Response response = await callServicePostHeaderJSON(url, bodyRequest).timeout(TIMEOUT);
    if(response != null){
      if (response.statusCode == HttpStatus.SC_OK && response.responseHttp!.body != null) {
        var responseObject = InsertarCabeModel.fromJson(json.decode(response.responseHttp!.body));
        return new EventObject(id: HttpStatus.SC_OK, object: responseObject);
      }else{
        if(response.statusCode==HttpStatus.NO_INTERNET_CONNECTION){
          return new EventObject(id: HttpStatus.NO_INTERNET_CONNECTION);
        } else if(response.statusCode==HttpStatus.BAD_REQUEST){
          var responseObject = ModelObject.fromJson(json.decode(response.responseHttp!.body));
          return new EventObject(id: HttpStatus.BAD_REQUEST, object: responseObject);
        } else if(response.statusCode==HttpStatus.NOT_FOUND){
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }  else if(response.statusCode==HttpStatus.UNAUTHORIZED){
          return new EventObject(id: HttpStatus.UNAUTHORIZED);
        }else{
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }
      }
    }else
      return new EventObject(id: HttpStatus.NOT_FOUND);
  } on TimeoutException {
    return new EventObject(id: HttpStatus.CANCELED_CALL_TIME);
  } on Exception {
    return new EventObject(id: HttpStatus.NOT_FOUND);
  }

}


Future<EventObject> getCategorias(dynamic bodyRequest) async {

  try {
    String url = "http://3.139.221.163/api/clasificacion_pro";

    Response response = await callServicePostJSON(url, bodyRequest).timeout(TIMEOUT);
    if(response != null){
      if (response.statusCode == HttpStatus.SC_OK && response.responseHttp!.body != null) {
        var responseObject = BuscarModel.fromJson(json.decode(response.responseHttp!.body));
        return new EventObject(id: HttpStatus.SC_OK, object: responseObject);
      }else{
        if(response.statusCode==HttpStatus.NO_INTERNET_CONNECTION){
          return new EventObject(id: HttpStatus.NO_INTERNET_CONNECTION);
        } else if(response.statusCode==HttpStatus.BAD_REQUEST){
          var responseObject = ModelObject.fromJson(json.decode(response.responseHttp!.body));
          return new EventObject(id: HttpStatus.BAD_REQUEST, object: responseObject);
        } else if(response.statusCode==HttpStatus.NOT_FOUND){
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }  else if(response.statusCode==HttpStatus.UNAUTHORIZED){
          return new EventObject(id: HttpStatus.UNAUTHORIZED);
        }else{
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }
      }
    }else
      return new EventObject(id: HttpStatus.NOT_FOUND);
  } on TimeoutException {
    return new EventObject(id: HttpStatus.CANCELED_CALL_TIME);
  } on Exception {
    return new EventObject(id: HttpStatus.NOT_FOUND);
  }

}





Future<EventObject> insertDetalle(dynamic bodyRequest) async {

  try {
    String url = "${URLS.BASE_URL_SERIE}/InsertarDetalleFac";

    Response response = await callServicePostJSON2(url, bodyRequest).timeout(TIMEOUT);
    if(response != null){
      if (response.statusCode == HttpStatus.SC_OK && response.responseHttp!.body != null) {
        var responseObject = InsertarCabeModel.fromJson(json.decode(response.responseHttp!.body));
        return new EventObject(id: HttpStatus.SC_OK, object: responseObject);
      }else{
        if(response.statusCode==HttpStatus.NO_INTERNET_CONNECTION){
          return new EventObject(id: HttpStatus.NO_INTERNET_CONNECTION);
        } else if(response.statusCode==HttpStatus.BAD_REQUEST){
          var responseObject = ModelObject.fromJson(json.decode(response.responseHttp!.body));
          return new EventObject(id: HttpStatus.BAD_REQUEST, object: responseObject);
        } else if(response.statusCode==HttpStatus.NOT_FOUND){
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }  else if(response.statusCode==HttpStatus.UNAUTHORIZED){
          return new EventObject(id: HttpStatus.UNAUTHORIZED);
        }else{
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }
      }
    }else
      return new EventObject(id: HttpStatus.NOT_FOUND);
  } on TimeoutException {
    return new EventObject(id: HttpStatus.CANCELED_CALL_TIME);
  } on Exception {
    return new EventObject(id: HttpStatus.NOT_FOUND);
  }

}


Future<EventObject> insertDetalleSerie(dynamic bodyRequest) async {

  try {
    String url = "${URLS.BASE_URL_SERIE}/InsertarDetalleSerie";

    Response response = await callServicePostJSON2(url, bodyRequest).timeout(TIMEOUT);
    if(response != null){
      if (response.statusCode == HttpStatus.SC_OK && response.responseHttp!.body != null) {
        var responseObject = InsertarCabeModel.fromJson(json.decode(response.responseHttp!.body));
        return new EventObject(id: HttpStatus.SC_OK, object: responseObject);
      }else{
        if(response.statusCode==HttpStatus.NO_INTERNET_CONNECTION){
          return new EventObject(id: HttpStatus.NO_INTERNET_CONNECTION);
        } else if(response.statusCode==HttpStatus.BAD_REQUEST){
          var responseObject = ModelObject.fromJson(json.decode(response.responseHttp!.body));
          return new EventObject(id: HttpStatus.BAD_REQUEST, object: responseObject);
        } else if(response.statusCode==HttpStatus.NOT_FOUND){
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }  else if(response.statusCode==HttpStatus.UNAUTHORIZED){
          return new EventObject(id: HttpStatus.UNAUTHORIZED);
        }else{
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }
      }
    }else
      return new EventObject(id: HttpStatus.NOT_FOUND);
  } on TimeoutException {
    return new EventObject(id: HttpStatus.CANCELED_CALL_TIME);
  } on Exception {
    return new EventObject(id: HttpStatus.NOT_FOUND);
  }

}







Future<EventObject> getProductos(dynamic bodyRequest) async {

  try {
    //String url = "http://201.218.2.21:8055/api/v2/producto";
    String url = "http://201.218.2.21:8055/api/v2/productosApp";

    Response response = await callServicePostHeaderJSON(url, bodyRequest).timeout(TIMEOUT);
    if(response != null){
      if (response.statusCode == HttpStatus.SC_OK && response.responseHttp!.body != null) {
        var responseObject = ProductosModel.fromJson(json.decode(response.responseHttp!.body));
        return new EventObject(id: HttpStatus.SC_OK, object: responseObject);
      }else{
        if(response.statusCode==HttpStatus.NO_INTERNET_CONNECTION){
          return new EventObject(id: HttpStatus.NO_INTERNET_CONNECTION);
        } else if(response.statusCode==HttpStatus.BAD_REQUEST){
          var responseObject = ModelObject.fromJson(json.decode(response.responseHttp!.body));
          return new EventObject(id: HttpStatus.BAD_REQUEST, object: responseObject);
        } else if(response.statusCode==HttpStatus.NOT_FOUND){
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }  else if(response.statusCode==HttpStatus.UNAUTHORIZED){
          return new EventObject(id: HttpStatus.UNAUTHORIZED);
        }else{
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }
      }
    }else
      return new EventObject(id: HttpStatus.NOT_FOUND);
  } on TimeoutException {
    return new EventObject(id: HttpStatus.CANCELED_CALL_TIME);
  } on Exception {
    return new EventObject(id: HttpStatus.NOT_FOUND);
  }

}


Future<EventObject> getFactura(dynamic bodyRequest) async {

  try {
    String url = "${URLS.BASE_URL_SERIE}/HistorialFacturasAppMovil";

    Response response = await callServicePostHeaderJSON(url, bodyRequest).timeout(TIMEOUT);
    if(response != null){
      if (response.statusCode == HttpStatus.SC_OK && response.responseHttp!.body != null) {
        var responseObject = FacturasModel.fromJson(json.decode(response.responseHttp!.body));
        return new EventObject(id: HttpStatus.SC_OK, object: responseObject);
      }else{
        if(response.statusCode==HttpStatus.NO_INTERNET_CONNECTION){
          return new EventObject(id: HttpStatus.NO_INTERNET_CONNECTION);
        } else if(response.statusCode==HttpStatus.BAD_REQUEST){
          var responseObject = ModelObject.fromJson(json.decode(response.responseHttp!.body));
          return new EventObject(id: HttpStatus.BAD_REQUEST, object: responseObject);
        } else if(response.statusCode==HttpStatus.NOT_FOUND){
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }  else if(response.statusCode==HttpStatus.UNAUTHORIZED){
          return new EventObject(id: HttpStatus.UNAUTHORIZED);
        }else{
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }
      }
    }else
      return new EventObject(id: HttpStatus.NOT_FOUND);
  } on TimeoutException {
    return new EventObject(id: HttpStatus.CANCELED_CALL_TIME);
  } on Exception {
    return new EventObject(id: HttpStatus.NOT_FOUND);
  }

}

Future<EventObject> getSerie(dynamic bodyRequest) async {

  try {
    String url = "${URLS.BASE_URL_SERIE}/HistorialSerie";

    Response response = await callServicePostHeaderJSON(url, bodyRequest).timeout(TIMEOUT);
    if(response != null){
      if (response.statusCode == HttpStatus.SC_OK && response.responseHttp!.body != null) {
        var responseObject = FacturasModel.fromJson(json.decode(response.responseHttp!.body));
        return new EventObject(id: HttpStatus.SC_OK, object: responseObject);
      }else{
        if(response.statusCode==HttpStatus.NO_INTERNET_CONNECTION){
          return new EventObject(id: HttpStatus.NO_INTERNET_CONNECTION);
        } else if(response.statusCode==HttpStatus.BAD_REQUEST){
          var responseObject = ModelObject.fromJson(json.decode(response.responseHttp!.body));
          return new EventObject(id: HttpStatus.BAD_REQUEST, object: responseObject);
        } else if(response.statusCode==HttpStatus.NOT_FOUND){
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }  else if(response.statusCode==HttpStatus.UNAUTHORIZED){
          return new EventObject(id: HttpStatus.UNAUTHORIZED);
        }else{
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }
      }
    }else
      return new EventObject(id: HttpStatus.NOT_FOUND);
  } on TimeoutException {
    return new EventObject(id: HttpStatus.CANCELED_CALL_TIME);
  } on Exception {
    return new EventObject(id: HttpStatus.NOT_FOUND);
  }

}









Future<EventObject> getDetallaFactura(dynamic bodyRequest) async {

  try {
    //String url = "${URLS.BASE_URL_SERIE}/ConsultarDetFac";
    String url = "${URLS.BASE_URL_SERIE}/ConsultarDetalleSerie";

    Response response = await callServicePostHeaderJSON(url, bodyRequest).timeout(TIMEOUT);
    if(response != null){
      if (response.statusCode == HttpStatus.SC_OK && response.responseHttp!.body != null) {
        var responseObject = DetalleFacturasModel.fromJson(json.decode(response.responseHttp!.body));
        return new EventObject(id: HttpStatus.SC_OK, object: responseObject);
      }else{
        if(response.statusCode==HttpStatus.NO_INTERNET_CONNECTION){
          return new EventObject(id: HttpStatus.NO_INTERNET_CONNECTION);
        } else if(response.statusCode==HttpStatus.BAD_REQUEST){
          var responseObject = ModelObject.fromJson(json.decode(response.responseHttp!.body));
          return new EventObject(id: HttpStatus.BAD_REQUEST, object: responseObject);
        } else if(response.statusCode==HttpStatus.NOT_FOUND){
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }  else if(response.statusCode==HttpStatus.UNAUTHORIZED){
          return new EventObject(id: HttpStatus.UNAUTHORIZED);
        }else{
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }
      }
    }else
      return new EventObject(id: HttpStatus.NOT_FOUND);
  } on TimeoutException {
    return new EventObject(id: HttpStatus.CANCELED_CALL_TIME);
  } on Exception {
    return new EventObject(id: HttpStatus.NOT_FOUND);
  }

}





Future<EventObject> getPremios(dynamic bodyRequest) async {

  try {
    String url = "${URLS.BASE_URL_SERIE}/HistorialPremios";

    Response response = await callServicePostHeaderJSON(url, bodyRequest).timeout(TIMEOUT);
    if(response != null){
      if (response.statusCode == HttpStatus.SC_OK && response.responseHttp!.body != null) {
        var responseObject = PremiosModel.fromJson(json.decode(response.responseHttp!.body));
        return new EventObject(id: HttpStatus.SC_OK, object: responseObject);
      }else{
        if(response.statusCode==HttpStatus.NO_INTERNET_CONNECTION){
          return new EventObject(id: HttpStatus.NO_INTERNET_CONNECTION);
        } else if(response.statusCode==HttpStatus.BAD_REQUEST){
          var responseObject = ModelObject.fromJson(json.decode(response.responseHttp!.body));
          return new EventObject(id: HttpStatus.BAD_REQUEST, object: responseObject);
        } else if(response.statusCode==HttpStatus.NOT_FOUND){
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }  else if(response.statusCode==HttpStatus.UNAUTHORIZED){
          return new EventObject(id: HttpStatus.UNAUTHORIZED);
        }else{
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }
      }
    }else
      return new EventObject(id: HttpStatus.NOT_FOUND);
  } on TimeoutException {
    return new EventObject(id: HttpStatus.CANCELED_CALL_TIME);
  } on Exception {
    return new EventObject(id: HttpStatus.NOT_FOUND);
  }

}






Future<EventObject> canjearCupo(dynamic bodyRequest) async {

  try {
    String url = "${URLS.BASE_URL_SERIE}/Premios";

    Response response = await callServicePostHeaderJSON(url, bodyRequest).timeout(TIMEOUT);
    if(response != null){
      if (response.statusCode == HttpStatus.SC_OK && response.responseHttp!.body != null) {
        var responseObject = CuponModel.fromJson(json.decode(response.responseHttp!.body));
        return new EventObject(id: HttpStatus.SC_OK, object: responseObject);
      }else{
        if(response.statusCode==HttpStatus.NO_INTERNET_CONNECTION){
          return new EventObject(id: HttpStatus.NO_INTERNET_CONNECTION);
        } else if(response.statusCode==HttpStatus.BAD_REQUEST){
          var responseObject = ModelObject.fromJson(json.decode(response.responseHttp!.body));
          return new EventObject(id: HttpStatus.BAD_REQUEST, object: responseObject);
        } else if(response.statusCode==HttpStatus.NOT_FOUND){
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }  else if(response.statusCode==HttpStatus.UNAUTHORIZED){
          return new EventObject(id: HttpStatus.UNAUTHORIZED);
        }else{
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }
      }
    }else
      return new EventObject(id: HttpStatus.NOT_FOUND);
  } on TimeoutException {
    return new EventObject(id: HttpStatus.CANCELED_CALL_TIME);
  } on Exception {
    return new EventObject(id: HttpStatus.NOT_FOUND);
  }

}











Future<EventObject> getCupo(dynamic bodyRequest) async {

  try {
    String url = "${URLS.BASE_URL_SERIE}/Saldo";

    Response response = await callServicePostHeaderJSON(url, bodyRequest).timeout(TIMEOUT);
    if(response != null){
      if (response.statusCode == HttpStatus.SC_OK && response.responseHttp!.body != null) {
        var responseObject = DisponibleModel.fromJson(json.decode(response.responseHttp!.body));
        return new EventObject(id: HttpStatus.SC_OK, object: responseObject);
      }else{
        if(response.statusCode==HttpStatus.NO_INTERNET_CONNECTION){
          return new EventObject(id: HttpStatus.NO_INTERNET_CONNECTION);
        } else if(response.statusCode==HttpStatus.BAD_REQUEST){
          var responseObject = ModelObject.fromJson(json.decode(response.responseHttp!.body));
          return new EventObject(id: HttpStatus.BAD_REQUEST, object: responseObject);
        } else if(response.statusCode==HttpStatus.NOT_FOUND){
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }  else if(response.statusCode==HttpStatus.UNAUTHORIZED){
          return new EventObject(id: HttpStatus.UNAUTHORIZED);
        }else{
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }
      }
    }else
      return new EventObject(id: HttpStatus.NOT_FOUND);
  } on TimeoutException {
    return new EventObject(id: HttpStatus.CANCELED_CALL_TIME);
  } on Exception {
    return new EventObject(id: HttpStatus.NOT_FOUND);
  }

}









Future<EventObject> getNotificaciones(dynamic bodyRequest) async {

  try {
    String url = "http://201.218.2.21:8055/api/v2/notificaciones";

    Response response = await callServicePostHeaderJSON(url, bodyRequest).timeout(TIMEOUT);
    if(response != null){
      if (response.statusCode == HttpStatus.SC_OK && response.responseHttp!.body != null) {
        var responseObject = ReponseNotificacionesModel.fromJson(json.decode(response.responseHttp!.body));
        return new EventObject(id: HttpStatus.SC_OK, object: responseObject);
      }else{
        if(response.statusCode==HttpStatus.NO_INTERNET_CONNECTION){
          return new EventObject(id: HttpStatus.NO_INTERNET_CONNECTION);
        } else if(response.statusCode==HttpStatus.BAD_REQUEST){
          var responseObject = ModelObject.fromJson(json.decode(response.responseHttp!.body));
          return new EventObject(id: HttpStatus.BAD_REQUEST, object: responseObject);
        } else if(response.statusCode==HttpStatus.NOT_FOUND){
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }  else if(response.statusCode==HttpStatus.UNAUTHORIZED){
          return new EventObject(id: HttpStatus.UNAUTHORIZED);
        }else{
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }
      }
    }else
      return new EventObject(id: HttpStatus.NOT_FOUND);
  } on TimeoutException {
    return new EventObject(id: HttpStatus.CANCELED_CALL_TIME);
  } on Exception {
    return new EventObject(id: HttpStatus.NOT_FOUND);
  }

}

Future<EventObject> getRecordatorio(dynamic bodyRequest) async {

  try {
    String url = "http://201.218.2.21:8055/api/v2/notificacionAbastecimiento";

    Response response = await callServicePostHeaderJSON(url, bodyRequest).timeout(TIMEOUT);
    if(response != null){
      if (response.statusCode == HttpStatus.SC_OK && response.responseHttp!.body != null) {
        var responseObject = ReponseNotificacionesModel.fromJson(json.decode(response.responseHttp!.body));
        return new EventObject(id: HttpStatus.SC_OK, object: responseObject);
      }else{
        if(response.statusCode==HttpStatus.NO_INTERNET_CONNECTION){
          return new EventObject(id: HttpStatus.NO_INTERNET_CONNECTION);
        } else if(response.statusCode==HttpStatus.BAD_REQUEST){
          var responseObject = ModelObject.fromJson(json.decode(response.responseHttp!.body));
          return new EventObject(id: HttpStatus.BAD_REQUEST, object: responseObject);
        } else if(response.statusCode==HttpStatus.NOT_FOUND){
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }  else if(response.statusCode==HttpStatus.UNAUTHORIZED){
          return new EventObject(id: HttpStatus.UNAUTHORIZED);
        }else{
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }
      }
    }else
      return new EventObject(id: HttpStatus.NOT_FOUND);
  } on TimeoutException {
    return new EventObject(id: HttpStatus.CANCELED_CALL_TIME);
  } on Exception {
    return new EventObject(id: HttpStatus.NOT_FOUND);
  }

}




Future<EventObject> productoParticipantes(dynamic bodyRequest) async {

  try {
    String url = "http://3.139.221.163/api/consultatodo";

    Response response = await callServicePost(url, bodyRequest).timeout(TIMEOUT);
    if(response != null){
      if (response.statusCode == HttpStatus.SC_OK && response.responseHttp!.body != null) {
        var responseObject = ListaParticipanteModel.fromJson(json.decode(response.responseHttp!.body));
        return new EventObject(id: HttpStatus.SC_OK, object: responseObject);
      }else{
        if(response.statusCode==HttpStatus.NO_INTERNET_CONNECTION){
          return new EventObject(id: HttpStatus.NO_INTERNET_CONNECTION);
        } else if(response.statusCode==HttpStatus.BAD_REQUEST){
          var responseObject = ModelObject.fromJson(json.decode(response.responseHttp!.body));
          return new EventObject(id: HttpStatus.BAD_REQUEST, object: responseObject);
        } else if(response.statusCode==HttpStatus.NOT_FOUND){
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }  else if(response.statusCode==HttpStatus.UNAUTHORIZED){
          return new EventObject(id: HttpStatus.UNAUTHORIZED);
        }else{
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }
      }
    }else
      return new EventObject(id: HttpStatus.NOT_FOUND);
  } on TimeoutException {
    return new EventObject(id: HttpStatus.CANCELED_CALL_TIME);
  } on Exception {
    return new EventObject(id: HttpStatus.NOT_FOUND);
  }
}















Future<EventObject> updateDfa(dynamic bodyRequest) async {

  try {
    String url = "http://3.139.221.163/api/actualizarDfa";

    Response response = await callServicePost2(url, bodyRequest).timeout(TIMEOUT);
    if(response != null){
      if (response.statusCode == HttpStatus.SC_OK && response.responseHttp!.body != null) {
        var responseObject = UpdateDFAModel.fromJson(json.decode(response.responseHttp!.body));
        return new EventObject(id: HttpStatus.SC_OK, object: responseObject);
      }else{
        if(response.statusCode==HttpStatus.NO_INTERNET_CONNECTION){
          return new EventObject(id: HttpStatus.NO_INTERNET_CONNECTION);
        } else if(response.statusCode==HttpStatus.BAD_REQUEST){
          var responseObject = ModelObject.fromJson(json.decode(response.responseHttp!.body));
          return new EventObject(id: HttpStatus.BAD_REQUEST, object: responseObject);
        } else if(response.statusCode==HttpStatus.NOT_FOUND){
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }  else if(response.statusCode==HttpStatus.UNAUTHORIZED){
          return new EventObject(id: HttpStatus.UNAUTHORIZED);
        }else{
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }
      }
    }else
      return new EventObject(id: HttpStatus.NOT_FOUND);
  } on TimeoutException {
    return new EventObject(id: HttpStatus.CANCELED_CALL_TIME);
  } on Exception {
    return new EventObject(id: HttpStatus.NOT_FOUND);
  }
}







Future<EventObject> productoParticipantes2(dynamic bodyRequest) async {

  try {
    String url = "http://201.218.2.21:8055/api/v2/productosParticipantes";

    Response response = await callServicePostHeaderJSON(url, bodyRequest).timeout(TIMEOUT);
    if(response != null){
      if (response.statusCode == HttpStatus.SC_OK && response.responseHttp!.body != null) {
        var responseObject = PartModel.fromJson(json.decode(response.responseHttp!.body));
        return new EventObject(id: HttpStatus.SC_OK, object: responseObject);
      }else{
        if(response.statusCode==HttpStatus.NO_INTERNET_CONNECTION){
          return new EventObject(id: HttpStatus.NO_INTERNET_CONNECTION);
        } else if(response.statusCode==HttpStatus.BAD_REQUEST){
          var responseObject = ModelObject.fromJson(json.decode(response.responseHttp!.body));
          return new EventObject(id: HttpStatus.BAD_REQUEST, object: responseObject);
        } else if(response.statusCode==HttpStatus.NOT_FOUND){
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }  else if(response.statusCode==HttpStatus.UNAUTHORIZED){
          return new EventObject(id: HttpStatus.UNAUTHORIZED);
        }else{
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }
      }
    }else
      return new EventObject(id: HttpStatus.NOT_FOUND);
  } on TimeoutException {
    return new EventObject(id: HttpStatus.CANCELED_CALL_TIME);
  } on Exception {
    return new EventObject(id: HttpStatus.NOT_FOUND);
  }
}




Future<EventObject> requesDFA(dynamic bodyRequest) async {

  try {
    String url = "http://201.218.2.21:8055/api/sendOtp";

    Response response = await callServicePostHeaderJSON(url, bodyRequest).timeout(TIMEOUT);
    if(response != null){
      if (response.statusCode == HttpStatus.SC_OK && response.responseHttp!.body != null) {
        //var responseObject = SolicitarDFAModel.fromJson(json.+decode(response.responseHttp!.body));
        return new EventObject(id: HttpStatus.SC_OK);
      }else{
        if(response.statusCode==HttpStatus.NO_INTERNET_CONNECTION){
          return new EventObject(id: HttpStatus.NO_INTERNET_CONNECTION);
        } else if(response.statusCode==HttpStatus.BAD_REQUEST){
          var responseObject = ModelObject.fromJson(json.decode(response.responseHttp!.body));
          return new EventObject(id: HttpStatus.BAD_REQUEST, object: responseObject);
        } else if(response.statusCode==HttpStatus.NOT_FOUND){
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }  else if(response.statusCode==HttpStatus.UNAUTHORIZED){
          return new EventObject(id: HttpStatus.UNAUTHORIZED);
        }else{
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }
      }
    }else
      return new EventObject(id: HttpStatus.NOT_FOUND);
  } on TimeoutException {
    return new EventObject(id: HttpStatus.CANCELED_CALL_TIME);
  } on Exception {
    return new EventObject(id: HttpStatus.NOT_FOUND);
  }
}

Future<EventObject> verifyDFA(dynamic bodyRequest) async {

  try {
    String url = "http://201.218.2.21:8055/api/verifyOtp";


    Response response = await callServicePostHeaderJSON(url, bodyRequest).timeout(TIMEOUT);
    if(response != null){
      if (response.statusCode == HttpStatus.SC_OK && response.responseHttp!.body != null) {
        //var responseObject = SolicitarDFAModel.fromJson(json.decode(response.responseHttp!.body));
        return new EventObject(id: HttpStatus.SC_OK);
      }else{
        if(response.statusCode==HttpStatus.NO_INTERNET_CONNECTION){
          return new EventObject(id: HttpStatus.NO_INTERNET_CONNECTION);
        } else if(response.statusCode==HttpStatus.BAD_REQUEST){
          var responseObject = ModelObject.fromJson(json.decode(response.responseHttp!.body));
          return new EventObject(id: HttpStatus.BAD_REQUEST, object: responseObject);
        } else if(response.statusCode==HttpStatus.NOT_FOUND){
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }  else if(response.statusCode==HttpStatus.UNAUTHORIZED){
          return new EventObject(id: HttpStatus.UNAUTHORIZED);
        }else{
          return new EventObject(id: HttpStatus.NOT_FOUND);
        }
      }
    }else
      return new EventObject(id: HttpStatus.NOT_FOUND);
  } on TimeoutException {
    return new EventObject(id: HttpStatus.CANCELED_CALL_TIME);
  } on Exception {
    return new EventObject(id: HttpStatus.NOT_FOUND);
  }
}