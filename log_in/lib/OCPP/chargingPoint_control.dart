import 'dart:async';
import 'package:log_in/Maps/mapPage2.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:log_in/Users%20services/login.dart';
import 'package:web_socket_client/web_socket_client.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; 
import 'package:profile/profile.dart';



final firebaseApp = Firebase.app();
final rtdb = FirebaseDatabase.instanceFor(app: firebaseApp, databaseURL: 'https://my-project-1579067571295-default-rtdb.firebaseio.com/');
 
 final socket = WebSocket(Uri.parse('ws://172.20.32.55:9000/test1'),
    timeout: Duration(seconds: 30));


class _ChargePointControl extends StatefulWidget {

DatabaseReference ref = FirebaseDatabase.instance.ref('chargingPoint');
 



  @override
  __ChargePointControl createState() => __ChargePointControl();
}

class __ChargePointControl extends State<_ChargePointControl> {
 final text="null";
@override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(text),
        ),
        body: Column  (

          children:[
             FloatingActionButton(
        onPressed: () {
          
             socket.send('[ 2,"12345", "BootNotification", {"chargePointVendor":${2}, "chargePointModel": ${2}}]');
        },
        child: Text(text),
      ),
           FloatingActionButton(
        onPressed: () {
          
            Navigator.pushNamed(context, 'chargePointHome');
        },
        child: Text('Add'),
      ),   
         FloatingActionButton(
        onPressed: () {
          
            Navigator.pushNamed(context, 'chargePointHome');
        },
        child: Text('Add'),
      ),
    ]
    )
    );
  }
}