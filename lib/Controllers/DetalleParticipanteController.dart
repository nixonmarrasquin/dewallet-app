import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Constants/Constants.dart';
import '../Entities/Productos.dart';
import '../Entities/Series.dart';
import '../Entities/Sesion.dart';
import '../Models/EventObject.dart';
import '../Models/ListaModel.dart';
import '../Models/ParticipanteModel.dart';
import '../Models/ProductosModel.dart';
import '../Models/SeriesModel.dart';
import '../Utils/HexColor.dart';
import '../services/ApiService.dart';
import 'BaseController.dart';
import 'dart:convert' show json;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';

  class DetalleParticipanteController extends BaseController {


     final ParticipanteModel producto;
    DetalleParticipanteController({required this.producto}) : super();



    @override
  _DetalleParticipanteController createState() => _DetalleParticipanteController();

}

class _DetalleParticipanteController extends BaseControllerState<DetalleParticipanteController> with AutomaticKeepAliveClientMixin , WidgetsBindingObserver {

  @override
  bool get wantKeepAlive => true;
  var placeholder = "assets/placeholder.jpeg";


  Sesion? sesion;
  List<Series> series = [];
  List<Productos> productos = [];
  Productos? producto = null;
  String error = SnackBarText.ERROR_DEFAULT;
  final _buscar = TextEditingController();
  final _numFactura = TextEditingController();
  String subtotal = "0.00";
  String iva = "0.00";
  String total = "0.00";
  String recaudado = "0.00";


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


  Future<void> _logOut() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: HexColor("f5f5f5"),

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
            padding: EdgeInsets.only(bottom: 12),
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 0.0),
            decoration: new BoxDecoration(
                color: HexColor("C5C5C5"),
                borderRadius: new BorderRadius.all(Radius.circular(20),
                )
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: CachedNetworkImage(
                fit: BoxFit.fitHeight,
                placeholder: (context, url) => SizedBox(
                    height: 50,
                    width: 50,
                    child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                        )
                    )
                ),
                imageUrl: "${widget.producto.url_image  }",
                errorWidget: (context, url, error) => Image.asset(placeholder, width: 120, height: 120,),
              ),

            ),
            ),
                const SizedBox(height: 16),
                Text("Código", textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(widget.producto.cod_producto ?? "", textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal)),

                const SizedBox(height: 16),
                Text("Descripción", textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(widget.producto.descripcion ?? "", textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal)),

                const SizedBox(height: 16),
                Text("Valor", textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(widget.producto.valor_premio ?? "", textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal)),

                const SizedBox(height: 16),
                Text("Vigencia", textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(widget.producto.vigencia ?? "", textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal)),

                const SizedBox(height: 10),
                GestureDetector(
                  onTap: (){

                   addItem();

                  },
                  child:  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 17),
                    height: 40,
                    decoration: BoxDecoration(
                        color: HexColor(ColorTheme.secundaryColor),
                        borderRadius: const BorderRadius.all(Radius.circular(5.0))
                    ),
                    child: const Center(

                      child: Text(
                        "Agregar producto",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            )
          )
        ),
      ),
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
                Text("INGRESE SERIE DE ITEM", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: HexColor(ColorTheme.buttoncolor)),),
                const SizedBox(height: 5),
                Flexible(child:
                SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        TextField(
                          controller: _buscar,
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
                        GestureDetector(
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
                        const SizedBox(height: 5),

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
                          loadDataProducto(series[index]!);
                        });

                        /*showEdit("",(){

                          if (texto.text.length > 0) {
                            Future.delayed(const Duration(milliseconds: 250), () {
                              loadDataProducto(series[index]!);
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

      //var item = ListaModel(serie: serie, producto: producto, valor: valor);
      var item = ListaModel(serie: serie, producto: producto, valor: '0');
      setState(() {
        Texts.listaGlobal.add(item);

        var sub = 0.0;
        var iv = 0.0;
        var to = 0.0;
        var rec = 0.0;

        for (var i = 0; i < Texts.listaGlobal.length; i++) {
          var lis = Texts.listaGlobal[i];
          sub =  sub + double.parse(lis.valor!);
          rec =  rec + double.parse(lis.producto!.valor!);
        }

        iv = sub * 0.12;
        to = sub + iv;
        subtotal = ""+sub.toStringAsFixed(2);
        iva = ""+iv.toStringAsFixed(2);
        total = ""+to.toStringAsFixed(2);
        recaudado = ""+rec.toStringAsFixed(2);

        Future.delayed(const Duration(milliseconds: 300), () {
          Fluttertoast.showToast(
              msg: "Producto añadido, en registrar Series",  // message
              toastLength: Toast.LENGTH_SHORT, // length
              gravity: ToastGravity.BOTTOM,    // location
              timeInSecForIosWeb: 1               // duration
          );

        });
      });

    }else{
      Fluttertoast.showToast(
          msg: "Lo sentimos intente otra vez",  // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.BOTTOM,    // location
          timeInSecForIosWeb: 1               // duration
      );
    }

    Future.delayed(const Duration(milliseconds: 250), () {
      Navigator.of(context).pop();
    });
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

    database.then((onValu){
      final result =  onValu.seriesDao.getSeriesByID(_buscar.text.toString());
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
                addItem();
              });
            });}
          }else{showNewConfirm("No se encontro resultados",(){
            Future.delayed(const Duration(milliseconds: 150), () {
              addItem();
            });
          });}



        }, onError: (e) {
          print("Error: "+e.toString());
        });
      }

    });

  }





}

