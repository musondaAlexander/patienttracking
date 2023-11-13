import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:location/location.dart';

class FirstResponderScreen extends StatefulWidget {
  @override
  _FirstResponderScreenState createState() => _FirstResponderScreenState();
}

class _FirstResponderScreenState extends State<FirstResponderScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late DatabaseReference _databaseRef;
  Location _location = Location();
  TextEditingController _latitudeController = TextEditingController();
  TextEditingController _longitudeController = TextEditingController();
  TextEditingController _radiusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = _auth.currentUser;
    final uid = user?.uid;
    _databaseRef =
        FirebaseDatabase.instance.ref().child('geofences').child(uid!);
    checkLocationPermission();
  }

  // Check if location service is enabled and permissions are granted
  Future<void> checkLocationPermission() async {
    bool _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        // Handle when location service is not enabled
      }
    }

    PermissionStatus _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        // Handle when location permission is not granted
      }
    }
  }

  // Function to set the geofence in Firebase Realtime Database
  Future<void> setGeofence() async {
    try {
      double latitude = double.tryParse(_latitudeController.text) ?? 0.0;
      double longitude = double.tryParse(_longitudeController.text) ?? 0.0;
      double radius = double.tryParse(_radiusController.text) ?? 0.0;

      final user = await _auth.currentUser!;
      final uid = user?.uid;

      if (uid != null) {
        final geofenceData = {
          'latitude': latitude,
          'longitude': longitude,
          'radius': radius,
        };

        // Set the geofence
        _databaseRef.set(geofenceData);
        // / add a snackbar to show the geofence has been set
        const SnackBar(
          content: Text('Geofence set successfully.'),
        );
      }
    } catch (e) {
      SnackBar(
        content: Text('Error setting geofence: $e'),
      );
    }
  }

  // Function to remove the geofence from Firebase Realtime Database
  Future<void> removeGeofence() async {
    try {
      final user = await _auth.currentUser!;
      final uid = user?.uid;

      if (uid != null) {
        // Remove the geofence
        _databaseRef.remove();
        const SnackBar(
          content: Text('Geofence removed successfully.'),
        );
      }
    } catch (e) {
      SnackBar(
        content: Text('Error removing geofence: $e'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // UI for the first responder screen
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _latitudeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Latitude'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _longitudeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Longitude'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _radiusController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Radius (in meters)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setGeofence();
              },
              child: const Text('Set Geofence'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                removeGeofence();
              },
              child: const Text('Remove Geofence'),
            ),
          ],
        ),
      ),
    );
  }
}
