import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:firebase_database/firebase_database.dart';

class MapsReceiver extends StatefulWidget {
  final String deviceid;
  MapsReceiver({Key key, @required this.deviceid}) : super(key: key);
  @override
  State createState() => MapsReceiverState();
}

class MapsReceiverState extends State<MapsReceiver> {

  static final databaseReference = FirebaseDatabase.instance.reference();

  static double currentLatitude = 0.0;
  static double currentLongitude = 0.0;

  static GoogleMapController mapController;

  StreamSubscription subscription;

  Map<String, double> currentLocation = new Map();
  StreamSubscription<Map<String, double>> locationSubcription;

  Location location = new Location();
  String error;

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();

    subscription = FirebaseDatabase.instance
        .reference()
        .child(widget.deviceid)
        .onValue
        .listen((event) {
      setState(() {
        currentLatitude = event.snapshot.value['latitude'];
        currentLongitude = event.snapshot.value['longitude'];
      });
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(event.snapshot.value['latitude'], event.snapshot.value['longitude']), zoom: 17),
        ),
      );
      mapController.addMarker(
        MarkerOptions(
          position: LatLng(event.snapshot.value['latitude'], event.snapshot.value['longitude']),
        ),
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(title: const Text('Reciver')),
        body: Padding(
          padding: EdgeInsets.all(0),
          child: Column(
            children: <Widget>[
              Container(
                child: SizedBox(
                  width: double.infinity,
                  height: 350.0,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(target: LatLng(currentLatitude, currentLongitude),
                        zoom: 17),
                    onMapCreated: _onMapCreated,
                  ),
                ),
              ),
              Container(
                child: Text('Lat/Lng: $currentLatitude/$currentLongitude'),
              ),
              Text("Device ID: ${widget.deviceid}")
            ],
          ),
        )
    );
  }
}