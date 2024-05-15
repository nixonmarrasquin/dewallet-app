import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Constants/Constants.dart';
import 'package:floor/floor.dart';
import '../DataBase/app_database.dart';
import 'package:intl/intl.dart';
import '../Utils/HexColor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseController extends StatefulWidget {



  @override BaseControllerState createState() => BaseControllerState();

  const BaseController({Key? key}): super(key: key);
}

class BaseControllerState<T extends BaseController> extends State<T>{

   Color colorBackground = HexColor(ColorTheme.backgroundColor);
   bool isOpen = false;
   final buscadorController = TextEditingController();
   var database = $FloorAppDatabase.databaseBuilder(App.DATABASE_NAME).build();
   final texto = TextEditingController();


   @override
  void initState() {
    super.initState();
    final migration = Migration(2, 3, (database) async {
      await database.execute('ALTER TABLE Sesion ADD COLUMN lista_precio INTEGER');
    });

    database = $FloorAppDatabase.databaseBuilder(App.DATABASE_NAME).addMigrations([migration]).build();
    //svalidateInactivity();


   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorBackground,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: HexColor(ColorTheme.buttoncolor), //change your color here
          ),
          backgroundColor: HexColor(ColorTheme.primaryColor),
          bottomOpacity: 0.0,
          elevation: 0.0,
          title:  Container(   // <--- Change here
              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.1),
              child: Image.asset("assets/logo.png", fit: BoxFit.fitHeight, height: 140,)
        ),
          centerTitle: true, systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: GestureDetector(
            onTap: () {FocusScope.of(context).requestFocus(new FocusNode());},
            child: setContent()
        )
    );
  }


  Widget setContent(){
    return Container();
  }

  void showSnackBar(String mensaje, [ VoidCallback? onPressed ] ){
    final snackBar = SnackBar(
      backgroundColor: HexColor(ColorTheme.backgroundColorSnackBar),
      content: Text(mensaje,style: TextStyle(color: Colors.white),),
      action: SnackBarAction(
        textColor: Colors.blue,
        disabledTextColor: Colors.blue,
        label: Texts.LBL_OK,
        onPressed: (){ if (onPressed != null) { onPressed.call(); } } ,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showAlert(String mensaje, [ VoidCallback? onPressed, String lbl_confirm = Texts.LBL_OK ] ){
    final alertDialog = Dialog(
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10.0) ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints( minHeight: 200.0, maxHeight: MediaQuery.of(context).size.height - 190),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 70, 15, 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(Texts.LBL_ATENCION, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),),
                          const SizedBox(height: 5,),
                          Flexible(child:
                           SingleChildScrollView(
                              child: Text(mensaje,textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, color: Colors.black)
                             ),
                           )
                          ),
                          const SizedBox(height: 20),
                          onPressed == null ?
                            buttonAlert(lbl_confirm, HexColor(ColorTheme.buttoncolor), onPressed) :
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buttonAlert(Texts.LBL_CANCELAR, HexColor(ColorTheme.buttoncolor)),
                              const SizedBox(width: 10,),
                              buttonAlert(lbl_confirm, Colors.green, onPressed)
                          ],)
                        ],
                      ),
                    ),
                  ),
                ),
            Positioned(
                top: -60,
                child: CircleAvatar(
                  backgroundColor: HexColor(ColorTheme.buttoncolor),
                  radius: 60,
                  //child: Icon(  Icons.assistant_photo, color: Colors.white, size: 50,),
                  child: Image.asset('assets/logo_white.png', width: 80, fit: BoxFit.cover),
                )
            ),
          ],
        )
    );
    showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => alertDialog);
  }

   void showAlert2(@required String mensaje, [ VoidCallback? onPressed, String lbl_confirm = Texts.LBL_OK ] ){
     final alertDialog = Dialog(
         shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10.0) ),
         child: Stack(
           clipBehavior: Clip.none,
           alignment: Alignment.topCenter,
           children: [
             Container(
               width: double.infinity,
               decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.all(Radius.circular(10.0))
               ),
               child: ConstrainedBox(
                 constraints: new BoxConstraints( minHeight: 200.0, maxHeight: MediaQuery.of(context).size.height - 190),
                 child: Padding(
                   padding: const EdgeInsets.fromLTRB(15, 70, 15, 15),
                   child: Column(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       Text(Texts.LBL_ATENCION, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),),
                       SizedBox(height: 5,),
                       Flexible(child:
                       SingleChildScrollView(
                         child: Text(mensaje,textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.black)
                         ),
                       )
                       ),
                       SizedBox(height: 20),
                       onPressed == null ?
                       buttonAlert(lbl_confirm, HexColor(ColorTheme.buttoncolor), onPressed) :
                       Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           buttonAlert("NO", HexColor(ColorTheme.buttoncolor)),
                           SizedBox(width: 10,),
                           buttonAlert(lbl_confirm, Colors.green, onPressed)
                         ],)
                     ],
                   ),
                 ),
               ),
             ),
             Positioned(
                 top: -60,
                 child: CircleAvatar(
                   backgroundColor: HexColor(ColorTheme.buttoncolor),
                   radius: 60,
                   //child: Icon(  Icons.assistant_photo, color: Colors.white, size: 50,),
                   child: Image.asset('assets/logo_white.png', width: 80, fit: BoxFit.cover),
                 )
             ),
           ],
         )
     );
     showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => alertDialog);
   }

   void showNewAlert(@required String mensaje, [ VoidCallback? onPressed, String lbl_confirm = Texts.LBL_OK, String lbl_cancelar = Texts.LBL_CANCELAR ] ){
     final alertDialog = Dialog(
         insetPadding: EdgeInsets.only(left: 18, right: 18),
         clipBehavior: Clip.antiAliasWithSaveLayer,
         shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0) ),
         child: Stack(
           clipBehavior: Clip.none,
           alignment: Alignment.topCenter,
           children: [
             Container(
               width: double.infinity,
               decoration: BoxDecoration(
                   color: Colors.white,
                   border: Border.all(color: Colors.black38, width: 2),
                   borderRadius: BorderRadius.all(Radius.circular(20.0))
               ),
               child: ConstrainedBox(
                 constraints: new BoxConstraints(minHeight: 200.0, maxHeight: MediaQuery.of(context).size.height - 190),
                 child: Padding(
                   padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
                   child: Column(
                     mainAxisSize: MainAxisSize.min,
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       //Text(Texts.LBL_ATENCION, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),),
                       //SizedBox(height: 5,),
                       Flexible(child:
                       SingleChildScrollView(
                         child: Text(mensaje,textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.bold)
                         ),
                       )
                       ),
                       SizedBox(height: 20),
                       onPressed == null ?
                       buttonAlert(lbl_confirm, HexColor(ColorTheme.buttoncolor), onPressed) :
                      Flexible(child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buttonAlert(lbl_confirm, HexColor(ColorTheme.buttoncolor), onPressed, HexColor(ColorTheme.thirdColor)),
                          SizedBox(width: 10,),
                          buttonAlert(lbl_cancelar, HexColor(ColorTheme.buttoncolor)),

                        ],))
                     ],
                   ),
                 ),
               ),
             ),
             /*Positioned(
                 top: -60,
                 child: CircleAvatar(
                   backgroundColor: HexColor(ColorTheme.primaryColor),
                   radius: 60,
                   //child: Icon(  Icons.assistant_photo, color: Colors.white, size: 50,),
                   child: Image.asset('assets/logo.png', width: 90, fit: BoxFit.cover),
                 )
             ),*/
           ],
         )
     );
     showDialog(context: context ,barrierColor:  Color(0x8AFFFFFF), barrierDismissible: false, builder: (BuildContext context) => alertDialog);
   }

   void showNewConfirm(@required String mensaje, [ VoidCallback? onPressed, String lbl_confirm = Texts.LBL_OK] ){
     final alertDialog = Dialog(
         insetPadding: EdgeInsets.only(left: 18, right: 18),
         clipBehavior: Clip.antiAliasWithSaveLayer,
         shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0) ),
         child: Stack(
           clipBehavior: Clip.none,
           alignment: Alignment.topCenter,
           children: [
             Container(
               width: double.infinity,
               decoration: BoxDecoration(
                   color: Colors.white,
                   border: Border.all(color: Colors.black38, width: 2),
                   borderRadius: BorderRadius.all(Radius.circular(20.0))
               ),
               child: ConstrainedBox(
                 constraints: new BoxConstraints(minHeight: 200.0, maxHeight: MediaQuery.of(context).size.height - 190),
                 child: Padding(
                   padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
                   child: Column(
                     mainAxisSize: MainAxisSize.min,
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       //Text(Texts.LBL_ATENCION, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),),
                       //SizedBox(height: 5,),
                       Flexible(child:
                       SingleChildScrollView(
                         child: Text(mensaje,textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.bold)
                         ),
                       )
                       ),
                       SizedBox(height: 20),
                       onPressed == null ?
                       buttonAlert(lbl_confirm, HexColor(ColorTheme.buttoncolor), onPressed) :
                       Flexible(child:  Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           buttonAlert(lbl_confirm, HexColor(ColorTheme.buttoncolor), onPressed, HexColor(ColorTheme.thirdColor)),
                           //SizedBox(width: 10,),
                           //buttonAlert(lbl_cancelar, HexColor(ColorTheme.primaryColor)),

                         ],))
                     ],
                   ),
                 ),
               ),
             ),
             /*Positioned(
                 top: -60,
                 child: CircleAvatar(
                   backgroundColor: HexColor(ColorTheme.primaryColor),
                   radius: 60,
                   //child: Icon(  Icons.assistant_photo, color: Colors.white, size: 50,),
                   child: Image.asset('assets/logo.png', width: 90, fit: BoxFit.cover),
                 )
             ),*/
           ],
         )
     );
     showDialog(context: context ,barrierColor:  Color(0x8AFFFFFF), barrierDismissible: false, builder: (BuildContext context) => alertDialog);
   }

   void showAlertComfir(@required String mensaje, [ VoidCallback? onPressed, String lbl_confirm = Texts.LBL_OK, String lbl_cancelar = Texts.LBL_CANCELAR ] ){
     final alertDialog = Dialog(
         insetPadding: EdgeInsets.only(left: 18, right: 18),
         clipBehavior: Clip.antiAliasWithSaveLayer,
         shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0) ),
         child: Stack(
           clipBehavior: Clip.none,
           alignment: Alignment.topCenter,
           children: [
             Container(
               width: double.infinity,
               decoration: BoxDecoration(
                   color: Colors.white,
                   border: Border.all(color: Colors.black38, width: 2),
                   borderRadius: BorderRadius.all(Radius.circular(20.0))
               ),
               child: ConstrainedBox(
                 constraints: new BoxConstraints(minHeight: 200.0, maxHeight: MediaQuery.of(context).size.height - 190),
                 child: Padding(
                   padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
                   child: Column(
                     mainAxisSize: MainAxisSize.min,
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [

                       Image.asset('assets/check_on.png', width: 110, height: 70),
                       SizedBox(height: 10),
                       Text("FELICITACIONES", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black54),),
                       SizedBox(height: 10),
                       Flexible(child:
                       SingleChildScrollView(
                         child: Text(mensaje,textAlign: TextAlign.center, style: TextStyle(fontSize: 17, color: Colors.black54)
                         ),
                       )
                       ),
                       SizedBox(height: 10),
                       onPressed == null ?
                       buttonAlert(lbl_confirm, HexColor(ColorTheme.buttoncolor), onPressed) :
                       Flexible(child:  Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           buttonAlert(lbl_confirm, HexColor(ColorTheme.buttoncolor), onPressed, HexColor(ColorTheme.thirdColor)),
                           //SizedBox(width: 10,),
                           //buttonAlert(lbl_cancelar, HexColor(ColorTheme.primaryColor)),

                         ],))
                     ],
                   ),
                 ),
               ),
             ),
             /*Positioned(
                 top: -60,
                 child: CircleAvatar(
                   backgroundColor: HexColor(ColorTheme.primaryColor),
                   radius: 60,
                   //child: Icon(  Icons.assistant_photo, color: Colors.white, size: 50,),
                   child: Image.asset('assets/logo.png', width: 90, fit: BoxFit.cover),
                 )
             ),*/
           ],
         )
     );
     showDialog(context: context ,barrierColor:  Color(0x8AFFFFFF), barrierDismissible: false, builder: (BuildContext context) => alertDialog);
   }

   void showAlertComfir2(@required String mensaje, [ VoidCallback? onPressed, String lbl_confirm = Texts.LBL_OK, String lbl_cancelar = Texts.LBL_CANCELAR ] ){
     final alertDialog = Dialog(
         insetPadding: EdgeInsets.only(left: 18, right: 18),
         clipBehavior: Clip.antiAliasWithSaveLayer,
         shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0) ),
         child: Stack(
           clipBehavior: Clip.none,
           alignment: Alignment.topCenter,
           children: [
             Container(
               width: double.infinity,
               decoration: BoxDecoration(
                   color: Colors.white,
                   border: Border.all(color: Colors.black38, width: 2),
                   borderRadius: BorderRadius.all(Radius.circular(20.0))
               ),
               child: ConstrainedBox(
                 constraints: new BoxConstraints(minHeight: 200.0, maxHeight: MediaQuery.of(context).size.height - 190),
                 child: Padding(
                   padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
                   child: Column(
                     mainAxisSize: MainAxisSize.min,
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [

                       Image.asset('assets/check_on.png', width: 110, height: 70),
                       SizedBox(height: 10),
                       Text("Atención", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black54),),
                       SizedBox(height: 10),
                       Flexible(child:
                       SingleChildScrollView(
                         child: Text(mensaje,textAlign: TextAlign.center, style: TextStyle(fontSize: 17, color: Colors.black54)
                         ),
                       )
                       ),
                       SizedBox(height: 10),
                       onPressed == null ?
                       buttonAlert(lbl_confirm, HexColor(ColorTheme.buttoncolor), onPressed) :
                       Flexible(child:  Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           buttonAlert(lbl_confirm, HexColor(ColorTheme.buttoncolor), onPressed, HexColor(ColorTheme.thirdColor)),
                           //SizedBox(width: 10,),
                           //buttonAlert(lbl_cancelar, HexColor(ColorTheme.primaryColor)),

                         ],))
                     ],
                   ),
                 ),
               ),
             ),
             /*Positioned(
                 top: -60,
                 child: CircleAvatar(
                   backgroundColor: HexColor(ColorTheme.primaryColor),
                   radius: 60,
                   //child: Icon(  Icons.assistant_photo, color: Colors.white, size: 50,),
                   child: Image.asset('assets/logo.png', width: 90, fit: BoxFit.cover),
                 )
             ),*/
           ],
         )
     );
     showDialog(context: context ,barrierColor:  Color(0x8AFFFFFF), barrierDismissible: false, builder: (BuildContext context) => alertDialog);
   }


   void showConfirm(@required String titulo, @required String mensaje, [ VoidCallback? onPressed, String lbl_confirm = Texts.LBL_OK ] ){
     final alertDialog = Dialog(
         shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10.0) ),
         child: Stack(
           clipBehavior: Clip.none,
           alignment: Alignment.topCenter,
           children: [
             Container(
               width: double.infinity,
               decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.all(Radius.circular(10.0))
               ),
               child: ConstrainedBox(
                 constraints: new BoxConstraints( minHeight: 200.0, maxHeight: MediaQuery.of(context).size.height - 190),
                 child: Padding(
                   padding: const EdgeInsets.fromLTRB(15, 70, 15, 15),
                   child: Column(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       Text(titulo, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),),
                       SizedBox(height: 5,),
                       Flexible(child:
                       SingleChildScrollView(
                         child: Text(mensaje,textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.black)
                         ),
                       )
                       ),
                       SizedBox(height: 20),
                       SizedBox(width: 150,
                         child: ElevatedButton(
                           child: Text(lbl_confirm),
                           onPressed: () {
                             if (onPressed != null) { onPressed.call(); }

                           },
                           style: ElevatedButton.styleFrom(
                               elevation: 0.0,
                               shadowColor: Colors.transparent,
                               primary: Colors.green,
                               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                               textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                         ),
                       )
                     ],
                   ),
                 ),
               ),
             ),
             Positioned(
                 top: -60,
                 child: CircleAvatar(
                   backgroundColor: HexColor(ColorTheme.buttoncolor),
                   radius: 60,
                   //child: Icon(  Icons.assistant_photo, color: Colors.white, size: 50,),
                   child: Image.asset('assets/logo_white.png', width: 90, fit: BoxFit.cover),
                 )
             ),
           ],
         )
     );
     showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => alertDialog);
   }

  Widget buttonAlert(String text, Color color, [ VoidCallback? onPressed, Color colorText = Colors.white]){
    const heightButton = 120.0;
    return SizedBox(width: heightButton,
      child: ElevatedButton(
        child: Text(text, style: TextStyle(color: colorText, fontWeight: FontWeight.bold),),
        onPressed: () {
          if (onPressed != null) { onPressed.call(); }
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
            elevation: 0.0,
            shadowColor: Colors.transparent,
            primary: color,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ),
    );
  }

   void cancelado(){

   }

  showLoading([ String title = Texts.LOAGING]){
    isOpen = true;
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10.0) ),
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10.0),
          CircularProgressIndicator(color: HexColor(ColorTheme.buttoncolor),),
          Container(margin: EdgeInsets.only(top: 10.0),child:Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),)),
        ],),
    );
    showDialog(barrierDismissible: false, context:context, builder:(BuildContext context){
        return alert;
      },
    ).then((value) => isOpen = false);
  }

   showLoadingAction([ String title = Texts.LOAGING]){
     const heightButton = 100.0;
     AlertDialog alert = AlertDialog(
       shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10.0) ),
       backgroundColor: Colors.white,
       content: Column(
         mainAxisSize: MainAxisSize.min,
         children: [
           SizedBox(height: 10.0),
           CircularProgressIndicator(color: HexColor(ColorTheme.buttoncolor),),
           Container(margin: EdgeInsets.only(top: 10.0),child:Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),)),
           SizedBox(height: 10.0),
           SizedBox(width: heightButton,
             child: ElevatedButton(
               child: Text("CANCELAR"),
               onPressed: () {
                 cancelado();
                 Navigator.of(context).pop();
               },
               style: ElevatedButton.styleFrom(
                   elevation: 0.0,
                   shadowColor: Colors.transparent,
                   primary: HexColor(ColorTheme.buttoncolor),
                   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                   textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
             ),
           )
         ],),
     );
     showDialog(barrierDismissible: false, context:context, builder:(BuildContext context){
       return alert;
     },
     );
   }

  dissmisLoading(){
    Navigator.pop(context);
  }




   void showEdit(@required String mensaje, [ VoidCallback? onPressed, String lbl_confirm = Texts.LBL_OK, TextInputType textStyle = TextInputType.number] ){
     setState(() {texto.text = mensaje;
     });

     final alertDialog = Dialog(
         shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10.0) ),
         child: Stack(
           clipBehavior: Clip.none,
           alignment: Alignment.topCenter,
           children: [
             Container(
               width: double.infinity,
               decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.all(Radius.circular(10.0))
               ),
               child: ConstrainedBox(
                 constraints: new BoxConstraints( minHeight: 200.0, maxHeight: MediaQuery.of(context).size.height - 190),
                 child: Padding(
                   padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                   child: Column(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       SizedBox(height: 30),
                       Text("INGRESE VALOR"),
                       SizedBox(height: 20),
                       Container(
                           child:  TextField(
                             maxLines: 1,
                             keyboardType: TextInputType.numberWithOptions(decimal: true),
                             inputFormatters: [
                               // Allow Decimal Number With Precision of 2 Only
                               FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                             ],
                             controller: texto,

                             textCapitalization: TextCapitalization.none,
                             cursorColor: Colors.black26,
                             style: TextStyle(color: Colors.black),
                             autocorrect: false,
                             decoration: InputDecoration(
                               floatingLabelBehavior: FloatingLabelBehavior.never,
                               isDense: true,
                               contentPadding: EdgeInsets.all(13),
                               hintText: "Ingrese",
                               focusedBorder: OutlineInputBorder(
                                 borderSide: BorderSide(color: Colors.black26, width: 1.0),
                               ),
                               enabledBorder: OutlineInputBorder(
                                 borderSide: BorderSide(color: Colors.black26, width: 1.0),
                               ),
                             ),
                           )
                       ),
                       SizedBox(height: 20),
                       onPressed == null ?
                       buttonAlert(lbl_confirm, HexColor(ColorTheme.buttoncolor), onPressed) :
                       Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           buttonAlert(Texts.LBL_CANCELAR, HexColor(ColorTheme.buttoncolor)),
                           SizedBox(width: 10,),
                           buttonAlert(lbl_confirm, Colors.green, onPressed)
                         ],)
                     ],
                   ),
                 ),
               ),
             ),

           ],
         )
     );
     showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => alertDialog);
   }









 }




