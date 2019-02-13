import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
        appBar: AppBar(title: const Text('Google Maps Flutter')),
        body: MapsDemo(),
    )
    );
  }
}

class MapsDemo extends StatefulWidget {
  @override
  State createState() => MapsDemoState();
}

class MapsDemoState extends State<MapsDemo> {

  GoogleMapController mapController;

  Map<String, double> currentLocation = new Map();
  StreamSubscription<Map<String, double>> locationSubcription;

  Location location = new Location();
  String error;

  @override
  void initState(){
    super.initState();

    currentLocation['latitude'] = 0.0;
    currentLocation['longitude'] = 0.0;

    initPlatformState();
    locationSubcription = location.onLocationChanged().listen((Map<String, double> result){
      setState(() {
        currentLocation = result;
      });
    });
  }


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.all(0),
      child: Column(
        children: <Widget>[
          Container(
            child: SizedBox(
              width: double.infinity,
              height: 400.0,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(target: LatLng(45.521563, -122.677433)),
                onMapCreated: _onMapCreated,
              ),
            ),
          ),
          Container(
            child: Text('Lat/Lng: ${currentLocation['latitude']}/${currentLocation['longitude']}'),
          )
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() { mapController = controller; });
  }

  void initPlatformState() async {
    Map<String, double> my_location;
    try{
      my_location = await location.getLocation();
      error = "";
    }on PlatformException catch(e){
      if(e.code == 'PERMISSION_DENIED')
        error = 'Permission Denied';
      else if(e.code == 'PERMISSION_DENIED_NEVER_ASK')
        error = 'Permission denied - please ask the user to enable it from the app settings';
      my_location = null;
    }
    setState(() {
      currentLocation = my_location;
    });
  }
}