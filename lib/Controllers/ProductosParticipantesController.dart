import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:siglo21/Entities/Facturas.dart';
import 'package:siglo21/Models/BuscarModel.dart';
import 'package:siglo21/Models/MarcaModel.dart';
import 'package:siglo21/Models/NombreNivel3Model.dart';
import 'package:siglo21/Models/ProdModel.dart';
import '../Constants/Constants.dart';
import '../Entities/Sesion.dart';
import '../Models/DisponibleModel.dart';
import '../Models/EventObject.dart';
import '../Models/FacturrasModel.dart';
import '../Models/ListaParticipanteModel.dart';
import '../Models/Model.dart';
import '../Models/PartModel.dart';
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

class ProductosParticipantesController extends BaseController {

  @override
  _ProductosParticipantesController createState() => _ProductosParticipantesController();

}

GlobalKey<FormState> myFormKey = GlobalKey();

class _ProductosParticipantesController extends BaseControllerState<ProductosParticipantesController> with WidgetsBindingObserver{

  List<String> itemsMarcas = [

  ];
  String? selectedMarca;
  List<ProdModel>? productos;

   List<String> itemsNombre = [
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
    WidgetsBinding.instance!.addPostFrameCallback((_) => getUser()
    );
  }


  getUser(){
    selectedMarca = "TODOS";
    selectedNombre = "TODOS";
    itemsMarcas.add("TODOS");
    itemsNombre.add("TODOS");
    database.then((onValu){

      onValu.detalleFacturasDao.cleanDetalleFacturas();
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
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
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
                      enablePullUp: false,
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
        var pro = ParticipanteModel(
            cod_producto: productos![index].cod_producto != null ? productos![index].cod_producto : "",
            descripcion: productos![index].descripcion != null ? productos![index].descripcion : "",
            id: 0,
            url_image: productos![index].url_image != null ? productos![index].url_image : "",
            valor_premio: productos![index].valor_premio != null ? "${productos![index].valor_premio}" : "0.0",
            vigencia: ""
        );

        Navigator.push(context, MaterialPageRoute(
            builder: (context) => DetalleParticipanteController(producto: pro)));
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


  Future<void> loadData() async {

    _refreshController.refreshCompleted();

    setState(() {
      pullUp = true;
      productos = [];
    });

    FocusScope.of(context).requestFocus(new FocusNode());
    showLoading();
    try {
      final body = {
        "codCliente": sesion != null ? "${sesion!.codigo_c}" : ""
      };

      print(body.toString());
      error = SnackBarText.ERROR_DEFAULT;
      EventObject _resp = await productoParticipantes2(body);
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
            PartModel? model = _resp.object as PartModel?;
            if (model != null) {
              if (model.code != null) {
                if (model.code == 200) {

                  if (model.data != null){
                    if (model.data! != null){
                        if (model.data!.length > 0){


                          for(var marca in model.data!) {
                            if (marca.marca != null){
                              if (!itemsMarcas.contains(marca.marca!)){
                                itemsMarcas.add(marca.marca!);
                              }
                            }

                            if (marca.categoria1 != null){
                              if (!itemsNombre.contains(marca.categoria1!)){
                                itemsNombre.add(marca.categoria1!);
                              }
                            }
                          }
                          //itemsMarcas.sort((a, b) => a.compareTo(b));
                          //itemsNombre.sort((a, b) => a.compareTo(b));

                          if (searchControlle.text.length > 0) {
                            for(var categoria in model.data!) {
                              if (categoria.descripcion!.contains(searchControlle.text.toUpperCase())){
                                productos!.add(categoria);
                              }
                            }
                            setState(() {});

                          }else if (selectedMarca == "TODOS" && selectedNombre == "TODOS"){
                            setState(() {
                              productos = model.data!;
                            });
                          }else  if (selectedMarca != "TODOS" && selectedNombre == "TODOS"){
                            for(var marca in model.data!) {
                              if (marca.marca! == selectedMarca){
                                productos!.add(marca);
                              }
                            }
                            setState(() {});
                          }else  if (selectedMarca == "TODOS" && selectedNombre != "TODOS"){
                            for(var categoria in model.data!) {
                              if (categoria.categoria1! == selectedNombre){
                                productos!.add(categoria);
                              }
                            }
                            setState(() {});
                          }else  if (selectedMarca != "TODOS" && selectedNombre != "TODOS"){
                            for(var categoria in model.data!) {
                              if (categoria.marca! == selectedMarca && categoria.categoria1! == selectedNombre){
                                productos!.add(categoria);
                              }
                            }
                            setState(() {});
                          }




                        }
                    }

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

      });
    } on Exception {
      setState(() {
        dissmisLoading();

      });
    }

  }




}
