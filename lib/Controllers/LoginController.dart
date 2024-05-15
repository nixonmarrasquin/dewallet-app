import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:siglo21/Controllers/DFAController.dart';
import 'package:siglo21/Controllers/MainController.dart';
import 'package:siglo21/Models/SesionModel.dart';
import 'package:stretchy_header/stretchy_header.dart';
import '../Constants/Constants.dart';
import '../Entities/Sesion.dart';
import '../Models/EventObject.dart';
import '../Utils/HexColor.dart';
import '../services/ApiService.dart';
import 'package:intl/intl.dart';
import 'BaseController.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends BaseController {

  @override
  _LoginController createState() => _LoginController();

}

class _LoginController extends BaseControllerState<LoginController>  {

  double heightHeader = 180;
  Sesion? sesion;
  int isDfa = 0;
  String error = SnackBarText.ERROR_DEFAULT;
  final _usuario = TextEditingController();
  final _password = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userRecoovery();
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(ColorTheme.backgroundColor),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: GestureDetector(
          onTap: () {FocusScope.of(context).requestFocus(new FocusNode());},
          child: StretchyHeader.singleChild(
            headerData: HeaderData(
              headerHeight: heightHeader,
              blurContent: false,
              backgroundColor: HexColor(ColorTheme.backgroundColor),
              overlay: Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  color: HexColor(ColorTheme.primaryColor),
                  child: Center(
                    child: Image.asset('assets/logo_white.png', scale: 4.0),
                  ),
              ),
              header: Container(
                width: double.infinity,
                color: HexColor(ColorTheme.primaryColor),
              ),
            ),
            child: _body(),
          ),
        )
      ),
    );
  }

  Widget _body(){
    return Container(
      //height:MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
      color: HexColor(ColorTheme.backgroundColor),
      constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - heightHeader,
          maxHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top
      ),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              transform: Matrix4.translationValues(0.0, -1.0, 0.0),
              color: HexColor(ColorTheme.primaryColor),
              child:  Container(
                  width: double.infinity,
                  height: 20,
                 // padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: HexColor(ColorTheme.backgroundColor),
                  )
              ),
            ),
           Container(
             transform: Matrix4.translationValues(0.0, -2.0, 0.0),
             color: HexColor(ColorTheme.backgroundColor),
             child:  Padding(padding: const EdgeInsets.all(17),
                 child: Column(
                     mainAxisSize: MainAxisSize.min,
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                         child: Text("Inicie sesión", textAlign: TextAlign.start,
                             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: HexColor(ColorTheme.buttoncolor))),),
                       Card(
                         elevation: 10,
                         shape: const RoundedRectangleBorder(
                             borderRadius: BorderRadius.all(Radius.circular(10))),
                         color: Colors.white,
                         child: Container(
                           width: double.infinity,
                           child: Padding(padding: const EdgeInsets.all(18),
                             child: Column(
                               mainAxisSize: MainAxisSize.max,
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [

                                 const Text("Usuario", textAlign: TextAlign.start,
                                     style: TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.bold,)),

                                 const SizedBox(height: 15),

                                 TextField(
                                   maxLines: 1,
                                   keyboardType: TextInputType.emailAddress,
                                   cursorColor: HexColor(ColorTheme.thirdColor),
                                   controller: _usuario,
                                   style: const TextStyle(color: Colors.black, fontFamily: Texts.FONT_FAMILY, fontSize: 15),
                                   decoration: InputDecoration(
                                     fillColor: HexColor("#F8F8FA"),
                                     filled: true,
                                     suffixIcon: GestureDetector(
                                       onTap: () {
                                         //_togglevisibility();
                                       },
                                       child: const Icon(
                                         Icons.email_outlined , color: Colors.black54,),
                                     ),
                                     floatingLabelBehavior: FloatingLabelBehavior.never,
                                     isDense: true,
                                     contentPadding: const EdgeInsets.all(16),
                                     hintText: "usuario@siglo21.com",
                                     focusedBorder: OutlineInputBorder(
                                       borderSide: BorderSide(color: HexColor("DDDDDD"),  width: 1.5),
                                       borderRadius: BorderRadius.circular(10.0),
                                     ),
                                     enabledBorder: OutlineInputBorder(
                                       borderSide: BorderSide(color: HexColor("DDDDDD"),  width: 1.5),
                                       borderRadius: BorderRadius.circular(10.0),
                                     ),
                                   ),
                                 ),


                                 const SizedBox(height: 15),

                                 const Text("Contraseña", textAlign: TextAlign.start,
                                     style: TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.bold,)),

                                 const SizedBox(height: 15),

                                 TextField(
                                   maxLines: 1,
                                   keyboardType: TextInputType.text,
                                   cursorColor: HexColor(ColorTheme.thirdColor),
                                   controller: _password,
                                   obscureText: !_showPassword,
                                   style: const TextStyle(color: Colors.black, fontFamily: Texts.FONT_FAMILY, fontSize: 15),
                                   decoration: InputDecoration(
                                     fillColor: HexColor("#F8F8FA"),
                                     filled: true,
                                     suffixIcon: GestureDetector(
                                       onTap: () {
                                         _togglevisibility();
                                       },
                                       child: Icon(
                                         _showPassword ? Icons.visibility : Icons
                                             .visibility_off, color: Colors.black54,),
                                     ),
                                     floatingLabelBehavior: FloatingLabelBehavior.never,
                                     isDense: true,
                                     contentPadding: const EdgeInsets.all(16),
                                     hintText: "**********",
                                     focusedBorder: OutlineInputBorder(
                                       borderSide: BorderSide(color: HexColor("DDDDDD"),  width: 1.5),
                                       borderRadius: BorderRadius.circular(10.0),
                                     ),
                                     enabledBorder: OutlineInputBorder(
                                       borderSide: BorderSide(color: HexColor("DDDDDD"),  width: 1.5),
                                       borderRadius: BorderRadius.circular(10.0),
                                     ),
                                   ),
                                 ),

                                 const SizedBox(height: 20),

                                 Container(
                                   width: double.infinity,
                                   child:  Text("¿Olvidaste tu contraseña?", textAlign: TextAlign.end,
                                       style: TextStyle(fontSize: 13, color: HexColor(ColorTheme.secundaryColor), fontWeight: FontWeight.bold,)),

                                 ),
                                 const SizedBox(height: 25),

                                GestureDetector(
                                  onTap: () {
                                    /*Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) {
                                          return MainController(isLogin: true);
                                        }));*/


                                    if (_usuario.text.length > 0 &&
                                        _password.text.length > 0) {
                                      FocusScope.of(context).requestFocus(new FocusNode());
                                      if (!RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(_usuario.text)) {
                                        showNewAlert(
                                            "Ingrese una dirección de correo válido por favor.");
                                        return;
                                      }
                                      loadData(context);
                                      return;
                                    } else {
                                      //showAlert("Ingrese usuario y contraseña válida antes de contiuar");
                                      showNewConfirm(
                                          "Ingrese usuario y contraseña válida antes de contiuar");
                                    }


                                  },
                                  child:  Container(
                                    width: double.infinity,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color:  HexColor(ColorTheme.secundaryColor),
                                        borderRadius: const BorderRadius.all(Radius.circular(10.0))
                                    ),

                                    child: const Center(
                                      child: Text(
                                        "Ingresar",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),

                                  ),
                                )


                               ],
                             ),
                           ),
                         ),
                       ),

                       const SizedBox(height: 20),

                       /*const Center(
                         child: Text("www.siglo21.net", textAlign: TextAlign.start,
                             style: TextStyle(fontSize: 15, color: Colors.black87,)),
                       ),*/




                     ]
                 )),
           ),
          ]),
    );
  }

  bool _showPassword = false;
  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }


  Future<void> loadData(BuildContext context) async {

    sesion = null;
    showLoading();
    try {
      final body = {
        "email": "${_usuario.text.toString()}",
        "password": "${_password.text.toString()}",
      };

      print(body.toString());
      error = SnackBarText.ERROR_DEFAULT;
      EventObject _resp = await login(body);
      switch (_resp.id) {
        case HttpStatus.SC_OK:
          {
            SesionModel? model = _resp.object as SesionModel?;
            if (model != null) {
              if (model.sms != null) {
                if (model.sms == true) {
                  if (model.local != null){

                    await database.then((onValu) async {
                      onValu.sesionDao.cleanSesion();
                      App.LISTA_PRECIO = model.lista_precio ?? 0;


                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setInt('dfa', model.dfa!);
                      isDfa = model.dfa!;



                      sesion = Sesion(sms: model.sms, mensaje: model.mensaje, local: model.local, correo: _usuario.text,codigo_c: model.codigo_c, codigo_v: model.codigo_v, lista_precio: model.lista_precio);
                      onValu.sesionDao.insertSesion(sesion!);
                    });


                  }else {
                    setState(() {
                      if (model.mensaje != null) {
                        error = model.mensaje!;
                      }
                      //showAlert(error);
                    });
                  }
                } else {
                  setState(() {
                    if (model.mensaje != null) {
                      error = model.mensaje!;
                    }
                    //showAlert(error);
                  });
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
          setState(() {
            // showAlert(error);
          });
          break;
      }
      setState(() {
        dissmisLoading();
        showData();
      });
    } on Exception {
      setState(() {
        dissmisLoading();
        showData();
      });
    }

  }

  Future<void> showData () async {
    if (sesion != null){


      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String date = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
      await prefs.setString('fechaHora', date);
      await prefs.setString('usuarioLogin', _usuario.text);
      await prefs.setString('passwordLogin', _password.text);


      if (isDfa == 1){
        Navigator.push(context, MaterialPageRoute(builder: (context) => DFAController()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainController(isLogin: true,)));
      }


    }else{
      //showAlert(error);
      showNewConfirm("${error}");
    }
  }


  Future<void> userRecoovery () async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String usuarioLogin = prefs.getString('usuarioLogin') ?? "";
    if (usuarioLogin.length > 0){
      setState(() {
        _usuario.text = usuarioLogin;
      });

    }


    String passwordLogin = prefs.getString('passwordLogin') ?? "";
    if (passwordLogin.length > 0){
      setState(() {
        _password.text = passwordLogin;
      });

    }
  }


}
