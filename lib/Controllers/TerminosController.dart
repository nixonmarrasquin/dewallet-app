import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Constants/Constants.dart';
import '../Entities/Sesion.dart';
import '../Models/EventObject.dart';
import '../Models/SolicitarDFAModel.dart';
import '../Models/UpdateDFAModel.dart';
import '../Utils/HexColor.dart';
import '../services/ApiService.dart';
import 'BaseController.dart';
import 'dart:convert' show json;
import 'package:shared_preferences/shared_preferences.dart';

import 'MainController.dart';

  class TerminosController extends BaseController {

    TerminosController() : super();



    @override
  _TerminosController createState() => _TerminosController();

}

class _TerminosController extends BaseControllerState<TerminosController> with AutomaticKeepAliveClientMixin , WidgetsBindingObserver {

  @override
  bool get wantKeepAlive => true;


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
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: GestureDetector(
        onTap: () {FocusScope.of(context).requestFocus(new FocusNode());},
        child: SingleChildScrollView(
          child:Container(
            padding: EdgeInsets.only(top: 25,left: 25,right: 25,bottom: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text("TÉRMINOS Y CONDICIONES DE USO", style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),),
                const SizedBox(height: 5),
                Text("Políticas de privacidad y tratamiento de datos ", style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),),
                const SizedBox(height: 16),
                Text("ELECTRÓNICA SIGLO 21  ha desarrollado los Términos y Condiciones aplicable a nuestra aplicación y al uso de la información contenida en el.  Al navegar, usted está aceptando, sin ninguna limitación, los términos y condiciones aquí descrito. Léalos atentamente.", style: new TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0),),
                const SizedBox(height: 10),
                Text("Propiedad intelectual sobre el contenido de esta aplicación.", style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),),
                const SizedBox(height: 10),
                Text("Al usar este sitio web, usted reconoce que contiene información, comunicaciones, software, fotos, videos, gráficos, música, sonido, imágenes y otros materiales y servicios pertenecientes a ELECTRÓNICA SIGLO 21 .  Usted declara conocer y aceptar que, sin perjuicio que ELECTRÓNICA SIGLO 21  le permite acceder al contenido, el mismo está protegido por normas relativas a la propiedad industrial e intelectual, protección que se extiende a los medios de transmisión existentes hoy o que en el futuro se desarrollen, por lo que el uso del contenido estará regido por las referidas normas de propiedad intelectual e industrial, incluidos los tratados internacionales ratificados por Ecuador. ", style: new TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0),),
                const SizedBox(height: 10),
                Text("Todo el contenido de nuestro sitio está protegido por las leyes de propiedad intelectual ecuatorianas e internacionales. ELECTRÓNICA SIGLO 21  es  titular de la propiedad intelectual de la selección, coordinación, combinación y mejoramiento de dicho contenido. En consecuencia, usted no puede modificar, publicar, transmitir, participar en la transferencia o venta, reproducir, crear trabajos derivados, distribuir, ejecutar, exhibir o en cualquier manera explotar parte alguna del contenido. La distribución en cualquier forma del contenido requiere del consentimiento previo de ELECTRÓNICA SIGLO 21  o de quien sea el titular del derecho de propiedad intelectual respectivo.", style: new TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0),),
                const SizedBox(height: 10),
                Text("Uso de la marca ", style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),),
                const SizedBox(height: 10),
                Text("El nombre y logotipo de ELECTRÓNICA SIGLO 21   y todos los nombres de productos relacionados, diseños de marca y slogan, son marcas registradas de ELECTRÓNICA SIGLO 21.  Usted no está autorizado a utilizar ningún nombre o marca de ELECTRÓNICA SIGLO 21  en la forma de hipertexto que se conecte con cualquier página del sitio Web, o en ningún aviso o publicidad, o en cualquier otra forma comercial sin el consentimiento por escrito de ELECTRÓNICA SIGLO 21. ", style: new TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0),),
                const SizedBox(height: 10),
                Text("Limitación de responsabilidad por uso de la aplicación o por su rendimiento.", style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),),
                const SizedBox(height: 10),
                Text("En la medida que lo permita la legislación aplicable y vigente, ELECTRÓNICA SIGLO 21  no será responsable, con respecto a esta aplicación, o respecto al contenido del mismo o su uso, por los daños o perjuicios causados por (incluyendo pero no limitado a: a) fallas en el rendimiento, errores, omisiones, interrupciones, defectos, demoras en la transmisión, virus computacionales, fallas en las líneas de comunicación, robo, destrucción o acceso no autorizado a esta aplicacion móvil o su alteración, del Contenido incluido en ella, o el uso negligente o, en general, por cualquier motivo.", style: new TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0),),
                const SizedBox(height: 10),
                Text("POLÍTICAS DE PRIVACIDAD ", style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),),
                const SizedBox(height: 10),
                Text("Lea esto con detenimiento. Este documento indica cómo serán utilizados y protegidos sus datos personales por ELECTRÓNICA SIGLO 21 . Al suministrar información personal, cuando navegue por esta aplicación, usted estará aceptando automáticamente las reglas de uso, protección y seguridad que aquí se mencionan.", style: new TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0),),

                const SizedBox(height: 10),
                Text("Seguridad y protección de sus datos personales ", style: new TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0),),
                const SizedBox(height: 10),
                Text("La seguridad de sus datos personales es una prioridad para ELECTRÓNICA SIGLO 21. Esta aplicación pretende ofrecer el más alto nivel de seguridad. Sin embargo, teniendo en consideración las características técnicas de la transmisión de información por Internet, ningún sistema es 100% seguro o exento de ataques.", style: new TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0),),
                const SizedBox(height: 10),
                Text("Su Privacidad", style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),),
                const SizedBox(height: 10),
                Text("ELECTRÓNICA SIGLO 21  respeta su privacidad. Toda información que nos sea proporcionada será tratada con cuidado y con la mayor seguridad posible, y solo será usada de acuerdo con las limitaciones que en este documento se establecen.", style: new TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0),),
                const SizedBox(height: 10),
                Text("¿Cómo es obtenida su información? ", style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),),

                const SizedBox(height: 10),
                Text("ELECTRÓNICA SIGLO 21  sólo obtiene sus datos personales cuando éstos son suministrados directa, voluntaria y conscientemente por usted.", style: new TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0),),
                const SizedBox(height: 10),
                Text("¿Cómo utilizamos su información?", style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),),
                const SizedBox(height: 10),
                Text("ELECTRÓNICA SIGLO 21  utilizará la información que usted suministre: (a) para el propósito específico para el cual usted la ha suministrado; (b) para incrementar nuestra oferta al mercado y hacer publicidad de productos y servicios que pueden ser de interés para usted, incluyendo los llamados para confirmación de su información; y (c) para personalizar y mejorar nuestros productos y servicios.", style: new TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0),),
                const SizedBox(height: 10),
                Text("¿Quién tiene acceso a su información? ", style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),),
                const SizedBox(height: 10),
                Text("ELECTRÓNICA SIGLO 21  tiene el compromiso permanente de presentar nuevas soluciones que mejoren el valor de sus productos y servicios. Esto con el objeto de ofrecer a usted oportunidades especiales de mercado, tales como incentivos y promociones. ELECTRÓNICA SIGLO 21  no comercializa, vende ni alquila su base de datos a otras empresas.", style: new TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0),),
                const SizedBox(height: 10),
                Text("¿Cómo desea usted que se utilice su información? ", style: new TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0),),
                const SizedBox(height: 10),
                Text("Cuando suministre datos personales, usted estará automáticamente autorizando a ELECTRÓNICA SIGLO 21  para usar sus datos personales de conformidad con esta Política de Seguridad y Privacidad.", style: new TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0),),
                const SizedBox(height: 10),
                Text("Recomendaciones generales sobre la protección de su privacidad", style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),),
                const SizedBox(height: 10),
                Text("Le recomendamos desconectarse de nuetra aplicación cuando finalice su uso, de modo que terceras personas no puedan tener acceso a sus datos personales, especialmente cuando otra persona use su celular.  ELECTRÓNICA SIGLO 21  no será responsable si usted hace caso omiso de estas recomendaciones, ni por cualquier daño causado por tal negligencia.", style: new TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0),),
                const SizedBox(height: 10),
                Text("Modificaciones a nuestra Política de Privacidad", style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),),
                const SizedBox(height: 10),
                Text("ELECTRÓNICA SIGLO 21  se reserva el derecho, a su exclusiva discreción de modificar, alterar, agregar a o eliminar cualquier parte de esta política en cualquier momento. Recomendamos a usted revisar esta política cada vez que visite nuestra aplicación.", style: new TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0),),
                const SizedBox(height: 30),

              ],),
          )
        ),
      ),
    );
  }

}

