import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:log_in/Users%20services/login.dart';
import 'package:log_in/Helpers/ui_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:log_in/Helpers/home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:log_in/Maps/mapPage.dart';

class Mysplash extends StatefulWidget {
  const Mysplash({Key? key}) : super(key: key);

  @override
  _MysplashState createState() => _MysplashState();
}

class _MysplashState extends State<Mysplash>
    with SingleTickerProviderStateMixin {

    @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  
    Future.delayed(Duration(seconds: 3), () {
      
if (FirebaseAuth.instance.currentUser != null) {
     Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) =>   SimpleMap(),
      ),
       ); 


} else {
   Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => const MyLogin(),
      ),
       );  
}

 


    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 223, 128, 3),Colors.blue],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.car_rental,
            size: 80,
            color: Colors.white,
            ),
            SizedBox(height: 20),
            Text('             EV\nCharging Stations', style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.white,
              fontSize: 35,
            ),
            ),
          ],
        ),
      ),

    );
  }
}