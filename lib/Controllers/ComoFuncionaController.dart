import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Constants/Constants.dart';
import '../Utils/HexColor.dart';
import 'BaseController.dart';
import 'package:dotted_line/dotted_line.dart';

class ComoFuncionaController extends BaseController {

  @override
  _ComoFuncionaController createState() => _ComoFuncionaController();

}

class _ComoFuncionaController extends BaseControllerState<ComoFuncionaController> with WidgetsBindingObserver{

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor(ColorTheme.backgroundColor),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark,
            child: GestureDetector(
              onTap: () {FocusScope.of(context).requestFocus(FocusNode());},
              child:  Container(
                height: double.infinity,
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
                      child:  Text("¿Cómo funciona?", textAlign: TextAlign.center, style: TextStyle(color: HexColor(ColorTheme.buttoncolor), fontWeight: FontWeight.bold, fontSize: 20)),
                    ),

                    Expanded(child: SingleChildScrollView(
                      padding: const EdgeInsets.all(17),
                      child:  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 17),
                          Center(child: Image.asset("assets/cupon.png", fit: BoxFit.fitWidth, width: 170)),
                          const SizedBox(height: 17),
                          Text("Recompensa por tus ventas", textAlign: TextAlign.center, style: TextStyle(color: HexColor(ColorTheme.primaryColor), fontWeight: FontWeight.bold, fontSize: 20)),
                          const SizedBox(height: 10),
                          const Text("El registro de tus series de los productos vendidos te permitiran acumular saldo y podrás canjear premios.", textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 16)),

                          Card(
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

                                        Text("\$25", textAlign: TextAlign.start, style: TextStyle(color: HexColor(ColorTheme.secundaryColor), fontWeight: FontWeight.bold, fontSize: 35)),
                                        const SizedBox(width: 10),
                                        Expanded(child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            //Text("Zumos junior", textAlign: TextAlign.start, style: TextStyle(color: HexColor(ColorTheme.secundaryColor), fontWeight: FontWeight.bold, fontSize: 16)),
                                            const Text("Tarjeta favorita", textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 16)),
                                          ],
                                        )),
                                        Icon(Icons.card_giftcard_outlined, color: HexColor(ColorTheme.secundaryColor))

                                      ],
                                    ),

                                    Padding(padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                                        child: Container(width: double.infinity, height: 1, color: Colors.black12)),

                                    Row(
                                      children: [

                                        Text("\$25  ", textAlign: TextAlign.start, style: TextStyle(color: HexColor(ColorTheme.secundaryColor), fontWeight: FontWeight.bold, fontSize: 35)),
                                        const SizedBox(width: 10),
                                        Expanded(child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            //Text("Club Sport", textAlign: TextAlign.start, style: TextStyle(color: HexColor(ColorTheme.primaryColor), fontWeight: FontWeight.bold, fontSize: 16)),
                                            const Text("Tarjeta Produbanco", textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 16)),
                                          ],
                                        )),
                                        Icon(Icons.card_giftcard_outlined, color: HexColor(ColorTheme.secundaryColor))

                                      ],
                                    ),

                                  ],
                                ),
                              )
                          ),

                          const SizedBox(height: 17),
                          const Text("En todas las secciones puedes revisar tu saldo disponible a canjear", textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 17),
                          Card(
                              elevation: 5,
                              color: Colors.amber,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(7),)),
                              child: Container(
                                color: Colors.white,
                                margin: const EdgeInsets.only(left: 13),
                                padding: const EdgeInsets.all(15),
                                child:  Column(
                                  children: [

                                    Row(
                                      children: [
                                        Icon(Icons.wallet_giftcard_outlined, size: 75, color: HexColor(ColorTheme.secundaryColor)),
                                        const SizedBox(width: 10),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text("\$75", textAlign: TextAlign.center, style: TextStyle(color: HexColor(ColorTheme.secundaryColor), fontWeight: FontWeight.bold, fontSize: 30)),
                                                const SizedBox(width: 10),
                                                const Text("Saldo", textAlign: TextAlign.start, style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 20)),
                                              ],
                                            ),
                                            const Text("CÓD: 10993699", textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
                                          ],
                                        )
                                      ],
                                    ),

                                    const SizedBox(height: 10),
                                    const DottedLine(dashLength: 10, dashColor: Colors.black26 ),
                                    const SizedBox(height: 10),
                                    const Text("Período de vigencia de hasta (12 meses), aplican restricciones", textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 13)),

                                  ],
                                ),
                              )
                          ),

                        ],
                      ),
                    ))
                    
                  ],
                )
              )
            )
        )
    );
  }
}
