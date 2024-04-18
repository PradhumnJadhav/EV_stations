import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:log_in/Helpers/home.dart';
import 'package:log_in/l10n/l10n.dart';
import 'package:log_in/Users%20services/login.dart';
import 'package:log_in/Users%20services/register.dart';
import 'package:log_in/Users%20services/resetPassword.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:log_in/splash_screen.dart';
import 'package:log_in/Maps/mapPage.dart';
import 'package:log_in/OCPP/chargePoint.dart';
//import 'package:log_in/Maps/info.dart';
 
import 'package:log_in/OCPP/chargePointHome.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'splash_screen',
    routes: {
      'login': (context) => MyLogin(),
      'register': (context) => MyRegister(),
      'splash_screen': (context) => Mysplash(),
      'flutter': (context) => HomePage(title: 'flutter'),
      'map': (context)=> SimpleMap(),
      'resetPassword':(context)=> ResetPasswordPage(),
      'chargePoint' :(context) => ChargePoint(),
      'chargePointHome' :(context) => ChargePointHome(),
      'SimpleMap' :(context) => SimpleMap(),
      //'stationPage': (context)=> StationPage(),
    },
    supportedLocales: L10n.all,
    localizationsDelegates: [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
  ));
}
