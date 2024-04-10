import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:log_in/OCPP/chargePoint.dart'; 
final firebaseApp = Firebase.app();
final rtdb = FirebaseDatabase.instanceFor(app: firebaseApp, databaseURL: 'https://my-project-1579067571295-default-rtdb.firebaseio.com/');


 List<List<String>> tableData = [
 ['chargingPointVendor', 'chargingPointModel', 'Status', 'EnergyUsed'],
  ];
 class ChargePointHome extends StatefulWidget {
  @override
  _ChargePointHome createState() => _ChargePointHome();
}

class _ChargePointHome extends State<ChargePointHome> {


 


   addToTable()async{
   
            final ref = FirebaseDatabase.instance.ref();
    final vendorname = await ref.child('chargePoint/pj1/chargingPointVendor').get();
final modelname = await ref.child('chargePoint/pj1/chargingPointModel').get();

 

            tableData.add([  vendorname.value.toString() ,modelname.value.toString(), 'Unavailable', '0 kWh']);
          


}

 
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            Navigator.pushNamed(context, 'chargePoint');
           },
        child: Icon(Icons.add),
      ),
    );
  }
}