import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:location/location.dart';
import 'dart:math';

class PatientScreen extends StatefulWidget {
  @override
  _PatientScreenState createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late DatabaseReference _databaseRef;
  Location _location = Location();
  String _status = 'Waiting for geofence updates...';

  @override
  void initState() {
    super.initState();
    final user = _auth.currentUser;
    final uid = user?.uid;
    _databaseRef =
        FirebaseDatabase.instance.ref().child('geofences').child(uid!);
  }

  // Function to listen for geofence updates
  Future<void> listenGeofence(context, AsyncSnapshot snapshot) async {
    try {
      _databaseRef.onValue.listen((event) {
        if (snapshot.hasData) {
          Map<dynamic, dynamic> map = snapshot.data.snapshot.value ?? {};
          double latitude = map['latitude'];
          double longitude = map['longitude'];

          _location.onLocationChanged.listen((LocationData currentLocation) {
            double distance = _calculateDistance(
              latitude,
              longitude,
              currentLocation.latitude!,
              currentLocation.longitude!,
            );

            if (distance < 500.0) {
              // Inside the geofence - trigger alarm
              setState(() {
                _status = 'Patient entered the geofence. Triggering alarm!';
              });
            } else {
              // Outside the geofence
              setState(() {
                _status = 'Patient outside the geofence.';
              });
            }
          });
        }
      });
    } catch (e) {
      print('Error listening to geofence: $e');
    }
  }

  // Function to calculate distance between two coordinates
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const R = 6371.0; // Earth radius in kilometers
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = R * c;

    return distance * 1000; // Convert to meters
  }

  double _toRadians(double degree) {
    return degree * (pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    // UI for the patient screen
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.lightBlueAccent,
        title: const Text(
          'Danger Zones',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      // we need to create a stream Builder
      body: StreamBuilder<Object>(
          stream: _databaseRef.child('geofences').onValue,
          builder: (context, snapshot) {
            listenGeofence(context, snapshot);
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_status),
                ],
              ),
            );
          }),
    );
  }
}
