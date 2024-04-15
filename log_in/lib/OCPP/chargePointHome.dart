import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:log_in/OCPP/chargePoint.dart'; 
import 'dart:convert';
import 'package:http/http.dart' as http; 
final firebaseApp = Firebase.app();
final rtdb = FirebaseDatabase.instanceFor(app: firebaseApp, databaseURL: 'https://my-project-1579067571295-default-rtdb.firebaseio.com/');



 class ChargePointHome extends StatefulWidget {
  @override
  _ChargePointHome createState() => _ChargePointHome();
}

class _ChargePointHome extends State<ChargePointHome> {
 List<List<String>> tableData = [
 ['chargingPointVendor', 'chargingPointModel', 'Status', 'EnergyUsed'],
  ];
  
  void initState() { 
    super.initState(); 
     
  readData();  
  } 
  
  bool isLoading = true; 
 
  Future<void> readData() async { 
      
    // Please replace the Database URL 
    // which we will get in “Add Realtime Database”  
    // step with DatabaseURL 
      
    var url = "https://my-project-1579067571295-default-rtdb.firebaseio.com/"+"chargePoint.json"; 
   
    try { 
      final response = await http.get(Uri.parse(url)); 
      final extractedData = json.decode(response.body) as Map<String, dynamic>; 
      if (extractedData == null) { 
        return; 
      } 
      extractedData.forEach((key, value) { 
       tableData.add([value['chargingPointVendor'].toString(),value['chargingPointModel'].toString(),'available','0']);
      }); 
      setState(() { 
        isLoading = false; 
      }); 
    } catch (error) { 
      print(error); 
    } 
  } 

 


   
   
            // final ref = FirebaseDatabase.instance.ref();
//     final vendorname = await ref.child('chargePoint/pj1/chargingPointVendor').get();
// final modelname = await ref.child('chargePoint/pj1/chargingPointModel').get();


//   ref.onValue.listen((event) {
//   for (final child in event.snapshot.children) {
//      final vendorname =  child.child('chargingVendor');
// final modelname = child.child('chargingPoint/chargingPointModel');
// tableData.add([  vendorname.value.toString() ,modelname.value.toString(), 'Unavailable', '0 kWh']);
//   }
// }, onError: (error) {
//  print('error');
// });

//  print('hii');
//             tableData.add([  vendorname.value.toString() ,modelname.value.toString(), 'Unavailable', '0 kWh']);
          




 
@override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Charge Points Nearby'),
        ),
       body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columns: List.generate(
              4,
              (index) => DataColumn(
                label: Text( tableData[0][index] ),
              ),
            ),
            rows: List.generate(
              tableData.length - 1,
              (rowIndex) => DataRow(
                cells: List.generate(
                  tableData[rowIndex + 1].length,
                  (cellIndex) => DataCell(
                    Text(tableData[rowIndex + 1][cellIndex]),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      
      
    );
  }
}