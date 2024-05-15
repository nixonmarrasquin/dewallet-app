import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:siglo21/Constants/Constants.dart';
import 'package:siglo21/Controllers/LoginController.dart';
import '../Utils/HexColor.dart';
import 'BaseController.dart';
import 'MainController.dart';

class IniciaController extends BaseController {

  @override
  _IniciaController createState() => _IniciaController();

}

class _IniciaController extends BaseControllerState<IniciaController> with WidgetsBindingObserver {

  bool isloading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance!.addObserver(this);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getUser();
    }
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  getUser() async {
    setState(() {
      isloading = true;
    });

    await database.then((onValu){
      final result =  onValu.sesionDao.getSesion();
      if (result != null){
        result.then((data) {
          if (data != null){
            if (data.length > 0){
              App.LISTA_PRECIO = data[0]!.lista_precio ?? 0;
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainController(isLogin: false,)));
            } else {
              setState(() {
                isloading = false;
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginController()));
              });
            }
          }else {
            setState(() {
              isloading = false;
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginController()));
            });
          }

        }, onError: (e) {
          print("Error: "+e.toString());
          setState(() {
            isloading = false;
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginController()));
          });
        });
      }else{
        setState(() {
          isloading = false;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginController()));
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: HexColor('D11E22'),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: HexColor(ColorTheme.primaryColor),
          child: Stack(
            children: [

              Center(
                child: Container(
                  width:  MediaQuery.of(context).size.width / 2,
                  child: Image.asset('assets/logo.png'),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
