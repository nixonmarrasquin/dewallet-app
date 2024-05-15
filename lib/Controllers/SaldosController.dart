import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Constants/Constants.dart';
import '../Entities/Premios.dart';
import '../Entities/Sesion.dart';
import '../Models/DisponibleModel.dart';
import '../Models/EventObject.dart';
import '../Models/Model.dart';
import '../Models/PremiosModel.dart';
import '../Models/SaleData.dart';
import '../Models/SaleData.dart';
import '../Utils/HexColor.dart';
import '../services/ApiService.dart';
import 'BaseController.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:intl/intl.dart';

import 'SaldosController.dart';
import 'SaldosController.dart';

class SaldosController extends BaseController {

  @override
  _SaldosController createState() => _SaldosController();

}

class _SaldosController extends BaseControllerState<SaldosController> with WidgetsBindingObserver{


  @override
  bool get wantKeepAlive => true;

  Sesion? sesion;
  List<Premios> premios = [];
  List<SalesData> grafica = [
    SalesData(sales: 20,year: 'Enero' )

  ];



  var saldo = "0.00";
  SaldoModel? disponible;

  List<String> meses = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre'
  ];

  String error = SnackBarText.ERROR_DEFAULT;

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
              child:  Container(
                color: HexColor(ColorTheme.backgroundColor),
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
                      child:  Column(
                        children: [

                          Text( sesion != null ? "${sesion!.correo}" : "", textAlign: TextAlign.center, style: TextStyle(color: HexColor(ColorTheme.buttoncolor), fontWeight: FontWeight.bold, fontSize: 18)),
                          SizedBox(height: 8),
                          Text("Hoy tu saldo disponible", textAlign: TextAlign.center, style: TextStyle(color: HexColor(ColorTheme.buttoncolor), fontSize: 15)),
                          const SizedBox(height: 8),
                          Text("\$ ${saldo}", textAlign: TextAlign.center, style: TextStyle(color: HexColor(ColorTheme.secundaryColor), fontWeight: FontWeight.bold, fontSize: 35)),
                          const SizedBox(height: 8),
                          /*Row(
                            children: [



                              Expanded(
                                  child: Card(
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                           Text("Ventas de hoy", textAlign: TextAlign.center, style: TextStyle(color: HexColor(ColorTheme.primaryColor), fontWeight: FontWeight.bold, fontSize: 15)),
                                          const SizedBox(height: 2),
                                            Row(children: [
                                              Expanded(child: Text("(+) 125.07", textAlign: TextAlign.center, style: TextStyle(color: HexColor(ColorTheme.primaryColor), fontSize: 20)),),
                                              const Icon(Icons.bar_chart)
                                            ]),

                                        ],
                                      ),
                                    ),
                                  )
                              ),

                              Expanded(
                                  child: Card(
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Text("Venta del mes", textAlign: TextAlign.center, style: TextStyle(color: HexColor(ColorTheme.primaryColor), fontWeight: FontWeight.bold, fontSize: 15)),
                                          const SizedBox(height: 2),
                                          Row(children: [
                                            Expanded(child: Text("(+) 2502.36", textAlign: TextAlign.center, style: TextStyle(color: HexColor(ColorTheme.primaryColor), fontSize: 20)),),
                                            const Icon(Icons.bar_chart)
                                          ]),

                                        ],
                                      ),
                                    ),
                                  )
                              ),

                            ],
                          ),*/
                          const SizedBox(height: 3),
                        ],
                      )
                    ),
                    Expanded(child: SingleChildScrollView(
                      child: Column(
                        children: [
                           Padding(padding: const EdgeInsets.all(15),
                           child: Text("Resumen de logros", textAlign: TextAlign.center, style: TextStyle(color: HexColor(ColorTheme.buttoncolor), fontWeight: FontWeight.bold, fontSize: 20))),
                          const SizedBox(height: 10),

                          Container(
                            padding: const EdgeInsets.all(5),
                            width: double.infinity,
                            height: MediaQuery.of(context).size.width / 2.2,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26, width: 1)
                            ),
                            child: SfCartesianChart(
                              // Initialize category axis
                                primaryXAxis: CategoryAxis(),
                                backgroundColor: Colors.white,
                                series: <LineSeries<SalesData, String>>[
                                  LineSeries<SalesData, String>(
                                    dataSource:  grafica,
                                    xValueMapper: (SalesData dash, _) => dash.year,
                                    yValueMapper: (SalesData dash, _) => dash.sales,
                                    color: Colors.red,
                                    width: 2,
                                    markerSettings: const MarkerSettings (
                                        isVisible:  true,
                                        height: 10,
                                        width: 10,
                                        shape: DataMarkerType.image,
                                       // image: Image.asset("assets/${imag_tipo}").image
                                      //borderColor: Colors.red
                                    ),
                                  )
                                ]
                            ),
                          ),



                          Padding(padding: const EdgeInsets.all(15),
                              child: Text("Cupones canjeados", textAlign: TextAlign.center, style: TextStyle(color: HexColor(ColorTheme.buttoncolor), fontWeight: FontWeight.bold, fontSize: 20))),



                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.all(15),
                            itemCount: premios.length,
                            itemBuilder: (context, index) {

                              return InkWell(
                                onTap: (){


                                },
                                child: celda(index),
                              );
                            },
                          )






                        ],
                      ),
                    ))
                  ],
                ),
              )
            )
        )
    );
  }






  Widget celda(int index){
    return Card(
        elevation: 5,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10),)),
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Column(
            children: [
              //Center(child: Image.asset("assets/cupon.png", fit: BoxFit.fitWidth, width: 200))
              Row(
                children: [

                  //Text("usd ${premios[index].valor!.toStringAsFixed(2)}", textAlign: TextAlign.start, style: TextStyle(color: HexColor(ColorTheme.secundaryColor), fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(width: 10),
                  Expanded(child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("USD ${premios[index].valor!.toStringAsFixed(2)}", textAlign: TextAlign.start, style: TextStyle(color: HexColor(ColorTheme.secundaryColor), fontWeight: FontWeight.bold, fontSize: 25)),
                      Text("${premios[index].nombreTarjeta}", textAlign: TextAlign.start, style: TextStyle(color: HexColor(ColorTheme.buttoncolor), fontWeight: FontWeight.bold, fontSize: 16)),
                       Text("${premios[index].fechaCanje}", textAlign: TextAlign.start, style: TextStyle(color: Colors.black54, fontSize: 16)),
                    ],
                  )),
                  Icon(Icons.card_giftcard_outlined, color: HexColor(ColorTheme.secundaryColor))

                ],
              ),

            ],
          ),
        )
    );
  }



  Future<void> loadData() async {

    setState(() {
      premios = [];
    });


    showLoading();
    DateTime now = DateTime.now();
    var nowDate = DateFormat('yyyy-MM-dd').format(now);

    try {
      final body = {
        "codVendedor": sesion != null ? "${sesion!.codigo_v}" : "",
        "fechaini": '2022-01-01',
        "fechafin": '${nowDate}'
      };

      print(body.toString());
      error = SnackBarText.ERROR_DEFAULT;
      EventObject _resp = await getPremios(body);
      switch (_resp.id) {
        case HttpStatus.SC_OK:
          {
            PremiosModel? model = _resp.object as PremiosModel?;
            if (model != null) {
              if (model.msg != null) {
                if (model.msg == true) {

                  if (model.data != null){

                    await database.then((onValu){
                      if (model.data!.length > 0) {
                        onValu.premiosDao.cleanPremios();
                        premios =  model.data!;
                        onValu.premiosDao.insertAllPremios(premios);
                      }

                    });

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
      premios = [];
      grafica = [
        SalesData(sales: 20,year: 'Enero' )

      ];
    });

    database.then((onValu){
      final result =  onValu.premiosDao.getPremios();
      if (result != null){
        result.then((data) {
          if (data != null){
            if (data.length > 0){
              setState(() {
                premios = data.cast<Premios>();
                grafica = [];
                for (var pre in premios){
                    var mes = int.parse(pre.fechaCanje!.substring(5,7).trim());
                    print("mes ${mes}");
                    grafica.add(SalesData(sales: pre.valor,year: meses[mes - 1] ));
                }
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

  }









}



