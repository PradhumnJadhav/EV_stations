import 'dart:async';
import 'dart:io';
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
import 'package:log_in/Helpers/ui_helper.dart';

final firebaseApp = Firebase.app();
final rtdb = FirebaseDatabase.instanceFor(app: firebaseApp, databaseURL: 'https://my-project-1579067571295-default-rtdb.firebaseio.com/');

 final socket = WebSocket(Uri.parse('ws:// 172.20.60.16:9000/pj5'),
    timeout: Duration(seconds: 30));
 
class ChargePointControl extends StatefulWidget {

// DatabaseReference ref = FirebaseDatabase.instance.ref('chargePoint');
 




  @override
  __ChargePointControl createState() => __ChargePointControl();
  
}

class __ChargePointControl extends State<ChargePointControl> {
//  final text="null";
// final uid="pj5";
TextEditingController id=TextEditingController();
TextEditingController meter=TextEditingController();

String userName ="";
String userEmail="" ;
final data={
 
"chargingPointVendor":'unknown',
"chargingPointModel":'unknown',
 

};

getProfile()async{
   final user =  await FirebaseAuth.instance.currentUser;
    userEmail="${user?.email}";
    userName='pj5';
   var url = "https://my-project-1579067571295-default-rtdb.firebaseio.com/"+"user.json"; 
    // Do not remove “data.json”,keep it as it is 
    try { 
      final response = await http.get(Uri.parse(url)); 
      final extractedData = json.decode(response.body) as Map<String, dynamic>; 
      if (extractedData == null) { 
        return; 
      } 
      extractedData.forEach((key, value) { 
       
       if(value['email'].toString()==userEmail){
        userName=value['name'];
       }
       
    
       
       
}) ;
    } catch (error) { 
      throw error; 
    } 


    
 


}
   readData( ) async { 
      
    // Please replace the Database URL 
    // which we will get in “Add Realtime Database”  
    // step with DatabaseURL 
      // DatabaseReference ref = FirebaseDatabase.instance.ref("chargePoint/${id.text.toString()}");
final ref = FirebaseDatabase.instance.ref();
final model = await ref.child('chargePoint/${id.text.toString()}/chargingPointModel').get();
final vendor = await ref.child('chargePoint/${id.text.toString()}/chargingPointVendor').get();
if (model.exists && vendor.exists) {
      data['chargingPointVendor']=vendor.value.toString() ;
      data['chargingPointModel']= model.value.toString();
      print(data['chargingPointVendor']);
} else {
    print('No data available.');
}
     
       
      
    // var url = "https://my-project-1579067571295-default-rtdb.firebaseio.com/"+"chargePoint.json"; 
   
    // try { 
    //   final response = await http.get(Uri.parse(url)); 
    //   final extractedData = json.decode(response.body) as Map<String, dynamic>; 
    //   if (extractedData == null) { 
    //     return; 
    //   } 
    //   extractedData.forEach((key, value) { 
    //   //  tableData.add([value['chargingPointVendor'].toString(),value['chargingPointModel'].toString(),'available','0']);
    //   print(id.text.toString());
    //   if(key==id.text.toString()){
       
    //     data['chargingPointVendor']=value['chargingPointVendor'].toString();
    //     data['chargingPointModel']=value['chargingPointModel'].toString();
    //   }
      
    //   }); 
     
     
    // } catch (error) { 
    //   throw error;
    // } 
  } 

@override
 void initState() {
     super.initState();
// readData();
   
  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Charging Point"),
        ),
        body: Column  (

          children:[ TextField(
             
        controller: id,
        textAlign: TextAlign.center,
         decoration: InputDecoration(hintText: "enter charge point uid "),
      ),
             TextButton(
              
            //  style: ButtonStyle(m
            
            
        onPressed: () {
                  print(id.text.toString());
                  readData();
                  if(data['chargingPointVendor']!="unknown" && data['chargingPointModel']!="unknown"  ){
                    print('object');
             socket.send('[ 2,"12345", "BootNotification", {"chargePointVendor":"${data['chargingPointVendor']}", "chargePointModel": "${data['chargingPointModel']}"}]');
             
                  }
              socket.messages.listen((message) async{
                
              DatabaseReference ref = FirebaseDatabase.instance.ref("chargePoint/${id.text.toString()}");
 
              await ref.update({
                   'status':message.toString().contains('Accepted') ? 'Accepted' : 'Rejected',
                                       } );

       showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("recieving message.."),
            actions: [
              Container(
                // color: const Color.fromARGB(255, 255, 21, 21),
                child:
                         TextButton(
                
                 child: Text(message ),
                 onPressed:  () {
                    Navigator.pushNamed(context,'charingPointControl');
                  }
                   
              ),
              ),
            ],
          );
        }  );
    });
   
        },
        child:Container(
          // padding: EdgeInsets.fromLTRB(99, 10, 30, 90),
// color: Color.fromRGBO(255, 0, 0, 2),
          child:  Text("Send BootNotification",textAlign: TextAlign.center,),
        )
     
      ),
  //      TextButton(onPressed:(){

  //          socket.send([ 2,"12345", "StatusNotification", {
  //  "connectorId": 1,"errorCode": "NoError","status": "Preparing","timestamp": "2022-06-12T09:13:00.515Z"}]);
  //       socket.messages.listen((message) async{
  //                  print("Status sent");
                  
             
  //             });
  //      }
  //    , child:Text('Send Status Notification',
  //                   textAlign: TextAlign.left,
  //                                 style: TextStyle(
  //                                     decoration: TextDecoration.none,
  //                                     color: Color.fromARGB(255, 255, 0, 0),
  //                                     fontSize: 18),
  //                               ),
    //  ),
      // TextField(
            
      //   controller: meter,
      //   textAlign: TextAlign.center,
      // ),
     

      
     TextButton(onPressed:(){
        getProfile();
        
         print('Transaction started ....');
                   
       socket.send('[ 2,"12345", "StartTransaction", { "connectorId":0 , "idTag":"${userName}"  ,"meterStart":0,"timestamp":"0" }]');
        socket.messages.listen((message) async{
                   print(message);
                   if(message.toString().contains('Accepted') ){
                     
                   }  
                  
             
              });
             

     }
            
     , child:Text('Start Transaction'),

     ),
  TextButton(onPressed:(){
int meterStop=0;

          for(int i=0;i<10 ;i++){
            for(int j=0;j<100000000;j++ ){

             
            } meterStop++;
          }
            (socket.send('[2,"12345", "StopTransaction", {   "idTag":"$userName"  ,"meterStop":$meterStop,"timestamp":"0" ,"transactionId":1 ,"reason":"Other"}]'));
                    socket.messages.listen((message) async{
                            print(message);

                    });
       }
     , child:Text('Stop  Transaction',
                    textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: Color.fromARGB(255, 255, 0, 0),
                                      fontSize: 18),
                                ),
     ),
      // TextField(
            
      //   controller: meter,
      //   textAlign: TextAlign.center,
      // ),
     

     
        TextButton(
        onPressed: () {
          
            Navigator.pushNamed(context, 'chargePointHome');
        },
        child: Text('Home'),
      ),   
          
      
    ]
    )
    );
  }
}