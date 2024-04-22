import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:log_in/OCPP/chargingPoint_control.dart';
 
final firebaseApp = Firebase.app();
final rtdb = FirebaseDatabase.instanceFor(app: firebaseApp, databaseURL: 'https://my-project-1579067571295-default-rtdb.firebaseio.com/');
 
class ChargePoint extends StatefulWidget {
  @override
  _ChargePoint createState() => _ChargePoint();
}

class _ChargePoint extends State<ChargePoint> {
putDataCP( TextEditingController vendor ,TextEditingController model,TextEditingController uid,FirebaseDatabase rtdb)async{

if(uid.text.toString()=="" ||  model.text.toString()=="" || vendor.text.toString()=="" ){
  print("hiii");
  return ;}


final data={
  "uid":    uid.text.toString(),
"chargingPointVendor":vendor.text.toString(),
"chargingPointModel":model.text.toString(),
"lattitde":   (lattitude.text.toString()),
"longitude":  longitude.text.toString(),
'status':'unavailable',
'rating':'10'

};
String  path='chargePoint/'  + (uid.text.toString()) ;

DatabaseReference ref = FirebaseDatabase.instance.ref(path);
await ref.set(data);
print(path);
}

  TextEditingController vendor=      TextEditingController();
  TextEditingController model=       TextEditingController();
  TextEditingController uid=         TextEditingController();
  TextEditingController lattitude=   TextEditingController();
  TextEditingController longitude=   TextEditingController();


@override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add a new Charge Point'),
        ),
        body: Column  (

          children:[
            
            TextField(
                            controller:uid,
                            style: TextStyle(),
                            obscureText: false,
                            decoration: InputDecoration(
                                fillColor:
                                    const Color.fromARGB(255, 254, 254, 254),
                                filled: true,
                                hintText: 'Charging Point  unique id ',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
          TextField(
                            controller:vendor,
                            style: TextStyle(),
                            obscureText: false,
                            decoration: InputDecoration(
                                fillColor:
                                    const Color.fromARGB(255, 254, 254, 254),
                                filled: true,
                                hintText: 'Charging Point Vendor ',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
              TextField(
                            controller:model,
                            style: TextStyle(),
                            obscureText: false,
                            decoration: InputDecoration(
                                fillColor:
                                    const Color.fromARGB(255, 254, 254, 254),
                                filled: true,
                                hintText: 'Charging Point Model ',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                           TextField(
                            
                            controller:lattitude,
                            style: TextStyle(),
                            obscureText: false,
                            decoration: InputDecoration(
                                fillColor:
                                    const Color.fromARGB(255, 254, 254, 254),
                                filled: true,
                                hintText: 'lattitude ',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                           TextField(
                            controller:longitude,
                            style: TextStyle(),
                            obscureText: false,
                            decoration: InputDecoration(
                                fillColor:
                                    const Color.fromARGB(255, 254, 254, 254),
                                filled: true,
                                hintText: 'longitude ',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
         FloatingActionButton(
        onPressed: () {
          putDataCP(vendor,model,uid,rtdb);
            Navigator.pushNamed(context, 'charingPointControl');
        },
        child: Text('Add'),
      ),
    ]
    )
    );
  }
}