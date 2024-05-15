import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Constants/Constants.dart';
import '../Entities/Sesion.dart';
import '../Models/EventObject.dart';
import '../Models/UpdateDFAModel.dart';
import '../Utils/HexColor.dart';
import '../services/ApiService.dart';
import 'BaseController.dart';
import 'dart:convert' show json;
import 'package:shared_preferences/shared_preferences.dart';

  class EditarDatosController extends BaseController {


    final Function() goHome;
    EditarDatosController({required this.goHome}) : super();



    @override
  _EditarDatosController createState() => _EditarDatosController();

}

class _EditarDatosController extends BaseControllerState<EditarDatosController> with AutomaticKeepAliveClientMixin , WidgetsBindingObserver {

  @override
  bool get wantKeepAlive => true;
  bool isChecked = false;

  final _nombre = TextEditingController();
  final _apellido = TextEditingController(text: "..");
  final _cedula = TextEditingController();
  final _correo = TextEditingController();
  final _password = TextEditingController();
  final _telefono = TextEditingController(text: "999999999");
  Sesion? sesion;

  String error = SnackBarText.ERROR_DEFAULT;
  bool isError = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    WidgetsBinding.instance!.addPostFrameCallback((_) => getUser()
    );

  }

  Future<void> getDFA() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int dfa = prefs.getInt('dfa') ?? 0;

      setState(() {
        isChecked = dfa == 1 ? true : false;
      });

  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  getUser(){

    getDFA();
    setState(() {
      _nombre.text = "Richard"; //widget.user.nombre!;
      _apellido.text = "Asencio"; //widget.user.apellido!;
      _cedula.text = "0930536115"; // widget.user.cedula!;
      _correo.text = "richard.asenciov@gmail.com"; //widget.user.correo!;
      _password.text = "123456"; //widget.user.clave!;
      _telefono.text = "0986786400"; //widget.user.telefono!;

      database.then((onValu){

        final result =  onValu.sesionDao.getSesion();
        if (result != null){
          result.then((data) async {
            if (data != null){
              if (data.length > 0){
                setState(() {
                  sesion =  data.cast<Sesion>()[0];
                  _correo.text = sesion!.correo!;
                });
              }
            }


          }, onError: (e) {
            print("Error: "+e.toString());
          });
        }


      });

    });
  }


  Future<void> _logOut() async {
    setState(() {});
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

                //SizedBox(height: 10),
              /*  Container(
                  margin: EdgeInsets.only(left: 19),
                  child: Text("Nombres", style: TextStyle(fontSize: 18, color: Colors.black)),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _nombre,
                  textCapitalization: TextCapitalization.words,
                  maxLines: 1,
                  keyboardType: TextInputType.text,

                  cursorColor: HexColor(ColorTheme.thirdColor),
                  style: TextStyle(color: Colors.black, fontFamily: Texts.FONT_FAMILY),
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    isDense: true,
                    contentPadding: EdgeInsets.all(16),
                    hintText: "Nombres de usuario",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor(ColorTheme.thirdColor), width: 1.5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor(ColorTheme.thirdColor),  width: 1.5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),



                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.only(left: 19),
                        child: Text("Apellidos", style: TextStyle(fontSize: 18, color: Colors.black)),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _apellido,
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        cursorColor: HexColor(ColorTheme.thirdColor),
                        style: TextStyle(color: Colors.black, fontFamily: Texts.FONT_FAMILY),
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          isDense: true,
                          contentPadding: EdgeInsets.all(16),
                          hintText: "Apellidos de usuario",
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: HexColor(ColorTheme.thirdColor), width: 1.5),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: HexColor(ColorTheme.thirdColor),  width: 1.5),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      )
                    ]),

                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.only(left: 19),
                  child: Text("Cédula", style: TextStyle(fontSize: 18, color: Colors.black)),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _cedula,
                  maxLines: 1,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(13),
                  ],
                  keyboardType: TextInputType.number,
                  maxLength: 13,
                  maxLengthEnforcement: MaxLengthEnforcement.none,
                  cursorColor: HexColor(ColorTheme.thirdColor),
                  style: TextStyle(color: Colors.black, fontFamily: Texts.FONT_FAMILY),
                  decoration: InputDecoration(
                    counterText: "",
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    isDense: true,
                    contentPadding: EdgeInsets.all(16),
                    hintText: "0000000000",
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


                Column(
                    crossAxisAlignment: CrossAxisAlignment.start
                    ,
                    children: [
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.only(left: 19),
                        child: Text("Teléfono", style: TextStyle(fontSize: 18, color: Colors.black)),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _telefono,
                        maxLines: 1,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(13),
                        ],
                        keyboardType: TextInputType.number,
                        cursorColor: HexColor(ColorTheme.thirdColor),
                        style: TextStyle(color: Colors.black, fontFamily: Texts.FONT_FAMILY),
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          isDense: true,
                          contentPadding: EdgeInsets.all(16),
                          hintText: "0000000000",
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: HexColor(ColorTheme.thirdColor),  width: 1.5),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: HexColor(ColorTheme.thirdColor),  width: 1.5),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      )
                    ]
                ) ,


                SizedBox(height: 10),*/
                Container(
                  margin: EdgeInsets.only(left: 19),
                  child: Text("Correo electrónico", style: TextStyle(fontSize: 18, color: Colors.black)),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _correo,
                  maxLines: 1,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: HexColor(ColorTheme.thirdColor),
                  style: TextStyle(color: Colors.black, fontFamily: Texts.FONT_FAMILY),
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    isDense: true,
                    contentPadding: EdgeInsets.all(16),
                    hintText: "email@dipaso.com",
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



                SizedBox(height: 10),
                /*Container(
                  margin: EdgeInsets.only(left: 19),
                  child: Text("Contraseña", style: TextStyle(fontSize: 18, color: Colors.black)),
                ),
                SizedBox(height: 8),
                TextField(
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  cursorColor: HexColor(ColorTheme.thirdColor),
                  controller: _password,
                  obscureText: !_showPassword,
                  style: TextStyle(color: Colors.black, fontFamily: Texts.FONT_FAMILY),
                  decoration: InputDecoration(
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
                    contentPadding: EdgeInsets.all(16),
                    hintText: "**********",
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

                SizedBox(height: 20),
                SafeArea(
                  child: Center(
                    child: Container(
                      width: 280,
                      child: Column(children: [


                        GestureDetector(
                            onTap: (){

                              if (_nombre.text.length > 0 && _password.text.length > 0 && _cedula.text.length > 0 && _correo.text.length > 0 && _apellido.text.length > 0 && _telefono.text.length > 0){
                                FocusScope.of(context).requestFocus(new FocusNode());

                                if (_cedula.text.length < 10){
                                  showNewAlert("Ingrese un número de cédula válido por favor.");
                                  return;
                                }else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_correo.text)){
                                  showNewAlert("Ingrese una dirección de correo válido por favor.");
                                  return;
                                }else if (_password.text.length < 4) {
                                  showNewAlert("Ingrese una contraseña válido por favor.");
                                  return;
                                }

                                //loadData(context);
                                return;
                              }else{
                                showNewConfirm("Complete los campos antes de contiuar");
                              }

                            },
                            child: Container(
                              width: double.infinity,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: HexColor(ColorTheme.buttoncolor),
                                  borderRadius: BorderRadius.all(Radius.circular(15.0))
                              ),
                              child: const Center(
                                child: Text(
                                  "Actualizar",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            )
                        ),

                      ]),

                    ),
                  ),
                ),*/

                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: const Text("Doble factor de autenticación", style: TextStyle(fontSize: 16, color: Colors.black)),
                    ),
                    Checkbox(
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          isChecked = value!;
                          loadData(context);
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SafeArea(
                  child: Center(
                    child: Container(
                      width: 280,
                      child: Column(children: [


                        GestureDetector(
                            onTap: (){

                              showNewAlert("¿Está seguro que desea cerrar sesión?", () {
                                Future.delayed(Duration(milliseconds: 100), () {
                                 database.then((onValu){

                                   onValu.cuponesDao.cleanCupones();
                                   onValu.seriesDao.cleanSeries();
                                   onValu.productosDao.cleanProductos();
                                   onValu.facturasDao.cleanFacturas();
                                   onValu.detalleFacturasDao.cleanDetalleFacturas();
                                   onValu.premiosDao.cleanPremios();
                                   onValu.sesionDao.cleanSesion().then((value) {
                                      Navigator.pop(context);
                                        widget.goHome();
                                    }

                                    );

                                  });
                                });
                              }, "SÌ", "NO");
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
                                  "Cerrar sesión",
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

  bool _showPassword = false;
  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  Future<void> loadData(BuildContext context) async {

    showLoading();
    try {
      final body = {
        "identificacion": "${sesion!.codigo_v}",
        "valor": isChecked,
      };

     // print(body.toString());
      error = SnackBarText.ERROR_DEFAULT;
      EventObject _resp = await updateDfa(body);
      switch (_resp.id) {
        case HttpStatus.SC_OK:
          {
            UpdateDFAModel? model = _resp.object as UpdateDFAModel?;
            if (model != null) {
              if (model.sms != null) {
                if (model.sms == true) {
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setInt('dfa', isChecked ? 1 : 0);

                  if (model.mensaje != null){
                      error = model.mensaje!;
                  }
                }else{
                  if (model.mensaje != null){
                    error = model.mensaje!;
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

  String prettyPrint(Map json) {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String pretty = encoder.convert(json);
    return pretty;
  }


}

