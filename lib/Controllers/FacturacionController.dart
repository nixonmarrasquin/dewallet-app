import 'dart:convert';
import 'dart:io';
import 'package:image_viewer/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:siglo21/Dao/ProductosDao.dart';
import 'package:siglo21/Models/SeriesModel.dart';
import '../Constants/Constants.dart';
import '../Entities/Productos.dart';
import '../Entities/Series.dart';
import '../Entities/Sesion.dart';
import '../Models/EventObject.dart';
import '../Models/InsertarCabeModel.dart';
import '../Models/ListaModel.dart';
import '../Models/ProductosModel.dart';
import '../Utils/HexColor.dart';
import 'package:path_provider/path_provider.dart';
import '../services/ApiService.dart';
import 'package:camera/camera.dart';
import 'BaseController.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class FacturacionController extends BaseController {

  @override
  _FacturacionController createState() => _FacturacionController();

}

class _FacturacionController extends BaseControllerState<FacturacionController> with WidgetsBindingObserver{




  late List<CameraDescription> _cameras;
  late CameraController controller;
  Sesion? sesion;
  List<File> _images = [];
  List<Series> series = [];
  List<ListaModel> lista = [];
  List<Productos> productos = [];
  Productos? producto = null;
  String error = SnackBarText.ERROR_DEFAULT;
  final _buscar = TextEditingController();
  final _digite = TextEditingController();
  String subtotal = "0.00";
  String iva = "0.00";
  String total = "0.00";
  String recaudado = "0.00";
  InsertarCabeModel? inserResult;
  final ImagePicker _picker = ImagePicker();
  var isFlag = false;
  var dataCode = "";

  @override
  void initState() {
    super.initState();
    isFlag = false;
    WidgetsBinding.instance!.addObserver(this);
    WidgetsBinding.instance!.addPostFrameCallback((_) => getUser()
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
    if (controller != null){
      controller.dispose();
    }
  }

  getUser(){
    database.then((onValu){

      if (Texts.listaGlobal != null){
        for (var it in Texts.listaGlobal){
          lista.add(it);
        }
        setState(() {
          var sub = 0.0;
          var iv = 0.0;
          var to = 0.0;
          var rec = 0.0;

          for (var i = 0; i < lista.length; i++) {
            var lis = lista[i];
            sub =  sub + double.parse(lis.valor!);
            rec =  rec + double.parse(lis.producto!.valor!);

          }

          iv = sub * 0.12;
          to = sub + iv;
          subtotal = ""+sub.toStringAsFixed(2);
          iva = ""+iv.toStringAsFixed(2);
          total = ""+to.toStringAsFixed(2);
          recaudado = ""+rec.toStringAsFixed(2);
        });
      }

      onValu.detalleFacturasDao.cleanDetalleFacturas();
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor(ColorTheme.backgroundColor),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark,
            child: GestureDetector(
              onTap: () {FocusScope.of(context).requestFocus(new FocusNode());},
              child:  Column(
                children: [
                  Container(
                    transform: Matrix4.translationValues(0.0, -1.0, 0.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            offset: Offset(0.0, 8.5),
                          )
                        ],
                        color: HexColor(ColorTheme.primaryColor)
                    ),
                    padding: const EdgeInsets.all(15),
                    child:   Text("Ingresar Serie", textAlign: TextAlign.center, style: TextStyle(color: HexColor(ColorTheme.buttoncolor), fontWeight: FontWeight.bold, fontSize: 20)),
                  ),

                  Expanded(child: SingleChildScrollView(
                    child: Padding(
                      padding:  const EdgeInsets.all(15),
                      child:  Column(
                        children: [

                          //ojo
                          Container(
                            margin: EdgeInsets.only(bottom: _images != null ? _images.length > 0 ? 10 : 0 : 0),
                              height: _images != null ? _images.length > 0 ? 70 : 0 : 0,
                              child:  ListView(
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  for (var x = 0; x < _images.length; x++)
                                      itemFoto(_images[x],x)
                                ],
                              )
                          ),

                          Row(
                            children: [
                              Expanded(child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text("Formulario", textAlign: TextAlign.start, style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 17)),
                                  Text("Registro de serie", textAlign: TextAlign.start, style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 17)),
                                ],
                              )),

                              ClipOval(
                                child: Material(
                                  color: HexColor(ColorTheme.buttoncolor), // Button color
                                  child: InkWell(
                                    splashColor: Colors.red, // Splash color
                                    onTap: () async {
                                      //imageSelector(context, "camera");
                                      _settingModalBottomSheet(context);


                                    },
                                    child: const SizedBox(width: 45, height: 45, child: Icon(Icons.camera_alt,color: Colors.white,)),
                                  ),
                                ),
                              )


                            ],
                          ),


                          const SizedBox(height: 15),
                          TextField(
                            textCapitalization: TextCapitalization.words,
                            maxLines: 1,
                            controller: _digite,
                            keyboardType: TextInputType.text,
                            cursorColor: HexColor(ColorTheme.thirdColor),
                            style: const TextStyle(color: Colors.black, fontFamily: Texts.FONT_FAMILY),
                            decoration: InputDecoration(
                              fillColor: HexColor("#f1f1f1"),
                              filled: true,
                              prefixIcon: const Icon(Icons.list_alt),
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              isDense: true,
                              contentPadding: const EdgeInsets.all(16),
                              hintText: "Digite el # de serie",
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

                          const SizedBox(height: 20),
                         GestureDetector(
                           onTap: (){
                             
                             //addItem();

                             //Navigator.of(context).pop();
                             FocusScope.of(context).requestFocus(new FocusNode());
                             Future.delayed(const Duration(milliseconds: 150), () {
                               if (_digite.text.length > 0 ) {
                                 _buscar.text = _digite.text;
                                 loadData();
                                 return;
                               } else {
                                 showNewConfirm(
                                     "Ingrese una serie antes de continuar");
                               }
                             });


                           },
                           child:  Container(
                             width: double.infinity,
                             height: 40,
                             decoration: BoxDecoration(
                                 color: HexColor(ColorTheme.secundaryColor),
                                 borderRadius: const BorderRadius.all(Radius.circular(5.0))
                             ),
                             child: const Center(

                               child: Text(
                                 "Buscar serie",
                                 style: TextStyle(
                                   fontSize: 17,
                                   fontWeight: FontWeight.bold,
                                   color: Colors.white,
                                 ),
                               ),
                             ),
                           ),
                         ),
                          const SizedBox(height: 30),
                          Container(
                            width: double.infinity,
                            color: HexColor("505050"),
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: const [

                                Expanded(
                                  flex: 1,
                                  child:
                                    Text("COD.", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: 15)),
                                ),
                                Expanded(
                                  flex: 2,
                                  child:
                                Text("DESP.", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: 15)),
                                ),
                                Expanded(
                                  flex: 0,
                                  child:
                                Text("", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: 15)),
                                )


                              ],
                            ),
                          ),

                          lista.length > 0 ?

                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(10),
                                itemCount: lista.length,
                                itemBuilder: (context, index) {

                                  return InkWell(
                                    onTap: (){
                                      /*Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => DetalleHostprialController())).then((value) => (){
                                        //gerUser();
                                      });*/
                                    },
                                    child: celda(index),
                                  );
                                },
                              )

                              :

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey)
                            ),
                            child: const Text("NO TIENE ITEM AGREGADO.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 15)),
                          ),

                          const SizedBox(height: 10),
                          /*Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(2),
                            child: Row(
                              children:  [

                                Expanded(
                                  flex: 1,
                                  child:
                                  Text("", textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontSize: 15)),
                                ),
                                Expanded(
                                  flex: 1,
                                  child:
                                  Text("", textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontSize: 15)),
                                ),
                                Expanded(
                                  flex: 1,
                                  child:
                                  Text("Subtotal", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 17)),
                                ),
                                Expanded(
                                  flex: 1,
                                  child:
                                  Text("\$ "+subtotal, textAlign: TextAlign.end, style: TextStyle(color: Colors.black, fontSize: 15)),
                                )


                              ],
                            ),
                          ),*/

                          /*Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(2),
                            child: Row(
                              children:  [

                                Expanded(
                                  flex: 1,
                                  child:
                                  Text("", textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontSize: 15)),
                                ),
                                Expanded(
                                  flex: 1,
                                  child:
                                  Text("", textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontSize: 15)),
                                ),
                                Expanded(
                                  flex: 1,
                                  child:
                                  Text("Iva", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 17)),
                                ),
                                Expanded(
                                  flex: 1,
                                  child:
                                  Text("\$ "+iva, textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.normal,color: Colors.black, fontSize: 15)),
                                ),


                              ],
                            ),
                          ),*/

                          /*Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(2),
                            child: Row(
                              children: [

                                Expanded(
                                  flex: 1,
                                  child:
                                  Text("", textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontSize: 15)),
                                ),
                                Expanded(
                                  flex: 1,
                                  child:
                                  Text("", textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontSize: 15)),
                                ),
                                Expanded(
                                  flex: 1,
                                  child:
                                  Text("Total", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 17)),
                                ),
                                Expanded(
                                  flex: 1,
                                  child:
                                  Text("\$ "+total, textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: 15)),
                                )


                              ],
                            ),
                          ), */

                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            height: 40,
                            decoration: BoxDecoration(
                                color: HexColor("303030"),
                                borderRadius: const BorderRadius.all(Radius.circular(0.0))
                            ),
                            child: Center(

                              child: Text(
                                "Total ganado: \$ "+recaudado,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),
                          GestureDetector(
                            onTap: (){
                              /*if (_numFactura.text.length == 0){
                                showNewAlert("Ingrese un número de serie antes de continuar");
                                return;
                              }*/

                              if (!(_images.length > 0)){
                                showNewAlert("Ingrese una imagen antes de continuar");
                                return;
                              }
                              if (lista.length == 0){
                                showNewAlert("Ingrese un producto antes de continuar");
                                return;
                              }


                              loadDataInsertCabecera();
                            },
                            child:  Container(
                              width: 150,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: HexColor(ColorTheme.buttoncolor),
                                  borderRadius: const BorderRadius.all(Radius.circular(5.0))
                              ),
                              child: const Center(
                                child: Text(
                                  "Registrar",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),




                        ],
                      ),
                    )
                  ))
                ],
              )
            )
        ),

    );
  }


  Widget celda(int index){
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          color: index%2 == 0 ? Colors.white : Colors.black12
      ),
      child: Column(
          children: [
            Row(
              children:  [

                Expanded(
                  flex: 1,
                  child:
                  Text(lista[index].producto!.cod_producto!.substring(0,5), textAlign: TextAlign.start, style: TextStyle(color: Colors.black87, fontSize: 15)),
                ),
                Expanded(
                  flex: 2,
                  child:
                  Text(lista[index].producto!.nombre!, textAlign: TextAlign.start, style: const TextStyle(color: Colors.black87, fontSize: 15)),
                ),
                Expanded(
                  flex: 0,
                  child:
                  GestureDetector(
                    onTap: (){

                      showNewAlert("¿Estás seguro que deseas eliminarlo?", () {
                        Future.delayed(const Duration(milliseconds: 100), () {
                          //canjearPunto(cupones[index]);


                          setState(() {
                            lista.removeAt(index);
                            Texts.listaGlobal.removeAt(index);
                            var sub = 0.0;
                            var iv = 0.0;
                            var to = 0.0;
                            var rec = 0.0;

                            for (var i = 0; i < lista.length; i++) {
                              var lis = lista[i];
                              sub =  sub + double.parse(lis.valor!);
                              rec =  rec + double.parse(lis.producto!.valor!);

                            }

                            iv = sub * 0.12;
                            to = sub + iv;
                            subtotal = ""+sub.toStringAsFixed(2);
                            iva = ""+iv.toStringAsFixed(2);
                            total = ""+to.toStringAsFixed(2);
                            recaudado = ""+rec.toStringAsFixed(2);
                          });



                        });
                      }, "SÌ", "NO");


                    },
                    child: const Icon(Icons.delete),
                  )
                )



              ],
            )
          ]),
    );
  }

  void addItem() {
    final alertDialog = Dialog(
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10.0) ),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0))
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints( minHeight: 200.0, maxHeight: MediaQuery.of(context).size.height - 190),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text("SERIE DE ITEM", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: HexColor(ColorTheme.buttoncolor)),),
                  const SizedBox(height: 5),
                  Flexible(child:
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        TextField(
                          controller: _buscar,
                          enabled: false,
                          textInputAction: TextInputAction.search,
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          cursorColor: HexColor(ColorTheme.thirdColor),
                          style: const TextStyle(color: Colors.black, fontFamily: Texts.FONT_FAMILY),
                          decoration: InputDecoration(
                            fillColor: HexColor("#f1f1f1"),
                            filled: true,
                            prefixIcon: const Icon(Icons.list_alt),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            isDense: true,
                            contentPadding: const EdgeInsets.all(16),
                            hintText: "Ingrese...",
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

                        const SizedBox(height: 20),
                        Text(series.length > 0 ? "SERIE(S)" : "", textAlign: TextAlign.left, style: TextStyle(fontSize: 16, color: HexColor(ColorTheme.buttoncolor)),),
                        const SizedBox(height: 5),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(0),
                          itemCount: series.length > 0 ? series!.length : 0,
                          itemBuilder: (context, index) {

                            return InkWell(
                              onTap: (){
                                /*Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => DetalleHostprialController())).then((value) => (){
                                        //gerUser();
                                      });*/
                              },
                              child: celdaaItem(index),
                            );
                          },
                        ),

                        const SizedBox(height: 20),
                      /*GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                          FocusScope.of(context).requestFocus(new FocusNode());
                          Future.delayed(const Duration(milliseconds: 150), () {
                            if (_buscar.text.length > 0 ) {
                              loadData();
                              return;
                            } else {
                              showNewConfirm(
                                  "Ingrese una serie antes de continuar");
                            }
                          });
                        },
                        child:   Center(
                          child:  Container(
                            width: 150,
                            height: 40,
                            decoration: BoxDecoration(
                                color: HexColor(ColorTheme.buttoncolor),
                                borderRadius: const BorderRadius.all(Radius.circular(5.0))
                            ),
                            child: const Center(
                              child: Text(
                                "Buscar",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                        const SizedBox(height: 5),*/

                      ],
                    )
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
    );
    showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => alertDialog);

  }


  Widget celdaaItem(int index){
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          color: index%2 == 0 ? Colors.white : Colors.black12
      ),
      child: Column(
          children: [
            Row(
              children:  [

                 Expanded(
                  flex: 1,
                  child:
                  Text(series[index].CodigoItem!.substring(0,4), overflow: TextOverflow.ellipsis, textAlign: TextAlign.start, style: TextStyle(color: Colors.black87, fontSize: 15)),
                ),
                Expanded(
                  flex: 2,
                  child:
                  Text(series[index].NombreItem!,  overflow: TextOverflow.ellipsis, textAlign: TextAlign.start, style: const TextStyle(color: Colors.black87, fontSize: 15)),
                ),
                Expanded(
                    flex: 0,
                    child:
                    GestureDetector(
                      onTap: (){

                        Future.delayed(const Duration(milliseconds: 250), () {
                          //loadDataProducto(series[index]!, texto.text);
                          loadDataProducto(series[index]!);
                        });

                      /*showEdit("",(){

                        if (texto.text.length > 0) {
                          Future.delayed(const Duration(milliseconds: 250), () {
                              loadDataProducto(series[index]!, texto.text);
                          });

                          return;
                        }else{
                          Fluttertoast.showToast(
                              msg: "Ingrese un valor para continuar",  // message
                              toastLength: Toast.LENGTH_SHORT, // length
                              gravity: ToastGravity.CENTER,    // location
                              timeInSecForIosWeb: 1               // duration
                          );
                        }


                      });*/


                      },
                      child: const Icon(Icons.save),
                    )
                ),



              ],
            )
          ]),
    );
  }

  Future<void> loadData() async {

    setState(() {
      series = [];
    });


    showLoading();
    try {
      final body = {
        "serieProducto": "${_buscar.text.toString()}",
        "codigoCliente": sesion != null ? "${sesion!.codigo_c}" : ""
      };

      print(body.toString());
      error = SnackBarText.ERROR_DEFAULT;
      EventObject _resp = await getSeries(body);
      switch (_resp.id) {
        case HttpStatus.SC_OK:
          {
            SeriesModel? model = _resp.object as SeriesModel?;
            if (model != null) {
              if (model.code != null) {
                if (model.code == 200) {

                  if (model.data != null){

                    await database.then((onValu){
                      if (model.data!.length > 0) {
                        onValu.seriesDao.cleanSeries();
                        series =  model.data!;
                        onValu.seriesDao.insertAllSeries(series);
                      }

                    });

                  }else {
                    setState(() {
                      /*if (model.mensaje != null) {
                        if (model.mensaje!.length > 0) {
                          error = model.mensaje!;
                        }
                      }*/
                      //showAlert(error);
                    });
                  }
                } else {
                  setState(() {
                    /*if (model.mensaje != null) {
                      if (model.mensaje!.length > 0) {
                        error = model.mensaje!;
                      }
                    }*/
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

    setState(() {
      series = [];
    });

    print(_buscar.text.toString());
    database.then((onValu){
      final result =  onValu.seriesDao.getSeriesByID(_buscar.text.toString().toUpperCase());
      if (result != null){
        result.then((data) {
          if (data != null){
            if (data.length > 0){
              setState(() {
                series = data.cast<Series>();
                addItem();
                return;
              });
            }else{showNewConfirm("No se encontro resultados",(){
              Future.delayed(const Duration(milliseconds: 150), () {
                //addItem();
              });
            });}
          }else{showNewConfirm("No se encontro resultados",(){
            Future.delayed(const Duration(milliseconds: 150), () {
              //addItem();
            });
          });}



        }, onError: (e) {
          print("Error: "+e.toString());
        });
      }

    });

  }



















  //Future<void> loadDataProducto(Series serie, String valor) async {
  Future<void> loadDataProducto(Series serie) async {

    setState(() {
      producto = null;
    });


    showLoading();
    try {
      final body = {
        "cod_producto": "${serie.CodigoItem!.toString()}",
        "cod_cliente":  sesion != null ? "${sesion!.codigo_c}" : "",
      };

      print(body.toString());
      error = SnackBarText.ERROR_DEFAULT;
      EventObject _resp = await getProductos(body);
      switch (_resp.id) {
        case HttpStatus.SC_OK:
          {
            ProductosModel? model = _resp.object as ProductosModel?;
            if (model != null) {
              if (model.sms != null) {
                if (model.sms == true) {

                  if (model.data != null){

                    producto = model.data!;
                    _digite.text = "";

                  }else {
                    setState(() {
                      /*if (model.mensaje != null) {
                        if (model.mensaje!.length > 0) {
                          error = model.mensaje!;
                        }
                      }*/
                      //showAlert(error);
                    });
                  }
                } else {
                  setState(() {
                    /*if (model.mensaje != null) {
                      if (model.mensaje!.length > 0) {
                        error = model.mensaje!;
                      }
                    }*/
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
        //showDataProducto(serie, valor);
        showDataProducto(serie);
      });
    } on Exception {
      setState(() {
        dissmisLoading();
        //showDataProducto(serie, valor);
        showDataProducto(serie);
      });
    }

  }

  //Future<void> showDataProducto (Series serie, String valor) async {
  Future<void> showDataProducto (Series serie) async {

    if (producto != null){
      productos.add(producto!);
      _buscar.text = "";
      series = [];

      var item = ListaModel(serie: serie, producto: producto, valor: '0');
      setState(() {
        lista.add(item);
        Texts.listaGlobal.add(item);

        var sub = 0.0;
        var iv = 0.0;
        var to = 0.0;
        var rec = 0.0;

        for (var i = 0; i < lista.length; i++) {
          var lis = lista[i];
          sub =  sub + double.parse(lis.valor!);
          rec =  rec + double.parse(lis.producto!.valor!);

        }

        iv = sub * 0.12;
        to = sub + iv;
        subtotal = ""+sub.toStringAsFixed(2);
        iva = ""+iv.toStringAsFixed(2);
        total = ""+to.toStringAsFixed(2);
        recaudado = ""+rec.toStringAsFixed(2);



      });

    }else{
      Fluttertoast.showToast(
          msg: "Lo sentimos intente otra vez",  // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.CENTER,    // location
          timeInSecForIosWeb: 1               // duration
      );
    }

    Future.delayed(const Duration(milliseconds: 250), () {
      Navigator.of(context).pop();
    });
  }

























  Future<void> loadDataInsertCabecera() async {

    dataCode = "";

    inserResult = null;
    showLoading();
    DateTime now = DateTime.now();
    var nowDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(now);
    var mill = DateTime.now().millisecondsSinceEpoch;
    try {
      final body = {
        "numOrden": "${mill}",
        "codCliente": sesion != null ? "${sesion!.codigo_c}" : "",
        "codVendedor": sesion != null ? "${sesion!.codigo_v}" : "",
        "mail": sesion != null ? "${sesion!.correo}" : "",
        //"numFactura": "${_numFactura.text.toString()}",
        "numFactura": "",
        //"subTotalFactura": "${subtotal}",
        //"totalFactura": "${total}",
        "valorPremioTotal": "${recaudado}",
        "created_at": "${nowDate}",
        "user_updated": sesion != null ? "${sesion!.codigo_v}" : "",
        "mail_updated": sesion != null ? "${sesion!.correo}" : ""
      };

      print(json.encode(body!));
      error = SnackBarText.ERROR_DEFAULT;
      EventObject _resp = await insertCabeceraSerie(body);
      switch (_resp.id) {
        case HttpStatus.SC_OK:
          {
            InsertarCabeModel? model = _resp.object as InsertarCabeModel?;
            if (model != null) {
              if (model.code != null) {
                if (model.code == 200) {

                  if (model.data != null){
                    inserResult = model;
                    if (inserResult!.data != null){
                      dataCode = inserResult!.data!;
                    }

                  }else {
                    setState(() {
                      /*if (model.mensaje != null) {
                        if (model.mensaje!.length > 0) {
                          error = model.mensaje!;
                        }
                      }*/
                      //showAlert(error);
                    });
                  }
                } else {
                  setState(() {
                    /*if (model.mensaje != null) {
                      if (model.mensaje!.length > 0) {
                        error = model.mensaje!;
                      }
                    }*/
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
        showDataFactura("${mill}","${nowDate}");
      });
    } on Exception {
      setState(() {
        dissmisLoading();
        showDataFactura("${mill}","${nowDate}");
      });
    }

  }

  Future<void> showDataFactura (String numOrden, String createAt) async {

      if (inserResult != null){
      if(inserResult!.code != null){
        if (inserResult!.code == 200){
          Future.delayed(const Duration(milliseconds: 250), () {
            loadDataInsertDetalle(numOrden, createAt);
          });

          return;
        }
      }
    }
      Future.delayed(const Duration(milliseconds: 500), () {
            showNewAlert("Lo sentimos intente mas tarde");
      });

  }










  Future<void> loadDataInsertDetalle(String numOrden, String createAt) async {

    List<Map<String, String>> detalles = [];
    showLoading();
    inserResult = null;
    try {

      for (var item in lista){

        var val =  double.parse(item!.valor!) * 0.12;

        var detail = {
          "numOrden": "${numOrden}",
        "codCliente": sesion != null ? "${sesion!.codigo_c}" : "",
          "codVendedor": sesion != null ? "${sesion!.codigo_v}" : "",
          "itemCodigo": item.producto != null ? "${item.producto!.cod_producto}" : "",
          "descripcion": item.producto != null ? "${item.producto!.nombre}" : "",
          "serie": item.serie != null ? "${item.serie!.Serie}" : "",
         // "numFactura": "${numFactura}",
          //"precioUnitario": "${item.valor}",
          //"iva": "${val.toStringAsFixed(2)}",
          "valorPremio": item.producto != null ? "${item.producto!.valor}" : "",
          "created_at": "${createAt}",
          "user_updated": sesion != null ? "${sesion!.codigo_v}" : "",
          "mail_updated": sesion != null ? "${sesion!.correo}" : ""
        };

        detalles.add(detail);

      }




      print(MapToJson(detalles));
      error = SnackBarText.ERROR_DEFAULT;
      EventObject _resp = await insertDetalleSerie(detalles);
      switch (_resp.id) {
        case HttpStatus.SC_OK:
          {
            InsertarCabeModel? model = _resp.object as InsertarCabeModel?;
            if (model != null) {
              if (model.code != null) {
                if (model.code == 200) {

                  if (model.data != null){
                    inserResult = model;
                  }else {
                    setState(() {
                      /*if (model.mensaje != null) {
                        if (model.mensaje!.length > 0) {
                          error = model.mensaje!;
                        }
                      }*/
                      //showAlert(error);
                    });
                  }
                } else {
                  setState(() {
                    /*if (model.mensaje != null) {
                      if (model.mensaje!.length > 0) {
                        error = model.mensaje!;
                      }
                    }*/
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
        showDataDetalleFactura();
      });
    } on Exception {
      setState(() {
        dissmisLoading();
        showDataDetalleFactura();
      });
    }

  }

  Future<void> showDataDetalleFactura () async {

    if (inserResult != null){
      if(inserResult!.code != null){
        if (inserResult!.code == 200){
          Future.delayed(const Duration(milliseconds: 250), () async {

            if (dataCode.length > 0){


              var contador = 0;
              for(var img in _images) {
                await Upload(img, contador);
                contador++;
              }

            }else{
              showNewConfirm("Series registrada con éxito",(){
                setState(() {

                  lista = [];
                  Texts.listaGlobal = [];
                  productos = [];
                  producto = null;
                  _digite.text = "";
                  _buscar.text = "";
                  subtotal = "0.00";
                  iva = "0.00";
                  total = "0.00";
                  recaudado = "0.00";


                });
              });
            }



          });

          return;
        }
      }
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      showNewAlert("Lo sentimos intente mas tarde");
    });

  }


  String MapToJson(List<Map<String, dynamic>> map) {
    String res = "[";

    for (var s in map) {
      res += "{";

      for (String k in s.keys) {
        res += '"';
        res += k;
        res += '":"';
        res += s[k].toString();
        res += '",';
      }
      res = res.substring(0, res.length - 1);

      res += "},";
      res = res.substring(0, res.length - 1);
    }

    res += "]";

    return res;
  }

  //ojo
  Widget itemFoto(File image, int index){
    return Container(
      margin: const EdgeInsets.only(right: 15),
      width: 70,
      height: 70,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () async {

              //var img = await  _getLocalFile(image.path);
              //print(img.path);
              /*ImageViewer.showImageSlider(
                images: [
                  image.path
                ],
                startingPosition: index,
              )*/


            },
            child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black54,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image:  FileImage(image)
                    )
                ),
                margin: EdgeInsets.only(top: 7),
                height: 60,
                width: 60.0
            ),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                _images.removeAt(index);
              });
            },
            child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey),
                  child: Icon(Icons.close,color: Colors.white,size: 22,),
                )
            ),
          )
        ],
      ),
    );
  }

  Future<File> _getLocalFile(String filename) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    return file;
  }

  //********************** IMAGE PICKER
  Future imageSelector(BuildContext context, String pickerType) async {

    File? _image;
    final ImagePicker _picker = ImagePicker();
    switch (pickerType) {
      case "gallery":

      /// GALLERY IMAGE PICKER
        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
         _image = File(image!.path);
        break;

      case "camera": // CAMERA CAPTURE CODE
        final XFile? image = await _picker.pickImage(source: ImageSource.camera);
        _image = File(image!.path);
        break;
    }

    if (_image != null) {
      print("You selected  image : " + _image!.path);
      setState(() {
        _images.add(_image!);
      });
      //Upload(_image!);
      setState(() {
        debugPrint("SELECTED IMAGE PICK   $_image");
      });
    } else {
      print("You have not taken image");
    }
  }

  // Image picker
  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    title: new Text('Galería'),
                    onTap: () => {
                      imageSelector(context, "gallery"),
                      Navigator.pop(context),
                    }),
                ListTile(
                  title: Text('Cámara'),
                  onTap: () => {
                    imageSelector(context, "camera"),
                    Navigator.pop(context)
                  },
                ),
              ],
            ),
          );
        });
  }


  Future<void> Upload(File imageFile, int index) async {

    showLoading();
    var request = http.MultipartRequest("POST", Uri.parse("http://3.139.221.163/api/imagen"));
    //add text fields
    request.fields["vendedor"] = sesion != null ? "${sesion!.codigo_v}" : "";
    request.fields["codigoIdentificador"] = dataCode != null ? "${dataCode}" : "";
    //create multipart using filepath, string or bytes
    var pic = await http.MultipartFile.fromPath("file", imageFile.path);
    request.files.add(pic);


    var response = await request.send();

    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);

    Map<String, dynamic> result = jsonDecode(responseString);
    if (result != null){
      if (result["sms"]){
        Future.delayed(const Duration(milliseconds: 250), () {
              //showNewAlert("Imagen guardada con éxito");
              //isFlag = true;
          if (index < (_images.length - 1)){
            return;
          }
          showNewConfirm("Series registrada con éxito",(){
            setState(() {

              _images = [];
              lista = [];
              Texts.listaGlobal = [];
              productos = [];
              producto = null;
              _digite.text = "";
              _buscar.text = "";
              subtotal = "0.00";
              iva = "0.00";
              total = "0.00";
              recaudado = "0.00";


            });
          });
        });
      }else{
        if (index < (_images.length - 1)){
          return;
        }
        Future.delayed(const Duration(milliseconds: 250), () {
          showNewAlert("Lo sentimos intente nuevamente");
        });

      }
    }
    dissmisLoading();
  }





}
