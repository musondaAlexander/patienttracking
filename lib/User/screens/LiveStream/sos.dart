import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:patienttracking/Features/Police/police_dashboard.dart';
import 'package:patienttracking/User/screens/LiveStream/live_sreem.dart';

class SOS extends StatefulWidget {
  const SOS({super.key});

  @override
  State<SOS> createState() => _SOSState();
}

class _SOSState extends State<SOS> {
  final liveIdController = TextEditingController();
  final String userId = Random().nextInt(900000 + 10000).toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.lightBlueAccent,
        title: const Text(
          'Start Live Stream',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Your User ID: $userId",
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: liveIdController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Joing OR start Live Meeting by Inputing ID',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    //This Function saves SOS Current user and Location Informaation o the database.
                    saveCurrentLocation();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ZegoLivePage(
                    //       userId: userId,
                    //       roomId: lveIdController.text,
                    //     ),
                    //   ),
                    // );
                    Get.to(() => LiveStreemVew(
                        roomId: liveIdController.text.toString(),
                        userId: userId,
                        isHost: true));
                  },
                  child: const Text("Start Live"),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ZegoLivePage(
                    //       userId: userId,
                    //       roomId: lveIdController.text,
                    //     ),
                    //   ),
                    // );
                    Get.to(() => LiveStreemVew(
                        roomId: liveIdController.text.toString(),
                        userId: userId,
                        isHost: false));
                  },
                  child: const Text("Join Live"),
                ),
                // ============================================================
                // This is the SOS Button
                // It uses the Cureent user ID as the roomId For the Live Stream
                // ============================================================
      
                SizedBox(
                  width: Get.width * 0.8,
                  height: Get.height * 0.2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: () async {
                      Get.to(
                        () => LiveStreemVew(
                            roomId: user!.uid.toString(),
                            userId: userId,
                            isHost: true),
                      );
                    },
                    child: const Text("SOS",
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                        )),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  // Function tp store the SOS data in the database

  saveCurrentLocation() async {
    //adding in try catch
    //save Current location to database
    // String videoId = sessionController.userid.toString();
    final user = FirebaseAuth.instance.currentUser;
    final ref = FirebaseDatabase.instance.ref("sos/${user!.uid.toString()}");
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((position) async {
      await placemarkFromCoordinates(position.latitude, position.longitude)
          .then((List<Placemark> placemarks) {
        Placemark place = placemarks[0];
        String address =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
        ref.set({
          "time":
              "${DateTime.now().hour}:${DateTime.now().minute} ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
          "address": address,
          "email": user.email.toString(),
          "lat": position.latitude.toString(),
          "long": position.longitude.toString(),
          "videoId": user.uid.toString(),
        });
      });
    });
  }
}
