import 'package:flutter/material.dart';
import 'package:flutter_maps/maps_host.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: ChooseUser()
    );
  }
}

class ChooseUser extends StatefulWidget{
  @override
  State createState() => ChooseUserState();
}

class ChooseUserState extends State<ChooseUser> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text('Google Maps Flutter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("I'm Host"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapsDemo()),
                );
              },),
            RaisedButton(
              child: Text("I'm Reciver"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapsDemo()),
                );
              },)
          ],
        ),
      ),
    );
  }

}