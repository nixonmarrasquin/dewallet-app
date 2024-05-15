import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:siglo21/services/ApiService.dart';
import '../Constants/Constants.dart';
import '../Entities/DetalleFacturas.dart';
import '../Entities/Sesion.dart';
import '../Models/DetalleFacturrasModel.dart';
import '../Models/EventObject.dart';
import '../Utils/HexColor.dart';
import 'BaseController.dart';
import 'dart:convert' show json;

  class DetalleHostprialController extends BaseController {
    String something;
    DetalleHostprialController(this.something);

  @override
  _DetalleHostprialController createState() => _DetalleHostprialController(this.something);

}

class _DetalleHostprialController extends BaseControllerState<DetalleHostprialController> with AutomaticKeepAliveClientMixin , WidgetsBindingObserver {


  @override
  bool get wantKeepAlive => true;

  Sesion? sesion;
  List<DetalleFacturas> facturas = [];
  String error = SnackBarText.ERROR_DEFAULT;
  double subtotal = 0.0;
  double iva = 0.0;
  double total = 0.0;
  double valorPremio = 0.0;


  String something;

  _DetalleHostprialController(this.something);


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
        child: Column(children: [
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
            child:  Text("Detalle de Series", textAlign: TextAlign.center, style: TextStyle(color: HexColor(ColorTheme.buttoncolor), fontWeight: FontWeight.bold, fontSize: 20)),
          ),

          Expanded(child:
            SingleChildScrollView(
              child: Padding(padding: EdgeInsets.all(16),
                child: Column(
                  children: [

                    Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Container(
                          width: double.infinity,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                const SizedBox(height: 10),
                                Text("INFORMACIÓN DE LA SERIE", textAlign: TextAlign.start, style: TextStyle(color: HexColor(ColorTheme.buttoncolor), fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: HexColor(ColorTheme.buttoncolor),
                                ),
                                const SizedBox(height: 20),

                                Row(
                                  children: [
                                    Container(
                                      child: Text("CLIENTE:", textAlign: TextAlign.start, style: TextStyle(color: HexColor(ColorTheme.buttoncolor), fontWeight: FontWeight.bold, fontSize: 14)),
                                      width: 100,
                                    ),
                                    Container(
                                      child: Text(facturas.length > 0 ? facturas[0].codCliente! : "" , maxLines:1,textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 14)),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 5),
                               /* Row(
                                  children: [
                                    Container(
                                      child: Text("RUC:", textAlign: TextAlign.start, style: TextStyle(color: HexColor(ColorTheme.primaryColor), fontWeight: FontWeight.bold, fontSize: 14)),
                                      width: 100,
                                    ),
                                    Container(
                                      child: Text("0930536115001", maxLines:1,textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 14)),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 5),*/
                                Row(
                                  children: [
                                    Container(
                                      child: Text("FECHA:", textAlign: TextAlign.start, style: TextStyle(color: HexColor(ColorTheme.buttoncolor), fontWeight: FontWeight.bold, fontSize: 14)),
                                      width: 100,
                                    ),
                                    Container(
                                      child: Text(facturas.length > 0 ? facturas[0].created_at! : "", maxLines:1,textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 14)),
                                    )
                                  ],
                                ),
                               /* const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Container(
                                      child: Text("DIRECCIÓN:", textAlign: TextAlign.start, style: TextStyle(color: HexColor(ColorTheme.primaryColor), fontWeight: FontWeight.bold, fontSize: 14)),
                                      width: 100,
                                    ),
                                    Container(
                                      child: Text("GUAYAQUIL, GUASMO SUR", maxLines:1,textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 14)),
                                    )
                                  ],
                                ),*/
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Container(
                                      child: Text("# ORDEN:", textAlign: TextAlign.start, style: TextStyle(color: HexColor(ColorTheme.buttoncolor), fontWeight: FontWeight.bold, fontSize: 14)),
                                      width: 100,
                                    ),
                                    Container(
                                          child: Text( "${widget.something}", maxLines:1,textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 14)),
                                    )
                                  ],
                                ),
                               /* const SizedBox(height: 25),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text("VALOR PREMIO", textAlign: TextAlign.end, style: TextStyle(color: HexColor("#1F94F1"), fontWeight: FontWeight.bold, fontSize: 15)),
                                      flex: 1,
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      //child: Text("\$ ${subtotal.toStringAsFixed(2)}", maxLines:1,textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 15)),
                                      child: Text(facturas.length > 0 ? "\$ ${facturas[0].valorPremio!}" : "", maxLines:1,textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 15)),
                                      flex: 1,
                                    )
                                  ],
                                ),*/
                                /*const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text("(-) DESCUENTO)", textAlign: TextAlign.end, style: TextStyle(color: HexColor("#1F94F1"), fontWeight: FontWeight.bold, fontSize: 15)),
                                      flex: 1,
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Text("10%", maxLines:1,textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 15)),
                                      flex: 1,
                                    )
                                  ],
                                ),*/
                                const SizedBox(height: 5),
                                /*Row(
                                  children: [
                                    Expanded(
                                      child: Text("SUBTOTAL NETO", textAlign: TextAlign.end, style: TextStyle(color: HexColor("#1F94F1"), fontWeight: FontWeight.bold, fontSize: 15)),
                                      flex: 1,
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Text("\$ 106.86", maxLines:1,textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 15)),
                                      flex: 1,
                                    )
                                  ],
                                ),
                                const SizedBox(height: 5),*/
                                /*Row(
                                  children: [
                                    Expanded(
                                      child: Text("IVA", textAlign: TextAlign.end, style: TextStyle(color: HexColor("#1F94F1"), fontWeight: FontWeight.bold, fontSize: 15)),
                                      flex: 1,
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Text("\$ ${iva.toStringAsFixed(2)}", maxLines:1,textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 15)),
                                      flex: 1,
                                    )
                                  ],
                                ),*/

                                const SizedBox(height: 5),
                               /* Row(
                                  children: [
                                    Expanded(
                                      child: Text("TOTAL", textAlign: TextAlign.end, style: TextStyle(color: HexColor("#1F94F1"), fontWeight: FontWeight.bold, fontSize: 15)),
                                      flex: 1,
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Text("\$ ${total.toStringAsFixed(2)}", maxLines:1,textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 15)),
                                      flex: 1,
                                    )
                                  ],
                                ),*/
                                const SizedBox(height: 15),


                              ]),
                        )
                      ),
                    ),

                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                          color: HexColor(ColorTheme.buttoncolor),
                          borderRadius: const BorderRadius.all(Radius.circular(0.0))
                      ),
                      child: Center(

                        child: Text(
                          "Total ganado: \$ "+valorPremio.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(10),
                      itemCount: facturas.length,
                      itemBuilder: (context, index) {

                        return InkWell(
                          onTap: (){


                          },
                          child: celda(index),
                        );
                      },
                    )


                  ]
                ),
              )
            )
          )

        ],),
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
              children: [
                Expanded(child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(facturas[index].descripcion!, textAlign: TextAlign.start, maxLines: 1, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 17)),
                    Text("# Serie: ${facturas[index].serie!}", textAlign: TextAlign.start, style: TextStyle(color: Colors.black54, fontSize: 18)),
                  ],)),

                Expanded(child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Text("\$ ${facturas[index].valorPremio!.toStringAsFixed(2)}", textAlign: TextAlign.end, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17))),
                    const SizedBox(width: 10),
                    Icon(Icons.check_box)
                  ],)),


              ],
            )
          ]),
    );
  }




  Future<void> loadData() async {

    setState(() {
      facturas = [];
    });


    showLoading();


    try {
      final body = {
        "numOrden": "${something}",
        //"codCliente": sesion != null ? "${sesion!.codigo_c}" : "",
        "codVendedor": sesion != null ? "${sesion!.codigo_v}" : "",
      };

      print(body.toString());
      error = SnackBarText.ERROR_DEFAULT;
      EventObject _resp = await getDetallaFactura(body);
      switch (_resp.id) {
        case HttpStatus.SC_OK:
          {
            DetalleFacturasModel? model = _resp.object as DetalleFacturasModel?;
            if (model != null) {
              if (model.msg != null) {
                if (model.msg == true) {

                  if (model.data != null){

                    await database.then((onValu){
                      if (model.data!.length > 0) {
                        onValu.detalleFacturasDao.cleanDetalleFacturas();
                        facturas =  model.data!;
                        onValu.detalleFacturasDao.insertAllDetalleFacturas(facturas);
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
      facturas = [];
      total = 0.0;
      valorPremio = 0.0;
    });

    database.then((onValu){
      final result =  onValu.detalleFacturasDao.getDetalleFacturas();
      if (result != null){
        result.then((data) {
          if (data != null){
            if (data.length > 0){
              setState(() {
                facturas = data.cast<DetalleFacturas>();

                if (facturas != null){
                  for (var fac in facturas){
                   setState(() {
                     /*subtotal =  subtotal + fac.precioUnitario!;
                     iva =  subtotal + fac.iva!;
                     valorPremio =  subtotal + fac.valorPremio!;
                     total =  subtotal + iva;*/
                     if (fac.valorPremio != null){
                       valorPremio = valorPremio + fac.valorPremio!;
                     }
                   });

                  }
                }

              });
            }
          }

        }, onError: (e) {
          print("Error: "+e.toString());
        });
      }

    });

  }

}

