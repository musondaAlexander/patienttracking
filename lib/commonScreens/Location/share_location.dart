import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:location/location.dart';
import 'package:patienttracking/User/user_home.dart';

class ShareMyLocation extends StatefulWidget {
  const ShareMyLocation({super.key});

  @override
  State<ShareMyLocation> createState() => _ShareMyLocationState();
}

class _ShareMyLocationState extends State<ShareMyLocation> {
  final Location location = Location();
  StreamSubscription<LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    _requestPermission();
    // location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    // location.enableBackgroundMode(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => {Get.to(() => UserHome())},
          child: const BackButton(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(Get.height * 0.1),
          child: Container(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                        image:
                            const AssetImage("assets/logos/logoiconwhite.png"),
                        height: Get.height * 0.1),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Live location",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(250, 50),
                elevation: 15,
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              onPressed: () {
                _getLocation();
              },
              child: const Text(
                'Add my location',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(250, 50),
                elevation: 15,
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              onPressed: () {
                _listenLocation();
              },
              child: const Text(
                'Enable live location',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 15,
                minimumSize: const Size(250, 50),
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              onPressed: () {
                _stopListening();
              },
              child: const Text(
                'Stop live location',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // method to request permission for location
  void _requestPermission() {}
  // method to get location
  void _getLocation() {}
  // Method to Stop listening on location
  void _stopListening() {}
  // Method to Listen on location
  void _listenLocation() {}
}
