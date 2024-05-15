import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:siglo21/Controllers/IniciaController.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'Constants/Constants.dart';
import 'Utils/HexColor.dart';
import 'dart:io' show Platform;

void main() {
  runApp(const Siglo21App());

  if (Platform.isAndroid) {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
  }

}

class Siglo21App extends StatelessWidget {
  const Siglo21App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.amber,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,));

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      localizationsDelegates: const [
        //GlobalMaterialLocalizations.delegate
      ],
      debugShowCheckedModeBanner: false,
      title:App.NAME_APP,
      theme:ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        cardColor: Colors.white,
        buttonTheme: ButtonThemeData(
          buttonColor: HexColor(ColorTheme.buttoncolor),
          textTheme: ButtonTextTheme.primary,
        ),
        unselectedWidgetColor: HexColor(ColorTheme.buttoncolor),
        fontFamily: Texts.FONT_FAMILY,
        primaryColor: HexColor(ColorTheme.buttoncolor),
        primarySwatch: createMaterialColor(HexColor(ColorTheme.buttoncolor)),

      ),
      home: IniciaController(),
    );
  }

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }
}
