import 'dart:async';
import 'package:log_in/Maps/mapPage2.dart';
import 'package:log_in/payment_config.dart';
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
import 'package:google_maps_flutter_platform_interface/src/types/bitmap.dart';
import 'package:pay/pay.dart';

const _paymentItems = [
  PaymentItem(
    label: 'Total',
    amount: '99.99',
    status: PaymentItemStatus.final_price,
  )
];

var googlePayButton = GooglePayButton(
  paymentConfiguration: PaymentConfiguration.fromJsonString(defaultGooglePay),
  paymentItems: const [
    PaymentItem(
      label: 'Total',
      amount: '0.01',
      status: PaymentItemStatus.final_price,
    )
  ],
  type: GooglePayButtonType.pay,
  margin: const EdgeInsets.only(top: 15.0),
  onPaymentResult: (result) => debugPrint('Payment Result $result'),
  loadingIndicator: const Center(
    child: CircularProgressIndicator(),
  ),
);

final firebaseApp = Firebase.app();
final rtdb = FirebaseDatabase.instanceFor(
    app: firebaseApp,
    databaseURL:
        'https://my-project-1579067571295-default-rtdb.firebaseio.com/');

final socket = WebSocket(Uri.parse('ws:// 172.20.60.16:9000/test1'),
    timeout: Duration(seconds: 30));

class SimpleMap extends StatefulWidget {
  @override
  _SimpleMapState createState() => _SimpleMapState();
}

class _SimpleMapState extends State<SimpleMap> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kInitialPosition = CameraPosition(
      target: LatLng(23.25941, 77.41225), zoom: 4, tilt: 0, bearing: 0);

  final TextEditingController _serverController = TextEditingController();

  String userName = "";
  String userEmail = "";

  pushData(int data, DatabaseReference ref, WebSocket socket) async {
    socket.send('[2, "12345", "Authorize", { "idTag":"pradhumn"   }]');
    socket.messages.listen((message) {
      print(message);
    });

    Navigator.pushNamed(context, 'chargePointHome');
  }

 getDetails() async {
 
try{

 String f = 'https://api.openchargemap.io/v3/poi/?output=json&key=d3a438d6-7b1a-4e83-9d8b-89288831649e&countrycode=IN&maxresults=300';
 
 final response = await http.get(Uri.parse(f) , headers:  {'User-Agent':'me' , }); 
 final extractedData = jsonDecode(response.body)  ;  
  int n=300;
    BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/charging.png');
  for(int i=0;i<n;i++){
      final uid = extractedData[i]['AddressInfo']['Title'];
      final latitude= extractedData[i]['AddressInfo']['Latitude'];
      final longitude=extractedData[i]['AddressInfo']['Longitude'];
      final powerKW=extractedData[i]['Connections'][0]['PowerKW'];
      final status=extractedData[i]['StatusType']["IsOperational"];
       final mar = Marker(
            onTap: () {
              _showBottomSheet(context,uid, powerKW,status);
            },
            markerId: MarkerId(uid),
            position: LatLng( latitude,
                 longitude,
                ),
           icon:markerIcon,
           infoWindow: InfoWindow(
            title: uid.toString(),
           ),

       );
            
        myMarker.add(mar);

  }}
  catch (error) {
       print(error);
        }
  
   
}

  signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const MyLogin(),
      ),
    );
  }

  mapsat() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => SimpleMap1(),
      ),
    );
  }

  addTodata() async {
    Navigator.pushNamed(context, 'chargePoint');
  }

  mapUpdate() async {
    final user = await FirebaseAuth.instance.currentUser;
    userEmail = "${user?.email}";
    userName = '${user?.email}';

    final List<Marker> mark = [];
    var url = "https://my-project-1579067571295-default-rtdb.firebaseio.com/" +
        "chargePoint.json";
    // Do not remove “data.json”,keep it as it is

    BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/charging.png');

    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((key, value) {
        //  tableData.add([value['chargingPointVendor'],value['chargingPointModel'],'available','0']);

        final mar = Marker(
            onTap: () {
              _showBottomSheet(context, 'Pranab ltd ' , '10KW','Operational' );
            },
            markerId: MarkerId(value['uid']),
            position: LatLng(double.parse(value['lattitde'].toString()),
                double.parse(value['longitude'].toString())),
            icon: markerIcon,
            
            infoWindow: const InfoWindow(
              title: 'EV Station',
            ));
        myMarker.add(mar);
      });
    } catch (error) {
       print( error);
        }

 
  }

  getProfile() async {
    var url = "https://my-project-1579067571295-default-rtdb.firebaseio.com/" +
        "user.json";
    // Do not remove “data.json”,keep it as it is
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((key, value) {
        if (value['email'].toString() == userEmail) {
          userName = value['name'];
        }
      });
    } catch (error) {
      print(error);
    }
  }

  final List<Marker> myMarker = [];
  final List<Marker> markerList = [];

  @override
  void initState() {
    super.initState();
    mapUpdate();
    myMarker.addAll(markerList);
    packdata();
    getProfile();
    getDetails();
  }

  Future<Position> getUserLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print('error$error');
    });

    return await Geolocator.getCurrentPosition();
  }

//
  packdata() {
    getUserLocation().then((value) async {
      // print('My Location');
      // print('${value.latitude} ${value.longitude}');

      myMarker.add(Marker(
          markerId: MarkerId('first'),
          position: LatLng(value.latitude, value.longitude),
          infoWindow: const InfoWindow(
            title: 'Current Location',
          )));

      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 15,
      );

      final GoogleMapController controller = await _controller.future;

      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(userName, style: TextStyle(fontSize: 22)),
                accountEmail: Text(userEmail, style: TextStyle(fontSize: 14)),
                currentAccountPicture: CircleAvatar(
                  radius: 25,
                  child: const Icon(Icons.person_2_rounded),
                ),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(10, 119, 208, 1),
                ),
              ),
              ListTile(
                leading: Icon(Icons.add_location),
                title: Text(
                  'Stations Nearby',
                  style: TextStyle(
                      // decoration: TextDecoration.underline,
                      color: Colors.black,
                      fontSize: 23),
                ),
                onTap: () {
                  DatabaseReference ref =
                      FirebaseDatabase.instance.ref("users/123");
                  pushData(12, ref, socket);
                },
              ),
              ListTile(
                leading: Icon(Icons.compare_outlined),
                title: Text(
                  'Satellite Map',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      // decoration: TextDecoration.underline,
                      color: Colors.black,
                      fontSize: 23),
                ),
                onTap: mapsat,
              ),
              ListTile(
                leading: Icon(Icons.autorenew),
                title: Text(
                  'Refresh',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      // decoration: TextDecoration.underline,
                      color: Colors.black,
                      fontSize: 23),
                ),
                onTap: mapUpdate,
              ),
              ListTile(
                leading: Icon(Icons.library_add_outlined),
                title: Text(
                  'List a Charger',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      // decoration: TextDecoration.underline,
                      color: Colors.black,
                      fontSize: 23),
                ),
                onTap: addTodata,
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text(
                  'Sign Out',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      // decoration: TextDecoration.underline,
                      color: Colors.black,
                      fontSize: 23),
                ),
                onTap: signOut,
              ),
            ],
          ),
          backgroundColor: Color.fromRGBO(230, 224, 224, 1),
        ),
        appBar: AppBar(
          title: const Text('EV Charging station',
              style: TextStyle(
                  letterSpacing: 1.5,
                  fontSize: 20,
                  color: Color.fromARGB(255, 235, 232, 232))),
          elevation: 0,
          backgroundColor: Color.fromRGBO(10, 119, 208, 1),
        ),
        body: Stack(children: [
          GoogleMap(
            initialCameraPosition: _kInitialPosition,
            mapType: MapType.normal,
            markers: Set<Marker>.of(myMarker),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Container(
            padding: EdgeInsets.fromLTRB(8.0, 700, 0, 0),
            child: FloatingActionButton(
              onPressed: () {
                packdata();
              },
              child: const Icon(Icons.radio_button_checked_sharp),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ]));
  }
}

void _showBottomSheet(BuildContext context , String name,String power,String status) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Station Name: $name ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Text(
              'Power: $power ', // Replace with actual power value
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            Text(
              'Status: $status ',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter, child: googlePayButton),
            ),
          ],
        ),
      );
    },
  );
}
// void _handlePayment(BuildContext context) {
//   // Implement Google Pay payment logic here
//   // For demonstration purposes, let's just navigate back to the home page
//   Navigator.pop(context); // Close the bottom sheet
//   Navigator.pushReplacement( // Navigate to the home page
//     context,
//     MaterialPageRoute(builder: (context) => HomePage()),
//   );
// }

