import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Constants/Constants.dart';
import '../Entities/Sesion.dart';
import '../Models/EventObject.dart';
import '../Models/SolicitarDFAModel.dart';
import '../Models/UpdateDFAModel.dart';
import '../Utils/HexColor.dart';
import '../services/ApiService.dart';
import 'BaseController.dart';
import 'dart:convert' show json;
import 'package:shared_preferences/shared_preferences.dart';

import 'MainController.dart';

  class DFAController extends BaseController {

    DFAController() : super();



    @override
  _DFAController createState() => _DFAController();

}

class _DFAController extends BaseControllerState<DFAController> with AutomaticKeepAliveClientMixin , WidgetsBindingObserver {

  @override
  bool get wantKeepAlive => true;

  Sesion? sesion;

  String error = SnackBarText.ERROR_DEFAULT;
  bool isError = true;
  final _correo = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    WidgetsBinding.instance!.addPostFrameCallback((_) => getUser()
    );

  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  getUser(){
    database.then((onValu){

        final result =  onValu.sesionDao.getSesion();
        if (result != null){
          result.then((data) async {
            if (data != null){
              if (data.length > 0){
                setState(() {
                  sesion =  data.cast<Sesion>()[0];
                  requestDFA(context);
                });
              }
            }


          }, onError: (e) {
            print("Error: "+e.toString());
          });
        }


      });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: HexColor(ColorTheme.buttoncolor), //change your color here
        ),
        backgroundColor: HexColor(ColorTheme.primaryColor),
        bottomOpacity: 0.0,
        elevation: 0.0,
        title:  Container(   // <--- Change here
            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.1),
            child: Image.asset("assets/logo_white.png", fit: BoxFit.fitHeight, height: 50,)
        ),
        centerTitle: true, systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: GestureDetector(
        onTap: () {FocusScope.of(context).requestFocus(new FocusNode());},
        child: SingleChildScrollView(
          child:Container(
            padding: EdgeInsets.only(top: 25,left: 25,right: 25,bottom: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  margin: EdgeInsets.only(left: 19),
                  child: Text("Ingrese el código OTP envia a tu correo", style: TextStyle(fontSize: 18, color: Colors.black)),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _correo,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  cursorColor: HexColor(ColorTheme.thirdColor),
                  style: TextStyle(color: Colors.black, fontFamily: Texts.FONT_FAMILY),
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    isDense: true,
                    contentPadding: EdgeInsets.all(16),
                    hintText: "Código OTP",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor(ColorTheme.thirdColor),  width: 1.5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor(ColorTheme.thirdColor),  width: 1.5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),

             SafeArea(
                  child: Center(
                    child: Container(
                      width: 280,
                      child: Column(children: [


                        GestureDetector(
                            onTap: (){
                              if (_correo.text.length > 0 ){
                                veriftDFA(context);
                              }else{
                                showNewAlert("Complete los campos");
                              }

                            },

                            child: Container(
                              width: double.infinity,
                              height: 40,
                              margin: const EdgeInsets.only(bottom: 15, top: 15),
                              decoration: BoxDecoration(
                                  color: HexColor(ColorTheme.buttoncolor),
                                  borderRadius: new BorderRadius.all(const Radius.circular(15.0))
                              ),
                              child: const Center(
                                child: Text(
                                  "Validar OTP",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                        ),

                      ]),

                    ),
                  ),
                ),



              ],),
          )
        ),
      ),
    );
  }





  Future<void> requestDFA(BuildContext context) async {

    showLoading();
    try {
      final body = {
        "Email": "${sesion!.correo}",
        "codigoVendedor": "${sesion!.codigo_v}",
      };

      // print(body.toString());
      error = SnackBarText.ERROR_DEFAULT;
      EventObject _resp = await requesDFA(body);
      switch (_resp.id) {
        case HttpStatus.SC_OK:
          {

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
          setState(() {
            // showAlert(error);
          });
          break;
      }
      setState(() {
        dissmisLoading();
        //showNewAlert(error);
      });
    } on Exception {
      setState(() {
        dissmisLoading();
        //showNewAlert(error);
      });
    }

  }


  Future<void> veriftDFA(BuildContext context) async {

    showLoading();
    try {
      final body = {
        "Email": "${sesion!.correo}",
        "OTP": int.parse("${_correo.text}"),
      };

      // print(body.toString());
      error = "OTP Inválido";
      EventObject _resp = await verifyDFA(body);
      switch (_resp.id) {
        case HttpStatus.SC_OK:
          {
            dissmisLoading();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainController(isLogin: true,)));
            return;

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
          setState(() {
            // showAlert(error);
          });
          break;
      }
      setState(() {
        dissmisLoading();
        showNewAlert(error);
      });
    } on Exception {
      setState(() {
        dissmisLoading();
        showNewAlert(error);
      });
    }

  }



}

