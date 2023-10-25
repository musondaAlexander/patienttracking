import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:patienttracking/commonScreens/Location/share_location.dart';

class MyLocationMap extends StatefulWidget {
  final String userId;
  const MyLocationMap(
    this.userId,
  );

  @override
  State<MyLocationMap> createState() => _MyLocationMapState();
}

class _MyLocationMapState extends State<MyLocationMap> {
  DatabaseReference ref = FirebaseDatabase.instance.ref('Location');
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  // Three variables to hold the user Data from the location
  double latitude = 0.0;
  double longitude = 0.0;
  String? userEmail;
  FirebaseAuth _auth = FirebaseAuth.instance;
  late User userID;

  @override
  void initState() {
    super.initState();
    userID = _auth.currentUser!;
    // location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    // location.enableBackgroundMode(enable: true);
  }

  late GoogleMapController _controller;
  bool _added = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Get.to(const ShareMyLocation()),
          child: const BackButton(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.lightBlueAccent,
        title: const Text(
          'Live Tracking',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder(
            stream: ref.child(userID.uid).onValue,
            builder: (context, AsyncSnapshot snapshot) {
              if (_added) {
                mymap(context, snapshot);
                Map<dynamic, dynamic> map = snapshot.data.snapshot.value ?? {};
                latitude = map['latitude'];
                longitude = map['longitude'];
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return GoogleMap(
                // zoomControlsEnabled: false,
                // zoomGesturesEnabled: true,
                scrollGesturesEnabled: true,
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
                markers: {
                  Marker(
                      position: LatLng(
                        latitude, longitude,
                        // snapshot.data!.docs.singleWhere((element) =>
                        //     element.id == widget.userId)['latitude'],
                        // snapshot.data!.docs.singleWhere((element) =>
                        //     element.id == widget.userId)['longitude'],
                      ),
                      markerId: const MarkerId('id'),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueMagenta)),
                },
                initialCameraPosition: CameraPosition(
                    target: LatLng(
                      latitude, longitude,
                      // snapshot.data!.docs.singleWhere(
                      //     (element) => element.id == widget.userId)['latitude'],
                      // snapshot.data!.docs.singleWhere((element) =>
                      //     element.id == widget.userId)['longitude'],
                    ),
                    zoom: 14.47),
                onMapCreated: (GoogleMapController controller) async {
                  setState(() {
                    _controller = controller;
                    _added = true;
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> mymap(context, AsyncSnapshot snapshot) async {
    if (!snapshot.hasData) {
      latitude = 0.0;
      longitude = 0.0;
    } else if (snapshot.hasData) {
      // set the Three variables to hold the user Data from the location
      Map<dynamic, dynamic> map = snapshot.data.snapshot.value ?? {};
      latitude = map['latitude'];
      longitude = map['longitude'];
    }
    await _controller
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(
              latitude!, longitude!,
              // plot using the latitude and longitude from the RTDB database
              // snapshot.data!.docs.singleWhere(
              //     (element) => element.id == widget.userId)['latitude'],
              // snapshot.data!.docs.singleWhere(
              //     (element) => element.id == widget.userId)['longitude'],
            ),
            zoom: 14.47)));
  }
}
