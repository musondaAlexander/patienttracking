import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as loc;
import 'package:patienttracking/commonScreens/Location/shared_map_location_output.dart';
import 'package:permission_handler/permission_handler.dart';

class ActiveUsers extends StatefulWidget {
  const ActiveUsers({super.key});

  @override
  State<ActiveUsers> createState() => _ActiveUsersState();
}

class _ActiveUsersState extends State<ActiveUsers> {
  DatabaseReference ref = FirebaseDatabase.instance.ref('Location');
  DatabaseReference ref2 = FirebaseDatabase.instance.ref();
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  // Three variables to hold the user Data from the location
  FirebaseAuth _auth = FirebaseAuth.instance;
  late User userID;
  @override
  void initState() {
    super.initState();
    _requestPermission();
    userID = _auth.currentUser!;
    // location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    // location.enableBackgroundMode(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.lightBlueAccent,
        title: const Text(
          'Active Users',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: Get.height * 0.1,
            ),
            Expanded(
              child: StreamBuilder(
                stream: ref2.child('Location').onValue,
                builder: (context, AsyncSnapshot snapshot) {
                  //  lets make a patients list
                  final tileList = <ListTile>[];
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

                    // recursively convert the map
                    Map<String, dynamic> convertMap(Map<dynamic, dynamic> map) {
                      map.forEach((key, value) {
                        if (value is Map) {
                          // it's a map, process it
                          value = convertMap(value);
                        }
                      });
                      // use .from to ensure the keys are Strings
                      return Map<String, dynamic>.from(map);
                      // more explicit alternative way:
                      // return Map.fromEntries(map.entries.map((entry) => MapEntry(entry.key.toString(), entry.value)));
                    }

                    final activePatients = Map<String, dynamic>.from(
                        snapshot.data!.snapshot.value);
                    activePatients.forEach((key, value) {
                      print(key);
                      final nextpatient = Map<String, dynamic>.from(value);
                      final patientOder = ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        tileColor: Colors.lightBlueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        title: Text(
                          nextpatient['userEmail'],
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        subtitle: Text(
                          "Latitude: ${nextpatient['latitude'].toString()} \nLongitude: ${nextpatient['longitude'].toString()}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(255, 255, 255, 1)),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.directions),
                          onPressed: () {
                            Get.to(() => MyLocationMap(key));
                          },
                        ),
                      );
                      tileList.add(patientOder);
                    });
                    //=========================================================================================

                    // Map<dynamic, dynamic> map =
                    //     snapshot.data.snapshot.value ?? {};
                    // latitude = map['latitude'];
                    // longitude = map['longitude'];
                    // userEmail = map['userEmail'];
                  }
                  // The code below Return a  list that Is used to diplay a List of Active users
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 40, horizontal: 10),
                      child: ListView(
                        children: tileList,
                      ),
                    ),
                  );
                  // ListView.builder(
                  //     itemCount: snapshot.data.snapshot.value.length,
                  //     itemBuilder: (context, index) {
                  //       return ListTile(
                  //         title: Text(
                  //           snapshot.data!.snapshot.value[index]['userEmail'].toString(),
                  //           style: const TextStyle(
                  //             fontSize: 20,
                  //             fontWeight: FontWeight.w700,
                  //           ),
                  //         ),
                  //         subtitle: Row(
                  //           children: [
                  //             Text(snapshot.data!.snapshot.value[index]['latitude']
                  //                 .toString()),
                  //             const SizedBox(
                  //               width: 20,
                  //             ),
                  //             Text(snapshot.data!.snapshot.value[index]['longitude']
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
                  //                 MyLocationMap(snapshot.data.snapshot.value[index].id));
                  //           },
                  //         ),
                  //       );
                  //     },);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

// ====================================================================================
// Commonly Used Methods
// ====================================================================================
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

// Another method that stores location to the database but uses RTDB

  _getLocationrRD() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('Location');
    FirebaseAuth _auth = FirebaseAuth.instance;
    User user = _auth.currentUser!;
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await ref.child(user.uid).set({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
        'userEmail': user.email,
      });
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

// Method to Listen on location but users RTDB
  _listenLocationRD() {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User user = _auth.currentUser!;
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('Location');
      await ref.child(user.uid).set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
        'userEmail': user.email,
      });
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
