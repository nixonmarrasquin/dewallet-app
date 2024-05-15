import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:siglo21/Entities/Facturas.dart';
import 'package:siglo21/Models/BuscarModel.dart';
import 'package:siglo21/Models/MarcaModel.dart';
import 'package:siglo21/Models/NombreNivel3Model.dart';
import '../Constants/Constants.dart';
import '../Entities/Sesion.dart';
import '../Models/DisponibleModel.dart';
import '../Models/EventObject.dart';
import '../Models/FacturrasModel.dart';
import '../Models/ListaParticipanteModel.dart';
import '../Models/Model.dart';
import '../Models/ParticipanteModel.dart';
import '../Utils/HexColor.dart';
import '../services/ApiService.dart';
import 'BaseController.dart';
import 'package:date_range_form_field/date_range_form_field.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'DetalleHostprialController.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'DetalleParticipanteController.dart';
import 'dart:ui' as ui;

class ProductosParticipantesController2 extends BaseController {

  @override
  _ProductosParticipantesController2 createState() => _ProductosParticipantesController2();

}

GlobalKey<FormState> myFormKey = GlobalKey();

class _ProductosParticipantesController2 extends BaseControllerState<ProductosParticipantesController2> with WidgetsBindingObserver{

  final List<String> itemsMarcas = [

  ];
  String? selectedMarca;
  List<ParticipanteModel>? productos;

  final List<String> itemsNombre = [
  ];
  String? selectedNombre;
  int page = 1;
  bool pullUp = true;

  @override
  bool get wantKeepAlive => true;
  final searchControlle = TextEditingController();

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

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
    WidgetsBinding.instance!.addPostFrameCallback((_) => loaddataSpinner()
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  getUser(){
  }

  @override
  Widget build(BuildContext context) {

    var top = MediaQueryData.fromWindow(ui.window).padding.top;
    var rest = 320;
    if (top > 0){
      rest = 410;
    }


    print("top: "+top.toString());
    print("tamnio pantalla: "+MediaQuery.of(context).size.height.toString());

    return Scaffold(
        backgroundColor: HexColor(ColorTheme.backgroundColor),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark,
            child: GestureDetector(
              onTap: () {FocusScope.of(context).requestFocus(new FocusNode());},
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [

                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [

                        Expanded(child:

                        TextField(
                          //textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value) {
                            setState(() {
                              page = 1;
                              selectedMarca = "TODOS";
                              selectedNombre = "TODOS";
                              loadData();
                            });
                          },
                          maxLines: 1,
                          controller: searchControlle,
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
                            hintText: "Buscar producto",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: HexColor(ColorTheme.thirdColor), width: 1.5),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: HexColor(ColorTheme.thirdColor),  width: 1.5),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        )),

                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              page = 1;
                              selectedMarca = "TODOS";
                              selectedNombre = "TODOS";
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
                  ),

                  /*Padding(padding: const EdgeInsets.only(left: 20),
                            child: Text("Resultados", textAlign: TextAlign.start, style: TextStyle(color: HexColor(ColorTheme.primaryColor), fontWeight: FontWeight.bold, fontSize: 18))),*/


                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          width: (MediaQuery. of(context). size. width  / 2) - 20,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                              border: Border.all(color: HexColor(ColorTheme.thirdColor))
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              hint:  Container(
                                width: MediaQuery. of(context). size. width  / 2 - 80 ,
                                child: Text(
                                  'Marca',  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: TextStyle(
                                    fontSize: 14,  overflow: TextOverflow.ellipsis,
                                    color: Theme
                                        .of(context)
                                        .hintColor,
                                  ),
                                ),
                              ),
                              items: itemsMarcas
                                  .map((item) =>
                                  DropdownMenuItem<String>(
                                    value: item,
                                    child: Container(
                                      width: MediaQuery. of(context). size. width  / 2 - 80 ,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,  overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ))
                                  .toList(),
                              value: selectedMarca,
                              onChanged: (value) {
                                setState(() {
                                  selectedMarca = value as String;
                                  setState(() {
                                    searchControlle.text = "";
                                    page = 1;
                                    loadData();
                                  });

                                });
                              },
                              buttonHeight: 40,
                              buttonWidth: 140,
                              itemHeight: 40,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: MediaQuery. of(context). size. width  / 2 - 20 ,
                          padding: EdgeInsets.only(left: 15, right: 15),
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                              border: Border.all(color: HexColor(ColorTheme.thirdColor))
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              hint: Container(
                                width: MediaQuery. of(context). size. width  / 2 - 80 ,
                                child: Text(
                                  'Categoría',  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: TextStyle(
                                    fontSize: 14,  overflow: TextOverflow.ellipsis,
                                    color: Theme
                                        .of(context)
                                        .hintColor,
                                  ),
                                ),
                              ),
                              items: itemsNombre
                                  .map((item) =>
                                  DropdownMenuItem<String>(
                                    value: item,
                                    child: Container(
                                      width: MediaQuery. of(context). size. width  / 2 - 80 ,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,  overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ))
                                  .toList(),
                              value: selectedNombre,
                              onChanged: (value) {
                                setState(() {
                                  selectedNombre = value as String;
                                  setState(() {
                                    searchControlle.text = "";
                                    page = 1;
                                    loadData();
                                  });
                                });
                              },
                              buttonHeight: 40,
                              buttonWidth: 140,
                              itemHeight: 40,
                            ),
                          ),
                        ),


                      ],
                    ),
                  ),


                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      color: Colors.black54,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children:  [

                          Expanded(
                            flex: 1,
                            child:
                            Text("Código", textAlign: TextAlign.start, style: TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            flex: 2,
                            child:
                            Text("Descripción", textAlign: TextAlign.start, style: const TextStyle(color: Colors.black87, fontSize: 15,fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            flex: 1,
                            child:
                            Text("Valor", textAlign: TextAlign.start, style: TextStyle(color: Colors.black87, fontSize: 15,fontWeight: FontWeight.bold)),
                          ),
                          Icon(Icons.arrow_forward_ios_rounded, color: Colors.transparent,)


                        ],
                      ),
                    ),
                  ),





                  Expanded(
                    //width: MediaQuery.of(context).size.width,
                    //height: MediaQuery.of(context).size.height - rest,
                    child: SmartRefresher(
                      scrollDirection: Axis.vertical,
                      enablePullDown: false,
                      enablePullUp: pullUp,
                      footer: CustomFooter(
                        builder: (context, mode) {
                          Widget body ;
                          if(mode==RefreshStatus.idle){
                            body =  Text("Cargando");
                          }else
                          if(mode==LoadStatus.idle){
                            //body =  Text("Cargando");
                            body =  Container();
                          }
                          else if(mode==LoadStatus.loading){
                            body =  const CupertinoActivityIndicator();
                          }
                          else if(mode == LoadStatus.failed){
                            body = Text("Intenta de nuevo");
                          }
                          else if(mode == LoadStatus.canLoading){
                            body = Text("soltar para cargar más");
                          }
                          else{
                            body = Text("No más datosv");
                          }
                          return Container(
                            height: 55.0,
                            child: Center(child:body),
                          );
                        },
                      ),
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      onLoading: _onLoading,
                      child: ListView.builder(
                        // physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: productos != null ? productos!.length : 0,
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
                      ),
                    ),
                  )








                ],)
            )
        )
    );
  }

  void _onRefresh() async{
    print("refresh");
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    print("_onLoading");
    page++;
    loadData();

    //_refreshController.loadComplete();
  }



  Widget celda(int index){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => DetalleParticipanteController(producto: productos![index],)));
      },
      child: Container(
        padding: const EdgeInsets.all(12),
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
                    Text(productos![index].cod_producto ?? "", textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    flex: 2,
                    child:
                    Text(productos![index].descripcion ?? "", textAlign: TextAlign.start, style: const TextStyle(color: Colors.black87, fontSize: 15)),
                  ),
                  Expanded(
                    flex: 1,
                    child:
                    Text("\$ ${productos![index].valor_premio} ",maxLines: 1, textAlign: TextAlign.end, style: TextStyle(overflow: TextOverflow.ellipsis,color: Colors.black, fontSize: 15)),
                  ),
                  const SizedBox(width: 5),
                  Icon(Icons.arrow_forward_ios_rounded, size: 18,)




                ],
              )
            ]),
      ),
    );
  }


  Future<void> loaddataSpinner() async {

    FocusScope.of(context).requestFocus(new FocusNode());
    showLoading();
    DateTime now = DateTime.now();
    try {
      final body = {
        "numOrden": "",
      };

      error = SnackBarText.ERROR_DEFAULT;
      EventObject _resp = await getCategorias(body);
      switch (_resp.id) {
        case HttpStatus.SC_OK:
          {
            BuscarModel? model = _resp.object as BuscarModel?;
            if (model != null) {
              if (model.sms != null) {
                if (model.sms == true) {

                  if (model.marcas != null){
                    itemsMarcas.add("TODOS");
                    for (var marca in model.marcas!){
                      if (marca.marca != null)
                        if (marca.marca!.length > 0)
                          itemsMarcas.add(marca.marca!);
                    }
                    setState(() { itemsMarcas; });
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


                  if (model.nombreNivel3 != null){
                    itemsNombre.add("TODOS");
                    for (var nombre in model.nombreNivel3!){
                      if (nombre.NombreNivel3T != null)
                        if (nombre.NombreNivel3T!.length > 0)
                          itemsNombre.add(nombre.NombreNivel3T!);
                    }
                    setState(() { itemsNombre; });
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
        loadData();

      });
    } on Exception {
      setState(() {
        dissmisLoading();
        loadData();

      });
    }

  }

  Future<void> loadData() async {

    _refreshController.refreshCompleted();

    setState(() {
      pullUp = true;
      if (page == 1){
        productos = [];
      }
    });

    FocusScope.of(context).requestFocus(new FocusNode());
    showLoading();
    try {
      final body = {
        "descripcion": searchControlle.text,
        "marca": selectedMarca != null ? selectedMarca == "TODOS" ? "" :  selectedMarca : "",
        "NombreNivel3": selectedNombre != null ? selectedNombre == "TODOS" ? "" :  selectedNombre : "",
        "list_precio": "${App.LISTA_PRECIO}",
        "page": "${page}"
      };

      print(body.toString());
      error = SnackBarText.ERROR_DEFAULT;
      EventObject _resp = await productoParticipantes(body);
      _refreshController.loadComplete();

      setState(() {
        pullUp = false;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          pullUp = true;
        });

      });


      switch (_resp.id) {
        case HttpStatus.SC_OK:
          {
            ListaParticipanteModel? model = _resp.object as ListaParticipanteModel?;
            if (model != null) {
              if (model.sms != null) {
                if (model.sms == true) {

                  if (model.data != null){
                    if (model.data!.data != null){
                        if (model.data!.data!.length > 0){

                          if(model.data!.next_page_url != null){
                            if(model.data!.next_page_url!.length > 0) {
                            }
                          }

                          if (page == 1){
                            productos = model.data!.data!;
                          }else{
                            for (var s in model.data!.data!){
                              /*if (productos!.firstWhere((val) => val.id == s.id) != null) {

                              }else{
                                productos!.add(s);
                              }*/
                              productos!.add(s);

                            }
                            setState(() {

                            });
                          }
                        }else{
                          if (page>1)
                            page--;
                        }
                    }else{
                    if (page>1)
                      page--;
                  }

                  }else{
                    if (page>1)
                      page--;
                  }
                }else{
                  if (page>1)
                    page--;
                }
              }else {
                setState(() {
                  //showAlert(error);
                });
                if (page>1)
                  page--;
              }
            } else {
              setState(() {
                //showAlert(error);
                if (page>1)
                  page--;
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
