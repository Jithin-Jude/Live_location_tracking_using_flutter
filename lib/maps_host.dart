import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

import 'package:device_id/device_id.dart';
import 'package:firebase_database/firebase_database.dart';

class MapsDemo extends StatefulWidget {

  @override
  State createState() => MapsDemoState();
}

class MapsDemoState extends State<MapsDemo> {

  void showSnackBar(BuildContext context){
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text("done"),
    ));
  }

  final databaseReference = FirebaseDatabase.instance.reference();

  GoogleMapController mapController;

  Map<String, double> currentLocation = new Map();
  StreamSubscription<Map<String, double>> locationSubcription;

  Location location = new Location();
  String error;

  String _deviceid = 'Unknown';

  Future<void> initDeviceId() async {
    String deviceid;

    deviceid = await DeviceId.getID;

    if (!mounted) return;

    setState(() {
      _deviceid = deviceid;
    });
  }

  void UpdateDatabase(){
    databaseReference.child(_deviceid).set({
      'latitude': currentLocation['latitude'],
      'longitude': currentLocation['longitude'],
    });
  }

  @override
  void initState(){
    super.initState();
    initDeviceId();
    currentLocation['latitude'] = 0.0;
    currentLocation['longitude'] = 0.0;

    initPlatformState();
    locationSubcription = location.onLocationChanged().listen((Map<String, double> result){
      setState(() {
        currentLocation = result;
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(currentLocation['latitude'], currentLocation['longitude']), zoom: 10),
          ),
        );
        mapController.clearMarkers();
        mapController.addMarker(
          MarkerOptions(
            position: LatLng(currentLocation['latitude'], currentLocation['longitude']),
          ),
        );
      });
      UpdateDatabase();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
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


  @override
  Widget build(BuildContext context) {



    return Scaffold(
        appBar: AppBar(title: const Text('Host')),
        body: Builder(
            builder: (context) =>
                Padding(
                  padding: EdgeInsets.all(0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: SizedBox(
                          width: double.infinity,
                          height: 350.0,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(target: LatLng(currentLocation['latitude'], currentLocation['longitude']),
                                zoom: 10),
                            onMapCreated: _onMapCreated,
                          ),
                        ),
                      ),
                      Container(
                        child: Text('Lat/Lng: ${currentLocation['latitude']}/${currentLocation['longitude']}'),
                      ),
                      Text("Device ID: $_deviceid"),
                    ],
                  ),
                )
        )
    );
  }
}