import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

import 'package:device_id/device_id.dart';
import 'package:firebase_database/firebase_database.dart';

class MapsReceiver extends StatefulWidget {
  @override
  State createState() => MapsReceiverState();
}

class MapsReceiverState extends State<MapsReceiver> {

  static final databaseReference = FirebaseDatabase.instance.reference();

  static GoogleMapController mapController;

  var subscription = FirebaseDatabase.instance
      .reference()
      .child('aef81f6ac80fd7d8')
      .onValue
      .listen((event) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(event.snapshot.value['latitude'], event.snapshot.value['longitude']), zoom: 10),
      ),
    );
    mapController.clearMarkers();
    mapController.addMarker(
      MarkerOptions(
        position: LatLng(event.snapshot.value['latitude'], event.snapshot.value['longitude']),
      ),
    );
  });

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

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

  @override
  void initState(){
    super.initState();
    initDeviceId();
    currentLocation['latitude'] = 0.0;
    currentLocation['longitude'] = 0.0;

    initPlatformState();
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
        appBar: AppBar(title: const Text('Google Maps Flutter')),
        body: Padding(
          padding: EdgeInsets.all(0),
          child: Column(
            children: <Widget>[
              Container(
                child: SizedBox(
                  width: double.infinity,
                  height: 200.0,
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
              Text("Device ID: $_deviceid")
            ],
          ),
        )
    );
  }
}