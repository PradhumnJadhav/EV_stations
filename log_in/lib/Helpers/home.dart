import 'dart:convert';
// import 'package:charge_points/charge_points.dart';
// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class RetivePoiParams {
//   final BoundingBox boundingBox;
//   final String countryCode;
//   final List<String> countryID;

//   RetivePoiParams()
//       : boundingBox = _setUpBoundingBox(),
//         countryCode = 'IT',
//         countryID = ['IT', 'US'];

//   static _setUpBoundingBox() {
//     final Corner topLeft = Corner(90, -180);
//     final Corner bottomRight = Corner(-90, 180);
//     return BoundingBox(topLeft, bottomRight);
//   }
// }

// class _MyHomePageState extends State<MyHomePage> {

//   getData() async { 
      
//     // Please replace the Database URL 
    
//   final String key = 'd3a438d6-7b1a-4e83-9d8b-89288831649e';
//   final ChargePointsClient client = ChargePointsClient(key);
//    final RetivePoiParams params = RetivePoiParams();
//   final List<POI> list = await client.retrievePoiList(
//     params.boundingBox,
//     params.countryCode,
//     params.countryID,
//   );
//   print(list); 
//   } 

 
   
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body:  Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//            children:   [
//             TextButton(onPressed: getData() , child:Text('Get'))
//            ]
            
           
//         ),
       
//     );
//   }
// }
 
 
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
 
import 'package:charge_points/charge_points.dart';



extendProfile(String email,String name)async{
 final firebaseApp = Firebase.app();
final rtdb = FirebaseDatabase.instanceFor(
    app: firebaseApp,
    databaseURL:
        'https://my-project-1579067571295-default-rtdb.firebaseio.com/');

  String  path='user/' + name  ;

DatabaseReference ref = FirebaseDatabase.instance.ref(path);

await ref.set({'name':name ,'email':email});
}
  
  void main()async{
     print("hhii");
    extendProfile('pradhumn@gmail.com', 'Pradhumn');
    print("hhii");

  }
