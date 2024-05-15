import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:siglo21/Models/DisponibleModel.dart';
import 'package:siglo21/Models/Model.dart';
import '../Constants/Constants.dart';
import '../Entities/Sesion.dart';
import '../Models/EventObject.dart';
import '../Utils/HexColor.dart';
import '../services/ApiService.dart';
import 'BaseController.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class InicioController extends BaseController {

  @override
  _InicioController createState() => _InicioController();

}

class _InicioController extends BaseControllerState<InicioController> with WidgetsBindingObserver{

  @override
  bool get wantKeepAlive => true;

  var saldo = "0.00";
double heightHeader = 140;
  Sesion? sesion;
  SaldoModel? disponible;
  String error = SnackBarText.ERROR_DEFAULT;
  var percentage = 0.0;

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
                    child:  Text("Inicio", textAlign: TextAlign.center, style: TextStyle(color: HexColor(ColorTheme.buttoncolor), fontWeight: FontWeight.bold, fontSize: 20)),
                  ),

                  Expanded(child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Card(
                            elevation: 0,
                            color: Colors.white,
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

                                      SizedBox(height: 15),
                                      CircularPercentIndicator(
                                        radius: 120.0,
                                        lineWidth: 13.0,
                                        animation: true,
                                        percent: percentage,
                                        center: new Text(
                                          "${saldo}",
                                          style:
                                          new TextStyle(fontWeight: FontWeight.bold, fontSize: 50.0, color: HexColor("505050")),
                                        ),
                                        footer: Padding(
                                          padding: EdgeInsets.only(top: 15),
                                          child: Text(
                                            "Cupo disponible",
                                            style:
                                            new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                                          ),
                                        ),
                                        circularStrokeCap: CircularStrokeCap.round,
                                        progressColor: HexColor(ColorTheme.secundaryColor),
                                      ),



                                    ])),



                                  ],
                                )
                            ),
                          ),

                          /*const SizedBox(height: 5),

                          RatingBar.builder(
                            initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),*/

                          const SizedBox(height: 15),
                          Container(
                            width: double.infinity,
                            color: HexColor("#29A498"),
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("DEWALLET PREMIA TU ESFUERZO", textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                                  const SizedBox(height: 8),
                                  Text("Tu fuerza de venta es compensada, por cada venta hecha registra series y te permite acumular saldo a tu favor, para que puedas canjear luego en lo que prefieras", textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontSize: 15)),
                                ],
                              ),
                            ),
                          ),


                        ],
                      ),
                    )
                  ))

                ],
              )
            )
        )
    );
  }




  Future<void> loadData() async {

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

  if (disponible != null) {
    Future.delayed(const Duration(milliseconds: 250), () {
      setState(() {
        saldo = "${disponible!.cupo!.toStringAsFixed(2)}";
        percentage =  (disponible!.cupo! / 100.0) <= 1 ? (disponible!.cupo! / 100.0) : 1;
      });
    });
  }

  }




}
