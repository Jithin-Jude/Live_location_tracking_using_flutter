import 'package:firebase_database/firebase_database.dart';

class CoordinatesModel {
   String id;
   double latitude;
   double longitude;
   String deviceId;

   CoordinatesModel(this.latitude, this.longitude, this.deviceId);

   CoordinatesModel.map(dynamic obj) {
     this.id = obj['id'];
     this.latitude = obj['latitude'];
     this.longitude = obj['longitude'];
     this.deviceId = obj['device_id'];
   }

   double get currentLatitude => latitude;
   double get currentLongitude => longitude;
   String get currentDeviceId => deviceId;

   CoordinatesModel.fromSnapshot(DataSnapshot snapshot) {
     id = snapshot.key;
     latitude = snapshot.value['latitude'];
     longitude = snapshot.value['longitude'];
     deviceId = snapshot.value['device_id'];
   }
}