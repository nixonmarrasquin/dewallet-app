import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:siglo21/Entities/Facturas.dart';
import '../Constants/Constants.dart';
import '../Entities/Sesion.dart';
import '../Models/DisponibleModel.dart';
import '../Models/EventObject.dart';
import '../Models/FacturrasModel.dart';
import '../Models/Model.dart';
import '../Utils/HexColor.dart';
import '../services/ApiService.dart';
import 'BaseController.dart';
import 'package:date_range_form_field/date_range_form_field.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'DetalleHostprialController.dart';

class HistorialFacturacionController extends BaseController {

  @override
  _HistorialFacturacionController createState() => _HistorialFacturacionController();

}

GlobalKey<FormState> myFormKey = GlobalKey();

class _HistorialFacturacionController extends BaseControllerState<HistorialFacturacionController> with WidgetsBindingObserver{

  @override
  bool get wantKeepAlive => true;


  DateTimeRange? myDateRange;
  Sesion? sesion;
  List<Facturas> facturas = [];
  String error = SnackBarText.ERROR_DEFAULT;


  void _submitForm() {
    final FormState? form = myFormKey.currentState;
    form!.save();
  }

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

      myDateRange = DateTimeRange(end:  DateTime.now(), start:  DateTime.now().subtract(const Duration(days: 120)));

      onValu.facturasDao.cleanFacturas();
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
                    padding: EdgeInsets.all(15),
                    child:  Column(children: [
                      Text("Historial Series", textAlign: TextAlign.center, style: TextStyle(color: HexColor(ColorTheme.buttoncolor), fontWeight: FontWeight.bold, fontSize: 20)),
                        const SizedBox(height: 10),
                        //seaarchBar()
                    ],)
                  ),
                  Expanded(child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: const EdgeInsets.all(13),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                children: [

                                  Expanded(child:   DateRangeField(
                                      enabled: true,
                                      cancelText: "Cancelar",
                                      confirmText: "Ok",
                                      errorFormatText: "Formato invalido",
                                      errorInvalidText: "Fuera de rango",
                                      fieldEndHintText: "Fecha fin",
                                      errorInvalidRangeText: "Rango invalido",
                                      helpText: "Seleccionar rango de fechas",
                                      fieldEndLabelText: "Fecha Fin",
                                      fieldStartHintText: "Fecha de inicio",
                                      fieldStartLabelText: "Fecha de inicio",
                                      saveText: "Guardar",
                                      firstDate: DateTime.now().subtract(const Duration(days: 120)),
                                      lastDate: DateTime.now(),
                                      initialValue: DateTimeRange(
                                          start:  DateTime.now().subtract(const Duration(days: 7)),
                                          end: DateTime.now()),
                                      decoration: const InputDecoration(
                                        labelText: 'Rango de fechas',
                                        prefixIcon: Icon(Icons.date_range),
                                        hintText: 'Seleccione una fecha de inicio y finalización',
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value!.end.isAfter(DateTime.now())) {
                                          return 'Introduce una fecha de inicio posterior';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        setState(() async {
                                          myDateRange = value!;
                                          await database.then((onValu){
                                            onValu.facturasDao.cleanFacturas();
                                            loadData();

                                          });

                                        });
                                      },
                                      onSaved: (value) {
                                        setState(() async {
                                          myDateRange = value!;
                                          await database.then((onValu){
                                            onValu.facturasDao.cleanFacturas();
                                            loadData();

                                          });

                                        });
                                      }),),

                                  GestureDetector(
                                    onTap: () async {
                                      await database.then((onValu){
                                        onValu.facturasDao.cleanFacturas();
                                        loadData();

                                      });
                                    },
                                    child:  Container(
                                      padding: EdgeInsets.only(left: 15, right: 15),
                                      height: 50,
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
                                  )

                                ],
                              ),

                            /*Padding(padding: const EdgeInsets.only(left: 20),
                            child: Text("Resultados", textAlign: TextAlign.start, style: TextStyle(color: HexColor(ColorTheme.primaryColor), fontWeight: FontWeight.bold, fontSize: 18))),*/

                              const SizedBox(height: 15),

                              Row(
                                children: [
                                  Expanded(child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Padding(padding: EdgeInsets.only(left: 20),
                                        child: Text("NOMBRE", textAlign: TextAlign.end, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),)
                                    ],)),

                                  Expanded(child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Expanded(child: Padding(padding: EdgeInsets.only(right: 20),
                                      child: Text("VALOR", textAlign: TextAlign.end, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),)),
                                    ],)),


                                ],
                              ),



                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(10),
                                itemCount: facturas.length,
                                itemBuilder: (context, index) {

                                  return InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => DetalleHostprialController("${facturas![index].numOrder}"))).then((value) => (){
                                        //gerUser();
                                      });
                                    },
                                    child: celda(index),
                                  );
                                },
                              )



                          ],)
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

  Widget seaarchBar(){
    return TextField(
      controller: buscadorController,
      textInputAction: TextInputAction.search,
      onSubmitted: (value) {
        //buscar(value);
      },
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          filled: true,
          focusColor: Colors.white,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.all(12),
          labelText: 'Buscar',
          floatingLabelBehavior: FloatingLabelBehavior.never

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
                Text("${facturas[index].created_at}", textAlign: TextAlign.start, maxLines: 1, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 17)),
                  Text(" # Orden: ${facturas[index].numOrder}", textAlign: TextAlign.start, style: TextStyle(color: Colors.black54, fontSize: 18)),
              ],)),

              Expanded(child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: Text("\$ ${facturas[index].valorPremio!.toStringAsFixed(2)}", textAlign: TextAlign.end, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17))),
                  Icon(Icons.navigate_next)
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
    DateTime now = DateTime.now();

    var nowDate = DateFormat('yyyy-MM-dd').format(myDateRange!.start);
    var lastDate = DateFormat('yyyy-MM-dd').format(myDateRange!.end);



    try {
      final body = {
        "codVendedor": sesion != null ? "${sesion!.codigo_v}" : "",
        "fechaini": '${nowDate}',
        "fechafin": '${lastDate}'
      };

      print(body.toString());
      error = SnackBarText.ERROR_DEFAULT;
      EventObject _resp = await getSerie(body);
      switch (_resp.id) {
        case HttpStatus.SC_OK:
          {
            FacturasModel? model = _resp.object as FacturasModel?;
            if (model != null) {
              if (model.msg != null) {
                if (model.msg == true) {

                  if (model.data != null){

                    await database.then((onValu){
                      if (model.data!.length > 0) {
                        onValu.facturasDao.cleanFacturas();
                        facturas =  model.data!;
                        onValu.facturasDao.insertAllFacturas(facturas);
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
    });

    database.then((onValu){
      final result =  onValu.facturasDao.getFacturas();
      if (result != null){
        result.then((data) {
          if (data != null){
            if (data.length > 0){
              setState(() {
                facturas = data.cast<Facturas>();
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
