import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:location/location.dart' as loc;
import 'package:patienttracking/User/screens/DashBoard/grid_dash.dart';
import 'package:patienttracking/User/user_home.dart';
import 'package:patienttracking/commonScreens/Location/shared_map_location_output.dart';
import 'package:permission_handler/permission_handler.dart';

class ShareMyLocation extends StatefulWidget {
  const ShareMyLocation({super.key});

  @override
  State<ShareMyLocation> createState() => _ShareMyLocationState();
}

class _ShareMyLocationState extends State<ShareMyLocation> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  // Three variables to hold the user Data from the location
  double? latitude;
  double? longitude;
  String? userEmail;

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
            SizedBox(
              height: Get.height * 0.1,
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
            SizedBox(
              height: Get.height * 0.05,
            ),
            Expanded(
                child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('location').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor:
                          AlwaysStoppedAnimation(Colors.lightBlueAccent),
                    ),
                  );
                } else if (snapshot.hasData) {
                  // set the Three variables to hold the user Data from the location
                  List<QueryDocumentSnapshot<Object?>> iterable =
                      snapshot.data!.docs;
                  iterable.forEach((element) {
                    latitude = element['latitude'];
                    longitude = element['longitude'];
                    userEmail = element['userEmail'];
                  });
                }

                //     itemCount: snapshot.data?.docs.length,
                //     itemBuilder: (context, index) {
                //       return ListTile(
                //         title: Text(
                //           snapshot.data!.docs[index]['userEmail'].toString(),
                //           style: const TextStyle(
                //             fontSize: 20,
                //             fontWeight: FontWeight.w700,
                //           ),
                //         ),
                //         subtitle: Row(
                //           children: [
                //             Text(snapshot.data!.docs[index]['latitude']
                //                 .toString()),
                //             const SizedBox(
                //               width: 20,
                //             ),
                //             Text(snapshot.data!.docs[index]['longitude']
                //                 .toString()),
                //           ],
                //         ),
                //         trailing: IconButton(
                //           icon: const Icon(Icons.directions),
                //           onPressed: () {
                //             // Navigator.of(context).push(MaterialPageRoute(
                //             //     builder: (context) => MyLocationMap(
                //             //         snapshot.data!.docs[index].id)));

                //             Get.to(
                //                 MyLocationMap(snapshot.data!.docs[index].id));
                //           },
                //         ),
                //       );
                //     });

                return Column(
                  children: [
                    Text(
                      userEmail.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      latitude.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      longitude.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                );
              },
            )),
          ],
        ),
      ),
    );
  }

  // method to request permission for location
  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  // method to get location
  _getLocation() async {
    final ref =
        FirebaseDatabase.instance.ref(); //used to reference the firebase RTDB
    final snapshot = await ref.child('Users').get();
    // assign the value of the snapshot to a variable

    print(snapshot.value);

    FirebaseAuth _auth = FirebaseAuth.instance;
    User user = _auth.currentUser!;
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance
          .collection('location')
          .doc(user.uid)
          .set({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
        'userEmail': user.email,
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  // Method to Listen on location
  Future<void> _listenLocation() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User user = _auth.currentUser!;
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance
          .collection('location')
          .doc(user.uid)
          .set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
        'userEmail': user.email,
      }, SetOptions(merge: true));
    });
  }

  // Method to Stop listening on location
  _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }
}
