import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:siglo21/Models/CuponModel.dart';
import '../Constants/Constants.dart';
import '../Entities/Cupones.dart';
import '../Entities/Sesion.dart';
import '../Models/CuponesModel.dart';
import '../Models/DataProModel.dart';
import '../Models/DisponibleModel.dart';
import '../Models/EventObject.dart';
import '../Models/Model.dart';
import '../Models/ProductoCanjeModel.dart';
import '../Utils/HexColor.dart';
import '../services/ApiService.dart';
import 'BaseController.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'GridController.dart';

class PremiosController extends BaseController {

  final Function() goHome;
  PremiosController({required this.goHome}) : super();

  @override
  _PremiosController createState() => _PremiosController();

}

class _PremiosController extends BaseControllerState<PremiosController> with WidgetsBindingObserver{


  @override
  bool get wantKeepAlive => true;
  var saldo = "0.00";
  SaldoModel? disponible;

  double heightHeader = 140;
  Sesion? sesion;
  List<Cupones> cupones = [];
  List<ProductoCanjeModel> productos = [];
  String error = SnackBarText.ERROR_DEFAULT;
  var canjearError = false;

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
                loadData();
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
              child: Column(
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
                    child:  Text("Premios", textAlign: TextAlign.center, style: TextStyle(color: HexColor(ColorTheme.buttoncolor), fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                  Expanded(child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: const EdgeInsets.all(13),
                          child: Card(
                            color: HexColor(ColorTheme.colorSaldo),
                            child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Flexible(child: Column(children: [
                                      Row(children: const [
                                        Icon(Icons.wallet_giftcard, size: 20),
                                        SizedBox(width: 5),
                                        Text("SALDO", textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 14)),
                                      ]),

                                      Row(children: [
                                        const SizedBox(width: 5),
                                        Text("\$", textAlign: TextAlign.start, style: TextStyle(color: HexColor(ColorTheme.secundaryColor), fontWeight: FontWeight.bold, fontSize: 20)),
                                        const SizedBox(width: 5),
                                        Text("${saldo}", textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
                                        const SizedBox(width: 5),
                                        const Text("disponible", textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                      ])

                                    ])),

                                    /*Row(children: const [
                                      Text("VER", textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
                                      Icon(Icons.navigate_next_outlined),

                                    ]),*/


                                  ],
                                )
                            ),
                          ),
                        ),



                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(left: 10, top: 2, right: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text("CUPONES", textAlign: TextAlign.start, style: TextStyle(color: HexColor(ColorTheme.buttoncolor), fontWeight: FontWeight.bold, fontSize: 16)),
                              ),
                              GestureDetector(
                                onTap: (){
                                  widget.goHome();
                                },
                                child: Text("Ver productos Part.", textAlign: TextAlign.start, style: TextStyle(color:Colors.black54, fontWeight: FontWeight.bold, fontSize: 16)),
                              )
                            ],
                          )
                        ),

                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.all(15),
                          itemCount: cupones != null ? cupones.length : 0,
                          itemBuilder: (context, index) {

                            return InkWell(
                              onTap: (){

                                var vc = double.parse(cupones[index]!.valor!);
                                var sal = double.parse(saldo);


                                if (vc > sal){
                                  Future.delayed(const Duration(milliseconds: 100), () {
                                    showNewAlert("Lo sentimos no tiene cupo disponible");
                                  });
                                  return;
                                }

                                var fecha_ini = new DateFormat("yyyy-MM-dd").parse(cupones[index]!.fecha_ini!);
                                var fecha_fin = new DateFormat("yyyy-MM-dd").parse(cupones[index]!.fecha_fin!);
                                DateTime now = DateTime.now();

                                var f =   false;
                                if (fecha_ini.isBefore(now) && fecha_fin.isAfter(now)){
                                  f = true;
                                }

                                if (!f){
                                  Future.delayed(const Duration(milliseconds: 100), () {
                                    showNewAlert("Lo sentimos cupon caducado");
                                  });
                                  return;
                                }





                                showNewAlert("${cupones[index].descripcion != null ? cupones[index].descripcion! : ''} \n\n ¿Estás seguro de canjear?", () {
                                  Future.delayed(const Duration(milliseconds: 100), () {
                                    loadDataCupon(index);
                                  });
                                }, "SÌ", "NO");

                              },
                              child: celda(index),
                            );
                          },
                        ),


                        Padding(padding: EdgeInsets.symmetric(horizontal: 10),child: Text("PRODUCTOS", textAlign: TextAlign.start, style: TextStyle(color: HexColor(ColorTheme.buttoncolor), fontWeight: FontWeight.bold, fontSize: 16)),),

                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(15),
                          itemCount: productos != null ? productos.length : 0,
                          itemBuilder: (context, index) {

                            return InkWell(
                              onTap: (){

                                var vc = productos[index]!.valor!;
                                var sal = double.parse(saldo);


                                if (vc > sal){
                                  Future.delayed(const Duration(milliseconds: 100), () {
                                    showNewAlert("Lo sentimos no tiene cupo disponible");
                                  });
                                  return;
                                }
                                showNewAlert("${productos[index].descripcion != null ? productos[index].descripcion! : ''} \n\n ¿Estás seguro de canjear?", () {
                                  Future.delayed(const Duration(milliseconds: 100), () {

                                    loadDataProducto(index);
                                  });
                                }, "SÌ", "NO");

                              },
                              child: celdaProducto(index),
                            );
                          },
                        ),


                      ],
                    ),
                  ))
                ],
              )
            )
        )
    );
  }




  Widget celda(int index){
    return Stack(
      children: [
        Image.asset("assets/cupon2.png", width: MediaQuery.of(context).size.width - 30, height: MediaQuery.of(context).size.width / 2.2),
        Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [


              Container(
                padding: const EdgeInsets.only(top: 15, bottom: 20),
                width: MediaQuery.of(context).size.width / 4,
                height: MediaQuery.of(context).size.width / 2.15,
                //color: Colors.blue,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      Flexible(child: RotatedBox(
                          quarterTurns: 3,
                          child: AutoSizeText(cupones[index].nombre != null ? cupones[index].nombre! : 'Cupón',maxLines: 3, textAlign: TextAlign.center, style: const TextStyle( color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16))
                      ))

                    ]
                ),

              ),

              const SizedBox(width: 10),
              AutoSizeText("\USD", textAlign: TextAlign.center,maxLines: 1, style: TextStyle(color: HexColor(ColorTheme.secundaryColor), fontWeight: FontWeight.bold, fontSize: 20)),
              Expanded(child: AutoSizeText(cupones[index].valor != null ? cupones[index].valor!.replaceAll(".00", "") : '0', textAlign: TextAlign.center,maxLines: 1, style: TextStyle(color: HexColor(ColorTheme.secundaryColor), fontWeight: FontWeight.bold, fontSize: 100))),
              Container(
                  padding: const EdgeInsets.only(top: 15),
                  margin: const EdgeInsets.only(right: 5),
                  //color: Colors.red,
                  height: MediaQuery.of(context).size.width / 2.36,
                  width: 65,
                  child: Align(
                      alignment: Alignment.topLeft,
                      child:
                      Container(
                        width: 65,
                        height: 65,
                        child: const Center(
                          child: Text("CANJEAR CUPON", textAlign: TextAlign.center, maxLines: 2,style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: HexColor(ColorTheme.buttoncolor)),
                      )
                  )
              ),
              SizedBox(width: 15),

            ]
        )
      ],
    );
  }






  Widget celdaProducto(int index){
    return Stack(
      children: [
        Image.asset("assets/cupon2.png", width: MediaQuery.of(context).size.width - 30, height: MediaQuery.of(context).size.width / 2.2),
        Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [


              Container(
                padding: const EdgeInsets.only(top: 15, bottom: 20),
                width: MediaQuery.of(context).size.width / 4,
                height: MediaQuery.of(context).size.width / 2.15,
                //color: Colors.blue,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(child: RotatedBox(
                          quarterTurns: 3,
                          child: AutoSizeText(productos[index].nombre != null ? productos[index].nombre! : 'Cupón',maxLines: 3, textAlign: TextAlign.center, style: const TextStyle( color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16))
                      )),

                    ]
                ),

              ),

              const SizedBox(width: 10),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("\USD ${productos[index].valor != null ? productos[index].valor!.toStringAsFixed(2) : '0'}", textAlign: TextAlign.center, maxLines: 2,style: TextStyle(fontSize: 18, color: HexColor(ColorTheme.secundaryColor), fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: 90,
                    height: 90,
                    child: Image.network(
                        productos[index].imagenes != null ? productos[index].imagenes!.length > 0 ? productos[index].imagenes![0].urlImagen! : "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg" : "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network(
                            "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg",
                            fit: BoxFit.cover,
                          );
                        }
                    ),
                  )

                ],
              )),
              //AutoSizeText("\USD", textAlign: TextAlign.center,maxLines: 1, style: TextStyle(color: HexColor(ColorTheme.secundaryColor), fontWeight: FontWeight.bold, fontSize: 20)),
              //Expanded(child: AutoSizeText(productos[index].valor != null ? productos[index].valor!.toStringAsFixed(2) : '0', textAlign: TextAlign.center,maxLines: 1, style: TextStyle(color: HexColor(ColorTheme.secundaryColor), fontWeight: FontWeight.bold, fontSize: 100))),
              Container(
                  padding: const EdgeInsets.only(top: 15),
                  margin: const EdgeInsets.only(right: 5),
                  //color: Colors.red,
                  height: MediaQuery.of(context).size.width / 2.36,
                  width: 85,
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.topRight,
                          child:
                          Container(
                            width: 65,
                            height: 65,
                            child: const Center(
                              child: Text("CANJEAR PRODUCTO", textAlign: TextAlign.center, maxLines: 2,style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: HexColor(ColorTheme.buttoncolor)),
                          )
                      ),
                      const SizedBox(height: 35),
                    GestureDetector(
                      onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                          builder: (context) => GridController(imageUrls: productos[index].imagenes!!)));
                      },
                      child:   Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          color: HexColor(ColorTheme.primaryColor),
                          child: Text("IMAGENES", style: TextStyle(color: HexColor(ColorTheme.buttoncolor),fontSize: 10, fontWeight: FontWeight.bold),),
                        ),
                      ),
                    )
                    ],
                  )
              ),
              SizedBox(width: 15),

            ]
        )
      ],
    );
  }




  Future<void> loadData() async {

    setState(() {
      cupones = [];
    });


    showLoading();
    try {
      final body = {
        "local": sesion != null ? "${sesion!.local}" : ""
      };

      print(body.toString());
      error = SnackBarText.ERROR_DEFAULT;
      EventObject _resp = await getCupones(body);
      switch (_resp.id) {
        case HttpStatus.SC_OK:
          {
            CuponesModel? model = _resp.object as CuponesModel?;
            if (model != null) {
              if (model.sms != null) {
                if (model.sms == true) {

                  if (model.promos != null){

                    await database.then((onValu){
                      if (model.promos!.length > 0) {
                        onValu.cuponesDao.cleanCupones();
                        cupones =  model.promos!;
                        onValu.cuponesDao.insertAllCupones(cupones);
                      }

                      if (model.mispromos!.length > 0) {

                        cupones = List.from(cupones)..addAll(model.mispromos!);
                        onValu.cuponesDao.insertAllCupones(model.mispromos!);
                      }

                    });

                  }else {
                    setState(() {
                      if (model.mensaje != null) {
                        if (model.mensaje!.length > 0) {
                          error = model.mensaje!;
                        }
                      }
                      //showAlert(error);
                    });
                  }
                } else {
                  setState(() {
                    if (model.mensaje != null) {
                      if (model.mensaje!.length > 0) {
                        error = model.mensaje!;
                      }
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

    setState(() {
      cupones = [];
    });

    database.then((onValu){
      final result =  onValu.cuponesDao.getCupones();
      if (result != null){
        result.then((data) {
          if (data != null){
            if (data.length > 0){
              setState(() {
                cupones = data.cast<Cupones>();
              });
            }
          }

        }, onError: (e) {
          print("Error: "+e.toString());
        });
      }

    });

    Future.delayed(const Duration(milliseconds: 250), () {
      loadDataSaldo();
    });

  }







  Future<void> loadDataCupon(int index) async {

    canjearError = false;

    DateTime now = DateTime.now();
    var nowDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(now);
    showLoading();
    try {
      final body = {
        "idtarjeta": cupones[index].id != null ? "${cupones[index].id}" : "",
        "nombreTarjeta": cupones[index].nombre != null ? "${cupones[index].nombre}" : "",
        "valor": cupones[index].valor != null ? "${cupones[index].valor}" : "",
        "codCliente":  sesion != null ? "${sesion!.codigo_c}" : "",
        "codVendedor":  sesion != null ? "${sesion!.codigo_v}" : "",
        "fechaCanje": "${nowDate}",
        "user_updated": sesion != null ? "${sesion!.codigo_v}" : "",
        "mail_updated":  sesion != null ? "${sesion!.correo}" : ""
      };

      print(body.toString());
      error = SnackBarText.ERROR_DEFAULT;
      EventObject _resp = await canjearCupo(body);
      switch (_resp.id) {
        case HttpStatus.SC_OK:
          {
            CuponModel? model = _resp.object as CuponModel?;
            if (model != null) {
              if (model.msg != null) {
                if (model.msg == true) {

                  canjearError = true;
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
        showDataCupon();
      });
    } on Exception {
      setState(() {
        dissmisLoading();
        showDataCupon();
      });
    }

  }

  Future<void> showDataCupon () async {

    var e = "Lo sentimos intente nuevamente";
    if (canjearError){
       e = "Canjeado con éxito";
    }

    Future.delayed(const Duration(milliseconds: 250), () {
          showNewConfirm(e, (){

            Future.delayed(const Duration(milliseconds: 100), () {
              loadDataSaldo();
            });


          });
    });


  }








  Future<void> loadDataProducto(int index) async {

    canjearError = false;

    DateTime now = DateTime.now();
    var nowDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(now);
    showLoading();
    try {
      final body = {
        "idtarjeta": productos[index].id != null ? "${productos[index].id}" : "",
        "nombreTarjeta": productos[index].nombre != null ? "${productos[index].nombre}" : "",
        "valor": productos[index].valor != null ? "${productos[index].valor}" : "",
        "codCliente":  sesion != null ? "${sesion!.codigo_c}" : "",
        "codVendedor":  sesion != null ? "${sesion!.codigo_v}" : "",
        "fechaCanje": "${nowDate}",
        "user_updated": sesion != null ? "${sesion!.codigo_v}" : "",
        "mail_updated":  sesion != null ? "${sesion!.correo}" : ""
      };

      print(body.toString());
      error = SnackBarText.ERROR_DEFAULT;
      EventObject _resp = await canjearCupo(body);
      switch (_resp.id) {
        case HttpStatus.SC_OK:
          {
            CuponModel? model = _resp.object as CuponModel?;
            if (model != null) {
              if (model.msg != null) {
                if (model.msg == true) {

                  canjearError = true;
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
        showDataCupon();
      });
    } on Exception {
      setState(() {
        dissmisLoading();
        showDataCupon();
      });
    }

  }






  Future<void> loadDataSaldo() async {

    setState(() {
      disponible = null;
      //saldo = "0.00";
    });


    showLoading();
    try {
      final body = {
        "codVendedor": sesion != null ? "${sesion!.codigo_v}" : ""
      };

      print(body.toString());
      error = SnackBarText.ERROR_DEFAULT;
      EventObject _resp = await getCupo(body);
      switch (_resp.id) {
        case HttpStatus.SC_OK:
          {
            DisponibleModel? model = _resp.object as DisponibleModel?;
            if (model != null) {
              if (model.msg != null) {
                if (model.msg == true) {

                  if (model.data != null){
                    setState(() {
                      disponible = model.data![0];
                    });

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
        showDataSaldo();
      });
    } on Exception {
      setState(() {
        dissmisLoading();
        showDataSaldo();
      });
    }

  }

  Future<void> showDataSaldo () async {

    if (disponible != null) {
      Future.delayed(const Duration(milliseconds: 250), () {
        setState(() {
          saldo = "${disponible!.cupo!.toStringAsFixed(2)}";
        });
      });
    }

    Future.delayed(const Duration(milliseconds: 250), () {
      loadDataProductos();
    });

  }





















  Future<void> loadDataProductos() async {

    setState(() {
      productos = [];
    });


    showLoading();
    try {
      final body = {
        "local": sesion != null ? "${sesion!.local}" : ""
      };

      print(body.toString());
      error = SnackBarText.ERROR_DEFAULT;
      EventObject _resp = await getProductosPromo(body);
      switch (_resp.id) {
        case HttpStatus.SC_OK:
          {
            DataProModel? model = _resp.object as DataProModel?;
            if (model != null) {
              if (model.msg != null) {
                if (model.msg == true) {
                  if (model.data != null){
                    productos = model.data!!;
                    setState(() {
                      productos.sort((a, b) => a.valor!.compareTo(b.valor!));
                    });

                  }else {

                  }
                } else {
                  setState(() {

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
      });
    } on Exception {
      setState(() {
        dissmisLoading();
      });
    }

  }








}
