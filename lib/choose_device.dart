import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter_maps/maps_receiver.dart';

class ChooseDevice extends StatefulWidget {
  @override
  State createState() => ChooseDeviceState();
}

class ChooseDeviceState extends State<ChooseDevice> {

  static final databaseReference = FirebaseDatabase.instance.reference();

  static double currentLatitude = 0.0;
  static double currentLongitude = 0.0;

  StreamSubscription subscription;

  Map<String, double> currentLocation = new Map();
  StreamSubscription<Map<String, double>> locationSubcription;
  String error;

  String deviceid = 'Unknown';

  List<String> list = [];

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    databaseReference.once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key,values) {
        setState(() {
          list.add(key);
        });
      });
    });
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(title: const Text('Choose device to track')),
        body: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapsReceiver(deviceid: list[index])),
                  );
                },
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    height: 50,
                    width: 240,
                    child: Text('Device ID : '+list[index]),
                  ),
                ),
              );
            },
            itemCount: list.length)
    );
  }
}