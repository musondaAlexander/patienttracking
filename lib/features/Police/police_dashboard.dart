import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:patienttracking/Features/Police/list_of_active_patients.dart';
import 'package:patienttracking/User/controllers/authentication_controller.dart';
import 'package:patienttracking/User/screens/GroupCall/call_page.dart';
import 'package:patienttracking/User/screens/LiveStream/live_sreem.dart';
import 'package:patienttracking/User/screens/LiveStream/sos.dart';
import 'package:patienttracking/commonScreens/Location/share_location.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class PoliceDashboard extends StatefulWidget {
  const PoliceDashboard({Key? key}) : super(key: key);
  @override
  State<PoliceDashboard> createState() => _PoliceDashboardState();
}

final user = FirebaseAuth.instance.currentUser;
// final assignmedRef =
//     FirebaseDatabase.instance.ref().child('assigned/${user!.uid}');
final activeRespondersRef =
    FirebaseDatabase.instance.ref().child('activeResponders');
final userRef = FirebaseDatabase.instance.ref().child('Users');
DatabaseReference ref2 = FirebaseDatabase.instance.ref();
String userType = '';
// final locationController = Get.put(messageController());
late Position position;
String status = '';
bool _switchValue = false;

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

class _PoliceDashboardState extends State<PoliceDashboard> {
  final user = FirebaseAuth.instance.currentUser;
  LocationData? _currentLocation;
  // var Value = false;

  @override
  void initState() {
    super.initState();
    _loadSwitchValue();
    _initLocation();
    debugPrint(_switchValue.toString());
  }

  void _initLocation() async {
    final location = Location();
    try {
      final currentLocation = await location.getLocation();
      setState(() {
        _currentLocation = currentLocation;
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> _loadSwitchValue() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _switchValue = prefs.getBool('switchValue') ?? false;
    });
  }

  Future<void> _saveSwitchValue(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('switchValue', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
        shape: const StadiumBorder(
            side: BorderSide(color: Colors.white24, width: 4)),
        onPressed: () {
          // Get.to(() => const ProfileScreen());
          AuthController.instance.logout();
        },
        child: const Icon(Icons.logout),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
        automaticallyImplyLeading: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(Get.height * 0.16),
          child: Container(
            padding: const EdgeInsets.only(bottom: 15),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dashboard",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text(
                      //   'Set your status: ${status}',
                      //   style: TextStyle(
                      //     fontSize: 15.0,
                      //     backgroundColor: Colors.white,
                      //     color: setColor(),
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      SlidingSwitch(
                        value: _switchValue,
                        // initial value of the switch
                        width: 100.0,
                        // width of the switch
                        onChanged: (value) {
                          setState(() {
                            _saveSwitchValue(value);
                            _switchValue = value;
                            status = getStatus();
                          });
                          _saveSwitchValue(value);
                          // Value = value;
                        },
                        height: 40.0,
                        // borderRadius: 20.0,
                        textOff: 'OFF',
                        textOn: 'ON',
                        colorOn: Colors.green,
                        colorOff: Colors.red,
                        onSwipe: () {
                          debugPrint(_switchValue.toString());
                        },
                        onTap: () {},
                        onDoubleTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
            ),
            child: Text(
              'Police Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.to(
                const ShareMyLocation(),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 300),
              );
            },
            child: const ListTile(
              leading: Icon(
                Icons.location_on,
                color: Colors.grey,
              ),
              title: Text('Share Live Location'),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.to(
                const ActiveUsers(),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 300),
              );
            },
            child: const ListTile(
              leading: Icon(
                Icons.directions,
                color: Colors.grey,
              ),
              title: Text('See Active Patients On Map'),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.to(
                const SOS(),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 300),
              );
            },
            child: const ListTile(
              leading: Icon(
                Icons.video_call,
                color: Colors.grey,
              ),
              title: Text('Join Live With Video'),
            ),
          ),
          const Divider(),
          GestureDetector(
            onTap: () {
              // Get.to(
              //   // const DangerZones(),
              //   transition: Transition.rightToLeft,
              //   duration: const Duration(milliseconds: 300),
              // );
            },
            child: const ListTile(
              leading: Icon(
                Icons.dangerous,
                color: Colors.grey,
              ),
              title: Text('Set Danger Zones'),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app,
              color: Colors.grey,
            ),
            title: const Text('Logout'),
            onTap: () {
              AuthController.instance.logout();
            },
          ),
        ]),
      ),
      body: Container(
          child: StreamBuilder(
        stream: ref2.child('sos').onValue,
        builder: (context, AsyncSnapshot snapshot) {
          //  lets make a patients list
          final tileList = <ListTile>[];
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation(Colors.lightBlueAccent),
              ),
            );
          } else if (snapshot.hasData) {
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

            final activeVideoRequests =
                Map<String, dynamic>.from(snapshot.data!.snapshot.value);

            // DataSnapshot dataSnapshot = snapshot.data!.snapshot;
            // Map<dynamic, dynamic> list =
            //     dataSnapshot.value as dynamic ?? new Map();
            // List<dynamic> list = [];
            // list.clear();
            // list = map.values.toList();

            activeVideoRequests.forEach((key, value) {
              final nextVideoRequest = Map<String, dynamic>.from(value);

              final patientVideoOder = ListTile(
                onTap: () async {
                  var lat = nextVideoRequest['lat'];
                  var long = nextVideoRequest['long'];
                  String url = '';
                  String urlAppleMaps = '';
                  if (nextVideoRequest['lat'] == null ||
                      nextVideoRequest['long'] == null) {
                    print("Key for the SOS ${key}");
                    Get.snackbar('Error', 'No Emergency Location Found');
                    return;
                  } else {
                    if (Platform.isAndroid) {
                      url =
                          'https://www.google.com/maps/search/?api=1&query=$lat,$long';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      } else {
                        throw 'Could not launch $url';
                      }
                    } else {
                      urlAppleMaps = 'https://maps.apple.com/?q=$lat,$long';
                      url =
                          'comgooglemaps://?saddr=&daddr=$lat,$long&directionsmode=driving';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      } else if (await canLaunchUrl(Uri.parse(urlAppleMaps))) {
                        await launchUrl(Uri.parse(urlAppleMaps));
                      } else {
                        throw 'Could not launch $url';
                      }
                    }
                  }
                },
                tileColor: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                title: Text(
                  nextVideoRequest['address'] ?? 'No Emergency Request Yet',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                // subtitle: Text(
                //   // list['userID'],
                //   'Distance: ${calculateDistance(
                //       double.parse(list['userLat'].toString()),
                //       double.parse(list['userLong'].toString()),
                //       double.parse(list['responderLat'].toString()),
                //       double.parse(list['responderLong'].toString())).toStringAsFixed(2)} km',
                //   style: const TextStyle(
                //       fontSize: 15,
                //       fontWeight: FontWeight.w700,
                //       color: Colors.white),
                // ),
                subtitle: Text(
                  'Distance: ${double.tryParse(nextVideoRequest['lat']) != null && double.tryParse(nextVideoRequest['long']) != null && _currentLocation?.latitude != null && _currentLocation?.longitude != null ? '${calculateDistance(double.tryParse(nextVideoRequest['lat']) ?? 0.0,
                      // Use a default value of 0.0 if the parsing fails or the value is null
                      double.tryParse(nextVideoRequest['long']) ?? 0.0, _currentLocation?.latitude ?? 0.0, _currentLocation?.longitude ?? 0.0).toStringAsFixed(2)} km' : ''}',
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                trailing: IconButton(
                    icon: const Icon(Icons.video_call,
                        color: Colors.red, size: 30),
                    onPressed: () {
                      if (nextVideoRequest['lat'] == null ||
                          nextVideoRequest['long'] == null) {
                        Get.snackbar('Error', 'No Emergency Request Yet');
                        return;
                      } else {
                        Get.to(
                          () => LiveCall(
                            roomId: nextVideoRequest['videoId'],
                            userId: user!.uid.toString(),
                          ),
                        );
                      }
                    }),
              );
              print(key);
              tileList.add(patientVideoOder);
            });

            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
                child: ListView(
                  children: tileList,
                ),
              ),
            );
            // return ListView.builder(
            //   itemCount: 1,
            //   itemBuilder: (context, index) {
            //     return Container(
            //       margin:
            //           const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
            //       child: ListTile(
            //         onTap: () async {
            //           var lat = list['lat'];
            //           var long = list['long'];
            //           String url = '';
            //           String urlAppleMaps = '';
            //           if (list['lat'] == null || list['long'] == null) {
            //             Get.snackbar('Error', 'No Emergency Location Found');
            //             return;
            //           } else {
            //             if (Platform.isAndroid) {
            //               url =
            //                   'https://www.google.com/maps/search/?api=1&query=$lat,$long';
            //               if (await canLaunchUrl(Uri.parse(url))) {
            //                 await launchUrl(Uri.parse(url));
            //               } else {
            //                 throw 'Could not launch $url';
            //               }
            //             } else {
            //               urlAppleMaps = 'https://maps.apple.com/?q=$lat,$long';
            //               url =
            //                   'comgooglemaps://?saddr=&daddr=$lat,$long&directionsmode=driving';
            //               if (await canLaunchUrl(Uri.parse(url))) {
            //                 await launchUrl(Uri.parse(url));
            //               } else if (await canLaunchUrl(
            //                   Uri.parse(urlAppleMaps))) {
            //                 await launchUrl(Uri.parse(urlAppleMaps));
            //               } else {
            //                 throw 'Could not launch $url';
            //               }
            //             }
            //           }
            //         },
            //         tileColor: Colors.lightBlueAccent,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(15),
            //         ),
            //         title: Text(
            //           list['userAddress'] ?? 'No Emergency Request Yet',
            //           style: const TextStyle(
            //               fontSize: 20,
            //               fontWeight: FontWeight.w700,
            //               color: Colors.white),
            //         ),
            //         // subtitle: Text(
            //         //   // list['userID'],
            //         //   'Distance: ${calculateDistance(
            //         //       double.parse(list['userLat'].toString()),
            //         //       double.parse(list['userLong'].toString()),
            //         //       double.parse(list['responderLat'].toString()),
            //         //       double.parse(list['responderLong'].toString())).toStringAsFixed(2)} km',
            //         //   style: const TextStyle(
            //         //       fontSize: 15,
            //         //       fontWeight: FontWeight.w700,
            //         //       color: Colors.white),
            //         // ),
            //         subtitle: Text(
            //           'Distance: ${list['lat'] != null && list['long'] != null && _currentLocation?.latitude != null && _currentLocation?.longitude != null ? '${calculateDistance(double.tryParse(list['lat'].toString()) ?? 0.0,
            //               // Use a default value of 0.0 if the parsing fails or the value is null
            //               double.tryParse(list['long'].toString()) ?? 0.0, double.tryParse(_currentLocation?.latitude as String) ?? 0.0, double.tryParse(_currentLocation?.longitude as String) ?? 0.0).toStringAsFixed(2)} km' : ''}',
            //           style: const TextStyle(
            //               fontSize: 15,
            //               fontWeight: FontWeight.w700,
            //               color: Colors.white),
            //         ),
            //         trailing: IconButton(
            //             icon: const Icon(Icons.video_call,
            //                 color: Colors.red, size: 30),
            //             onPressed: () {
            //               if (list['lat'] == null || list['long'] == null) {
            //                 Get.snackbar('Error', 'No Emergency Request Yet');
            //                 return;
            //               } else {
            //                 Get.to(
            //                   () => LiveStreemVew(
            //                       roomId: user!.uid.toString(),
            //                       userId: list['videoId'],
            //                       isHost: false),
            //                 );
            //               }
            //             }),
            //       ),
            //     );
            //   },
            // );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      )
          // Center(
          //    child: Text(
          //      'You are not available to see SOS requests',
          //      style: TextStyle(
          //        fontSize: 20.0,
          //        color: Colors.red,
          //        fontWeight: FontWeight.bold,
          //      ),
          //    ),
          //  )),
          ),
    );
  }

  String getStatus() {
    if (_switchValue == true) {
      // setResponderData();
      setState(() {
        status = 'Available';
        setResponderData();
      });
    } else {
      setState(() {
        status = 'Unavailable';
        activeRespondersRef.child(user!.uid.toString()).remove();
      });
    }
    return status;
  }

  Color setColor() {
    if (Value == true) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  setResponderData() async {
    userType = '';
    // await smsController.handleLocationPermission();
    await Geolocator.getCurrentPosition().then((position) async {
      try {
        await userRef
            .child(user!.uid.toString())
            .get()
            .then((DataSnapshot snapshot) {
          if (snapshot.value != null) {
            Map<dynamic, dynamic> map = snapshot.value as dynamic;
            userType = map['UserType'];
            activeRespondersRef.child(user!.uid.toString()).set({
              "lat": position.latitude.toString(),
              "long": position.longitude.toString(),
              "responderType": userType,
              "responderID": user!.uid.toString(),
            });
          } else {
            userType = 'Null';
          }
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  getUserType() async {
    try {
      await userRef
          .child(user!.uid.toString())
          .get()
          .then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          Map<dynamic, dynamic> map = snapshot.value as dynamic ?? {};

          return map['UserType'];
        } else {
          return '';
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
