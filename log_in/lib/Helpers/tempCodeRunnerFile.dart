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


import 'package:charge_points/charge_points.dart';

void main() async {
 
 String f = 'https://api.openchargemap.io/v3/poi/?output=json&key=d3a438d6-7b1a-4e83-9d8b-89288831649e&countrycode=IN&maxresults=2';
 final response = await http.get(Uri.parse(f) , headers:  {'User-Agent':'me' , }); 
  int len=response.body.length;
   String  data=response.body.substring(1,len-1);
   print(response.body);
     final extractedData = jsonDecode(data) ;  
  //  print(extractedData.runtimeType);
 
  
}
