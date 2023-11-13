import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeoFencingService {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
// create an instance for Firebase geofencing
  DatabaseReference ref = FirebaseDatabase.instance.ref('DangerZones');

// Function adds the Danger Zone to the Firebase database

  Future<void> addDangerZone(String name, LatLng latLng, double radius) async {
    await ref.child(name).set({
      'latitude': latLng.latitude,
      'longitude': latLng.longitude,
      'radius': radius,
    });
  }

  // function to remove the danger zone from the Firebase database
  Future<void> removeDangerZone(String name) async {
    await ref.child(name).remove();
  }
}
