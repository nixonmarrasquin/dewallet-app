import 'package:flutter/material.dart';

import '../Models/ListaModel.dart';

enum Section
{
  INICIO,
  FACTURACION,
  PRODUCTOS_PARTICIPANTES,
  SALDOS,
  HISTORIAL,
  PREMIOS,
  COMOFUNCIONA,
  TERMINOS_CONDICIONES
}

class App{
  static  const String NAME_APP = "DeWallet";
  static const String DATABASE_NAME = "sigloe_21_database.db";
  static var section = Section.INICIO;
  static var PLATAFORM_ANDROID = "ANDROID";
  static var PLATAFORM_IOS = "IOS";
  static var IS_BETA = true;
  static var LISTA_PRECIO = 0;
}

class URLS {
  //DESARROLLO
  //static const String BASE_URL = 'https://apk.latincosmetic.com.ec/v1/';
  //static const String BASE_URL_IMAGE = 'https://apk.latincosmetic.com.ec/storage/';

  //PRODUCCION
  static const String BASE_URL = 'http://3.139.221.163/api';
  //static const String BASE_URL_SERIE = 'http://201.218.2.21:8055/api/v2';
  static const String BASE_URL_SERIE = 'http://201.218.2.21:8055/api/v2';
  static const String BASE_URL_IMAGE = 'https://app.dipaso.com.ec/storage/';

  static const String X_WWW_FORM_URLENCODED = "application/x-www-form-urlencoded";
  static const String X_WWW_APPLICATION_JSON = "application/json";
}

class Services {
  static const String X_WWW_FORM_URLENCODED = "application/x-www-form-urlencoded";
  static const String LOGIN = "Login";
}

class APIKeys {
  static const String apiKey = "AIzaSyDFem6c3bmE_ajodQaOlEX1sOVrb6u6djc";
}

class SnackBarText {
  static const String NO_INTERNET_CONNECTION = "Sin conexión a Internet";
  static const String NOT_FOUND = "Servicio no disponible, intentelo más tarde.";
  static const String CANCELED_CALL_TIME_TITLE = "Problemas de conexión";
  static const String CANCELED_CALL_TIME = "Problemas de conexión, inténtelo nuevamente.";
  static const String ENTER_EMAIL = "Por favor ingrese usuario";
  static const String ENTER_PASS = "Por favor ingrese contraseña";
  static const String ERROR_DEFAULT = "Lo sentimos no pudimos cargar datos, inténtelo más tarde";
}

class ColorTheme{
  static const String primaryColor = "#FFC107"; //"#1C2556";
  static const String secundaryColor = "#111111";
  static const String thirdColor = "#BFC4D1";
  static const String backgroundColor = "#F8F8F8";
  static const String backgroundColorSnackBar = "323232";
  static const String buttoncolor = "111111";
  static const String colorEnd = "303030";
  static const String colorSaldo = "#FDF0C2";
}

class HttpStatus {
  static const int SC_OK = 200;
  static const int TIMER_INACTIVITY = 3600; //sec
  static const int BAD_REQUEST = 400;
  static const int UNAUTHORIZED = 401;
  static const int NOT_FOUND = 404;
  static const int INTERNAL_SERVER_ERROR = 500;
  static const int CANCELED_CALL_TIME = 408;
  static const int NO_INTERNET_CONNECTION = 0;
}

class Dimensions{
  static const double HEIGHT_APPBAR = 75.0;
}

class Texts {
  static const String USER = "Usuario";
  static const String LBL_ATENCION = "Atención";
  static const String LBL_OK = "OK";
  static const String LBL_CANCELAR = "CANCELAR";
  static const String LOAGING = "Cargando...";
  static const String FONT_FAMILY = 'Monsetrrat';
  static  List<ListaModel> listaGlobal = [];
}


