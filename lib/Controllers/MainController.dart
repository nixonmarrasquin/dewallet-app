import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:siglo21/Controllers/HistorialFacturacionController.dart';
import 'package:siglo21/Controllers/LoginController.dart';
import 'package:siglo21/Entities/Sesion.dart';
import '../Constants/Constants.dart';
import '../Models/EventObject.dart';
import '../Models/NotificacionesModel.dart';
import '../Models/ReponseNotificacionesModel.dart';
import '../Utils/HexColor.dart';
import '../Utils/slider_menu/slider.dart';
import '../Utils/slider_menu/slider_direction.dart';
import '../services/ApiService.dart';
import 'BaseController.dart';
import 'dart:convert' show json;
import '../Constants/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ComoFuncionaController.dart';
import 'EditarDatosController.dart';
import 'FacturacionController.dart';
import 'InicioController.dart';
import 'PremiosController.dart';
import 'ProductosParticipantesController.dart';
import 'SaldosController.dart';
import 'package:intl/intl.dart';

import 'TerminosController.dart';

  class MainController extends BaseController {

    final bool isLogin;
    MainController({required this.isLogin}) : super();


    @override
    _MainController createState() => _MainController();
}

class _MainController extends BaseControllerState<MainController> with AutomaticKeepAliveClientMixin , WidgetsBindingObserver {

  @override
  bool get wantKeepAlive => true;
  String error = SnackBarText.ERROR_DEFAULT;
  int id = 0;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Sesion? sesion;
  GlobalKey<SliderMenuContainerState> scafoldKey = GlobalKey<SliderMenuContainerState>();
  List<String> opciones = <String>['Inicio','Reg. Series','Producto\nParticipantes', 'Historial Series', 'Premios','¿Cómo funciona?','Términos de uso'];
  List<String> opciones_images = <String>['inicio.png','facturacion.png','product.png','historial.png','premios.png','como.png','information.png'];
  List<String> opcionesBottom = <String>['Inicio','Saldos', 'Premios'];
  List<String> opciones_imagesBottom = <String>['inicio.png','facturacion.png','premios.png'];
  int position = 0;
  List<int> listId = [];
  List<int> listRecordatorios = [];
  List<NotificacionesModel>? dataNotify;

  static const DarwinNotificationDetails darwinNotificationDetails =
  DarwinNotificationDetails(
    categoryIdentifier: 'textCategory',
  );

  @override
  void initState() {
    super.initState();
    setState(() {
      App.section = Section.COMOFUNCIONA;
      position = 5;
      gerUser();
      validateInactivity ();
      loadData();
      Future.delayed(const Duration(milliseconds: 1500), () {
        loadDataRecordatorio();
      });

    });
  }

  Future<void> validateInactivity () async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String date = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
    String fechaHora = prefs.getString('fechaHora') ?? "";
    print("La fecha hora: "+fechaHora);
    if (fechaHora.length > 0){
      DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(fechaHora);
      DateTime now = DateFormat("yyyy-MM-dd hh:mm:ss").parse(date);
      Duration diff = now.difference(tempDate);
      if (diff.inSeconds > HttpStatus.TIMER_INACTIVITY){
        await prefs.setString('fechaHora', "");
        showNewConfirm("Lo sentimos sesión expirada",(){
          //Navigator.pop(context);
          Future.delayed(Duration(milliseconds: 800), () {

            database.then((onValu){

              onValu.cuponesDao.cleanCupones();
              onValu.seriesDao.cleanSeries();
              onValu.productosDao.cleanProductos();
              onValu.facturasDao.cleanFacturas();
              onValu.detalleFacturasDao.cleanDetalleFacturas();
              onValu.premiosDao.cleanPremios();
              onValu.sesionDao.cleanSesion().then((value) {
                reload();
              }

              );

            });
          });
        });
      }

    }
  }


  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Widget body;

    switch (App.section)
    {
      case Section.INICIO:
        body = InicioController();
        break;
      case Section.FACTURACION:
        body = FacturacionController();
        break;
     case Section.PRODUCTOS_PARTICIPANTES:
        body = ProductosParticipantesController();
        break;
      case Section.HISTORIAL:
        body = HistorialFacturacionController();
        break;
      case Section.PREMIOS:
        body = PremiosController(goHome: goProducto);
        break;
      case Section.COMOFUNCIONA:
        body = ComoFuncionaController();
        break;
      case Section.SALDOS:
        body = SaldosController();
        break;
      case Section.TERMINOS_CONDICIONES:
        body = TerminosController();
        break;

    }

    return Scaffold(
      backgroundColor: HexColor(ColorTheme.primaryColor),
      body: SafeArea(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: GestureDetector(
              onTap: () {FocusScope.of(context).requestFocus(FocusNode());},
              child: SliderMenuContainer(
                  hasAppBar: true,
                  drawerIconColor: HexColor(ColorTheme.buttoncolor),
                  animationDuration: 300,
                  slideDirection: SlideDirection.LEFT_TO_RIGHT,
                  shadowColor: Colors.white,
                  isShadow: false,
                  appBarHeight: Dimensions.HEIGHT_APPBAR,
                  appBarColor: HexColor(ColorTheme.primaryColor),
                  title:  Container(
                      color: HexColor(ColorTheme.primaryColor),
                      child: Image.asset("assets/logo_white.png", fit: BoxFit.fitHeight)
                  ),
                  key: scafoldKey,
                  sliderMenu: menuDrawer(),
                  sliderMain: Container(
                    color: HexColor(ColorTheme.backgroundColor),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(child:
                          GestureDetector(

                              onTap: () {if (scafoldKey.currentState!.isDrawerOpen) {scafoldKey.currentState!.closeDrawer();}},
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: body, // Controller
                                  ),
                                  Container(
                                    color: HexColor(ColorTheme.backgroundColor),
                                    child: Container(
                                      padding: const EdgeInsets.only(top: 15, bottom: 8),
                                      decoration: BoxDecoration(
                                        color: HexColor(ColorTheme.primaryColor),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(20.0),
                                        ),
                                        border: Border.all(
                                          color: HexColor(ColorTheme.primaryColor),
                                          style: BorderStyle.solid,
                                          width: 1,
                                        ),

                                      ),
                                      child: SafeArea(
                                        top: false,
                                        child: Row(
                                          children: [
                                            for (int i=0; i<opcionesBottom.length; i++)
                                              menuBottom(i)
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )

                          ))
                        ]),
                  ))
          ),
        ),
      ),
    );
  }

  Widget menuBottom(int index){
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: (){
          setState(() {

            switch (index)
            {
              case 0:
                App.section = Section.INICIO;
                position = 0;
                break;
              case 1:
                App.section = Section.SALDOS;
                position = -1;
                break;
              case 2:
                App.section = Section.PREMIOS;
                position = 3;
                break;

            }

          });
        },
        child: Column(children: [

          Image.asset("assets/${opciones_imagesBottom[index]}", width: 30, height: 30, color: HexColor(ColorTheme.secundaryColor),),
          const SizedBox(height: 5),
          Text(opcionesBottom[index], style: TextStyle(color: HexColor(ColorTheme.secundaryColor), fontWeight: FontWeight.bold, fontSize: 13))

        ]),
      ),
    );
  }

  Widget menuDrawer(){
    return  Container(
        color: HexColor(ColorTheme.primaryColor),
        child: Stack(
          children: [
            /*Positioned(
              child: Align(
                  alignment: FractionalOffset.bottomRight,
                  child: Container(
                    transform: Matrix4.translationValues(80.0, 80.0, 0.0),
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                        color: HexColor('DCDCDC'),
                        shape: BoxShape.circle,
                        border: Border.all(color: HexColor(ColorTheme.secundaryColor), width: 60),
                    ),
                  )
              ),
            ),*/

            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  GestureDetector(
                    onTap: () {
                      scafoldKey.currentState!.closeDrawer();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => EditarDatosController(goHome: reload,))).then((value) => (){
                        gerUser();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 30, bottom: 10, left: 20, right: 20),
                      color: HexColor(ColorTheme.primaryColor),
                      width: double.infinity,
                      child: SafeArea(
                        bottom: false,
                        left: false,
                        right: false,
                        top: false,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: Icon(Icons.person, color: HexColor(ColorTheme.buttoncolor)),
                              ),
                              Expanded(flex: 1, child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text(sesion != null ? sesion!.correo! : "", style: TextStyle(color: HexColor(ColorTheme.buttoncolor), fontSize: 13, fontWeight: FontWeight.bold),),
                                    Text("Vendedor", style: TextStyle(color: HexColor(ColorTheme.buttoncolor), fontSize: 12),)

                                  ])),
                              Container(
                                child: Icon(Icons.arrow_forward_ios_sharp, color: HexColor(ColorTheme.buttoncolor)),
                              )


                            ]),
                      ),
                    ),
                  ),


                  //SizedBox(height: 25),
                  Flexible(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ListView.builder(
                                padding: const EdgeInsets.only(left: 20, right: 20, top: 25),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 7,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                      height: 60,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {

                                            scafoldKey.currentState!.closeDrawer();
                                            position = index;
                                            switch (index)
                                            {
                                              case 0:
                                                App.section = Section.INICIO;
                                                break;
                                              case 1:
                                                App.section = Section.FACTURACION;
                                                break;
                                              case 2:
                                                App.section = Section.PRODUCTOS_PARTICIPANTES;
                                                break;
                                              case 3:
                                                App.section = Section.HISTORIAL;
                                                break;
                                              case 4:
                                                App.section = Section.PREMIOS;
                                                break;
                                              case 5:
                                                App.section = Section.COMOFUNCIONA;
                                                break;
                                                case 6:
                                                App.section = Section.TERMINOS_CONDICIONES;
                                                break;

                                            }
                                          });
                                        },
                                        child: Row(children: [
                                          index == position ?
                                          Container(
                                            height: 40,
                                            width: 40,
                                            padding: const EdgeInsets.all(8),
                                            child: Image.asset("assets/${opciones_images[index]}",color: Colors.white),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(width: 1, color: HexColor(ColorTheme.secundaryColor)),
                                                color: HexColor(ColorTheme.secundaryColor)
                                            ),
                                          ) :
                                          Container(
                                            height: 40,
                                            width: 40,
                                            padding: const EdgeInsets.all(8),
                                            child: Image.asset("assets/${opciones_images[index]}", color: HexColor(ColorTheme.buttoncolor),),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(width: 1, color: Colors.transparent),
                                                color: Colors.transparent
                                            ),
                                          ),

                                          const SizedBox(width: 15),
                                          index == position ?
                                          Text('${opciones[index]}', style: TextStyle(fontSize: 15, color: HexColor(ColorTheme.secundaryColor), fontWeight: FontWeight.bold),)
                                          :  Text('${opciones[index]}', style: TextStyle(fontSize: 15, color: HexColor(ColorTheme.buttoncolor), fontWeight: FontWeight.bold),),
                                        ],),
                                      )
                                  );
                                }
                            ),

                          ],
                        ),
                      ))

                ])

          ],
        )
    );
  }


  reload() {
    App.section = Section.INICIO;
    position = 0;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginController()));

  }

  goProducto() {
    setState(() {
      position = 2;
      App.section = Section.PRODUCTOS_PARTICIPANTES;
    });

  }

  Future<void> gerUser() async {

    database.then((onValu){

      final result =  onValu.sesionDao.getSesion();
      if (result != null){
        result.then((data) async {
          if (data != null){
            if (data.length > 0){
              setState(() {
                sesion =  data.cast<Sesion>()[0];
              });
            }
          }


        }, onError: (e) {
          print("Error: "+e.toString());
        });
      }


    });

  }







  Future<void> loadData() async {

    //showLoading();
    try {
      final body = {
        //"codVendedor": sesion != null ? "${sesion!.codigo_v}" : ""
      };

      print(body.toString());
      error = SnackBarText.ERROR_DEFAULT;
      EventObject _resp = await getNotificaciones(body);
      switch (_resp.id) {
        case HttpStatus.SC_OK:
          {
            ReponseNotificacionesModel? model = _resp.object as ReponseNotificacionesModel?;
            if (model != null) {
              if (model.code != null) {
                if (model.code == 200) {

                  if (model.data != null){
                    //code all
                    dataNotify = model.data;
                    generateNotification(dataNotify);

                  }
                }
              }else {
                setState(() {
                  //showAlert(error);
                });
              }
            } else {
              setState(() {
                //showAlert(error);
              });
            }
          }
          break;
        case HttpStatus.BAD_REQUEST:
          {
            setState(() {
              //showAlert(error);
            });
          }
          break;
        case HttpStatus.CANCELED_CALL_TIME:
          setState(() {
            //showAlert(error);
          });
          break;
        case HttpStatus.NO_INTERNET_CONNECTION:
          setState(() {
            //showAlert(error);
          });
          break;
        case HttpStatus.NOT_FOUND:

          break;
      }

    } on Exception {

    }

  }

  Future<void> generateNotification (List<NotificacionesModel>? data) async {

    for (var not in data!){
      if (not.FechaInicio != null && not.FechaFin != null){
        if (not.FechaInicio!.length > 0 && not.FechaFin!.length > 0) {
          var fi = not.FechaInicio!.replaceAll("T00:00:00", "");
          var ff = not.FechaFin!.replaceAll("T00:00:00", "");

          DateTime di = new DateFormat("yyyy-MM-dd").parse(fi);
          DateTime df = new DateFormat("yyyy-MM-dd").parse(ff);
          if (DateTime.now().isBetween(di, df) != null){
              if (DateTime.now().isBetween(di, df)!){
                if (!listId.contains(not.MensajePushId!) && not.Estado!){
                  _showNotification(not);
                  listId.add(not.MensajePushId!);
                  Future.delayed(const Duration(milliseconds: 300000), () {
                    generateNotification(dataNotify);
                  });
                  break;
                }
              }
          }


        }
      }


    }



  }


  Future<void> _showNotification(NotificacionesModel data) async {

    BigTextStyleInformation bigTextStyleInformation =
    BigTextStyleInformation(
      '${data.DescripcionMensaje}',
      htmlFormatBigText: true,
      contentTitle: '${data.NombreMensaje}',
      htmlFormatContentTitle: true,
      summaryText: 'summary <i>text</i>',
      htmlFormatSummaryText: true,
    );

    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        icon: "@drawable/ic_stat_dewallet",
        styleInformation: bigTextStyleInformation
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
      macOS: darwinNotificationDetails,
    );
    //
    // await flutterLocalNotificationsPlugin.show(
    //     id++, '${data.NombreMensaje}', '${data.DescripcionMensaje}', notificationDetails,
    //     payload: 'item x');

    await flutterLocalNotificationsPlugin.show(
        id++, '${data.NombreMensaje}', '${data.DescripcionMensaje}', notificationDetails);

  }




  Future<void> generateRecordatorio (List<NotificacionesModel>? data) async {

    for (var not in data!){
      if (not.FechaInicio != null && not.FechaFin != null){
        if (not.FechaInicio!.length > 0 && not.FechaFin!.length > 0) {
          var fi = not.FechaInicio!.replaceAll("T00:00:00", "");
          var ff = not.FechaFin!.replaceAll("T00:00:00", "");

          DateTime di = new DateFormat("yyyy-MM-dd").parse(fi);
          DateTime df = new DateFormat("yyyy-MM-dd").parse(ff);
          if (DateTime.now().isBetween(di, df) != null){
            if (DateTime.now().isBetween(di, df)!){
              showNewAlert( '${not?.DescripcionMensaje}');
              if (!listRecordatorios.contains(not.MensajePushId!) && not.Estado!){
                listRecordatorios.add(not.MensajePushId!);
                break;
              }
            }
          }


        }
      }


    }



  }


  Future<void> loadDataRecordatorio() async {

    //showLoading();
    try {
      final body = {
        "codCliente": sesion != null ? "${sesion!.codigo_c}" : ""
      };

      print(body.toString());
      error = SnackBarText.ERROR_DEFAULT;
      EventObject _resp = await getRecordatorio(body);
      switch (_resp.id) {
        case HttpStatus.SC_OK:
          {
            ReponseNotificacionesModel? model = _resp.object as ReponseNotificacionesModel?;
            if (model != null) {
              if (model.code != null) {
                if (model.code == 200) {

                  if (model.data != null){
                    //code all
                    dataNotify = model.data;
                    generateRecordatorio(dataNotify);

                  }
                }
              }else {
                setState(() {
                  //showAlert(error);
                });
              }
            } else {
              setState(() {
                //showAlert(error);
              });
            }
          }
          break;
        case HttpStatus.BAD_REQUEST:
          {
            setState(() {
              //showAlert(error);
            });
          }
          break;
        case HttpStatus.CANCELED_CALL_TIME:
          setState(() {
            //showAlert(error);
          });
          break;
        case HttpStatus.NO_INTERNET_CONNECTION:
          setState(() {
            //showAlert(error);
          });
          break;
        case HttpStatus.NOT_FOUND:

          break;
      }

    } on Exception {

    }

  }














}

extension DateTimeExtension on DateTime? {

  bool? isAfterOrEqualTo(DateTime dateTime) {
    final date = this;
    if (date != null) {
      final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
      return isAtSameMomentAs | date.isAfter(dateTime);
    }
    return null;
  }

  bool? isBeforeOrEqualTo(DateTime dateTime) {
    final date = this;
    if (date != null) {
      final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
      return isAtSameMomentAs | date.isBefore(dateTime);
    }
    return null;
  }

  bool? isBetween(
      DateTime fromDateTime,
      DateTime toDateTime,
      ) {
    final date = this;
    if (date != null) {
      final isAfter = date.isAfterOrEqualTo(fromDateTime) ?? false;
      final isBefore = date.isBeforeOrEqualTo(toDateTime) ?? false;
      return isAfter && isBefore;
    }
    return null;
  }

}
